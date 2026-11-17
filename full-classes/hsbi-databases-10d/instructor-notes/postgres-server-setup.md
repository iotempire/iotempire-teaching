# Instructor setup — native PostgreSQL + pgweb + Cloudflare on Debian Trixie

[Module 6b](../modules/06b-polyglot-persistence.md) · [06b instructor note](./06b.md) · [All notes](./README.md)

**Status: draft for the 2026-11-19 run.** The commands below target a vanilla **Debian 13
“Trixie”** install with **PostgreSQL 17** from the Debian archive and **pgweb 0.17.0** from its
GitHub release. They have not yet been exercised on the Optiplex; test them there and correct this
file when reality disagrees. The container fallback remains
[`postgres-tunnel.sh`](./postgres-tunnel.sh).

**What this guide sets up**

- PostgreSQL 17 on `127.0.0.1:5432` (never published).
- One database and one role per pod, with generated passwords.
- pgweb on `127.0.0.1:8081`, behind HTTP basic auth.
- A Cloudflare named tunnel from `https://hsbi-dbs.ulno.net` to pgweb.
- A credential sheet for the room, and a clear answer to “what certificate do we hand out?”

**What students receive:** the HTTPS URL, the shared pgweb basic-auth login, and one row per pod
with host, port, database, user, and password. They do **not** receive a client certificate, the
Cloudflare `cert.pem`, or the tunnel credentials JSON.

---

## 1. One-page runbook for class day

```sh
# 0. Load the pgweb password generated in section 6
PGWEB_PASS="$(sudo sed -n 's/^PGWEB_AUTH_PASS=//p' /etc/pgweb/pgweb.env)"

# 1. Services are up
systemctl status postgresql pgweb cloudflared --no-pager

# 2. Local pgweb answers (401 without credentials, 200 with them)
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8081
curl -s -o /dev/null -w '%{http_code}\n' -u class:"$PGWEB_PASS" http://127.0.0.1:8081

# 3. The public URL answers through Cloudflare
curl -s -o /dev/null -w '%{http_code}\n' https://hsbi-dbs.ulno.net

# 4. The credential sheet is readable by you, not the world
ls -l /etc/dbs-bench/credentials.txt

# 5. One pod connects (from the server itself)
PGPASSWORD='pod01-password' psql -h 127.0.0.1 -U pod01 -d pod01 -c 'SELECT * FROM machine;'
```

Then test from a **student laptop on the campus Wi-Fi**, not from the Optiplex: open the URL, log
into pgweb, connect `pod01`, and run the same `SELECT`.

If the public URL fails, the fallback is the LAN: run pgweb on `0.0.0.0:8081` behind the campus
firewall, or use [`postgres-tunnel.sh up --lan`](./postgres-tunnel.sh). The lesson is identical; the
connection host changes from `127.0.0.1` to the server's LAN address.

---

## 2. Install PostgreSQL 17

Debian 13 ships PostgreSQL 17 in the default archive; no PGDG repository is needed.

```sh
sudo apt update
sudo apt install -y postgresql postgresql-client unzip curl ca-certificates openssl
psql --version
```

Expected: `psql (PostgreSQL) 17.x`.

Debian creates the `postgres` system user and a cluster named `main` on port `5432`. Check:

```sh
sudo systemctl status postgresql --no-pager
sudo -u postgres psql -c 'SHOW server_version;'
```

---

## 3. Configure PostgreSQL for a classroom

Keep PostgreSQL on localhost; pgweb is the only exposed service.

```sh
sudo pg_conftool 17 main set listen_addresses 'localhost'
sudo pg_conftool 17 main set max_connections 200
sudo pg_conftool 17 main set shared_buffers '256MB'
sudo pg_conftool 17 main set work_mem '8MB'
sudo systemctl restart postgresql
```

Check the values:

```sh
sudo -u postgres psql -c 'SHOW listen_addresses;'
sudo -u postgres psql -c 'SHOW max_connections;'
sudo -u postgres psql -c 'SHOW shared_buffers;'
```

`pg_hba.conf` must allow the pgweb host connection with a password. Debian's default usually
contains:

```text
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256
```

Check it:

```sh
sudo grep -E '^(host|local)' /etc/postgresql/17/main/pg_hba.conf
```

If the `127.0.0.1/32` line says `peer` or `trust`, change it to `scram-sha-256` and reload:

