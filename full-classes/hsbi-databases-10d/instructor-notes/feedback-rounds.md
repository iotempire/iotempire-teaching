# Feedback-Round Manual

A **feedback round** is a studio session where you walk from pod to pod, look at what they actually have, and say what is missing. It is **not an assessment**. Nothing is decided, nothing is recorded as a result, and no points are lost by being behind.

That distinction is not a formality. In most German examination regulations the graded assessment happens at the **end** of the term, so a mid-term checkpoint cannot be a graded event anyway. Calling it feedback is both correct and kinder — and it stops students from performing instead of showing you the messy truth.

> [!IMPORTANT]
> **Say this in the first minute:** *"Nothing is decided today. I want one artefact and one sentence per module. If it is not there yet, say 'not yet' and we move on."*

## Before the round

- [ ] **Register the day.** Pods sign up at the start of the session for a rough timeslot (paper or the LMS). Publish the list. Random order is fine; silent order is not.
- [ ] **Do the arithmetic.** 20 pods total; 10 per session. **10 minutes per pod** with the instructor; two lanes (instructor + TA) = **50 minutes** for 10 pods. One lane = 100 minutes. The peer practice stays **12 minutes each way**. If you have less time, cut the instructor slot, not the peer practice — the practice is where the portfolio gate happens.
- [ ] **Open the template** ([`feedback-template.md`](./feedback-template.md)) in your editor, one line per pod.
- [ ] **A visible timer.** A phone is enough, but it must be visible to the pod.
- [ ] **Decide the fallback**: pods that are not ready get **4 minutes**. Publish that rule with the sign-up list.

## The checkpoint day (20 pods, two rounds)

<!-- TODO: remove the timing notes after the run; keep the registration and two-lane structure. -->

| Minutes | What happens |
|---|---|
| 0:00–0:05 | **Late-start buffer and registration.** Pods sign up for a rough slot. |
| 0:05–0:35 | **Peer practice:** 12 minutes each way + 3-minute switches + settling. All pairs at once. |
| 0:35–0:50 | **Break.** |
| 0:50–1:40 | **Instructor lanes:** two lanes (instructor + TA), five pods each × 10 minutes. The rest of the room works. |
| 1:40–1:50 | **Wrap:** what happens next, when points are recorded, what “not yet” means. |
| 1:50–3:00 | **Project work** continues; the TA floats. |

**Every instructor slot is 10 minutes.** The peer slots stay 12. With two lanes, 10 pods finish in 50 minutes; one lane needs 100. **Two rounds:** Session 8 covers 10 pods, Session 9 the other 10. Do not attempt 20 × 10 in one sitting.

The TA may run the second lane, ask the same questions, write the feedback note, **suggest points and readiness**, and **mark an individual for recheck**; **only the instructor records points**. See the [TA briefing](./TA-briefing.md).

## The peer practice round (about 30 minutes)

The point is that students hear the goals explained by peers before they hear them from you — and that every portfolio is **checked** by someone who is not the instructor.

### The 12-minute peer slot

| Minutes | What |
|---|---|
| 0–2 | **Portfolio gate.** Every member of the presenting pod opens *their own* portfolio on *their own* device. The receiving pod verifies four things (below). |
| 2–10 | **One artefact each.** Each member shows exactly **one** artefact that proves a learning goal, and names the goal. At most one minute of questions per artefact. |
| 10–12 | **One reflection.** The pod shows the reflection entry it is proudest of, and says why. |

The **3-minute switch** between directions is for writing feedback notes, not for presenting. If a pod runs over, cut the reflection, not the gate.

The receiving pod writes the presenting members' **first names** first — 30 seconds, same as in your round.

### The portfolio gate (the only hard requirement)

The receiving pod checks, for **each** member:

