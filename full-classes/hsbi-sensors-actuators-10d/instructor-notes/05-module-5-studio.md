# Module 5 Studio — LEDs & Light as Output

[Module 5](../modules/05-leds-and-light-output.md) · [Architecture decisions](./00-architecture-decisions.md) · [All instructor notes](./README.md)

## Why this session is guided

Module 5 is the session observed for the teaching evaluation. The evaluation format expects a
lecture-style segment, while the module outcomes are hands-on. The compromise is a **guided
walkthrough**: you drive, the students type along on their own laptops, and questions are welcome at
any point. Then the strip is handed over for the challenge.

Do not turn it into a slide lecture. The walkthrough is the lecture-style segment, but it stays
interactive: students predict, measure, and call out results. The learning evidence is still the
challenge. Confirm the current evaluation format with quality management before the visit; if the
observer needs a different shape, adapt the run sheet, not the learning goals.

## Toolchain: Arduino IDE is the common path

Most students have Arduino IDE 2 from Module 1; many do not have PlatformIO, and a PlatformIO install can eat the whole ramp-up on a lab network. The guided session uses the **Arduino IDE** so that everyone can follow the clicks. The same sketch is a PlatformIO project in the module appendix for students who already use it; do not make PlatformIO a requirement.

- Test the Arduino IDE path on a lab laptop: board profile, port, library, upload, Serial Monitor.
- On Windows, have the CP210x/CH340 driver ready; a missing port is the most common first-light failure.
- Keep one pre-flashed board and strip as a fallback.
- If you demo from Zed/PlatformIO because you are faster there, show the Arduino IDE steps on the handout; students follow the clicks, not your CLI.

## Run sheet (90 minutes)

| Time | Segment | What happens |
|---|---|---|
| 0–15 | Ramp-up | Arduino IDE: board, port, library, upload, Serial Monitor; the optional PlatformIO path; `help` output |
| 15–45 | Single RGB LED | 220 Ω default, three measured channel currents, three PWM channels, six colors, linear vs. gamma fade |
| 45–60 | 8-LED strip | 5 V/GND/data wiring, one pixel by index, `walk`, the USB power arithmetic |
| 60–65 | AI-first + repo | one prompt in VS Code/Zed, verify one claim, commit and push, copy the repo link |
| 65–85 | Challenge | pods design an animation, fill the power table, commit the repo; you circulate and ask for one choice |
| 85–90 | Outlook | Module 6 animation/panels, Module 7 motors; collect the power tables |

- If the room is slow, cut the gamma comparison, **not** the strip bring-up. First light is the
  non-negotiable.
- If the room is fast, let pods start the challenge during the strip segment.
- Keep the last five minutes for the outlook; do not let the challenge run silently to the bell.

## Before the session

- **Arduino IDE path (default).** A `led_lab` folder with `led_lab.ino` from the module appendix, the
  ESP32 board core and **Adafruit NeoPixel** installed, tested on a lab laptop, not only on yours.
  Prepare a short RGB example sketch as well; the appendix sketch is the strip example.
- **PlatformIO path (optional).** The same sketch as a PlatformIO project for students who already
  use it; test it once, but do not require it.
- **Boards and cables.** One board per student or pair, known-good USB cables, one spare board, one
  known-good strip and supply for triage.
- **Parts.** RGB LEDs, **220 Ω** resistors for the three channels (the safe default), 330 Ω for the
  data line, a few 100 Ω/180 Ω for comparison, 8-LED WS2812 strips, breadboards, jumpers, USB power
  meters.
- **Fallbacks.** Pre-flash one board and strip; a student who cannot upload can still follow the
  serial REPL on the known-good board and fix the toolchain during the challenge.
- **USB ports.** Check the lab machines: a 500 mA port and a 1 A port behave differently with the
  strip and the ESP32 on the same port. Bring a powered hub or a USB charger if the machines are
  weak.
- **Visible goals.** Put the learning goals and the challenge on the screen at the start; the
  observer should see them, and students should know where the session is going.
- **Repo ready.** The course template and `gh` login work on the lab laptop; have a short link or QR
  code to the template and a known-good repo to demo. If GitHub is down, commit locally and push
  later.

## Why 220 Ω is fine

Students will ask why the module starts with 220 Ω when the calculation gives 180 Ω or 33 Ω. Answer:
220 Ω is a conservative default that keeps every channel in the few-mA range and protects the GPIO;
the precise values target a current and are very sensitive to `Vf`. Measure the three channels and
show the imbalance — red much higher than blue. That is a better lesson than three different
resistors. If a student wants a balanced white, adjust PWM first, not the resistors.

If the LED is common-anode on 5 V, the same 220 Ω gives 8–14 mA per channel and all three are
bright. If it is common-cathode on 3.3 V, blue may be dim; that is the `Vf` sensitivity, not a wiring
fault.

## The 8-LED USB arithmetic (say it out loud)

- 8 LEDs × 60 mA = **480 mA** at full white — the strip alone, inside a 500 mA USB 2.0 port by
  20 mA.
