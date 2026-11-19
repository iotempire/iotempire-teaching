# Nebula auf OpenWrt einrichten (deutsche Fassung)

[← Modul 3](./03-overlay-and-mesh-networks.md)

Bonus-Übersetzung der Anleitung aus **Task 1**. Maßgeblich ist die englische Fassung im Modul; diese Seite ist für den Einstieg in der Muttersprache gedacht. Fachbegriffe wie *Bundle*, *Lighthouse* und *Overlay* bleiben englisch, damit beide Fassungen zusammenpassen.

## 1. Pakete installieren

*System → Software*: `luci-proto-nebula` installieren. Danach den **Router neu starten**.

## 2. Dateien auf den Router kopieren

Das Bundle (`ca.crt`, `<host>.crt`, `<host>.key`, `config.yml`) nach `/etc/nebula/` kopieren:

```bash
scp -O ca.crt <host>.crt <host>.key config.yml root@192.168.14.1:/etc/nebula/
```

`-O` ist nötig, weil OpenWrt meist keinen sftp-Server hat. Die Pfade in `config.yml` müssen auf `/etc/nebula/…` zeigen, und der Schlüssel gehört auf Modus `600`.

**Nicht** `/etc/config/` verwenden — das ist für UCI-Konfigurationen gedacht; das Bundle gehört nicht dorthin.

## 3. Interface anlegen

*Network → Interfaces → Add new interface*:

- Name: `nebula1`
- Protocol: `Nebula`
- Config file: `/etc/nebula/config.yml`

Unter *Firewall Settings* eine neue Zone `nebula` anlegen und zuweisen, dann *Save & Apply*. Damit startet netifd Nebula und das Device `nebula1` mit der Mesh-Adresse erscheint. LuCI zeigt das Interface trotzdem dauerhaft als *pending* — das ist normal und der Grund für Schritt 4.

## 4. Firewall

*Network → Firewall → Zone `nebula` bearbeiten*:

- Input: **accept**
- Output: **accept**
- Forward: **reject**
- **Masquerading: an** — nötig, weil das Mesh nur Absender-Adressen aus dem Nebula-Zertifikat akzeptiert
- *Allow forward from source zones*: `lan`
- *Advanced Settings → Covered devices*: `nebula1`

Der letzte Punkt ist entscheidend: Weil das Interface nie „up“ ist, kennt die Firewall sonst kein Device für die Zone und verwirft den Verkehr vom LAN ins Mesh.

## 5. DNS

*Network → DHCP and DNS*:

- *Forwards*: `/ulno.mesh/10.100.0.1` — Anfragen für `*.ulno.mesh` gehen damit an den Mesh-DNS.
- *Filter → Domain whitelist* (Rebind-Schutz): `ulno.mesh` — sonst verwirft dnsmasq die Antworten mit privaten 10.x-Adressen (im Log: „possible DNS-rebind attack detected“).

## 6. Testen

Auf dem Router: `ping 10.100.0.1` und `ping ulno-ge75.ulno.mesh`. Auf einem Rechner im LAN: `ping ulno-oldplex05.hsbi01.ulno.mesh`.

Bei Problemen: *Status → System Log* nach Meldungen von `dnsmasq` und `nebula` durchsuchen.

## Was das Masquerading bedeutet

Durch das Masquerading erscheinen alle LAN-Geräte im Mesh als der Router. Ob ein Dienst im Mesh erreichbar ist, entscheiden also die **Nebula-Firewallregeln der Gegenstelle** für das Zertifikat bzw. die Gruppen des Routers — nicht die Firewall des Routers.

---

[← Modul 3](./03-overlay-and-mesh-networks.md) | [Modulindex](./00-index.md)
