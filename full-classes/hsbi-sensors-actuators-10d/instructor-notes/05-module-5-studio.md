# Module 5 Studio — LEDs & Light as Output

[Module 5](../modules/05-leds-and-light-output.md) · [Architecture decisions](./00-architecture-decisions.md) · [All instructor notes](./README.md)

## Why this session is guided

Module 5 is the session observed for the teaching evaluation. The evaluation format expects a
lecture-style segment and an AI-first approach, while the module outcomes are hands-on. The
compromise is a **guided setup and walkthrough**: you drive, the students follow on their own
laptops, and the AI agents do the scaffolding while you show the theory slides. Then the benches take
over.

Do not turn it into a slide lecture. The walkthrough is the lecture-style segment, but it stays
interactive: students predict, measure, and call out results. The learning evidence is the lab and
the repo.

## The day is 180 minutes (two 90-minute blocks)

A normal teaching day is **two 90-minute blocks**, not one (D20). The break sits between them.

### Session 1 — first light, theory, Stage 2

| Time | Segment | What happens |
|---|---|---|
| 0–10 | Stage 1: one LED | 220 Ω, GPIO 16, `analogWrite` fade; first light, no AI |
| 10–25 | Theory slides | forward voltage and voltage capping, resistor computation, PWM, gamma — grounded in the fade |
| 25–35 | AI scaffold | prompt the AI in the `led-lab` folder; it installs/uses `pio`, completes the project and editors, writes `AGENTS.md` |
| 35–80 | Stage 2 | wire the RGB LED, `R G B` over serial, measure the three channel currents |
| 80–90 | Commit | Stage 2 in the portfolio repo; preview Stage 3 |

### Session 2 — theory, Stage 3, Stage 4

| Time | Segment | What happens |
|---|---|---|
| 0–10 | Rewire + recap | remove the Stage 2 red channel; DIN to GPIO 16; 5 V/GND |
| 10–25 | Theory slides | WS2812B single-wire signal, DMA/RMT, power budget |
| 25–65 | Stage 3 | NeoPixelBus, `index R G B`, `clear`, `SetLuminance(80)`, measure |
| 65–85 | Stage 4 | one or two extensions, AI-assisted |
| 85–90 | Share + outlook | commit, repo link, Module 6/7 |

- If the room is slow, cut **Stage 4**, never Stages 1–3.
- The AI agents are the built-in waiting time: show the slides while they scaffold, and stop when
  the build finishes.
- If the room is fast, start Stage 4 earlier and let pods compare animations.

## Toolchain: one `pio`, Zed for demos, VS Code optional

The project is plain PlatformIO; Zed and VS Code open the same folder. Test the setup on a lab
laptop before the session.

- **Install once:** `uv tool install --with pip platformio && uv tool update-shell`; an existing
  `pio` on `PATH` is fine. Do not let VS Code download a second Python environment
  (`"platformio-ide.useBuiltinPIOCore": false`).
- **Board:** `pio project init --board mhetesp32minikit`. The MH-ET LIVE ESP32 MiniKit is
  `mhetesp32minikit`; do not silently substitute `esp32dev`.
- **Serial port:** Linux needs `dialout` (or `uucp`) membership and the PlatformIO udev rules;
  Windows/macOS need the CP210x or CH340 driver if no port appears.