- [ ] The repository exists on GitHub and is **their own copy** (made with *Use this template*, not a fork of a podmate's repo).
- [ ] They can **edit**: change one line in a file, commit it, and show the commit.
- [ ] They can **link**: a relative Markdown link from one file to another opens the right page (ideally to a podmate's entry).
- [ ] They have **at least one entry per module worked on so far**, or a visible "not yet".

A member who fails the gate is not in trouble — it is a five-minute fix now and a disaster in week 11. Note it on their line as `gate: fix`.

### Questions the receiving pod should ask

Use these to keep the 12 minutes moving and to avoid "looks good" as the whole feedback.

**About the portfolio itself**
- "Is this your own repository? Show me a commit you made yourself."
- "Show me a link from your notes to someone else's entry."
- "Which module entry is the weakest? What would you add?"

**About the artefacts (adapt to the modules they have reached)**
- "Which line of that query plan told you the index was used?"
- "Show me a defect you **proved** with a query, not one you described."
- "Which constraint did you watch reject something, and what was the error?"
- "Where does the data come from, and what happens if you load the file twice?"
- "Why is this a database and not a spreadsheet?"

**About the reflection**
- "Which entry would you show a future employer, and why that one?"
- "What did you believe at the start of the module that you no longer believe?"

The receiving pod's job ends with **two strengths, one gap, and one question they could not answer** — the last one goes to `#sql-questions`.

## The instructor slot (10 minutes)

**First 30 seconds: names.** While the pod sits down, it writes its members' **first names** into the `members` field. No discussion, no spelling bee — it is so you can use their names and so the line is still readable in week 11. If they hesitate, write what you hear and move on.

**Move on the timer, not on the sentence.** Put the pods in a front-to-back order and sit at the front. When 10 minutes are up you move to the neighbouring pod — a few steps, never a walk across the room — and the next pod takes the seat you left. Do not wait for a sentence to finish; they will finish it while you sit down. The timer is visible to the pod, so nobody argues.

| Minutes | What you do |
|---|---|
| 0–1 | **“Show me the one artefact you are proudest of, and name the learning goal it proves.”** |
| 1–3 | **“Now the other module: show it, or say ‘not yet’.”** |
| 3–6 | One question from you, then **one strength and one next step**. |
| 6–9 | Write one line in the template. Ask the next pod to come up. |
| 9–10 | Transition and overrun; if the slot is clean, the next pod starts early. |

**The 4-minute variant (not ready).** "Show me what exists." One next step. "Come back in the studio." No rescue, no negotiation, no guilt — and write `not yet` so the final review knows where to look.

## If someone is missing

Illness happens; do not turn it into an administrative problem.

- **Video call.** A podmate joins the round from home. Camera on if they can — the point is that they hear the feedback about their own work.
- **Record it.** If they cannot join, the pod records the round (audio is enough) and sends it to them. Ask everyone at the table to agree first, and delete the recording after the round.
- **A message from the absent member.** They may send you a short note — especially if the pod showed something *they* built and did not mention them. Add it to their line before you file it.
- **A 15-minute office-hour slot.** The default for anything that needs more than a message. Offer it before they ask.
- In the template, mark the line `(abs)` and note anything the follow-up changed.

## What to write

One line per pod, in the template:

```
P03 | Ada, Ben, Chi | ok | M1, M2 | M4 | bring the M2 orphan query and its plan
```

- **members** — first names only, written by the pod in the first 30 seconds. No surnames, no student IDs.
- **gate** — `ok` or `fix`, taken from the peer practice round. This is the field that saves you in week 11.
- **shown** — module numbers only. A tick is not needed; the list is the tick.
- **not yet** — module numbers, or `—`.
- **next step** — one imperative sentence. If you cannot fit it in one line, it is not a next step yet.
- **suggested points / recheck** — the TA may append `suggested=2/2` or `suggested=1/2; recheck Ada`.
  It is a suggestion, not a recorded point; the instructor confirms and records.
- Nothing per student otherwise. The individual picture comes from the final project discussion and the portfolio review.

## What not to do

- **Do not grade in the slot.** No “that would be a 2” at the table. The TA may suggest a point value
  in the note; the instructor records points from the portfolio evidence, not from the conversation.
  If you catch yourself assessing, say “not yet” and move on.
- **Do not teach in the slot.** Two minutes of explanation is fine; a ten-minute tutorial is not, and the other eleven pods are waiting.
- **Do not rescue.** A pod that is behind does not need you to fix it at the table; it needs one next step.
- **Do not read the whole portfolio.** Ask for the one artefact that proves the most, then spot-check.
- **Do not run long.** The last pod gets the same ten minutes as the first, or the round was unfair.

## After the round

- Tell the room the **running count** if you keep one ("most pods have Modules 1–2; Module 3 is where everyone is behind"). That is feedback at cohort level and it is useful.
- Keep the template file — it is the index for the final portfolio review and for the project discussion in week 11.
- Convert it to a table when you need to look at it again (see the template file for the one-liner), or paste it into a spreadsheet with `|` as the separator.

> [!TIP]
> The template is a **text file on purpose**: it is fast to type in during the round, and it turns into a table afterwards. A Markdown table looks nicer and is miserable to fill in while twelve pods are waiting.
