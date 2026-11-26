# Chatto session — the class chat on the cluster

Instructor setup for the chat surface Module 4 compares MQTT against. Small on purpose:
one host, one binary, one port, one firewall rule.

**What it is.** [Chatto](https://github.com/chattocorp/chatto) (AGPL-3.0 with Apache-2.0
exceptions) is a self-hosted team chat. One Go binary serves the API *and* the web frontend,
with an embedded NATS store — no external database. Default port **4000**. Voice/video needs a
separate LiveKit server; **we do not run it**. Config lives in `chatto.toml` next to the binary,
data in `./data`.

**Why it is here.** Module 4 asks whether a chat protocol and MQTT solve the same problem. A
live server students can actually use beats a paragraph. It is *not* an assessment target and
not part of the grading pipeline; it is a comparison object and a place to swap curiosities.

**Current state (2026-11-25).** Installed and running:

| | |
|---|---|
| URL | **`https://10.100.1.1:4000`** for students (an IP needs no DNS); `https://ulno-oldplex01.hsbi01.ulno.mesh:4000` also works for any client that runs the Nebula client — both are in `allowed_origins`. The scheme must be `https`, see §1 |
| Service | `systemctl status chatto` — user `chatto`, `/var/lib/chatto`, unit `/etc/systemd/system/chatto.service`; listens on **127.0.0.1:4001** only |
| TLS | `chatto-tls.service` (stunnel4) terminates TLS on `0.0.0.0:4000` and forwards to `127.0.0.1:4001`; self-signed certificate in `/etc/ssl/chatto/` with SANs `IP:10.100.1.1` and the mesh name; see §2.3 |
| Version | **0.6.0-beta.8** (a prerelease) — binary from the release tarball, sha256 checked against the GitHub API digest. 0.5.0 is kept beside it for a one-command rollback; see §2 |
| Operator API | local root-equivalent Unix socket `/run/chatto/operator.sock`, enabled — that is how accounts and rooms are made without mail; see §2.1 |
| Firewall | `4000/tcp` from `10.100.0.0/16` in the `oldplex01` pack, applied 2026-11-24 (host backup `config.yml.bak.20261124-175402`) |
| Still to do | Rooms only — `chatto operator room create --name podNN` (§4). Accounts exist: `ulno` (owner) and `pod01`…`pod15`, password `iotempire`, created 2026-11-25 |

## 1. Decide where it runs

| Choice | Decision |
|---|---|
| Host | `ulno-oldplex01.hsbi01.ulno.mesh` (`10.100.1.1`) — the admin host, already the iperf3 target |
| Reachability | **Overlay only.** No public port, no reverse proxy, no DNS entry outside the mesh |
| Transport | **HTTPS** on `:4000`, terminated locally by stunnel with a self-signed certificate. Plain HTTP looks harmless — the tunnel already encrypts the wire — but the web client calls `crypto.randomUUID()`, and browsers expose that only in a **secure context**. Over `http://` the app throws `TypeError: crypto.randomUUID is not a function` and dies on the loading dots. TLS is a hard requirement, not a nicety |
| TLS / mail | Not configured. No SMTP, so e-mail invitations and password reset do not work — accounts are created in the setup wizard, by an owner, or with the operator CLI |
| Calls | Not configured (no LiveKit). Text, files, and reactions only |

Students reach it from a laptop on the pod LAN through their **router's Nebula gateway**
(masquerade), exactly like Node-RED in Module 3 — no client software, no admin rights.

## 2. Install as a service

```bash
# on oldplex01, as root
useradd --system --home-dir /var/lib/chatto --shell /usr/sbin/nologin chatto
install -d -m 0750 -o chatto -g chatto /var/lib/chatto

cd /var/lib/chatto
curl -fL -o /tmp/chatto.tar.gz \
  https://github.com/chattocorp/chatto/releases/download/v0.6.0-beta.8/chatto_Linux_x86_64.tar.gz
sha256sum /tmp/chatto.tar.gz           # must match the digest on the release page

tar xzf /tmp/chatto.tar.gz chatto      # the archive holds chatto, NOTICE, LICENSES/ (98 MB)
chown chatto:chatto chatto && chmod 0755 chatto
./chatto --version                     # expect: chatto version 0.6.0-beta.8

sudo -u chatto ./chatto init           # NON-interactive; -i is the guided version
```

