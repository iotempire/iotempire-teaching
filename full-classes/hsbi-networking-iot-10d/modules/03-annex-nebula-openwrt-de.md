# Nebula auf OpenWrt einrichten (deutsche Fassung)

[← Modul 3](./03-overlay-and-mesh-networks.md)

Bonus-Übersetzung der Anleitung aus **Task 1**. Maßgeblich ist die englische Fassung im Modul; diese Seite ist für den Einstieg in der Muttersprache gedacht. Fachbegriffe wie *Bundle*, *Lighthouse* und *Overlay* bleiben englisch, damit beide Fassungen zusammenpassen.

## 1. Bundle holen

Der Dozent gibt pro Pod einen `croc`-Code aus. Öffne <https://getcroc.com/#receive> und folge der Empfangsanleitung — das funktioniert im Browser ohne Installation. Wer es lieber auf der Kommandozeile macht: das Binary von <https://getcroc.com/> herunterladen und `croc <code>` ausführen. Nimm das Archiv für **deinen** Pod — die ID steht auf dem Aufkleber am Router. Code und Archiv sind Zugangsdaten: nicht weitergeben.

## 2. Paket installieren

*System → Software*: `luci-proto-nebula` installieren. Danach den **Router neu starten**. Oder per SSH: `apk update && apk add luci-proto-nebula && reboot`.

## 3. Vier Dateien entpacken und auf den Router kopieren

Archiv entpacken (Windows: Rechtsklick → *Alle extrahieren*, macOS: Doppelklick, Linux: `unzip`). Du brauchst genau vier Dateien: `ca.crt`, `<host>.crt`, `<host>.key`, `config.yml`.

Terminal öffnen — PowerShell unter Windows (10/11 bringt `scp` im OpenSSH-Client mit), Terminal unter macOS, deine Shell unter Linux — und mit `cd` in den entpackten Ordner wechseln. Tipp: `cd ` tippen und den Ordner aus dem Dateimanager ins Fenster ziehen.

```bash
ssh root@192.168.14.1 "mkdir -p /etc/nebula"
scp -O ca.crt <host>.crt <host>.key config.yml root@192.168.14.1:/etc/nebula/
```

`scp` legt das Zielverzeichnis nicht an, und die Nebula-Pakete bringen `/etc/nebula` auch nicht mit — deshalb die erste Zeile. `-O` ist nötig, weil OpenWrt keinen sftp-Server hat. Fehlt `scp` unter Windows: *Einstellungen → Apps → Optionale Features → OpenSSH-Client*.

## 4. Per SSH prüfen

Derselbe Login wie in Modul 2:

```bash
ssh root@192.168.14.1
ls -l /etc/nebula/
chmod 600 /etc/nebula/*.key
grep -E 'ca:|cert:|key:' /etc/nebula/config.yml
```

Alle vier Dateien müssen in `/etc/nebula/` liegen, der Schlüssel auf Modus `600`, und die drei Pfade in `config.yml` müssen auf `/etc/nebula/…` zeigen. **Nicht** `/etc/config/` — das ist das UCI-Verzeichnis.

## 5. Interface anlegen

*Network → Interfaces → Add new interface*:

- Name: `nebula1`
- Protocol: `Nebula Network` (so heißt das Protokoll in LuCI, nicht nur „Nebula“)
- Config file: `/etc/nebula/config.yml`

> [!TIP]
> **Name und `tun.dev` müssen übereinstimmen.** Im Bundle steht `nebula1`, also muss das Interface auch `nebula1` heißen. Weichen sie ab, startet das Protokoll und beendet sich sofort; die Fehlermeldung nennt beide Namen so, dass sie gleich aussehen — achte auf ein Leerzeichen am Ende.

Unter *Firewall Settings* eine neue Zone `nebula` anlegen und zuweisen, dann *Save & Apply*. Damit startet netifd Nebula und das Device `nebula1` mit der Mesh-Adresse erscheint. LuCI zeigt das Interface trotzdem dauerhaft als *pending* — das ist normal und der Grund für Schritt 6.

## 6. Firewall

*Network → Firewall → Zones*: `nebula` öffnen (oder **Add**, falls du die Zone in Schritt 5 nicht angelegt hast):

- Input **accept**, Output **accept**, *Intra zone forward* **reject**
- **IPv4 Masquerading** an — nötig, weil das Mesh nur Absender-Adressen aus dem Nebula-Zertifikat akzeptiert
- *Allow forward to destination zones*: nichts; *Allow forward from source zones*: `lan`
- *Covered networks*: leer lassen — das ist **nicht** das Device-Feld, auch wenn der Name so klingt
- *Advanced Settings → Covered devices*: `nebula1` — nach dem Tippen **Enter** drücken, sonst übernimmt LuCI den Eintrag nicht

Das Covered-Device ist der entscheidende Punkt: Weil das Interface nie „up“ ist, kennt die Firewall sonst kein Device für die Zone und verwirft den Verkehr vom LAN ins Mesh.

## 7. DNS

*Network → DNS* — nicht die DHCP-Seite, das sind zwei getrennte Menüpunkte:

- **DNS Forwards**: `/ulno.mesh/10.100.0.1` — Anfragen für `*.ulno.mesh` gehen damit an den Mesh-DNS.
- **Filter → Domain whitelist** (Rebind-Schutz): `ulno.mesh` — sonst verwirft dnsmasq die Antworten mit privaten 10.x-Adressen (im Log: „possible DNS-rebind attack detected“).

Danach **Save & Apply** — beide Tabs bleiben bis dahin ungespeichert.

## 8. Testen

Auf dem Router (`ssh root@192.168.14.1`): `ping vps.ulno.mesh` (DNS funktioniert und das Lighthouse antwortet). Auf einem Rechner im LAN: `ping ulno-oldplex02.hsbi01.ulno.mesh` — alle Service-Hosts heißen `ulno-oldplexNN.hsbi01.ulno.mesh`.

Bei Problemen: *Status → System Log* nach Meldungen von `dnsmasq` und `nebula` durchsuchen.

## Was das Masquerading bedeutet

Durch das Masquerading erscheinen alle LAN-Geräte im Mesh als der Router. Ob ein Dienst im Mesh erreichbar ist, entscheiden also die **Nebula-Firewallregeln der Gegenstelle** für das Zertifikat bzw. die Gruppen des Routers — nicht die Firewall des Routers.

---

[← Modul 3](./03-overlay-and-mesh-networks.md) | [Modulindex](./00-index.md)