- **Editor parity:** the Zed tasks, `.zed/settings.json`, `.clangd`, and the VS Code snippets are in
  the [resource bank](../modules/Z-resources-bank.md#platformio-cli--zedvscode-setup).
- **AI context:** one `AGENTS.md` at the project root, no `CLAUDE.md`. Pinout, library, CLI, USB
  power rules. The template is in [Module 5](../modules/05-leds-and-light-output.md#agentsmd).

## AI assistants and credits (as of this offering)

Model names and credit rules change; verify in the tool before the session.

- **Existing assistant (Claude, DeepSeek, ChatGPT, ...):** if it is already set up in the editor, that
  is enough. Do not force a switch to Copilot; the workflow matters, not the vendor.
- **GitHub Copilot Education (students):** inline tab completions (`edit_predictions` in Zed) are
  unlimited and do not consume the 200 monthly AI credits. For chat/agent tasks, VS Code uses
  `Auto` routing automatically; in Zed (native Copilot or the Copilot ACP agent), select a
  lightweight model — `GPT-6 Luna`, `Gemini 3.8 Flash`, or `Claude Haiku 5.5` — to conserve credits
  across the semester.
- **Claude Pro/Max (students and instructor):** use **Claude Haiku 5.5** (`claude-haiku-5-5`) in Zed
  (native Copilot or the ACP Claude agent) and in VS Code (Claude Code) for low-latency, low-credit
  live coding.

## AI-first and the shareable project

The evaluation expects AI-first teaching. Make it visible in the lab, not as a separate AI lecture.

- **Five-minute demo at the start.** Open the portfolio repo in Zed, ask an AI for a README or an
  extension, verify one claim on the strip, commit and push, copy the repo link. That is the whole
  loop: prompt → draft → verify → commit.
- **Students do the same.** The deliverable is the repo (`Module05/`), not a screenshot. AI drafts;
  they verify; they commit.
- **Verification is the assessed skill.** Pin, LED count, color order, library, baud, current. If the
  AI's arithmetic disagrees with the meter, the meter wins.
- **GitHub Education is optional.** Point to the Student Developer Pack and Copilot at
  education.github.com and to the course template as an option; if students already use Claude,
  DeepSeek, or another assistant, that is enough. Do not do live sign-ups in class.
- **If the room is slow.** The demo still happens; the repo and README become homework. Do not skip
  the verification step.

## Before the session

- **Send the prep email.** At least two days before Day 5, send the [Module 5 student email](./06-module-5-student-email.md): `pio` via `uv`, an AI assistant (Copilot via GitHub Education, Claude, DeepSeek, or `opencode`; GitHub Education optional). The first session opens with the install check.
- **CLI baseline.** `uv` and `pio` on the lab laptops, the ESP32 platform cached, and one
  known-good `led-lab` project. Test `pio run -t compiledb && pio run` on a lab machine.
- **Boards and cables.** One MiniKit per student or pair, known-good USB cables, one spare board, one
  known-good strip and supply for triage.
- **Parts.** Red/yellow 5 mm LEDs, common-cathode RGB LEDs, 220 Ω resistors (one for Stage 1, three
  per RGB LED), 8-LED WS2812B strips, breadboards, jumpers, USB power meters. A few 100 Ω/180 Ω
  resistors for comparison.
- **GPIO 16 progression.** Stage 1 uses GPIO 16 for the single LED; Stage 2 uses 16/17/18 for the
  RGB channels; Stage 3 uses GPIO 16 for DIN. Plan the rewires and say them out loud; do not let a
  pod wire two stages at once.
- **Repo ready.** The course template and `gh` login work on the lab laptop; have a short link or QR
  code to the template and a known-good repo to demo. If GitHub is down, commit locally and push
  later.
- **Slides ready.** Render `slides/05-leds.md` and keep the PDF open for the waiting time.
- **Visible goals.** Put the learning goals and the four stages on the screen at the start.

## Stage 1 prep

- A red or yellow 5 mm LED per student/pair, a 220 Ω resistor, jumper wires. Anode (long leg) →
  220 Ω → GPIO 16; cathode (short leg, flat) → GND.
- The Stage 1 sketch is in the module; it uses `analogWrite()` and no library.
- `analogWrite()` works through LEDC in the current Arduino-ESP32 core; older cores need
  `ledcAttach()`/`ledcWrite()`. Check the core version on the lab image.

## Stage 2 prep

- Common-cathode RGB LED through three 220 Ω resistors: R=GPIO16, G=GPIO17, B=GPIO18, common to GND.
  The sketch has `#define COMMON_ANODE false`; set it to `true` for a common-anode part.
- Measure each channel current with the meter in series, or measure the resistor voltage and use
  `I = U/R`. Red will be much higher than blue; that is the lesson.

## Stage 3 prep

- 8× WS2812B, 5 V and GND from the MiniKit USB rail, DIN to GPIO 16, common ground. A ~330 Ω data
  resistor is optional on a short strip; keep it as a reliability option, not a blocker.
- **Library:** `makuna/NeoPixelBus`, `NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s1Ws2812xMethod>`.
  Explain the choice: Wi-Fi/BLE radio interrupts corrupt software-timed output; NeoPixelBus uses the
  hardware I²S1 DMA/RMT path.
- **Guardrail:** `strip.SetLuminance(80)` in `setup()`. Full white on 8 LEDs is 480 mA; luminance 80
  keeps the real animation well below that.
- **GPIO 16 rewire:** unplug the Stage 2 red channel before wiring the strip.
- **Power:** 8 × 60 mA = 480 mA; USB 2.0 = 500 mA; the ESP32 adds 100–250 mA. Most students will
  have a USB 3.0 or USB-C port (900 mA–3 A; check the port/charger), so the pair fits comfortably.
  Keep the USB 2.0 500 mA case as the constraint and the teaching example; use a 1 A+ port, a
  powered hub, or a separate supply with a common ground.

## The 8-LED USB arithmetic (say it out loud)

- 8 LEDs × 60 mA = **480 mA** at full white — the strip alone, inside a 500 mA USB 2.0 port by
  20 mA.
- 9 LEDs would be 540 mA, over that port. That is why the class uses 8.
- USB 2.0 = 500 mA, USB 3 = 900 mA, a USB-C port or USB charger = 1.5–3 A (check the port). The
  ESP32 adds 100–250 mA with Wi-Fi.
- Most students will have a USB 3.0 or USB-C port, where 8 LEDs **and** the ESP32 fit comfortably.
  Keep the USB 2.0 500 mA case as the constraint and the teaching example.
- So: strip alone on a 500 mA port is tight but plausible; strip **and** ESP32 on one 500 mA port
  is over. Use a 1 A+ port, a USB 3.0/USB-C port, a powered hub, or a separate USB supply with a
  common ground.
- Measure it. Cheap strips vary, brightness setting changes the current, and a meter shows the
  difference between “full white” and a real animation.

## What to demo, what to hand over

- **Demo:** the Stage 1 fade, the 220 Ω default, the Stage 2 three measured channel currents, the
  `R G B` REPL, the Stage 3 `index R G B`/`clear` REPL, `SetLuminance(80)`, the current measurement,
  and one AI prompt plus the commit/push.
- **Hand over:** the Stage 4 extension, the palette, the input (serial, button, sensor), and the
  scaling argument for 30/60/144 LEDs.
- **Do not demo a finished animation.** The extension is to design one; a demo becomes the answer.

## Evaluation visit — practical notes

- Start with the goals and the stages, not with slides.
- Ask for predictions before running: “What current for 8 LEDs?”, “What changes at 9?”, “Why is blue
  dimmer than red at the same resistor?”
- Walk the room during the stages; ask each pod to explain **one** choice (why this luminance, why
  this library, why this supply).
- The observer should see: clear goals, structured input, every student working, one AI prompt, one
  verification on the strip, and one commit. That is the hybrid.

## If the AI is slow: the slides

The theory deck is [`slides/05-leds.md`](../slides/05-leds.md). Use it while the agents scaffold or
when a build is slow:

- forward voltage and voltage capping (why a blue LED is hard on 3.3 V),
- resistor computation and the 220 Ω default,
- PWM duty cycle, frequency, and gamma,
- the WS2812B signal: 24 bits per pixel, GRB, 800 kHz NRZ, reset/latch,
- hardware DMA/RMT versus software timing under Wi-Fi,
- the 480 mA power budget and `SetLuminance(80)`.

Stop when the build finishes; the slides are the waiting-time material, not a second lecture.

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