`chatto init` writes the defaults: port `4000`, URL `http://localhost:4000`, embedded NATS with
data directory `./data`, and the first-run setup wizard enabled. Then set the public URL to the
**overlay** address, so links in the UI point where students can connect, and let Chatto check the
file:

```bash
cd /var/lib/chatto
cp -a chatto.toml chatto.toml.bak
sed -i "s|url = 'http://localhost:4000'|url = 'https://10.100.1.1:4000'|" chatto.toml
# the TLS terminator (§2.3) is the only listener on 4000, so Chatto itself goes to loopback
sed -i "s|^port = 4000|port = 4001|" chatto.toml
sed -i "/^port = 4001/a bind_address = '127.0.0.1'" chatto.toml
grep -nE '^(url|port|bind_address) =' chatto.toml
sudo -u chatto ./chatto config check   # expect: Configuration check passed
```

Also set `allowed_origins` to the **https** origins (IP and mesh name, §2.3). Leave it on `http://`
and the login succeeds while the app still refuses to boot — the most confusing failure in this file.

```toml
allowed_origins = ['https://10.100.1.1:4000', 'https://ulno-oldplex01.hsbi01.ulno.mesh:4000']
```

`chatto.toml` contains `cookie_signing_secret`, `core.secret_key` and the embedded NATS token. Keep
it at mode `600`, never paste it into the repository, and treat a leaked copy as a full reset of
sessions and invitation codes.

`oldplex01` has `ffmpeg`, so `asset_processing` stays enabled and thumbnails work. On a host
without it, set `[asset_processing] enabled = false` rather than running a worker that fails on
every upload.

`/etc/systemd/system/chatto.service`:

```ini
[Unit]
Description=Chatto chat server
Documentation=https://docs.chatto.run/
After=network-online.target
Wants=network-online.target

[Service]
User=chatto
Group=chatto
WorkingDirectory=/var/lib/chatto
ExecStart=/var/lib/chatto/chatto run
Restart=always
RestartSec=3
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=full
ProtectHome=yes

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload && systemctl enable --now chatto
systemctl status chatto --no-pager
curl -sI http://127.0.0.1:4000 | head -1      # expect an HTTP response
journalctl -u chatto -n 30 --no-pager         # if it did not come up
```

### 2.1 Enable the operator API (no mail, so this is the user admin)

The operator CLI talks to a **local root-equivalent Unix socket** that is **disabled by default**, and
it lives in `/tmp` — which the unit's `PrivateTmp=yes` hides from the host. Give it a real runtime
directory instead:

```ini
# in [Service] of /etc/systemd/system/chatto.service
RuntimeDirectory=chatto
RuntimeDirectoryMode=0700
```

```toml
# appended to /var/lib/chatto/chatto.toml
[operator_api]
enabled = true
socket_path = '/run/chatto/operator.sock'
```

```bash
systemctl daemon-reload && systemctl restart chatto
ls -l /run/chatto                     # operator.sock, dir 0700 owned by chatto
cd /var/lib/chatto && ./chatto operator user list
```

**The directory mode must be `0700`, not `0750`.** Chatto refuses to start with
`operator API socket directory … must not be accessible by group or other users` — a clear message,
but only after you have already wondered why the unit flaps.

### 2.2 Rollback to 0.5.0

The previous binary, its data directory and its config are kept side by side. Same schema family, but
the 0.6 client seeds rooms differently, so roll back with its own data:

```bash
systemctl stop chatto
cd /var/lib/chatto
mv chatto chatto-beta8 && mv data data.beta8 && mv chatto.toml chatto.toml.beta8
mv chatto-0.5.0 chatto && mv data.0.5.0 data && mv chatto.toml.0.5.0 chatto.toml
systemctl start chatto
```

