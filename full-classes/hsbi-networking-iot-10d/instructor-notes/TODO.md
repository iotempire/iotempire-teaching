# Future work — TODOs for the next run

> Working list, written during the first run (WS 2026/27). Nothing here is a promise; it is the
> memory of what we noticed and did not have time to fix. Tick items as they land, and add the
> observation that motivated them — a TODO without a reason gets dropped.
>
> **Decisions are not made here.** The reasoning belongs in the
> [architecture log](./00-architecture-decisions.md). If an item turns out to be a design choice,
> write the record there and leave only the action here.

## The main design debt: over-specification and bloat

- [ ] **Relieve the whole class from AI over-specification and bloat.** Module 2 was far too
      detailed. It read like a generated checklist: every step was pre-decided, the text explained
      conclusions before students could reach them, and the volume crowded out engagement, own
      research, and the discovery of *why* something works. The result was a module students could
      execute without learning to think like the person who has to debug it.

      **Do not fix Module 2 during this run.** Use the observation as the design constraint for
      everything that follows, starting with Module 3 (Nebula). After the run, audit Module 2 and
      the other modules against it.

      **Keep explicit:** safety-critical commands, credential handling, recovery paths, and the
      minimum hardware facts that prevent damage. **Cut or convert:** step-by-step recipes that
      pre-empt a decision, explanations that arrive before the task creates the need, repeated
      warnings, reference tables that belong in the resource bank, and “do this” instructions where
      a question plus two sources would teach more.

- [x] **Before Module 3 (Nebula): apply the constraint, do not repeat the pattern.** Module 3 was
      rewritten for WS 2026/27 as five Task/Subtask/Evidence tasks: Nebula only, router gateway by
      default, direct laptop as a stretcher, Node-RED on the Optiplex cluster, and MQTT through the
      overlay. Yggdrasil is deferred; B.A.T.M.A.N. is an optional showcase. Keep the de-bloat
      constraint for Modules 4–7.

- [ ] **Audit Module 2 after the run.** Count the prescribed steps against the actual student
      decisions. For each step ask: *does this prevent damage, or does it prevent thought?* Keep
      the former; rewrite the latter as a decision, a source, or a failure to investigate. Keep the
      story, the discussion map, and the portfolio structure — the problem is the bloat, not the
      studio pattern.

## How to recognise the same problem in another module

- [ ] **A step tells the student what to conclude.** Replace the conclusion with the evidence and
      the question.
- [ ] **A theory box answers a question the task has not raised yet.** Move it after the attempt,
      or turn it into a study break.
- [ ] **There are more commands than decisions.** The module is a runbook, not a studio.
- [ ] **The instructor could read the module aloud and students would never need to look anything
      up.** That is the clearest sign that discovery has been designed out.
- [ ] **Safety and exploration are mixed in the same list.** Separate the non-negotiable guardrails
      from the part students are allowed to own.

## Module 2 — after the first run

- [ ] **Unify the pod SSID naming next run.** Module 2 allows both `pod<NN>` (this workbook) and
      `iotempire<NN>` (the German OpenWrt guide distributed in class, e.g. `iotempire07`). The split
      caused confusion in the room; the damage is done for WS 2026/27, so keep the dual naming for
      now. Next run, pick one scheme before the routers are handed out — likely `iotempire<NN>` to
      match the German guide — and update the module, the resource bank, and the slides together.
      Do not confuse either with the class uplink `iotempire-b1300-5g`.
- [ ] **Revisit the extroot/uplink order.** This run extroots before the uplink (Round 2 before
      Round 3), which works because the class image already contains the extroot packages. The
      German guide joins eduroam first because its script may download packages. With the script now
      in `resources/`, decide next run whether to keep extroot-first (fewer moving parts before
      Round 3) or switch to uplink-first (works on a plain upstream image and matches the German
      guide). If you switch, update Round 2 and the resource-bank recipe.

## Module 3 — before the session

