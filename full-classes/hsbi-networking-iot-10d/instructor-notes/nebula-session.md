# Instructor Notes — The Nebula Session (Module 3)

[← Instructor notes](./README.md) · [Module 3](../modules/03-overlay-and-mesh-networks.md) · [Syllabus](../syllabus.md)

The class joins an overlay with a **bundle per pod**, not with a certificate ceremony. The
student-facing tasks are in [Module 3](../modules/03-overlay-and-mesh-networks.md); this page is
what you prepare before the session.

**Scope this run:** Nebula only. Yggdrasil is deferred to a later class. B.A.T.M.A.N. is an
optional instructor showcase. A Chatto/Discord/MQTT bridge is a later extra, not a dependency.

## Before the session

- [ ] **Lighthouse:** the class lighthouse is reachable and `am_lighthouse: true`; put its public
  `ip:port` into every `static_host_map`. The concrete endpoint is kept with the CA workspace.
- [ ] **Certificate workspace:** an instructor-owned CA workspace outside Git; the CA key never
  leaves the instructor machine. The concrete path is kept with the keys.
- [ ] **Certificates and groups:**
  - one lighthouse certificate;
  - one router certificate per pod, with the student group **and a per-pod group**;
  - one certificate per service host, with the service group and the admin group;
  - one certificate for the admin host, with the admin group only;
  - optional laptop certificates, with the laptop group (and the pod group when the laptop must
    reach that pod's Node-RED).
- [ ] **One bundle per pod** for its router, with the shared pod policy; laptop bundles only
  for students who confirmed admin rights. Use `nebula-manager` with `-l` and keep the operator
  log.
- [ ] **Service hosts:** Nebula installed on the instructor-provided Optiplex hosts; one admin-only
  host and several Node-RED hosts. Up to four rootless Podman containers per Node-RED host, one
  persistent volume per pod, one class login.
- [ ] **Install the prepared service bundles** and run `nebula -test`; `firewall explain` must show
  the admin rule and only the matching per-pod rules.
- [ ] **Pod-to-container map:** each pod is assigned to one service host and one host port; put the
  URL table on the board. The concrete map is kept with the CA workspace.
- [ ] **Firewall policy:** service hosts drop inbound by default and allow only the matching
  per-pod group on the assigned Node-RED port; the admin group is allowed for administration.
  Pod routers use the shared pod policy: broker port from the service group, SSH/ICMP from
  the student/laptop/admin groups, outbound open. No broad subnet rules.
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

## Certificate layout (template)

The concrete certificate names, overlay addresses, group labels, port map, policy-pack names,
bundle directory, and signing commands are kept with the CA workspace, not in this repository.
Use this shape:

| Node | Groups | Firewall intent |
|---|---|---|
| Lighthouse | lighthouse | Directory only; control traffic |
| Admin host | admin | Drop inbound; allow the admin group only |
| Service hosts | service + admin | Drop inbound; allow each pod's group only on its assigned port |
| Pod routers | student + per-pod | Drop inbound; broker port from the service group; SSH/ICMP from student/laptop/admin |
| Optional laptops | laptop (+ per-pod) | No service exposure; add the per-pod group only for that pod's Node-RED |

**The per-pod group is the selector.** A service host cannot distinguish pods from a single
student group; every router needs the student group plus its own per-pod group. The service host
allows only the matching pod group on the assigned port.

> [!NOTE]
> **Group names are provisional.** The current labels (`services`, `podNN`, `students`, `laptops`)
> are still being discussed. Confirm them before issuing the student certificates. The firewall
> shape is what matters: one group per pod, one service group, one admin group.

**What the group split means.**

- A router with only the student group cannot reach its Node-RED port; it needs its per-pod group.
- A direct laptop join needs the laptop group plus the pod group if it should reach that pod's
  Node-RED. Without the pod group, use the router gateway path.
- Replacing a router: keep the name, overlay IP, and per-pod group. Re-sign only the certificate.
- Changing the pod-to-port map: update that service host's policy pack and re-bundle the host;
  the pod group stays the same.
- The shared pod policy allows inbound broker traffic from the service group, SSH/ICMP from
  the student/laptop/admin groups, and open outbound.

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
  each per-pod group only on its assigned Node-RED port; do not open the UI to the world.
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

- Delete the student bundles from the instructor host and any HTTP share; after installing the
  service bundles, delete those archives too. Re-sign anything that was exposed.
- Back up the CA workspace. Losing the CA key means re-issuing the whole mesh.
- Keep the Node-RED volumes for the next module; do not delete a pod's flow between Module 3 and
  Module 4.

## Why bundles instead of certificate commands

The deployment unit is a node: **certificate + private key + config**. A bundle is that unit in
one archive, plus a self-contained installer. It removes the per-student `nebula-cert` ceremony,
makes the router and laptop paths the same artifact, and turns revocation into one certificate
instead of a shared secret everyone has to change.
