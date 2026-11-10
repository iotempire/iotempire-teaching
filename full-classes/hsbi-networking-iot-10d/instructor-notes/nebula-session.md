# Instructor Notes — The Nebula Session (Module 3)

[← Instructor notes](./README.md) · [Module 3](../modules/03-overlay-and-mesh-networks.md) · [Syllabus](../syllabus.md)

The class joins an overlay with a **bundle per pod**, not with a certificate ceremony.
The student-facing steps are in [Module 3](../modules/03-overlay-and-mesh-networks.md);
this page is what you prepare before the session.

## Before the session

- [ ] **Lighthouse:** one small VPS or lab VM with a stable address,
  `lighthouse.am_lighthouse: true`, UDP 4242 open inbound. Put its public `ip:port`
  into `static_host_map` for every node config.
- [ ] **Class CA** in `~/keys/class` — never in Git, never on a shared drive.
- [ ] **One certificate per pod** for its router (`pod07-router`, `10.100.0.7/24`,
  group `students`); add laptop certificates (`…-laptop`, group `laptops`) for the
  students who confirmed admin rights on their own machine.
- [ ] `cert config generate --all`, then `cert bundle <name> --out ~/bundles` — or
  `fleet croc --select group:students --policy students` for one code per node.
- [ ] **Static `nebula` binaries** for the router architectures (MIPS / MIPSLE / ARM)
  pre-downloaded to a USB stick or an HTTP folder. The routers cannot be relied on to
  fetch from GitHub, and 16 MB of flash will not take a package install.
- [ ] Run **one router bundle end to end yourself** before class — that is the path
  most pods take, and the one that can eat the session.
- [ ] USB sticks for extroot are handed out and set up in **Module 2**; verify
  `df -h /overlay` shows the stick before this session.

## Handing out

- One archive per pod. Never a shared archive: each bundle contains one private key.
- Put the pod names and their overlay IPs on the projector; unlabeled archives get
  swapped within minutes.
- Say out loud that the archive is a credential and must not land in the portfolio
  repository.

## During the session

- The Windows path (`install.ps1`) needs admin; expect half the room to be
  router-only. Demo the **router** path and let the Windows students follow along.
- Lost key or leaked archive: `cert resign-all` (or a single `sign`), hand out the new
  bundle, and have the client run `--certs-only`. Treat it as a five-minute lesson in
  why the key *is* the credential — not as an incident.
- Nobody runs `nebula-manager` as root; it elevates per action by design.
- If a pod finishes early, the stretchers are in the module: B.A.T.M.A.N. mesh,
  Yggdrasil, or "be the CA" with a scratch workspace.

## After the session

- Delete the student bundles from the instructor host and any HTTP share; re-sign
  anything that was exposed.
- Back up `~/keys/class`. Losing the CA key means re-issuing the whole mesh.

## Why bundles instead of certificate commands

The deployment unit is a node: **certificate + private key + config**. A bundle is that
unit in one archive, plus a self-contained installer. It removes the per-student
`nebula-cert` ceremony, makes the router and laptop paths the same artifact, and turns
revocation into one certificate instead of a shared secret everyone has to change.
