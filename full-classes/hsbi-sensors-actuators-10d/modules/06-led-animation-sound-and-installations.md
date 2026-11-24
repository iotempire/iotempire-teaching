# Module 6 – LED Animation, Sound & Interactive Installations

[← Back to Module 5](./05-leds-and-light-output.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-motors-and-motion-actuators.md)

> A panel is not a bigger strip. It is a display: 1024 pixels, a scan rate, a power budget — and a story.

**Course placement:** Day 6 — one 180-minute studio, two halves with a break. **No new setup:** reuse the `pio` toolchain, the portfolio, and the `AGENTS.md` habit from Module 5. Work in your Task Pod; the instructor circulates and joins the debugging.

## 🎯 Learning Goals

This module gives you the opportunity to explore a real LED display and achieve competency in driving a scanned matrix, measuring its power ceiling, animating without blocking, fusing sound into the light, and turning the result into something someone wants to play with.

By the end of this module, you can:
1. Drive a 32×32 HUB75 RGB panel from a microcontroller: wiring, library, and a stable test pattern.
2. Measure the panel’s current at several brightness levels and choose a maximum luminance that leaves margin on the 5 V 4 A supply.
3. Explain how a scanned panel works — rows, scan rate, refresh — and why it is not a WS2812B strip.
4. Build a non-blocking breathing animation and fuse a microphone envelope (and, if you want, the IMU or a distance sensor) into it.
5. Defend the two-controller architecture and the protocol between the boards; name what one controller would cost.
6. Write a one-sentence story hook and turn it into a small interactive toy, instrument, or game.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Exhibition That Had to Breathe

**Lumenwerk Gütersloh GmbH** has one week before the Stadtmuseum opening. Curator **Aylin Demir** wants the light wall to *breathe*: a slow pulse when the room is empty, a faster wave when visitors approach, and a bright ripple when the room gets loud. Creative director **Mara Voss** has replaced the prototype strip with a 32×32 RGB panel; technician **Jonas Feld** has the panel, a 5 V 4 A supply, and an M5StickC-S3 with a microphone.

The first test is beautiful — until Jonas sets the panel to full white and the supply sags. The second problem is quieter: the panel needs thirteen control pins, the Stick has the microphone and the IMU, and the animation must keep running while the audio is sampled. Aylin’s question is practical: *“Can one board do both jobs, or does this installation need two — and how bright can we actually run it?”*

The answer in this module is **two** — unless you can defend one. And the wall is not finished until someone wants to touch it.

## 🧰 What you have

