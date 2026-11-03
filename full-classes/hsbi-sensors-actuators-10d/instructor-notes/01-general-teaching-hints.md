# General Teaching Hints — Sensors and Actuators

Course-wide teaching hints for the workbook. Technical reference material for students stays in the [resource bank](../modules/Z-resources-bank.md); assessment and operations stay in [Assessment & operations](./00-assessment-and-operations.md); the binding rules remain the module handbook and the [syllabus](../syllabus.md).

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## Before the first studio

Check the kit: label every Grove module with its I²C address, keep one known-good jumper wire and one known-good sensor as a reference, and test the Mosquitto broker (and optional Node-RED) on its host before students arrive. A USB power meter saves many “why does it reset?” conversations. For Module 2, have one known-good ESP32 scope/analyzer build and a PulseView install ready as a fallback for the instrument sprint.

## Task Pods and feedback rounds

Form Task Pods of two or three on Day 1: two is the default; use three for a large cohort (roughly >40 students). The feedback-round schedule, the 2-pod practice round, and the video alternative are defined in the [syllabus](../syllabus.md#how-module-points-are-earned-feedback-checkpoints); run the slots from there. Assess from the portfolio, not from task completion, and keep each feedback round a short conversation rather than a presentation rehearsal.

## Studio rhythm

Open with a short warm-up, then a pod-study block (concepts, pointers, LLM Q&A, study log), a share with a neighbouring pod, a short whole-room clarification, then the lab. Split this across the day's sessions as the timetable allows, and protect the break. Consider closing a session with a five-minute **harvest** — the optional, ungraded curiosity swap described in [Module 1](../modules/01-foundations-measurement-and-sensor-chain.md#harvest); if it does not fit, skip it, and never turn it into a quiz. Resist the urge to lecture the concept a second time; let the pod study surface the gaps.

## Stories

The stories in the modules are deliberately separate case studies. Keep new examples consistent with the [story canon](../modules/Z-resources-bank.md#story-canon-the-recurring-cast), and make a story concrete enough to pitch in a minute: one named person, one place, one moment of pain, something at stake. The [story-craft test](../modules/Z-resources-bank.md#story-craft-is-it-concrete-enough) is the check.

## Demo day

Ask every Project Team for a fallback recording of the live flow. Run the fault injection yourself (disconnect the sensor, block the actuator, restart the broker) and let the team explain the recovery. The rubric lives only in the syllabus.

## Slides

Session 1 has a plain-Markdown deck — [`slides/01-introduction.md`](../slides/01-introduction.md). It opens in any Markdown viewer (Zed, GitHub, VS Code) and renders to a 16:9 PDF with **pandoc + Typst** — [`slides/render-slides.sh`](../slides/render-slides.sh) — presented fullscreen in **Okular**. Slides are separated by `---`, so the deck is easy to read, diff, and adapt. HTML comments (`<!-- note -->`) are dropped from the PDF, so keep speaker hints there. There is no notebook runtime and no build step.

## Module-specific notes

- [Module 3 studio](./02-module-3-studio.md) — LDR/potentiometer/DS18B20 setup, multimeter pairing, water prep, fall field transect, DHT11 comparison, running the three rounds.

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)
