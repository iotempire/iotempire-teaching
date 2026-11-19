#!/bin/sh
# openwrt-extroot-setup.sh - set up a USB stick as extroot (OpenWrt 25.x, apk)
# Class resource for Networking and IoT Solutions; tested on the Cudy TR1200.
# Run on the router: sh openwrt-extroot-setup.sh [/dev/sdX]   (default: /dev/sda)
# Type yes to confirm (any capitalization); every other answer aborts without changes.

set -e

DISK="${1:-/dev/sda}"
PART="${DISK}1"
MNT="/tmp/extroot"
PKGS="block-mount kmod-fs-ext4 e2fsprogs kmod-usb-storage fdisk"

die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo ">>> $*"; }

[ "$(id -u)" = 0 ] || die "Run as root."

# --- Packages: this class runs OpenWrt 25.x, which uses apk. Older opkg-based
# --- releases are not supported; stop rather than guess.
command -v apk >/dev/null 2>&1 \
	|| die "This script needs the apk package manager (OpenWrt 25.x). Older opkg-based releases are not supported - flash a current image."

pkg_installed() { apk info -e "$1" >/dev/null 2>&1; }
pkg_install()   { apk update && apk add "$@"; }

MISSING=""
for p in $PKGS; do
	pkg_installed "$p" || MISSING="$MISSING $p"
done
if [ -n "$MISSING" ]; then
	info "Installing missing packages:$MISSING"
	pkg_install $MISSING || die "Package installation failed (internet connection?)."
fi

# --- Is extroot already active? ---
if block info | grep -q "^${DISK}[0-9]*:.*MOUNT=\"/overlay\""; then
	die "Extroot is already active on $DISK."
fi

# --- Wait for the stick ---
i=0
while [ ! -b "$DISK" ]; do
	[ $i -ge 15 ] && die "$DISK not found. Is the stick plugged in?"
	i=$((i + 1)); sleep 1
done

NAME="${DISK##*/}"
SIZE_MB=$(( $(cat /sys/block/$NAME/size) / 2048 ))
VENDOR=$(tr -s ' ' < /sys/block/$NAME/device/vendor 2>/dev/null || true)
MODEL=$(tr -s ' ' < /sys/block/$NAME/device/model 2>/dev/null || true)

# --- Confirmation ---
echo
echo "Found device: $DISK  ($VENDOR $MODEL, ${SIZE_MB} MB)"
block info 2>/dev/null | grep "^${DISK}" || echo "  (no recognised filesystems)"
echo
echo "WARNING: ALL DATA ON $DISK WILL BE ERASED!"
printf "Type yes to continue: "
read -r ANSWER < /dev/tty
case "$ANSWER" in
	[yY][eE][sS]) ;;
	*) die "Aborted, nothing changed." ;;
esac

# --- Unmount mounted partitions on the stick ---
for p in "$DISK"[0-9]*; do
	[ -b "$p" ] || continue
	if grep -q "^$p " /proc/mounts; then umount "$p"; fi
done

# --- Partition and format ---
info "Erasing the old partition table and signatures ..."
dd if=/dev/zero of="$DISK" bs=1M count=4 2>/dev/null
sync

info "Creating one partition across the whole stick ..."
printf 'o\nn\np\n1\n\n\nw\n' | fdisk -w always -W always "$DISK" >/dev/null \
	|| die "fdisk failed."

i=0
while [ ! -b "$PART" ]; do
	[ $i -ge 10 ] && die "$PART did not appear."
	i=$((i + 1)); sleep 1
done
umount "$PART" 2>/dev/null || true

info "Formatting $PART with ext4 ..."
mkfs.ext4 -q -F -L extroot "$PART" || die "mkfs.ext4 failed."

# --- Configure fstab ---
UUID=""
eval $(block info "$PART" | grep -o -e 'UUID="\S*"')
[ -n "$UUID" ] || die "No UUID found for $PART."

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
info "fstab: extroot -> UUID $UUID, old overlay ($ORIG) -> /rwm"

# --- Copy the overlay to the stick (only if the mount really works) ---
mkdir -p "$MNT"
mount -t ext4 "$PART" "$MNT" || die "Mounting $PART failed."
grep -q " $MNT ext4 " /proc/mounts || die "$PART is not mounted at $MNT."

info "Copying $OVERLAY to the stick ..."
tar -C "$OVERLAY" -cf - . | tar -C "$MNT" -xf -
sync
[ -d "$MNT/upper" ] || die "Copy incomplete ($MNT/upper missing)."
umount "$MNT"

# --- Reboot ---
info "Done. After the reboot, check with 'df -h /overlay'."
info "Rebooting in 10 seconds (Ctrl+C aborts) ..."
sleep 10
reboot
