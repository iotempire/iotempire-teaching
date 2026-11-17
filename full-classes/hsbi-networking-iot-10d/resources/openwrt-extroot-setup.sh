#!/bin/sh
# openwrt-extroot-setup.sh - set up a USB stick as extroot (OpenWrt 24.10 / 25.x)
# Class resource for Networking and IoT Solutions; tested on the Cudy TR1200.
# Run on the router: sh openwrt-extroot-setup.sh [/dev/sdX]   (default: /dev/sda)
# The prompts are German: confirm with JA; every other answer aborts without changes.

set -e

DISK="${1:-/dev/sda}"
PART="${DISK}1"
MNT="/tmp/extroot"
PKGS="block-mount kmod-fs-ext4 e2fsprogs kmod-usb-storage fdisk"

die()  { echo "FEHLER: $*" >&2; exit 1; }
info() { echo ">>> $*"; }

[ "$(id -u)" = 0 ] || die "Bitte als root ausführen."

# --- Pakete prüfen und ggf. nachinstallieren (apk ab 25.x, sonst opkg) ---
if command -v apk >/dev/null 2>&1; then
	pkg_installed() { apk info -e "$1" >/dev/null 2>&1; }
	pkg_install()   { apk update && apk add "$@"; }
elif command -v opkg >/dev/null 2>&1; then
	pkg_installed() { opkg list-installed | grep -q "^$1 "; }
	pkg_install()   { opkg update && opkg install "$@"; }
else
	die "Weder apk noch opkg gefunden."
fi

MISSING=""
for p in $PKGS; do
	pkg_installed "$p" || MISSING="$MISSING $p"
done
if [ -n "$MISSING" ]; then
	info "Installiere fehlende Pakete:$MISSING"
	pkg_install $MISSING || die "Paketinstallation fehlgeschlagen (Internetverbindung?)."
fi

# --- Läuft Extroot schon? ---
if block info | grep -q "^${DISK}[0-9]*:.*MOUNT=\"/overlay\""; then
	die "Extroot ist bereits auf $DISK aktiv."
fi

# --- Auf den Stick warten ---
i=0
while [ ! -b "$DISK" ]; do
	[ $i -ge 15 ] && die "$DISK nicht gefunden. Ist der Stick eingesteckt?"
	i=$((i + 1)); sleep 1
done

NAME="${DISK##*/}"
SIZE_MB=$(( $(cat /sys/block/$NAME/size) / 2048 ))
VENDOR=$(tr -s ' ' < /sys/block/$NAME/device/vendor 2>/dev/null || true)
MODEL=$(tr -s ' ' < /sys/block/$NAME/device/model 2>/dev/null || true)

# --- Nachfrage ---
echo
echo "Gefundenes Laufwerk: $DISK  ($VENDOR $MODEL, ${SIZE_MB} MB)"
block info 2>/dev/null | grep "^${DISK}" || echo "  (keine erkannten Dateisysteme)"
echo
echo "ACHTUNG: ALLE DATEN AUF $DISK WERDEN GELÖSCHT!"
printf "Zum Fortfahren JA eingeben: "
read -r ANSWER < /dev/tty
[ "$ANSWER" = "JA" ] || die "Abgebrochen, nichts verändert."

# --- Eingehängte Partitionen des Sticks aushängen ---
for p in "$DISK"[0-9]*; do
	[ -b "$p" ] || continue
	if grep -q "^$p " /proc/mounts; then umount "$p"; fi
done

# --- Partitionieren und formatieren ---
info "Lösche alte Partitionstabelle und Signaturen ..."
dd if=/dev/zero of="$DISK" bs=1M count=4 2>/dev/null
sync

info "Lege eine Partition über den ganzen Stick an ..."
printf 'o\nn\np\n1\n\n\nw\n' | fdisk -w always -W always "$DISK" >/dev/null \
	|| die "fdisk fehlgeschlagen."

i=0
while [ ! -b "$PART" ]; do
	[ $i -ge 10 ] && die "$PART erscheint nicht."
	i=$((i + 1)); sleep 1
done
umount "$PART" 2>/dev/null || true

info "Formatiere $PART mit ext4 ..."
mkfs.ext4 -q -F -L extroot "$PART" || die "mkfs.ext4 fehlgeschlagen."

# --- fstab konfigurieren ---
UUID=""
eval $(block info "$PART" | grep -o -e 'UUID="\S*"')
[ -n "$UUID" ] || die "Keine UUID für $PART gefunden."

MOUNT=""
eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
OVERLAY="${MOUNT:-/overlay}"
ORIG="$(block info | sed -n -e '/MOUNT="\S*\/overlay"/s/:\s.*$//p')"

touch /etc/config/fstab
uci -q delete fstab.rwm || true
if [ -n "$ORIG" ]; then
	uci set fstab.rwm="mount"
	uci set fstab.rwm.device="$ORIG"
	uci set fstab.rwm.target="/rwm"
fi
uci -q delete fstab.extroot || true
uci set fstab.extroot="mount"
uci set fstab.extroot.uuid="$UUID"
uci set fstab.extroot.target="$OVERLAY"
uci commit fstab
info "fstab: extroot -> UUID $UUID, altes Overlay ($ORIG) -> /rwm"

# --- Overlay auf den Stick kopieren (nur wenn der Mount wirklich klappt) ---
mkdir -p "$MNT"
mount -t ext4 "$PART" "$MNT" || die "Mount von $PART fehlgeschlagen."
grep -q " $MNT ext4 " /proc/mounts || die "$PART ist nicht unter $MNT eingehängt."

info "Kopiere $OVERLAY auf den Stick ..."
tar -C "$OVERLAY" -cf - . | tar -C "$MNT" -xf -
sync
[ -d "$MNT/upper" ] || die "Kopie unvollständig ($MNT/upper fehlt)."
umount "$MNT"

# --- Neustart ---
info "Fertig. Nach dem Neustart mit 'df -h /overlay' prüfen."
info "Neustart in 10 Sekunden (Strg+C bricht ab) ..."
sleep 10
reboot