- 9 LEDs would be 540 mA, over that port. That is why the class uses 8.
- USB 2.0 = 500 mA, USB 3 = 900 mA, a USB charger = 1.5–3 A. The ESP32 adds 100–250 mA with Wi-Fi.
- So: strip alone on a 500 mA port is tight but plausible; strip **and** ESP32 on one 500 mA port
  is over. Use a 1 A+ port, a powered hub, or a separate USB supply with a common ground.
- Measure it. Cheap strips vary, brightness setting changes the current, and a meter shows the
  difference between “full white” and a real animation.

## What to demo, what to hand over

- **Demo:** the 220 Ω default, the three measured channel currents, one channel, six colors, gamma,
  one pixel by index, `walk`, the current measurement, and one AI prompt plus the commit/push.
- **Hand over:** the animation, the palette, the input (serial, button, sensor), and the scaling
  argument for 30/60/144 LEDs.
- **Do not demo a finished animation.** The challenge is to design one; a demo becomes the answer.

## AI-first and the shareable project

The evaluation expects AI-first teaching. Make it visible in the challenge, not as a separate AI
lecture.

- **Five-minute demo at the start of the challenge.** Open the portfolio repo in VS Code or Zed, ask
  an AI for a README or an animation variant, verify one claim on the strip, commit and push, copy
  the repo link. That is the whole loop: prompt → draft → verify → commit.
- **Students do the same.** The challenge deliverable is the repo, not a screenshot. AI drafts; they
  verify; they commit.
- **Verification is the assessed skill.** Pin, LED count, color order, library, baud, current. If the
  AI's arithmetic disagrees with the meter, the meter wins.
- **GitHub Education.** Point to the Student Developer Pack and Copilot at education.github.com and
  to the course template; do not do live sign-ups in class.
- **If the room is slow.** The demo still happens; the repo and README become homework. Do not skip
  the verification step.

## Evaluation visit — practical notes

- Start with the goals and the challenge, not with slides.
- Ask for predictions before running: “What current for 8 LEDs?”, “What changes at 9?”
- Walk the room during the challenge; ask each pod to explain **one** choice (why this palette, why
  this timing, why this supply).
- The observer should see: clear goals, structured input, every student working, and evidence being
  produced. That is the hybrid. Add one AI prompt, one verification on the strip, and one commit.

## The capacitor: theory vs classroom

**Theory.** A 100–1000 µF electrolytic across 5 V/GND is **bulk** capacitance. It supplies the
current bursts when many pixels switch and reduces supply droop and ringing. It is a reliability
margin for long strips, long supply leads, or weak supplies. Adafruit's guide recommends it for
exactly that reason.

**Practice.** It is not a functional requirement. A short strip on a good, short-wired supply often
runs without it. In a classroom, the failure modes are ugly and common:

- **reverse polarity** — a reverse-connected electrolytic can vent or explode;
- **6.3 V rating on a 5 V rail** — too little margin; use 10 V or 16 V;
- **inrush** — charging a large capacitor can trip a USB supply or make a spark;
- **live wiring** — a charged capacitor can discharge into the strip or the bench.

That is why this class **does not require** the capacitor. If a pod wants to test one, use a
correctly rated, correctly oriented part, power off while wiring, and treat it as an experiment.
Do not call it a “decoupling capacitor”: a 0.1 µF ceramic at an IC is decoupling; the 1000 µF
electrolytic is bulk.

**What to say if asked.** “The capacitor is not there to make the data work. It is a reservoir for
current bursts. On a short strip with a good supply you may not need it; if you use one, the
polarity and voltage rating matter more than the capacitance.”

## The other two parts

| Part | Job | Classroom rule |
|---|---|---|
| ~330 Ω series resistor in the data line | damps ringing, limits current into the first pixel | use it; cheap insurance, no drama |
| Level shifter (3.3 V → 5 V) | meets the WS2812 input spec (~0.7 × VDD ≈ 3.5 V) | 3.3 V often works on a short strip; do not make the shifter a blocker. If a strip is flaky, try a shifter before blaming the library |
| Bulk electrolytic | supply transient reservoir | optional; 10–16 V, correct polarity; omit if unsure |

## 1000 LEDs on one data line

The data line is not the limiting factor: each pixel regenerates the signal for the next one, so one
GPIO can address a long strip (1000 LEDs ≈ 30 ms per frame, ~33 fps). The limits are **power** and
**refresh time**:

- 1000 LEDs × 60 mA = **60 A** at full white — that needs multiple injection points and thick
  wires, not a bigger capacitor;
- voltage droop along the strip causes color shifts and resets; inject 5 V at both ends and, for
  long strips, the middle;
- the first pixel still needs a valid logic level; after that, the signal is regenerated.

If your room runs 1000 LEDs reliably without bulk capacitors, that is a valid result for that
supply and wiring. Teach it as “measure your supply and wiring”, not as “capacitors are useless”.

## Why the divergence exists

Theory describes worst-case reliability for a production installation: long cables, high current,
EMC, unknown supply. Practice is a classroom with short strips, a bench supply, and cheap parts.
The recommendation is **conditional**, and the conditions are what the AI answer omitted. The fix is
to teach the conditions and the failure modes — not to turn a margin into a mandatory part, or to
ban it outright.
