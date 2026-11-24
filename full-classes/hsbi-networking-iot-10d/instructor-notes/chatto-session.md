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

## 1. Decide where it runs

| Choice | Decision |
|---|---|
| Host | `ulno-oldplex01.hsbi01.ulno.mesh` (`10.100.1.1`) — the admin host, already the iperf3 target |
| Reachability | **Overlay only.** No public port, no reverse proxy, no DNS entry outside the mesh |
| Transport | **Plain HTTP** on `:4000`. The Nebula tunnel already encrypts the wire; a certificate would add a private CA on every student laptop for no teaching gain |
| TLS / mail | Not configured. Invitations by e-mail do not work — create accounts with the operator CLI |
| Calls | Not configured (no LiveKit). Text, files, and reactions only |

Students reach it from a laptop on the pod LAN through their **router's Nebula gateway**
(masquerade), exactly like Node-RED in Module 3 — no client software, no admin rights.

## 2. Install as a service

```bash
# on oldplex01, as root
useradd --system --home-dir /var/lib/chatto --shell /usr/sbin/nologin chatto
install -d -o chatto -g chatto /var/lib/chatto

# take the Linux x86_64 binary from the releases page (asset name like
# chatto-linux-amd64; check https://github.com/chattocorp/chatto/releases)
cd /var/lib/chatto
curl -fL -o chatto https://github.com/chattocorp/chatto/releases/latest/download/chatto-linux-amd64
chmod +x chatto
sudo -u chatto ./chatto init          # writes chatto.toml and ./data
```

`chatto init` writes the defaults: port `4000`, URL `http://localhost:4000`, embedded NATS with
data directory `./data`. Then set the public URL to the **overlay** address, so links in the UI
point where students can actually connect:

```toml
# /var/lib/chatto/chatto.toml
[webserver]
url = "http://10.100.1.1:4000"
```

`/etc/systemd/system/chatto.service`:

```ini
[Unit]
Description=Chatto chat server
After=network-online.target

[Service]
User=chatto
Group=chatto
WorkingDirectory=/var/lib/chatto
ExecStart=/var/lib/chatto/chatto run
Restart=always
RestartSec=3
NoNewPrivileges=yes

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload && systemctl enable --now chatto
systemctl status chatto --no-pager
curl -sI http://127.0.0.1:4000 | head -1      # expect an HTTP response
journalctl -u chatto -n 30 --no-pager         # if it did not come up
```

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

# from a pod router (or any mesh node)
nc -vz 10.100.1.1 4000
# from a laptop behind the pod router
curl -sI http://10.100.1.1:4000 | head -1
```

If `nc` says "connection refused" the service is down; if it hangs, the firewall rule is missing
or was not applied. That distinction is worth teaching — it is the same one as Module 3 Task 2.

## 4. First login and rooms

Register the first account in the web UI at `http://10.100.1.1:4000`, or from the shell:

```bash
cd /var/lib/chatto && sudo -u chatto ./chatto operator user create --login ulno
```

Suggested structure (keep it boring, `#` prefix, one room per pod so students have somewhere to
put a screenshot):

- `#class` — announcements, the URL and the credentials
- `#pod01` … `#pod15` — one per pod; the shared artefacts and questions land here
- `#curiosities` — the Module 4 replacement for the harvest ritual

Put the address **and** the credentials on the board. They are lab credentials, like the
Node-RED login — say so out loud so nobody reuses a real password.

## 5. Optional: the MQTT bridge (not installed)

The comparison gets sharp if a message can cross from MQTT into chat. Chatto has webhooks and an
HTTP API; there is no ready-made MQTT bridge, and it should not be one more service to operate
during the session. Two directions, both a small Python script on any laptop:

| Direction | Shape |
|---|---|
| MQTT → chat | subscribe `pod<NN>/cold/alarm`, POST the payload to the room's incoming webhook |
| chat → MQTT | Chatto webhook → a tiny HTTP endpoint → `client.publish(f"pod<NN>/chat/{room}", text)` |

Write it as a 15-line script if a pod asks; do not put it in the module as a task. The teaching
point is that both are publish/subscribe and only the addressing differs: a topic is chosen by
the publisher, a room by the people who joined it.

## 6. Traps

- **Port already in use.** `ss -ltnp | grep 4000` before you start; `oldplex01` also runs
  `iperf3` (`5201`) and SSH.
- **Wrong URL in `chatto.toml`.** With `http://localhost:4000` the UI hands out links nobody
  can open. It must be the overlay address.
- **Permissions.** Everything under `/var/lib/chatto` must belong to `chatto`; a root-owned
  `data/` fails at first write, not at start.
- **Browser warnings.** Plain HTTP plus a login prompt makes some browsers grumble. Expected;
  the tunnel is encrypted even when the last hop is not.
- **No mail.** Anything that expects SMTP (password reset, invitations) will not work. Create
  accounts with the operator CLI.
- **It is not assessment.** Do not require a Chatto artefact in any portfolio; the module offers
  it as an optional comparison in Task 2.

## 7. Sources

- [Chatto repository](https://github.com/chattocorp/chatto) · [self-hosting docs](https://docs.chatto.run/) ·
  [releases](https://github.com/chattocorp/chatto/releases) — binary, environment variables,
  `chatto.toml`, operator CLI
- [Chatto announcement](https://hmans.dev/blog/chatto-is-open-source) — what it is and is not