**Do not roll back just because it is a beta.** 0.5.0 needs TLS for exactly the same reason, so
reverting costs the newer UI and forces the wizard again without reducing risk. Roll back only if
beta.8 fails *after* the certificate has been accepted, and capture the console error first — a
rollback discards the current `data/`, including accounts and rooms.

### 2.3 TLS in front of Chatto — required, not optional

Plain HTTP breaks the web client. `crypto.randomUUID()` is `[SecureContext]`, so on
`http://10.100.1.1:4000` it is `undefined`; the app throws an uncaught `TypeError` right after the
realtime socket connects and never boots. The server looks healthy (login logged, event stream open,
assets `200`) and the page sits on the loading dots — the failure is entirely browser-side.

`stunnel4` is the smallest possible terminator: it speaks TLS and hands the decrypted byte stream to
Chatto, so HTTP *and* the realtime WebSocket pass unchanged.

```bash
apt-get install -y stunnel4

install -d -m 700 /etc/ssl/chatto
openssl req -x509 -newkey rsa:2048 -nodes -days 365 \
  -keyout /etc/ssl/chatto/chatto.key -out /etc/ssl/chatto/chatto.crt \
  -subj '/CN=10.100.1.1' \
  -addext 'subjectAltName=IP:10.100.1.1,DNS:ulno-oldplex01.hsbi01.ulno.mesh'
chmod 600 /etc/ssl/chatto/chatto.key
```

`/etc/stunnel/stunnel.conf`:

```ini
foreground = yes
debug = 4

[chatto]
accept  = 4000
connect = 127.0.0.1:4001
cert    = /etc/ssl/chatto/chatto.crt
key     = /etc/ssl/chatto/chatto.key
```

`/etc/systemd/system/chatto-tls.service` — a native unit. Debian's own `stunnel4` service is a sysv
script that looks *enabled* and stays *inactive*; `foreground = yes` plus `Type=simple` (the default)
keeps systemd in charge:

```ini
[Unit]
Description=Chatto TLS terminator (stunnel 4000 to chatto 127.0.0.1:4001)
After=network-online.target chatto.service
Wants=network-online.target chatto.service

[Service]
ExecStart=/usr/bin/stunnel4 /etc/stunnel/stunnel.conf
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload && systemctl enable --now chatto-tls
curl -k -o /dev/null -w '%{http_code}\n' https://127.0.0.1:4000/          # 200
# the realtime socket must survive the tunnel too — this is the one that matters
curl -k -o /dev/null -w '%{http_code}\n' \
  -H 'Connection: Upgrade' -H 'Upgrade: websocket' -H 'Sec-WebSocket-Version: 13' \
  -H 'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==' -H 'Origin: https://10.100.1.1:4000' \
  https://10.100.1.1:4000/api/realtime                                   # 101
```