```sh
sudo systemctl reload postgresql
```

Do **not** add a `0.0.0.0/0` line. pgweb runs on the same machine and connects to `127.0.0.1`.

---

## 4. Provision one database and role per pod

Use the actual pod count. The default below is 20; set `PODS` to the real number.

```sh
umask 077
PODS=20
SHEET="$(mktemp)"
sudo install -d -m 700 /etc/dbs-bench

for n in $(seq -w 1 "$PODS"); do
  pod="pod$n"
  pw="$(openssl rand -hex 12)"

  if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname = '$pod'" | grep -qx 1; then
    sudo -u postgres psql -v ON_ERROR_STOP=1 -c "ALTER ROLE $pod WITH PASSWORD '$pw';"
  else
    sudo -u postgres psql -v ON_ERROR_STOP=1 -c "CREATE ROLE $pod LOGIN PASSWORD '$pw';"
  fi

  if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname = '$pod'" | grep -qx 1; then
    sudo -u postgres psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $pod OWNER $pod;"
  fi

  printf '%s\t%s\t%s\n' "$pod" "$pod" "$pw" >> "$SHEET"
done

sudo install -m 600 "$SHEET" /etc/dbs-bench/credentials.txt
rm -f "$SHEET"
```

The pod names are generated (`pod01` …), and the passwords are hex; do not paste arbitrary user
input into these SQL strings.

Check one role:

```sh
sudo -u postgres psql -c '\du pod01'
sudo -u postgres psql -c "SELECT datname FROM pg_database WHERE datname = 'pod01';"
```

---

## 5. Pre-create the 6b table in every pod database

The server task expects a small `machine` table with one row. Pre-create it so the 25-minute
task is about the server, not about table creation that Module 4 already covered.

```sh
PODS=20
for n in $(seq -w 1 "$PODS"); do
  sudo -u postgres psql -v ON_ERROR_STOP=1 -d "pod$n" <<'SQL'
CREATE TABLE IF NOT EXISTS machine(
    machine_id      INTEGER PRIMARY KEY,
    site            TEXT NOT NULL,
    parts_produced  INTEGER NOT NULL DEFAULT 0
);
INSERT INTO machine(machine_id, site, parts_produced)
VALUES (1, 'guetersloh', 0)
ON CONFLICT (machine_id) DO NOTHING;
SQL
done
```

This is deliberately **not** Module 4's `sensor` table. Module 4 has `sensor`/`reading`; the legacy
`machine` table is Module 2. Module 4's DDL also uses SQLite-only `STRICT`/`PRAGMA`, and its
`reading` table uses a `VIRTUAL` generated column that PostgreSQL does not support. The DML is
portable; the DDL is not.

---

## 6. Install pgweb

pgweb is a single Go binary; no package is required.

```sh
sudo useradd --system --home /var/lib/pgweb --shell /usr/sbin/nologin pgweb 2>/dev/null || true
sudo install -d -o pgweb -g pgweb -m 750 /var/lib/pgweb

curl -L -o /tmp/pgweb.zip \
  https://github.com/sosedoff/pgweb/releases/download/v0.17.0/pgweb_linux_amd64.zip
sudo unzip -o /tmp/pgweb.zip -d /usr/local/bin
sudo chmod 755 /usr/local/bin/pgweb
pgweb --version
```

Generate the pgweb basic-auth password once and store it in an environment file:

```sh
PGWEB_PASS="$(openssl rand -hex 12)"
sudo install -d -m 755 /etc/pgweb
printf 'PGWEB_AUTH_USER=class\nPGWEB_AUTH_PASS=%s\nPGWEB_SESSIONS=1\n' "$PGWEB_PASS" \
  | sudo tee /etc/pgweb/pgweb.env >/dev/null
sudo chmod 600 /etc/pgweb/pgweb.env
printf 'pgweb basic auth: class / %s\n' "$PGWEB_PASS"
```

Create the systemd unit:

```sh
sudo tee /etc/systemd/system/pgweb.service >/dev/null <<'EOF'
[Unit]
Description=pgweb for the Databases class
After=network.target postgresql.service
Wants=postgresql.service

[Service]
User=pgweb
Group=pgweb
EnvironmentFile=/etc/pgweb/pgweb.env
ExecStart=/usr/local/bin/pgweb --bind 127.0.0.1 --listen 8081
Restart=on-failure
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now pgweb
systemctl status pgweb --no-pager
```