| Part | What it gives you |
|---|---|
| 32×32 HUB75 RGB panel, 5 mm pitch ([Adafruit 2026](https://www.adafruit.com/product/2026)) | 1024 RGB pixels, 5 V logic, up to 4 A at full white, 13 control signals |
| 5 V 4 A power supply | The panel’s supply — not the microcontroller’s USB port |
| MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`) | The **panel controller**: the class board; its header exposes the HUB75 pins, including the four JTAG-labelled ones |
| M5StickC-S3 | The **sensor/UI controller**: microphone, BMI270 IMU, display, buttons, speaker |
| 74HCT245 level shifter, jumpers, breadboard | 3.3 V logic to the panel’s 5 V inputs; the link between the boards |
| Multimeter (shared), phone camera | Current measurements and the video for your portfolio |
| Optional: piezo, small servo, DC motor shield, joystick board | The physical twist for the play task; ask before you wire it |
| Optional: Adafruit I2S amplifier + speaker | Real sound output without the Stick’s half-duplex codec; check the free I2S peripheral and pins (if the modules arrive) |

Meters are shared; ask your instructor which panels and supplies are per pod, and plan the pass-around with your neighbouring pod.

## 🧭 How to work

You work in your Task Pod at your own pace. The instructors circulate; ask early, not after twenty minutes of guessing. Task 1 is deliberately **without AI** — the panel is new hardware, and first light should be yours. Task 2 is AI-scaffolded. Task 3 is yours to invent; it stays open after the exchange. At the end, each pod shows one thing that works and one thing that does not.

## ★ Task 1 — First light and the power ceiling

**Proves:** Goals 1, 2, and 3 · **Produces:** `task1-panel/` with a stable test pattern, a wiring photo, and the power table.

1. **Wire the default rig.** Panel + 5 V 4 A supply + 74HCT245 + MH-ET LIVE ESP32 MiniKit. Use the pin table in [Appendix A](#appendix-a). Common ground everywhere; never power the panel from USB or a GPIO. The Stick stays on the bench for Task 2.
2. **Flash the library example.** Use [`ESP32-HUB75-MatrixPanel-DMA`](https://github.com/mrcodetastic/ESP32-HUB75-MatrixPanel-DMA) and its example sketch — no agent. Confirm orientation, colour order, and that the whole 32×32 area is addressed.
3. **Measure the ceiling.** Measure current at 25 %, 50 %, 75 %, and 100 % white. Fill the table, watch the panel voltage, and choose the highest brightness that stays stable with margin on the 4 A supply.
4. **How the panel actually works.** In one paragraph, explain the row scan, the 1/16 scan of this panel, the refresh rate, and why a phone camera may show flicker that the eye does not. Use the library and the Adafruit background as sources.

   **Then find out by removing signals.** Put a still picture on the panel and unplug **one signal wire at a time**, look at what changes, and plug it back before the next one. Signal wires only — never the 5 V feed, and never a ground wire: the ground is the reference every signal is measured against, so pulling it gives you nonsense rather than a lesson. Write down what you actually saw; the exact shape of the damage differs between panels, and explaining it is the point.

   | Unplug | What to expect | What it tells you |
   |---|---|---|
   | `CLK` (pin 13) | the image freezes, garbles, or disappears | nothing shifts into the column drivers without a clock |
   | `LAT` (pin 14) | the image freezes or smears | data arrives but is never transferred to the outputs |
   | `OE` (pin 15) | panel goes blank, the code still runs | output enable only gates the LEDs; the data path is untouched |
   | `A`, `B`, `C` or `D` (pins 9–12) | the picture folds or repeats in horizontal bands | the address lines choose which row group is lit right now |
   | `R1`, `G1` or `B1` (pins 1–3) | that colour disappears from the **upper** half | `R1`/`G1`/`B1` are the upper half's data |
   | `R2`, `G2` or `B2` (pins 5–7) | that colour disappears from the **lower** half | `R2`/`G2`/`B2` are the lower half's data |

   The last two rows are the ones worth staring at: one panel, two data sets, each driving half the rows — that is the 1/16 scan made visible. Once you have seen it, "16 row groups lit in turn, each group showing two rows at once" stops being a sentence you memorised.

In `## Study log` in `Module06/README.md`: the wiring, the maximum brightness you trust, the measured current at each step, the scan explanation, and one line per removed signal on what changed.

| Brightness | Measured current | Panel voltage | Stable? | Notes |
|---:|---:|---:|---|---|
| 25 % | | | | |
| 50 % | | | | |
| 75 % | | | | |
| 100 % | | | | |

**Done when:** the panel shows a stable test pattern, you can state the maximum brightness you trust on the 4 A supply, your scan explanation is written down, and you can say what a signal group does because you have watched it stop doing it.

## ★ Task 2 — Breathe and listen (AI scaffold)

**Proves:** Goals 4 and 5 · **Produces:** `task2-breathe/` with `panel/` and `stick/`, a video, and a mapping note.

1. **Create two PlatformIO projects.** `task2-breathe/panel/` for the MH-ET LIVE ESP32 MiniKit and `task2-breathe/stick/` for the M5StickC-S3. One `README.md` at the top documents the protocol and the wiring.
2. **Paste the prompts.** Each agent scaffolds one project, its `AGENTS.md`, and its README.
3. **Wire the link.** Default: **UART** at 115200. Stick HAT2 **G1 (TX) → panel GPIO32 (RX)**, Stick **G2 (RX) ← panel GPIO33 (TX)**, and a common ground. The `◇` alternative is **ESP-NOW** — same protocol, no wire (see [Appendix A](#appendix-a)).
4. **Breathe.** Build a `millis()`-based breathing effect — no `delay()` in the loop — with one normalized parameter for speed and depth. The panel keeps breathing while the link is idle.
5. **Listen.** Use the Stick’s microphone (M5Unified): sample in short blocks, compute a peak or RMS envelope, add automatic gain control, and send `L 0..100`. Map the level to brightness; map tilt (IMU) or a distance sensor to hue, or to a second parameter.
6. **Verify.** Quiet and loud, still and moving. Note latency, flicker, and what you changed to make it stable. Record a short video.
7. **Log it.** In the same log: the protocol, the envelope, the mapping, and what still flickers.

<a id="task-2-panel-prompt"></a>

<details>
<summary>Task 2 prompt — panel controller (MH-ET LIVE ESP32 MiniKit)</summary>

```text
Initialize a PlatformIO Arduino project in this empty folder for an MH-ET LIVE ESP32 MiniKit (`board = mhetesp32minikit`) that drives a 32×32 HUB75 RGB panel with `ESP32-HUB75-MatrixPanel-DMA` and `Adafruit GFX`.

Configure `platformio.ini` with `monitor_speed = 115200` and:
lib_deps =
    https://github.com/mrcodetastic/ESP32-HUB75-MatrixPanel-DMA.git
    adafruit/Adafruit GFX Library
Add a `.gitignore` for `.pio/` and `compile_commands.json`.

Create `AGENTS.md` documenting:
- Board: `mhetesp32minikit` (MH-ET LIVE ESP32 MiniKit), panel: 32×32 HUB75, 1/16 scan.
- HUB75 pins (MiniKit; the JTAG labels TDO/TDI/TCK/TMS are GPIO 15/12/13/14): R1=25, G1=26, B1=27, R2=14, G2=12, B2=13, A=23, B=19, C=5, D=17, E=-1, LAT=4, OE=15, CLK=16.
- Power: 5 V 4 A panel supply, common ground, never from USB or a GPIO.
- Link: `Serial2` on GPIO32 (RX) and GPIO33 (TX), 115200, newline-terminated `L <0..100>` and `H <0..255>`.
- Brightness cap: `setBrightness8(96)` (adjust after measuring the panel).

In `src/main.cpp`, start with `#include <Arduino.h>`, initialize the panel, set a conservative brightness cap, and parse the `L`/`H` lines without blocking. Keep a slow `millis()`-based breathing effect; the incoming level scales it and the hue colours it. Echo the applied values on the USB serial monitor. Add a short `README.md` with the wiring, the protocol, and the build/upload/monitor commands. Verify with `pio run`.
```

</details>

<a id="task-2-stick-prompt"></a>

<details>
<summary>Task 2 prompt — sensor controller (M5StickC-S3)</summary>

```text
Initialize a PlatformIO Arduino project in this empty folder for the M5StickC-S3 (ESP32-S3) with `M5Unified`.

Use this recipe, because the StickS3 is not an official PlatformIO board:
platform = espressif32@6.12.0
board = esp32-s3-devkitc-1
framework = arduino
board_build.arduino.partitions = default_8MB.csv
board_build.arduino.memory_type = qio_opi
build_flags =
    -DESP32S3
    -DBOARD_HAS_PSRAM
    -mfix-esp32-psram-cache-issue
    -DCORE_DEBUG_LEVEL=5
    -DARDUINO_USB_CDC_ON_BOOT=1
    -DARDUINO_USB_MODE=1
lib_deps = m5stack/M5Unified
Add a `.gitignore` for `.pio/` and `compile_commands.json`.

Create `AGENTS.md` documenting:
- Board: M5StickC-S3, `board = esp32-s3-devkitc-1`, 8 MB flash and PSRAM, USB CDC.
- Link: `Serial2` on HAT2 G1 (TX) and G2 (RX), 115200, newline-terminated.
- Protocol: send `L <0..100>` every 50 ms, and `H <0..255>` when the hue changes.
- Audio is half-duplex: do not use the speaker while the microphone is recording.

In `src/main.cpp`, use `M5Unified`: initialize the display, microphone, IMU, and `Serial2`. Record short blocks (8 kHz, 256 samples), compute RMS with a noise floor and a simple automatic gain control, map it to 0..100, and send `L`. Map tilt to hue 0..255 and send `H`. Show the current level and hue on the display. Add a short `README.md` with the wiring, the protocol, and the calibration knobs. Verify with `pio run`.
```

</details>

**Why two controllers.** The HUB75 panel needs thirteen signals; the Stick’s exposed header is small and already shares pins with the display, audio codec, and IMU. The MH-ET LIVE ESP32 MiniKit exposes the header the panel needs; the Stick is the sensor/UI board — see [Appendix A](#appendix-a).

**Why UART.** It is deterministic, needs no pairing or channel state, and works with the boards on the same bench. ESP-NOW is the alternative "fun" `◇` version: low latency, no router, but MAC pairing and packet-loss debugging are a separate lesson. Do not use SoftwareSerial on the S3; it competes with the I2S microphone and the panel DMA.

**Done when:** the panel breathes smoothly while the loop stays responsive, the sound mode reacts visibly without constant re-tuning, and the link and protocol are written down.

## ★ Task 3 — Play (mandatory, stays open)

**Proves:** Goal 6 · **Produces:** `task3-play/` with the story hook, one interaction, a video, and a five-line design note.

1. **Write the story hook first.** One sentence: *“Someone wants … because …”* Put it at the top of `task3-play/README.md`. The story is more important than the realization; a small, clear idea beats an unfinished spectacle.
2. **Build one interaction.** A toy, an instrument, or a game. One behaviour is enough. Seeds are in [Appendix C](#appendix-c): a reaction game, a tiny snake, a VU meter, a theremin, a distance-triggered wave, a joystick game.
3. **Optional physical twist.** A piezo, the Stick’s speaker, or — if the Adafruit I2S amplifier + speaker modules have arrived — an external I2S amp. A small servo or DC motor shield, or a joystick board. Keep it optional; do not let it eat the panel time. The Stick’s microphone and speaker are half-duplex; a piezo or an external amp avoids the conflict. Check the free I2S peripheral and pins before wiring.
4. **Log it and document.** Put the hook, the input → light/sound mapping, one failure mode, and the video link at the top of `task3-play/README.md`. In the shared `## Study log`, link to that README and add one sentence on what you would change with another hour.

**Done when:** someone can interact with it for thirty seconds without instructions, and the hook, the design note, and the video exist.

**This task stays open after Task 5.** Keep the folder and the video in the portfolio; return to it in self-study, or bring it into the final project. The hook is the seed for your project story.

## ★ Task 4 — Share the repo

**Proves:** Goals 1–6 · **Produces:** the committed `Module06/` folder and its README.

1. Open the portfolio repo in Zed or VS Code. The Source Control panel (or `gh`) commits and pushes; the [Git primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the workflow.
2. Finish the README: the wiring, the protocol, the power table, the three task folders, the play hook, and the videos.
3. Verify before you commit: pin map, panel size, colour order, library, brightness cap, baud rate, and the measured current. The AI’s arithmetic is a claim, not a measurement.
4. Commit code, READMEs, `AGENTS.md`, the power table, and the videos. No secrets, no `.pio/`, no `compile_commands.json`, no large binaries.

The AI is the drafting tool; verification is the skill.

## ★ Task 5 — Exchange and evidence

**Proves:** Goals 1–6 · **Produces:** the agreed learning in your shared log, one shared artefact, and the evidence list below.

1. Show each other the panel, the power table, the breathing and sound modes, and the play interaction.
2. Compare architectures: who used UART, who tried ESP-NOW, and what broke in each case? Compare the prompts: what did the agents get wrong?
3. Agree on the 3–5 most noteworthy points and one learning you jointly stand behind; one of you writes the “Agreed learning (pod discussion)” note into the shared log.
4. Pick one shared artefact — the best video, the power table, the hook, or a wiring photo — and post it in the course Discord with one sentence on why.
5. Check the evidence list below and fill the gaps.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. `## Study log` in `Module06/README.md` with the three task entries and the architecture decision.
2. Panel wiring: a photo or diagram, the pin map, the level shifter, and the library you used.
3. Power table: brightness versus measured current, the maximum stable luminance, and the supply margin.
4. The two-controller link: the protocol, the pin pair, and whether you used UART or ESP-NOW.
5. Video: the breathing effect and the sound reaction (plus the IMU or distance input if you used it).
6. The play task: the story hook, the video, and the five-line design note.
7. One paragraph on the installation constraints: heat, mounting, and what happens when a cable or the sound input fails.
8. The panel explainer: row scan, 1/16 scan, refresh, and why a phone camera may show flicker.
9. Deeper question: why is a scanned panel a different engineering problem from a WS2812B strip?

> You may prove the same goals another way. The evidence is the point, not the task list.

<a id="appendix-a"></a>
## 📎 Appendix A — Panel facts, wiring, power, and the link

**Panel facts.** The 32×32 panel is a HUB75 display: 1024 RGB LEDs, 5 V logic, thirteen signals (six data: R1/G1/B1/R2/G2/B2; seven control: A/B/C/D, CLK, LAT, OE — some panels also expose E). It is scanned, so the whole image is not lit at once; the library refreshes rows fast enough that the eye sees one image. Adafruit rates the panel at up to 4 A with all LEDs on; typical animations draw less. Product: [Adafruit 2026](https://www.adafruit.com/product/2026); background: [RGB LED matrix basics](https://learn.adafruit.com/32x16-32x32-rgb-led-matrix).

> **1/16 scan, in one line.** The controller lights 16 row groups one after another, so only 1/16 of the pixels is on at any instant and `E` — the fifth address bit a 1/32-scan panel would need — stays unused. The arithmetic, the refresh consequences, and the WS2812B comparison are in the [resource bank](./Z-resources-bank.md#hub75-scan).

**Default wiring (MH-ET LIVE ESP32 MiniKit).** The library’s default GPIO numbers, wired explicitly in the reference project; the MiniKit prints four of them as JTAG names:

| Signal | GPIO | Signal | GPIO |
|---|---:|---|---:|
| R1 | 25 | R2 | 14 |
| G1 | 26 | G2 | 12 |
| B1 | 27 | B2 | 13 |
| A | 23 | B | 19 |
| C | 5 | D | 17 |
| E | — (1/16 scan) | LAT | 4 |
| OE | 15 | CLK | 16 |

The HUB75 ribbon carries the signals and a ground reference; it does **not** carry the LED power. Power the panel through its 5 V/GND terminals from the 4 A supply. The library’s wiring and pin notes are in the [library README](https://github.com/mrcodetastic/ESP32-HUB75-MatrixPanel-DMA).

**The connector itself.** The panel prints the pin functions right next to the HUB75 plug, in pairs — pins 1–16 from the pin-1 corner:

```text
R1   G1
B1   GND
R2   G2
B2   GND
A    B
C    D
CLK  LAT
OE   GND
```

That print is authoritative — use it, not a photo of somebody else's panel. Depending on how you handle the cable you read the same pins in one of two orders, so both are written out below.

**View A — dupont straight into the back of the panel**, rows exactly as printed:

| # | Signal | GPIO | # | Signal | GPIO |
|---:|---|---:|---:|---|---:|
| 1 | `R1` | 25 | 2 | `G1` | 26 |
| 3 | `B1` | 27 | 4 | `GND` | — |
| 5 | `R2` | 14 | 6 | `G2` | 12 |
| 7 | `B2` | 13 | 8 | `GND` | — |
| 9 | `A` | 23 | 10 | `B` | 19 |
| 11 | `C` | 5 | 12 | `D` | 17 |
| 13 | `CLK` | 16 | 14 | `LAT` | 4 |
| 15 | `OE` | 15 | 16 | `GND` | — |

**View B — dupont onto the free end of a flat ribbon.** The ribbon presents the same pins **mirrored left to right**, so every pair reads in the reverse order. The numbers still belong to the panel, so match **signal names**, never column positions:

| # | Signal | GPIO | # | Signal | GPIO |
|---:|---|---:|---:|---|---:|
| 2 | `G1` | 26 | 1 | `R1` | 25 |
| 4 | `GND` | — | 3 | `B1` | 27 |
| 6 | `G2` | 12 | 5 | `R2` | 14 |
| 8 | `GND` | — | 7 | `B2` | 13 |
| 10 | `B` | 19 | 9 | `A` | 23 |
| 12 | `D` | 17 | 11 | `C` | 5 |
| 14 | `LAT` | 4 | 13 | `CLK` | 16 |
| 16 | `GND` | — | 15 | `OE` | 15 |

**The mistake that costs hours.** The two views differ only in the order of each pair, and one of those pairs is `CLK`/`LAT`. Swap those two and the panel is **completely dark while your code reports success** — the clock pulses arrive on the latch input and no pixel data is ever shifted in. The other pairs fail quietly: `R1`/`G1` crossed makes red look green, and `B1`/`B2` landing in the `GND` holes costs you the entire blue channel, so white comes out yellow. Crossed `A`/`B` and `C`/`D` look perfect in any solid colour and only show up in a frame with distinct corners — test with a pattern that has four differently coloured corners, not with a filled screen.

**Where those pins are on your board.** Some ESP32 boards print the JTAG function instead of the GPIO number, and the four JTAG pins are exactly the four the panel needs:

| Silkscreen | GPIO | Used as |
|---|---:|---|
| `TDI` / `MTDI` | 12 | `G2` |
| `TDO` / `MTDO` | 15 | `OE` |
| `TCK` / `MTCK` | 13 | `B2` |
| `TMS` / `MTMS` | 14 | `R2` |

If your board is the **MH-ET LIVE MiniKit** (ESP32 in a D1-mini footprint), these two tables put the ribbon beside the header. The board columns are the fixed side; the `H<n>` marks tie a board pin to a HUB75 pin, and the two tables differ only in how the ribbon reads — same tags, same pins, because a ribbon is a 1:1 cable.

*View A — ribbon read as printed:*

| HUB75 | | | left-outer | left-inner | | right-inner | right-outer |
|---|---|---|---|---|---|---|---|
| `1` `R1` | `2` `G1` | | `GND` | `RST` | | `TXD` (1) | `GND` |
| `3` `B1` | `4` `GND` | | `NC` | `SVP` (36) | | `RXD` (3) | `IO27` **H3** |
| `5` `R2` | `6` `G2` | | `SVN` (39) | `IO26` **H2** | | `IO22` | `IO25` **H1** |
| `7` `B2` | `8` `GND` | | `IO35` | `IO18` | | `IO21` | `IO32` |
| `9` `A` | `10` `B` | | `IO33` | `IO19` **H10** | | `IO17` **H12** | `TDI` (12) **H6** |
| `11` `C` | `12` `D` | | `IO34` | `IO23` **H9** | | `IO16` **H13** | `IO4` **H14** |
| `13` `CLK` | `14` `LAT` | | `TMS` (14) **H5** | `IO5` **H11** | | `GND` | `IO0` |
| `15` `OE` | `16` `GND` | | `NC` | `3V3` | | `VCC` | `IO2` |
| | | | `SD2` (9) | `TCK` (13) **H7** | | `TDO` (15) **H15** | `SD1` (8) |
| | | | `CMD` (11) | `SD3` (10) | | `SD0` (7) | `CLK` (6) |

*View B — ribbon read mirrored (its other face):*

| HUB75 | | | left-outer | left-inner | | right-inner | right-outer |
|---|---|---|---|---|---|---|---|
| `2` `G1` | `1` `R1` | | `GND` | `RST` | | `TXD` (1) | `GND` |
| `4` `GND` | `3` `B1` | | `NC` | `SVP` (36) | | `RXD` (3) | `IO27` **H3** |
| `6` `G2` | `5` `R2` | | `SVN` (39) | `IO26` **H2** | | `IO22` | `IO25` **H1** |
| `8` `GND` | `7` `B2` | | `IO35` | `IO18` | | `IO21` | `IO32` |
| `10` `B` | `9` `A` | | `IO33` | `IO19` **H10** | | `IO17` **H12** | `TDI` (12) **H6** |
| `12` `D` | `11` `C` | | `IO34` | `IO23` **H9** | | `IO16` **H13** | `IO4` **H14** |
| `14` `LAT` | `13` `CLK` | | `TMS` (14) **H5** | `IO5` **H11** | | `GND` | `IO0` |
| `16` `GND` | `15` `OE` | | `NC` | `3V3` | | `VCC` | `IO2` |
| | | | `SD2` (9) | `TCK` (13) **H7** | | `TDO` (15) **H15** | `SD1` (8) |
| | | | `CMD` (11) | `SD3` (10) | | `SD0` (7) | `CLK` (6) |

Unused header pins are **`IO22`**, `IO21`, `IO32`, `IO18`, `IO0`, `IO2`, `IO33`, `IO34`, `IO35`, `SVP`, `SVN`; `IO18` is the spare that can take over `G2` if GPIO 12 misbehaves. Never use `SD0`–`SD3`, `CLK`, `CMD` (GPIO 6–11, the internal flash bus); `SVP`/`SVN` and `IO34`/`IO35` are input-only.

**Strapping pins.** GPIO 5, 12 and 15 are sampled at reset, and the panel or the level shifter can hold them at the wrong level before your code configures them. GPIO 12 (`G2`) is the one that bites: high at reset selects a 1.8 V flash voltage and the board never boots. Two habits keep this boring:

- **Flash with the ribbon unplugged** if the board refuses to boot or upload; reconnect afterwards. Once booted, all three behave as ordinary outputs.
- If it keeps failing, add a **10 kΩ pulldown from GPIO 12 to GND**, or move `G2` to **GPIO 18** (free) — one `#define` change and one wire.

**Level shifter (74HCT245).** The ESP32 is 3.3 V; the panel expects 5 V logic. Put the 3.3 V signals on the A side and the panel signals on the B side, VCC = 5 V, OE = GND, DIR = 3.3 V, common ground, and a 100 nF decoupling capacitor. Many panels work at 3.3 V on a short ribbon; the shifter is the reliable choice, not a blocker.

**Power.** Full white is the worst case and leaves no margin on a 4 A supply; that is why you measure and cap the brightness. Use short, thick wires; add a bulk capacitor across 5 V/GND if bright frames flicker. Panels get warm at high brightness — do not cover them. Never power the panel from USB, a GPIO, or the 3.3 V rail.

**The link (default: UART).**

| StickS3 HAT2 | MiniKit | Note |
|---|---|---|
| G1 (TX) | GPIO32 (RX) | data from Stick to panel |
| G2 (RX) | GPIO33 (TX) | data from panel to Stick |
| GND | GND | common ground; required |

`Serial2.begin(115200, SERIAL_8N1, RX, TX)` on both sides; newline-terminated `L <0..100>` and `H <0..255>`. The Stick’s Grove port is G9/G10 if you prefer the Grove cable; verify the TX/RX order before you trust it. The StickS3 pin map is in the [M5 docs](https://docs.m5stack.com/en/core/StickS3).

**The link (`◇` alternative: ESP-NOW).** Same protocol, no wire. Put both boards in station mode on the same Wi-Fi channel, read the receiver’s MAC from its serial output, add it as a peer, and send the same two messages. Start with the [Arduino ESP-NOW guide](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/espnow.html) and the [Random Nerd tutorial](https://randomnerdtutorials.com/esp-now-esp32-arduino-ide/). ESP-NOW is fast and fun; it is not the default because pairing and channel state add a second lesson to a 180-minute studio.

**M5StickC-S3.** ESP32-S3 with 8 MB flash, 8 MB PSRAM, BMI270 IMU, ES8311 codec, MEMS microphone, speaker, display, and buttons. Use [M5Unified](https://github.com/m5stack/M5Unified) for the microphone and IMU; the microphone is an I2S codec, not a bare analog pin. **The codec is half-duplex:** M5Unified does not support microphone and speaker at the same time. For simultaneous sound and listening, use a piezo on the panel controller or a second Stick. If the Adafruit I2S amplifier + speaker modules arrive, they are an optional third path; check the free I2S peripheral and pins (on the classic ESP32 the HUB75 driver already uses one). PlatformIO does not ship an official StickS3 board; use `board = esp32-s3-devkitc-1` with the recipe in the Task 2 prompt ([M5 PlatformIO notes](https://docs.m5stack.com/en/core/StickS3)).

**Non-blocking animation.** Keep the render interval and the update interval separate, animate a normalized `0..1` parameter, and never `delay()` in the loop. The pattern is the same as in [Module 5](./05-leds-and-light-output.md).

**Sound envelope.** Sample in blocks, compute peak or RMS over a short window, and decouple the fast audio sampling from the slower frame rate. Automatic gain control normalizes to a recent maximum, so the effect survives both a whisper and a loud room.

**Installation.** Plan for heat, mounting, a diffuser, strain relief on the ribbon and power wires, and a defined behaviour when the sensor or the link drops. An installation that looks good for a minute is not the same as one that survives an evening.

## 📎 Appendix B — Doing it without AI

The panel is new hardware; a working manual path matters.

- **Panel bring-up.** Flash the `ESP32-HUB75-MatrixPanel-DMA` examples (`ColorPixels`, `PatternPlasma`, `AnimatedGIFs`) before writing your own sketch. They prove the wiring, the pin map, the colour order, and the brightness cap.
- **Two-controller link.** Start with two minimal sketches: one that prints `L 42` and `H 128` every second on `Serial2`, and one that reads the lines and prints them on the USB monitor. Add the panel only after the link is boring.
- **Microphone.** Run the M5Unified `Microphone` example first. If the waveform is flat, check the library version and the Stick model before suspecting your wiring.
- **Power.** Measure the panel at 25 % before you raise the brightness. A stable test pattern at low brightness is the baseline; everything else is an experiment.
- **Sources.** [Adafruit RGB matrix basics](https://learn.adafruit.com/32x16-32x32-rgb-led-matrix), [library README](https://github.com/mrcodetastic/ESP32-HUB75-MatrixPanel-DMA), [M5Unified](https://github.com/m5stack/M5Unified), [M5StickS3 docs](https://docs.m5stack.com/en/core/StickS3).

<a id="appendix-c"></a>
## 📎 Appendix C — Ideas, prompts, and sources

Read in any order, take what helps, and replace the rest with your own research. Cite what you use.

**Play seeds (Task 3)**

- **Reaction game:** one pixel lights, the player hits the button, the next one lights; score on the panel.
- **Tiny snake or Tetris:** a grid game on 32×32; the joystick or the Stick buttons are the controller.
- **VU meter:** microphone level to rows, with a peak-hold dot.
- **Theremin:** hand distance (ToF) or light (LDR) to hue and tone; the piezo or the Stick speaker plays the note.
- **Distance wave:** the Module 4 ToF sensor wakes the panel when someone approaches.
- **Sound mirror:** the panel shows the envelope as a moving bar; quiet and loud rooms must both work.
- **Motorized twist:** a servo or DC motor shield moves a diffuser or a pointer; keep it optional and do not let it eat the panel time.
- **Networked twist (`◇`):** a phone hotspot and a tiny web UI or MQTT; this is Module 8/final-project territory, not a requirement.

**Questions to ask an LLM (then verify on the panel)**

- “Scaffold a PlatformIO project for a 32×32 HUB75 panel on an MH-ET LIVE ESP32 MiniKit with the HUB75 DMA library: test pattern, brightness control, and a non-blocking loop.”
- “Given measured currents at 25/50/75/100 % white, estimate the maximum safe brightness for a 5 V 4 A supply and the margin I should keep.”
- “Write a `millis()`-based breathing effect for a 32×32 panel with one speed/depth parameter. No `delay()`.”
- “Compute a short-term RMS envelope from an I2S microphone and map it to brightness with automatic gain control.”
- “Design a tiny protocol for a two-controller panel: `L 0..100` and `H 0..255` over UART; show the parser and the failure handling.”
- “Explain HUB75 scan and refresh, and why a phone camera may show flicker that the eye does not.”
- “Turn this story hook into a one-button game loop on a 32×32 panel: <hook>.”

> Run each prompt against your own panel, and record where the model is wrong, vague, or over-confident.

**Wiring and background sources**

- [Adafruit 32×32 panel](https://www.adafruit.com/product/2026) and [RGB LED matrix basics](https://learn.adafruit.com/32x16-32x32-rgb-led-matrix) — power, scan, wiring.
- [`ESP32-HUB75-MatrixPanel-DMA`](https://github.com/mrcodetastic/ESP32-HUB75-MatrixPanel-DMA) — driver, examples, default pin maps.
- [M5StickS3 documentation](https://docs.m5stack.com/en/core/StickS3) — pin map, PlatformIO recipe, audio codec.
- [M5Unified](https://github.com/m5stack/M5Unified) — microphone, IMU, display, speaker.
- [Arduino ESP-NOW guide](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/espnow.html) and [Random Nerd tutorial](https://randomnerdtutorials.com/esp-now-esp32-arduino-ide/) — the wireless `◇`.
- [Arduino: `millis()`](https://docs.arduino.cc/language-reference/en/functions/time/millis/) and [Blink Without Delay](https://docs.arduino.cc/built-in-examples/digital/BlinkWithoutDelay/) — the non-blocking pattern.
- [Envelope (music)](https://en.wikipedia.org/wiki/Envelope_(music)) and [Root mean square](https://en.wikipedia.org/wiki/Root_mean_square) — the sound features you can compute on a microcontroller.

## 📎 Appendix D — `AGENTS.md` template

One `AGENTS.md` per project, at its root. Keep the two projects separate; each agent gets only the rules it needs.

```md
# AGENTS.md — panel controller

- Board: MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`), PlatformIO.
- Panel: 32×32 HUB75, 1/16 scan. Pins: R1=25, G1=26, B1=27, R2=14, G2=12,
  B2=13, A=23, B=19, C=5, D=17, E=-1, LAT=4, OE=15, CLK=16. On the MiniKit,
  TDO/TDI/TCK/TMS are GPIO 15/12/13/14.
- Power: 5 V 4 A panel supply, common ground; never from USB or a GPIO.
- Link: Serial2, GPIO32 (RX) / GPIO33 (TX), 115200. Protocol: `L 0..100`,
  `H 0..255`, newline-terminated.
- Brightness: cap at `setBrightness8(96)` until the power table says otherwise.
- Keep the loop non-blocking; no `delay()` in the render path.
```

```md
# AGENTS.md — sensor controller (M5StickC-S3)

- Board: M5StickC-S3, `board = esp32-s3-devkitc-1`, `platform = espressif32@6.12.0`,
  8 MB partitions, qio_opi, USB CDC; `lib_deps = m5stack/M5Unified`.
- Link: Serial2, HAT2 G1 (TX) / G2 (RX), 115200.
- Protocol: send `L 0..100` every 50 ms; send `H 0..255` when the hue changes.
- Microphone: short blocks, 8 kHz, 256 samples; RMS with a noise floor and AGC.
- Audio is half-duplex: do not use the speaker while recording.
```

## 📚 If you want to go deeper

- [Adafruit 32×32 panel](https://www.adafruit.com/product/2026) and [RGB LED matrix basics](https://learn.adafruit.com/32x16-32x32-rgb-led-matrix) — wiring, power, and scan.
- [`ESP32-HUB75-MatrixPanel-DMA`](https://github.com/mrcodetastic/ESP32-HUB75-MatrixPanel-DMA) — DMA driver, examples, and pin mapping.
- [M5Unified](https://github.com/m5stack/M5Unified) — microphone, IMU, and display on the Stick.
- [Arduino: `millis()`](https://docs.arduino.cc/language-reference/en/functions/time/millis/) and [Blink Without Delay](https://docs.arduino.cc/built-in-examples/digital/BlinkWithoutDelay/) — the non-blocking pattern.
- [Envelope (music)](https://en.wikipedia.org/wiki/Envelope_(music)) and [Root mean square](https://en.wikipedia.org/wiki/Root_mean_square) — the sound features you can compute on a microcontroller.

---

[← Previous: Module 5](./05-leds-and-light-output.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 7 — Motors & Motion Actuators →](./07-motors-and-motion-actuators.md)
