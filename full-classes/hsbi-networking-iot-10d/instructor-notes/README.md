# Instructor Notes — Networking and IoT Solutions

Operational notes for teaching the class. They are kept in the open on purpose:
students can see how the course is run, and co-teachers can reuse the setup. The
**binding** rules remain the RPO/SPO, the module handbook, and the
Prüfungsausschuss.

[← Course workbook](../README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

| Note | What is inside |
|---|---|
| [Architecture decisions](./00-architecture-decisions.md) | Why the class is shaped this way: provenance, decision records with alternatives and reversal triggers, rejected ideas, open questions, recreation checklist, module-handbook coverage |
| [TODO](./TODO.md) | The next-run backlog, led by the main design debt: relieve the class from AI over-specification and bloat so discovery, engagement, and own research have room |
| [From Databases](./from-databases.md) | A gift from the Databases class at the end of its first run: six things to copy first, a TODO backlog, what not to copy, and the questions the two classes should close together |
| [Assessment & operations](./00-assessment-and-operations.md) | Assessment form, milestone plan, submission hygiene, group accountability and sign-off template, re-examination, privacy, AI assistance |
| [Nebula session](./nebula-session.md) | Preparing the lighthouse, class CA, bundles, handout, in-session recovery, cleanup |
| [Chatto session](./chatto-session.md) | The class chat on `oldplex01`: single binary, port 4000 over the overlay, TLS with a self-signed certificate, the one firewall rule, rooms, accounts, and the optional MQTT bridge |
| [Module 4 CoAP lab](./module4-coap-lab/README.md) | The reference `coap_unit.py` for Task 3: one state, two doors (MQTT and CoAP), three tests from the pod LAN to the cluster, and the traps that cost an afternoon |
| [Collecting portfolios](./portfolios.md) | The one-click template link, the invite rule, bulk-accepting invitations and cloning repositories |

Technical hints that are useful to students (capture points, router quirks,
troubleshooting) live in the [resource bank](../modules/Z-resources-bank.md#instructor-hints);
this folder holds the course-operation side.
