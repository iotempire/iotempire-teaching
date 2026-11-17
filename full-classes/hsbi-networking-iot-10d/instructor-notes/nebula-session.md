# Instructor Notes — The Nebula Session (Module 3)

[← Instructor notes](./README.md) · [Module 3](../modules/03-overlay-and-mesh-networks.md) · [Syllabus](../syllabus.md)

The class joins an overlay with a **bundle per pod**, not with a certificate ceremony. The
student-facing tasks are in [Module 3](../modules/03-overlay-and-mesh-networks.md); this page is
what you prepare before the session.

**Scope this run:** Nebula only. Yggdrasil is deferred to a later class. B.A.T.M.A.N. is an
optional instructor showcase. A Chatto/Discord/MQTT bridge is a later extra, not a dependency.

## Before the session

- [ ] **Lighthouse:** the existing lighthouse on `ulno.mesh` is reachable, with `am_lighthouse:
  true` and UDP 4242 open. Put its public `ip:port` into every `static_host_map`.
- [ ] **Class CA** in `~/keys/class` — never in Git, never on a shared drive.
- [ ] **Certificates and groups:**
  - `lighthouse` — the lighthouse;
  - `students` — one router per pod;
  - `services` — the four Optiplex hosts;
  - `laptops` — optional direct laptop joins.
- [ ] **One bundle per pod** for its router, plus laptop bundles only for students who confirmed
  admin rights. Use `nebula-manager` for the CA, signing, configs, bundles, and the initial
  firewall policy; keep the commands in the transcript.
- [ ] **Optiplex cluster:** Nebula installed on `ulno-oldplex02`–`ulno-oldplex05`, group
  `services`. Four rootless Node-RED Podman containers per host, ports `18080–18083`, one
  persistent `/data` volume per pod, one class login.
- [ ] **Pod-to-container map:** `oldplex02` = pod01–04, `oldplex03` = pod05–08,
  `oldplex04` = pod09–12, `oldplex05` = pod13–15 + spare. Put the URL table on the board.
- [ ] **Firewall policy:** service hosts allow Node-RED ports `18080–18083` from `students`; pod
  routers allow `1883` from `services`. Restrict by host and port; do not add broad subnet rules
  in this first overlay session.
- [ ] **Node-RED login:** one initial class credential, `admin` / `iotempire`. It is a lab
  credential behind the Nebula policy, not a personal password; do not reuse it elsewhere.
- [ ] **Static `nebula` binaries** for the router architectures (MIPS / MIPSLE / ARM),
  pre-downloaded to a USB stick or an HTTP folder. The routers cannot be relied on to fetch from
  GitHub, and 16 MB of flash will not take a package install.
- [ ] **One router bundle end to end yourself** before class: install, `nebula -test`,
  `nebula1`, cross-NAT ping/ssh, router gateway, Node-RED, MQTT publish/subscribe.
- [ ] **USB sticks for extroot** are handed out and set up in Module 2; verify
  `df -h /overlay` shows the stick before this session.
- [ ] **Fallback:** if the Optiplex cluster is not ready, run one instructor-hosted Node-RED
  instance for the room. The MQTT path still works; the per-pod isolation is lost.

## The path to prove

```text
pod sensor -> pod Mosquitto (192.168.14.1:1883)
           -> Nebula -> router overlay address :1883
           -> Optiplex Node-RED (overlay name :1808x)
           -> command back to pod/<device>/set
           -> pod Mosquitto -> actuator

pod laptop -> Cudy LAN -> router gateway -> Node-RED UI (overlay name :1808x)
```

- **Router as gateway is the default.** A laptop on the pod LAN uses the router's `nebula1`
  forwarding and masquerade; no Nebula client is needed on the laptop.
- **Direct laptop joins are a stretch.** One or two students per pod may hold their own bundle;
  that is two overlay nodes in one pod, not a mistake.
- **Node-RED sees the router's overlay address** when the router masquerades LAN clients. Allow
  the `students` group on the Node-RED ports; do not open the UI to the world.
- **The lighthouse is a directory.** It does not relay HTTP or MQTT.

## Handing out

- One archive per pod. Never a shared archive: each bundle contains one private key.
- Put the pod names, overlay IPs, Node-RED URLs, and class login on the projector. Unlabeled
  archives get swapped within minutes.
- Say out loud that the archive is a credential and must not land in the portfolio repository.

## During the session

- The Windows path (`install.ps1`) needs admin; expect most of the room to use the router.
- Demo the **router** path, then one **cross-NAT** test, then one **MQTT through the overlay**
  command. The Node-RED UI is the easy part; the firewall and gateway are where the learning is.
- Use `nebula-manager` live only for the small things you did not prepare — a re-sign, a
  firewall-policy change, a bundle refresh. The students do not need the manager to install a
  bundle.
- Lost key or leaked archive: `cert resign-all` (or a single `sign`), hand out the new bundle,
  and have the client run `--certs-only`. Treat it as a lesson in why the key *is* the
  credential — not as an incident.
- If a pod finishes early: direct laptop join, scratch CA, or watch the B.A.T.M.A.N. showcase.
  Yggdrasil is not part of this run.

## After the session

- Delete the student bundles from the instructor host and any HTTP share; re-sign anything that
  was exposed.
- Back up `~/keys/class`. Losing the CA key means re-issuing the whole mesh.
- Keep the Node-RED volumes for the next module; do not delete a pod's flow between Module 3 and
  Module 4.

## Why bundles instead of certificate commands

The deployment unit is a node: **certificate + private key + config**. A bundle is that unit in
one archive, plus a self-contained installer. It removes the per-student `nebula-cert` ceremony,
makes the router and laptop paths the same artifact, and turns revocation into one certificate
instead of a shared secret everyone has to change.