**Flag check:** `--bind` is the HTTP-server host; `--listen` is the HTTP port. `--host` would be
the *database* host, which is not what you want here. pgweb lets each browser session enter the
database host in the connection form. `PGWEB_SESSIONS=1` enables multiple database sessions.

Test:

```sh
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8081
curl -s -o /dev/null -w '%{http_code}\n' -u class:"$PGWEB_PASS" http://127.0.0.1:8081
```

Expected: `401` without credentials, `200` with them.

---

## 7. Cloudflare named tunnel

You already have `cloudflared` installed. Confirm:

```sh
cloudflared --version
```

### 7.1 Log in and create the tunnel

`cloudflared tunnel login` needs a browser. On a headless Optiplex it prints a URL; open that URL
on another machine and authorize the zone. The command stores `cert.pem` in `/root/.cloudflared`
when run with `sudo`.

```sh
sudo cloudflared tunnel login
sudo cloudflared tunnel create dbs-bench
sudo cloudflared tunnel list
```

If `dbs-bench` already exists, reuse its UUID from `tunnel list` and skip `create`.

`tunnel create` prints a UUID and writes `/root/.cloudflared/<UUID>.json`. Copy the credential to
the service directory:

```sh
sudo install -d -m 700 /etc/cloudflared
sudo cp /root/.cloudflared/<UUID>.json /etc/cloudflared/<UUID>.json
sudo chmod 600 /etc/cloudflared/<UUID>.json
```

### 7.2 Route the hostname

```sh
sudo cloudflared tunnel route dns dbs-bench hsbi-dbs.ulno.net
```

This creates the CNAME in the Cloudflare-managed zone. If the record already exists, either reuse
it or remove the old one in the dashboard first.

### 7.3 Write the ingress config

Replace `<UUID>` with the tunnel UUID:

```sh
sudo tee /etc/cloudflared/config.yml >/dev/null <<'EOF'
tunnel: <UUID>
credentials-file: /etc/cloudflared/<UUID>.json
ingress:
  - hostname: hsbi-dbs.ulno.net
    service: http://127.0.0.1:8081
  - service: http_status:404
EOF
```

The final `http_status:404` rule is required; the tunnel will not start without a catch-all.

### 7.4 Install the service

```sh
sudo cloudflared --config /etc/cloudflared/config.yml service install
sudo systemctl enable --now cloudflared
systemctl status cloudflared --no-pager
```

If a cloudflared service already exists, stop and remove the old one first; do not run two
connectors for the same tunnel without intending it.

### 7.5 Test

```sh
PGWEB_PASS="$(sudo sed -n 's/^PGWEB_AUTH_PASS=//p' /etc/pgweb/pgweb.env)"
curl -s -o /dev/null -w '%{http_code}\n' https://hsbi-dbs.ulno.net
curl -s -o /dev/null -w '%{http_code}\n' -u class:"$PGWEB_PASS" https://hsbi-dbs.ulno.net
```

Expected: `401` without credentials, `200` with them. A `502` means Cloudflare reached the tunnel
but pgweb is down or on the wrong port. A `1033` means the tunnel itself is not connected.

### Quick tunnel for a smoke test

If you do not want to touch DNS yet:

```sh
cloudflared tunnel --url http://127.0.0.1:8081
```

Use the random `*.trycloudflare.com` URL for a single test. It is not stable for a term.

---

## 8. Credential sheet and certificate handout

### 8.1 What to hand out

Generate a sheet from `/etc/dbs-bench/credentials.txt` plus the fixed fields:

```text
Databases 6b — shared PostgreSQL

URL:          https://hsbi-dbs.ulno.net
pgweb login:  class / <PGWEB_PASS>
Host:         127.0.0.1        (container fallback: db)
Port:         5432
SSL mode:     disable         (pgweb-to-Postgres is local; Cloudflare TLS is browser-to-pgweb)

Pod 01   database pod01   user pod01   password <generated>
Pod 02   database pod02   user pod02   password <generated>
...
```

Hand out one row per pod; do not publish the sheet in the course repository. Print it or put it in
the LMS. The TA owns the printed copy and the first line of support.

### 8.2 What **not** to hand out

- **No client certificate.** Cloudflare terminates TLS with a public certificate; the browser
  shows a normal padlock. Students do not install anything.
