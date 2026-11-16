# Module 10 – Project Video & Feedback Walkthrough

[← Back to Module 9](./09-final-project-studio.md) | [Quick module index](./00-index.md)

> The last session is not a stage exam. It is the rehearsal before the take: you walk us through the system, we push back, and then you record the version you submit.

**Course placement:** Day 9, third slot (14:15–15:45). Three Project Teams, 30 minutes each: 15–20 minutes presentation, with the rest of the slot for instructor and peer feedback. The assessed artifacts are the **submitted video, slide deck, and documentation**, not the live performance.

## 🎯 Learning Goals

By the end of this module, you can:
1. Walk a technical audience through a characterized sensor/actuator system in 15–20 minutes.
2. Explain the story, architecture, one measurement with uncertainty, and one failure from your submitted evidence.
3. Give and take specific feedback that improves another team's system and your own video.
4. Record a 5–10 minute video that stands on its own as the assessed artifact.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Night the System Has to Work

It is the opening night at the Stadtmuseum. **Aylin Demir** is watching the corridor; **Mara Voss** is standing by the controller; **Jonas Feld** has a USB cable and a fallback recording. The light wall is supposed to breathe, wake on approach, and survive a guest unplugging the wrong thing. Nobody cares how elegant the sketch is if the wall goes dark at 19:55.

Your walkthrough is that moment in miniature: show the system measuring and acting, then explain the decisions that are documented in your report. The story gives the *why*; the characterization and the fault-injection log give the *how do you know?*

## 🗓️ The day

| Time | What happens |
|---|---|
| 08:30–11:30 | Finish, beautify, and practise: complete the system, the measurements, and the slides; run the walkthrough informally as often as you like. |
| 11:30–12:30 | Break. |
| 12:30–14:00 | Demo preparation: finalize the demo sequence and the fallback, then run one full timed rehearsal. |
| 14:15–15:45 | Three teams, 30 minutes each: 15–20 minutes presentation, feedback fills the rest of the slot. |
| After class, until the last day of the examination period | Record and edit the 5–10 minute video; submit it with the slide deck and documentation. |

The live session is deliberately a **feedback rehearsal**. Nothing in it is graded. The video is recorded and edited afterwards, with the feedback incorporated, and submitted by the **last day of the examination period** (*Prüfungszeitraum*, announced in the LMS) — that video is the assessed artifact.

## 🛠️ The 15–20 minute walkthrough

Keep it to five slides:

1. **Story and user.** One named person, one problem, one decision the system supports.
2. **Architecture.** Sensors with buses and addresses, actuator with driver and supply, the node, and the integration layer — local control or optional MQTT.
3. **One measurement.** The transfer function or calibration, resolution, and uncertainty. Show the table or plot.
4. **One failure.** A fault-injection result: sensor disconnect, actuator stall, noise, or (Track B) broker restart. What did the system do?
5. **One improvement.** What you would change with another day, and why.

Then demonstrate live: measure a real quantity, make the actuator respond, and repeat the demo if the first try fails. Several attempts are expected, not embarrassing.

## 🎥 The submitted video (5–10 minutes)

Record and edit after the feedback round, then submit by the last day of the examination period. It should stand alone for someone who was not in the room:

- 30 seconds: the story and the user.
- 2–3 minutes: the system working, with the measurement visible.
- 2–3 minutes: the architecture and the characterization, with the numbers on screen.
- 1–2 minutes: the failure test and the recovery, plus one improvement.

A phone camera and a screen recording are enough. Upload the video with the slide deck and the documentation; the links go into the portfolio.

## 📋 Where the rubric lives

The final project is assessed according to the [syllabus](../syllabus.md#final-project-requirements-5-points), and the rubric lives **only** there. This page is the working script and checklist; if the two ever disagree, the syllabus wins.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] The submitted 5–10 minute video.
- [ ] The slide deck used in the walkthrough and the video.
- [ ] The project documentation: architecture, system boundary, characterization, evaluation, fault-injection log.
- [ ] The feedback you received and one sentence per change you made in the video.
- [ ] Reflection logbook entry for Day 9 (`Reflections/ref09.md`).
- [ ] Where you did not work entirely alone: links to pod mates and sources.

> [!IMPORTANT]
> Never commit large binaries, credentials, private keys, or personal data. Link the video from your portfolio instead.

## 🎓 Course Retrospective & What's Next

After the three walkthroughs:

- **What survives contact with a real room?** Which choices held, which broke, and what would you do differently?
- **What did you learn that is not in a datasheet?** Wiring, timing, heat, noise, people.
- **Where next?** Final project, a Stretcher, the sibling IoT classes, or your own build.

---

[← Previous: Module 9](./09-final-project-studio.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md)