Students accept the self-signed certificate once per browser (*Advanced → Accept the risk*). That is
the price of not running a public CA; the reasoning, the rejected alternatives (Cloudflare Tunnel, a
public host on the lighthouse, desktop clients, Prosody) and the recorded upgrade path are in
[D25](./00-architecture-decisions.md#d25--the-chat-is-served-over-self-signed-tls-inside-the-overlay-a-public-name-is-the-recorded-upgrade-path).
A trusted certificate needs a public name resolving to `10.100.1.1` plus a Let's Encrypt **DNS-01**
challenge (HTTP-01 cannot reach a private address); the same unit then only swaps the two file paths.

Anything **scripted** that posts to the chat must skip certificate verification: `requests.post(url,
verify=False)` in Python, `msg.rejectUnauthorized = false` in a Node-RED `http request`. That is fine
inside the overlay and wrong anywhere else — it is the sentence students are asked to write in
Module 4 Task 4 (the bridges).

## 3. Open the firewall — the only Nebula change

Chatto is useless if the mesh drops the packets. `oldplex01` carries the `oldplex01` policy pack
(`~/.config/nebula-manager/policies/oldplex01.yml`). It already allows the `ulno` group and
ICMP + `5201` from `10.100.0.0/16`; **add one rule**:

```yaml
  - port: 4000
    proto: tcp
    cidr: 10.100.0.0/16
```

Apply it from the CA workspace and verify — `fleet ssh` replaces the whole `firewall:` section
from the pack, so edit the pack, never the host:

```bash
nebula-manager fleet ssh ulno-oldplex01.hsbi01.ulno.mesh --policy oldplex01 --yes
# if it is not on PATH, run ./nebula-manager from the nebula-manager checkout

# from a pod router (or any mesh node)
nc -vz 10.100.1.1 4000
# from a laptop behind the pod router (add -k: the certificate is self-signed)
curl -k -sI https://10.100.1.1:4000 | head -1
```

If `nc` says "connection refused" the service is down; if it hangs, the firewall rule is missing
or was not applied. That distinction is worth teaching — it is the same one as Module 3 Task 2.

## 4. First login and rooms

There is a **browser setup wizard**: the first visit to `https://10.100.1.1:4000` asks for the server
name and the owner account — no mail, no CLI. (Accept the certificate warning first; see §2.3.) Do
that yourself — do not let a student take the
owner slot. From then on, accounts come from the owner (invitation codes) or from the shell:

```bash
cd /var/lib/chatto

# one account per student, password from stdin so it stays out of the shell history
printf '%s' 'iotempire' | ./chatto operator user create \
  --login pod01a --display-name 'Pod 01 A' --password-stdin

./chatto operator user list                      # who exists, with roles
./chatto operator user set-password USER_ID      # when someone forgets (--password-stdin likewise)
./chatto operator room create --name class --description 'Announcements'
./chatto operator room create --name pod01
```

Use `--role owner` on a second instructor account, and keep the room names boring and `#`-free on the
command line (Chatto adds the prefix). Run all of this as **root from the host**, not with `sudo -u
chatto`: the socket is root-equivalent by design and the CLI finds it at the path from §2.1.

**One student, on the spot** — the whole thing is a single command as root on `oldplex01`:

```bash
cd /var/lib/chatto && ./chatto operator user create \
  --login pod16 --display-name 'Pod 16' --password iotempire
```

`pod01`…`pod15` and the owner `ulno` already exist in this state (2026-11-25). If a login is
forgotten or wrong, `set-password USER_ID` fixes it without touching anything else. `operator room`
has **create**, **list** and **member** — there is **no delete**, so choose room names deliberately;
they are easier to live with than to undo.

**State (2026-11-25).** Owner `ulno`; accounts `pod01`…`pod15` (password `iotempire`); channel rooms
`announcements` and `general` (seeded), `pod01`…`pod14` and `curiosities` (created). `pod15` has an
account but no room — add one with `operator room create --name pod15` if the fifteenth pod exists.

**Registration is open.** `[auth] direct_registration = true` and `direct_login = true`, so anyone who
can reach the overlay can create an account; the hand-out accounts and self-registration coexist.
With no SMTP the e-mail verification step has nowhere to go, so **test one throwaway registration**
before you count on it. If it dead-ends, or the rooms start filling with junk, set
`direct_registration = false` and restart — then the only ways in are your accounts and owner
invitations.

There is no mail, so **there is no self-service**: no password reset, no e-mail invitation. Either
the owner issues invitation codes in the UI, or you create accounts here. Decide before the session
which of the two the students will meet, because they will meet it in the first five minutes.

Suggested structure (keep it boring, `#` prefix, one room per pod so students have somewhere to
put a screenshot):

- `#class` — announcements, the URL and the credentials
- `#pod01` … `#pod15` — one per pod; the shared artefacts and questions land here
- `#curiosities` — the Module 4 replacement for the harvest ritual

Put the address **and** the credentials on the board. They are lab credentials, like the
Node-RED login — say so out loud so nobody reuses a real password.

## 5. The MQTT bridge — a student task, not an install

The comparison gets sharp if a message can cross from MQTT into chat, so it is now part of
**Module 4 Task 4 — bridges**: Node-RED subscribes `cold/ac/alarm` and posts to a room's incoming
webhook, optionally the other way round. Chatto has webhooks and an HTTP API; there is no ready-made
MQTT bridge, and it should not become one more service to operate during the session.

| Direction | Shape |
|---|---|
| MQTT → chat | `mqtt in` → `function` → `http request` POST to the room's incoming webhook |
| chat → MQTT | a bot token (Telegram/Discord) or the Chatto API → `mqtt out` on `cold/ac/set` |

The teaching point is that both are publish/subscribe and only the addressing differs: a topic is
chosen by the publisher, a room by the people who joined it. Keep it out of assessment — D24 makes
the chat a comparison object.

**Do students need bot accounts, Discord-style?** Two different jobs need two different mechanisms:

| Job | Mechanism | Who can create it |
|---|---|---|
| MQTT → chat, one way | an **incoming webhook** on the room — no account, the URL *is* the credential | whoever may manage the room; as owner you can make one per pod room |
| chat → MQTT, read and reply | a **bot account** with an API key, inheriting its owner's permissions | the pod, if the UI offers it to a member; otherwise the owner creates it |

For the bridge task the lazy and good answer is **one webhook per pod room**, created in the UI (room
settings → integrations) and handed to the pod. The reverse direction can share a single `bridge`
bot, with the caveat that everything it posts looks like the same author. Webhook URLs and API keys
are secrets: never in the repository, never on a slide — hand them over like the bundle keys. Bot
accounts cannot be created through the operator CLI, only in the app.

## 6. Traps

- **Port already in use.** `ss -ltnp | grep 4000` before you start; `oldplex01` also runs
  `iperf3` (`5201`) and SSH.
- **Wrong URL in `chatto.toml`.** With `http://localhost:4000` the UI hands out links nobody
  can open. It must be the overlay address.
- **Permissions.** Everything under `/var/lib/chatto` must belong to `chatto`; a root-owned
  `data/` fails at first write, not at start.
- **Browser warnings.** Plain HTTP plus a login prompt makes some browsers grumble. Expected; the
  tunnel is encrypted even when the last hop is not. A mesh **name** does not change this — the badge
  is about `http://`, not about the address. Removing it would need a certificate Firefox trusts:
  a private CA on every laptop (no) or a real domain with a Let's Encrypt DNS-01 certificate
  pointing at `10.100.1.1` (possible, but renewal plus split-horizon DNS for a comparison object).
- **Two accepted origins.** `[webserver] allowed_origins` lists the IP and the mesh name, so cookie
  auth works on either. If you later add a third way in (a tunnel, another name), add it there too or
  the login will succeed and the app will sit on a loading spinner.
- **The app hangs on the loading dots over plain HTTP — that is the secure-context trap, not a server
  fault.** The console shows `Uncaught TypeError: crypto.randomUUID is not a function` right after
  `[ws] Connected`. The server log stays clean because nothing is wrong with the server, and upgrading
  Chatto does not help: 0.5.0 and 0.6.0 both need a secure context. Fix the origin — TLS, §2.3 — and
  keep `webserver.url` plus `allowed_origins` on `https://`.
- **Console noise from browser extensions.** `Content-Security-Policy … blocked an inline script` and
  `… blocked a JavaScript eval`, both on `content.js`, come from a content-script extension (reader,
  translator, password manager), not from Chatto: Chatto ships a strict `script-src` with two exact
  hashes. Ignore those two lines and look for the first red *TypeError* instead.
- **A fresh data directory means the wizard again.** Swapping `data/` aside to start clean also
  discards the owner account — claim the owner slot before students see the URL, or anybody can.
- **No mail.** Anything that expects SMTP (password reset, invitations) will not work. Create
  accounts with the operator CLI.
- **It is not assessment.** Do not require a Chatto artefact in any portfolio; the module offers
  it as an optional comparison in Task 2.

## 7. Sources

- [Chatto repository](https://github.com/chattocorp/chatto) · [self-hosting docs](https://docs.chatto.run/) ·
  [releases](https://github.com/chattocorp/chatto/releases) — binary, environment variables,
  `chatto.toml`, operator CLI
- [Chatto announcement](https://hmans.dev/blog/chatto-is-open-source) — what it is and is not