- **Never hand out `/root/.cloudflared/cert.pem`.** It authorizes tunnel management for the zone.
- **Never hand out `/etc/cloudflared/<UUID>.json`.** It is the tunnel credential.
- **Do not hand out the `postgres` superuser password.** Students use their pod role only.

If “certificate handout” meant **Nebula client certificates**, that is a different network stack and
is not part of this Cloudflare setup. This guide assumes the public HTTPS tunnel. For a LAN-only
fallback with HTTPS, use Caddy with an internal CA and hand out the CA certificate explicitly;
plain HTTP on the classroom LAN is acceptable only for fake data and only with pgweb basic auth.

---

## 9. Test checklist

- [ ] `psql --version` shows 17.x.
- [ ] `systemctl status postgresql pgweb cloudflared` — all active.
- [ ] `SHOW listen_addresses;` → `localhost`.
- [ ] `SHOW max_connections;` → `200`.
- [ ] `SELECT * FROM machine;` works in `pod01` as `pod01`.
- [ ] pgweb returns `401` without basic auth and `200` with it.
- [ ] `https://hsbi-dbs.ulno.net` returns `401` without basic auth and `200` with it.
- [ ] A student laptop on the campus Wi-Fi can log into pgweb and connect `pod01`.
- [ ] Two different browsers can both open `pod01` and run the `UPDATE`.
- [ ] `sudo systemctl stop postgresql` makes a query fail; `start` and a pgweb reload recover it.
- [ ] The credential sheet is mode `600` and the TA has a printed copy.

---

## 10. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `502` from Cloudflare | pgweb is down or the tunnel points at the wrong port | `systemctl status pgweb`; `curl http://127.0.0.1:8081`; check `service:` in `/etc/cloudflared/config.yml` |
| `1033` from Cloudflare | Tunnel not connected | `systemctl status cloudflared`; `journalctl -u cloudflared -n 50`; `cloudflared tunnel info dbs-bench` |
| `401` in the browser | pgweb basic auth missing/wrong | Check `/etc/pgweb/pgweb.env`; restart pgweb |
| `password authentication failed` | Wrong pod password or `pg_hba.conf` line | Re-check the sheet; `grep 127.0.0.1 /etc/postgresql/17/main/pg_hba.conf`; reset the role password |
| `FATAL: sorry, too many clients already` | `max_connections` too low | `SHOW max_connections;`; raise it and restart PostgreSQL |
| pgweb cannot connect to `127.0.0.1` | PostgreSQL not listening or not running | `SHOW listen_addresses;`; `systemctl status postgresql` |
| `cert.pem` missing | `cloudflared tunnel login` was not completed | Re-run `sudo cloudflared tunnel login` |
| DNS does not resolve | CNAME not created | `sudo cloudflared tunnel route dns dbs-bench hsbi-dbs.ulno.net` |
| `pgweb: command not found` | Binary not in `/usr/local/bin` | Unzip `pgweb_linux_amd64.zip`; `chmod 755` |

---

## 11. Teardown

At the end of the run, decide whether to keep the server for the project weeks or tear it down.

```sh
sudo systemctl disable --now pgweb cloudflared
sudo cloudflared tunnel delete dbs-bench   # only when the tunnel is not running
```

Then remove the DNS record in the Cloudflare dashboard if it was only for this class, and drop the
pod databases/roles if the server will not be reused:

```sh
for n in $(seq -w 1 20); do
  sudo -u postgres dropdb --if-exists "pod$n"
  sudo -u postgres dropuser --if-exists "pod$n"
done
```

Remove `/etc/dbs-bench/credentials.txt` and `/etc/pgweb/pgweb.env` when they are no longer needed.

---

## 12. Security baseline

- PostgreSQL listens on `127.0.0.1` only. Never publish `5432`.
- pgweb is the only exposed service, behind HTTP basic auth and Cloudflare TLS.
- One role per pod, owning one database; no superuser, no `CREATEDB`, no cross-pod access.
- Fake data only. No student names, no real exports, no personal data.
- The credential sheet is mode `600`; the tunnel credentials are mode `600`.
- Rotate or discard the pod passwords at the end of the term.
- Do not debug infrastructure for more than ten minutes in front of the room; use the SQLite
  two-writer fallback and keep the lesson moving.