- [ ] **Re-sign the class certificates onto one wide prefix.** The `/24` split made the service
      hosts unreachable from routers and laptops: in Nebula the certificate mask *is* the
      reachability boundary ([D22](./00-architecture-decisions.md#d22)). Re-sign every class
      certificate with the class prefix (same addresses), rebuild the bundles, and check `ip route`
      on one router and one service host. Re-signing writes a **new private key**, so every
      installed node needs a fresh bundle — including the instructor's own host, which drops its
      overlay connection for the moment it takes the new cert. The test certificate in the CA
      workspace (same host, address inside the infrastructure range) proves the cause first.
- [x] **Confirm the pod group naming.** Pod groups are `hsbi-netiotNN`; routers are
      `routerNN.hsbi-netiot.ulno.mesh` with `hsbi-netiotNN`. The service policies and the 15
      router certs use this scheme.
- [x] **Remove redundant role groups.** `services`, `students`, and `laptops` were removed; the
      router policy selects by the service range and the student range instead, with `ulno` as the
      admin group. No role groups remain to rename. Rationale and the accepted relaxation:
      [D21](./00-architecture-decisions.md#d21).
- [ ] **Test one router end to end** before the class: bundle with the shared pod policy, install,
      and verify SSH/ICMP and the broker path.
- [ ] **Install and verify the service-host bundles.** The four Node-RED hosts were re-bundled with
      the `hsbi-netiotNN` rules; the admin-only host is unchanged. After installing,
      `firewall explain` on each host must show `inbound_action: drop`, the admin rule, and only
      that host's pod groups on the assigned ports. The admin host must allow only the admin group.

## Module 3 — overlay policy watch items

- [ ] **Decide whether Task 5 may use `iperf3` to the service hosts.** The service policies open only the
      Node-RED ports (`18080`–`18083`) per pod group; `5201` is closed. Either add a `5201` rule per pod
      group for the measurement task, or keep the throughput measurement on the pod LAN (laptop ↔
      router) and say so on the board. Observation: the module's first draft asked for `iperf3` to the
      host without a rule that allows it.
- [ ] **Watch for cross-pod router access.** By design ([D21](./00-architecture-decisions.md#d21)) any
      student certificate may SSH to any pod router: the student range is wide and the rule selects
      by range, not by pod. That is an accepted convenience, not an oversight. If a pod reaches
      another pod's router and it disturbs the class, or if the routers start holding credentials or
      data, cut per-pod blocks inside the student range and re-sign the student certificates. It is an
      addressing change, not a group change — no role groups come back.
- [ ] **Check whether the wide student range was actually used for repairs.** Cross-pod SSH exists so
      that a pod whose own laptop is not set up can still help another pod, and so the instructor has
      one rule instead of fifteen. If nobody ever used it, the justification is weaker than the record
      claims — say so in the record rather than keeping a rule for a scenario that did not happen.

## Module 4 — before the session

- [x] **Deploy Chatto before Friday.** Installed and running on `oldplex01`: `https://10.100.1.1:4000` (TLS is mandatory — the web client needs a secure context for `crypto.randomUUID`), systemd units `chatto` (loopback `4001`) and `chatto-tls` (stunnel on `4000`), firewall `4000/tcp` from the class prefix, owner account `ulno` claimed 2026-11-25. Self-signed certificate, reasoned in [D25](./00-architecture-decisions.md#d25--the-chat-is-served-over-self-signed-tls-inside-the-overlay-a-public-name-is-the-recorded-upgrade-path). Manual: [`chatto-session.md`](./chatto-session.md).
- [x] **Create the accounts.** `ulno` (owner) plus `pod01`…`pod15` (password `iotempire`) created
      2026-11-25 through the operator socket. One student on the spot is a single
      `chatto operator user create --login … --password iotempire` as root on `oldplex01`
      ([`chatto-session.md`](./chatto-session.md) §4).
- [x] **Create the rooms.** `announcements` and `general` were seeded; `pod01`…`pod14` and
      `curiosities` created 2026-11-25 via `operator room create`. `pod15` has an account but no room
      (14 room names were requested) — add it if the fifteenth pod is real. Then the URL **and** the
      credentials on the board, plus one sentence about accepting the certificate warning.
- [ ] **Decide the bridge credentials for Task 4.** One incoming webhook per pod room (create in the
      UI; not available from the operator CLI) is enough for MQTT → chat; a single `bridge` bot
      covers the reverse direction. Test one self-registration too, since
      `[auth] direct_registration = true` and there is no SMTP behind it.
- [ ] **Take the trusted-certificate route next time.** A public name resolving to `10.100.1.1` plus
      a Let's Encrypt DNS-01 challenge removes the click-through; the stunnel unit stays, only
      `cert`/`key`, `webserver.url` and `allowed_origins` change
      ([D25](./00-architecture-decisions.md#d25--the-chat-is-served-over-self-signed-tls-inside-the-overlay-a-public-name-is-the-recorded-upgrade-path)).
- [ ] **Decide the M5StickC hand-out.** Flash IoTempower onto each stick and set its pod's Wi-Fi
      credentials *before* the session — at the end of Module 4 or the start of Module 5, not during
      it. Module 4 no longer depends on the sticks, because the AC unit is a simulation; the stick
      is an optional second publisher for the mock-to-real swap, so a pod without one is not
      blocked.
- [x] **IoTknit** — retired from every document
      ([D24](./00-architecture-decisions.md#d24)). No MicroPython port to chase: the laptop runs
      `paho-mqtt` (pinned `>=2,<3`) and the router runs `umqtt.simple`.
- [x] **MicroPython + MQTT stretcher** — landed as Module 3's `◇ Task 6 — The router as a node`.
      Module 4's Task 6 now builds the threshold service on top of it instead of repeating the
      client.

## Before the next semester (reset)

- [ ] **Watch the timing of the four new tasks.** Module 4 is now HTTP baseline → MQTT deep dive → a
      little CoAP → bridges (at least three, one reverse). If the day runs short, Task 3 (CoAP) is the
      one to drop or hand out as homework; the bridges must not be the thing that gets cut. The router
      MicroPython service from the old module survives only as one possible bridge target.

- [ ] **Rename the closing section in Modules 1 and 2 to `## 📚 Resources`.** Modules 3–9 were
      renamed in WS 2026/27, because the section now also carries comparison material (Tailscale,
      NetBird, Headscale) and not only "go deeper" links. Modules 1 and 2 still say
      `## 📚 If you want to go deeper`; they were left alone so the rename stayed out of the two
      modules that had already been taught this run. No anchor links point at the old heading, so
      the change is safe whenever it happens.
- [ ] **Re-run `./tools/check-all.sh`** from the repository root before the first session.
- [ ] **Check the DRAFT BOUNDARY positions** against what was actually taught. Move each boundary
      to the first genuinely provisional section, not to the end by habit.
- [ ] **Re-check the session mapping and hardware assumptions** against the real semester calendar
      and the router/node count that was actually available.
- [ ] **Build the slot-by-slot time breakdown from the real calendar.** For every date record the
      time, the type (Übung / Praktikum / betreutes Selbststudium), the minutes, and the school
      hours (45-minute units); sum by type and by day, and check the total against the module
      handbook. Then check that the number of days still fits the module and project distribution.
      The Sensors class needed this in 2026-11: a 90-minute slot is **two** school hours and a
      180-minute slot is four, so a block-count model silently undercounted the term by four hours.
      Keep the breakdown in the instructor notes, not in the student-facing syllabus.
- [ ] **Switch to one reflection per teaching day.** The instructor's rule across all classes is one
      logbook entry after each teaching day or session, whether the class is taught as a block or
      spread over weeks. This class currently specifies one entry per teaching block. Align the
      points table, the reflection-format section, and the `Reflections/refNN.md` evidence in every
      module (ten entries for ten days). The Sensors class made the change in 2026-11: nine entries
      for nine days, still 4 points.
- [x] **Adopt the intermediate German grades (1.3, 1.7, 2.3).** The grade-scale table bands points
      (14–15 = 4.0, 16–17 = 3.0, 18–19 = 2.0, 20 = 1.0) and never awards 1.3, 1.7, or 2.3. The
      Sensors class uses the fine 20-point table (20 = 1.0, 19 = 1.3, 18 = 1.7, 17 = 2.0,
      16 = 2.3, 15 = 3.0, 14 = 4.0, below 14 = 5.0) plus a documented 2.7 case for an overall 3.0
      with an exceptionally shaped portfolio. Change the syllabus only — assessment is
      examination-law territory (D4).
      **Done 2026-11-17:** the fine table, the 2.7 case, and the “orientation, assessed as a whole”
      note are in the syllabus. Keep the tone descriptive; do not turn the table into a task-point
      calculator.
- [ ] **Genericize the certificate naming scheme in the tracked notes.** Concrete ranges (the
      service and student ranges), the admin host name, and the overlay address prefix were removed
      from tracked files on 2026-11-17. What remains is the scheme itself: `hsbi-netiotNN` in
      [D21](./00-architecture-decisions.md#d21), [TODO](./TODO.md), and
      [`nebula-session.md`](./nebula-session.md), plus `routerNN.hsbi-netiot.ulno.mesh` in the TODO.
      It was kept because students meet the group name in class and the scheme explains the model.
      Decide next run whether the workbook and notes use placeholders (`<pod-group>`, `<pod-name>`)
      and leave the real scheme in the CA workspace with the rest of the overlay detail.
- [ ] **Review the discussion map after the de-bloat.** Every round should still name the learning
      goal and theory box its discussion checks; fewer steps must not mean fewer checks on
      understanding.
- [ ] **Keep the safety net visible.** The de-bloated version may leave more room for failure, but
      flashing, extroot, credential handling, and recovery must remain explicit and demonstrable.

## Shared vocabulary with Sensors

- [ ] **Adopt Task → Subtask → Evidence when the modules are next revised.** The Sensors workbook
      settled the student-facing naming in
      [ADR D21](../../hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d21):
      every main divider is `Task N — <outcome>` with `Proves:`/`Produces:`, subtasks are short
      unnumbered moves (max four), every task ends with a standing `Log it`, and the module
      closes with an exchange/evidence task. “Stage”, “Round”, and “Studio” retire as activity
      names. Do not rename by hand mid-run; fold it into the next module revision so students meet
      one vocabulary across the three workbooks.

## Deliberately not in this TODO

- A Module 2 rewrite during the run. Module 3 is next; the redesign waits.
- Removing the story, the discussion log, or the portfolio sections. Those are working parts of the
  format.
- Replacing safety-critical instructions with “let students discover it”. A bricked router is not a
  learning outcome.
- Copying the Databases assessment or module numbers. This class has its own syllabus.
