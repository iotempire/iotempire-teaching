# Module 6 Studio — LED Panels, Sound & Play

[Module 6](../modules/06-led-animation-sound-and-installations.md) · [Architecture decisions](./00-architecture-decisions.md) · [All instructor notes](./README.md)

## Why this session is open

Module 5 proved the pattern: a no-AI first win, then AI scaffolds, then an open end where the
creativity happens (D19). Module 6 keeps that shape. The lecture-style segment is gone; the
instructor circulates, pre-flights the hardware, and joins the debugging. The play task is
mandatory and stays open after the exchange (D24).

## Before the session

- **Pre-flight the reference project.** Flash [`module6-panel-lab/`](./module6-panel-lab/README.md) on the actual
  32×32 panel, the 5 V 4 A supply, an MH-ET LIVE ESP32 MiniKit, and an M5StickC-S3. Measure at 25 % white,
  confirm the colour order and the UART link, and photograph the wiring.
- **Keep a known-good baseline.** One `task1-panel/` folder with the library example, the pin map,
  and the power table; one pre-flashed panel; one Stick with the mic and the sender working.
- **Test the Stick recipe.** PlatformIO has no official StickS3 board: `board = esp32-s3-devkitc-1`,
  8 MB partitions, `qio_opi`, USB CDC flags, M5Unified. Confirm the upload and the serial monitor.
- **Wire-pulling experiment.** Run Task 1's signal-removal experiment on the instructor rig or a
  spare panel, not the only working class panel. Keep a spare ribbon; signal wires only, never the
  5 V feed or a ground.
- **No prep email is required** if the pods use the class boards: the toolchain is Module 5's. If
  pods bring their own Stick, send the PlatformIO recipe and the UART pin pair.
- **Pack for the play task.** Motors, DC motor shields, small servos, joystick dev boards, piezos,
  and a few spare jumpers. If the Adafruit I2S amplifier + speaker modules arrive in time, pack them
  too as an optional audio path (check the free I2S peripheral and pins first). Module 5's best
  moments came from students adding a piezo and a phone hotspot; Module 6 makes the play task
  mandatory, so have the physical options on the table.

## The day is 180 minutes (two halves)

A normal teaching day is two 90-minute halves with a break (D20). Day 6 is one 180-minute
Praktikum slot in WS 2026/27; take the break inside it.

| Time | Segment | What happens |
|---|---|---|
| 0–10 | Story and safety | Panel power, common ground, level shifter, the two-controller default, the four folders |
| 10–55 | Task 1 — first light | Wire the panel, flash the library example, measure 25/50/75/100 %, fill the power table, choose the cap |
| 55–65 | Break | — |
| 65–115 | Task 2 — breathe and listen | Two projects, two prompts, UART link, mic envelope, IMU/ToF hue, video |
| 115–155 | Task 3 — play | Story hook first, one interaction, optional motor/joystick/piezo; this task continues after the exchange |
| 155–170 | Share and exchange | Commit, compare architectures and prompts, one shared artefact |
| 170–180 | Buffer and demo | One working and one broken thing per pod; point to the open play task |

If Task 1 runs long, protect the link and the mic: Task 3 moves to self-study. If Task 1 is fast,
start Task 2 early; the play task is the reward, not the schedule's hostage.

## The default architecture

- **Panel controller:** MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`), `ESP32-HUB75-MatrixPanel-DMA`,
  the library's default GPIO numbers (R1=25, G1=26, B1=27, R2=14, G2=12, B2=13, A=23, B=19, C=5, D=17,
  E=-1, LAT=4, OE=15, CLK=16).
- **Sensor/UI controller:** M5StickC-S3, M5Unified, microphone + BMI270, display, buttons.
- **Link:** UART, 115200, `Serial2`. Stick HAT2 G1 (TX) → panel GPIO32 (RX); Stick G2 (RX) ← panel
  GPIO33 (TX); common ground. Protocol: `L 0..100`, `H 0..255`, newline-terminated.
- **Wireless `◇`:** ESP-NOW, same protocol; same Wi-Fi channel; peer MAC from the serial output.
  No router. Do not use SoftwareSerial: it competes with the I2S microphone and the panel DMA.

**Why the ESP32 and not the ESP8266 boards of earlier years.** Both chips drive a HUB75 panel — the
ESP32 through DMA (`ESP32-HUB75-MatrixPanel-DMA`), the ESP8266 through bit-banging (`PxMatrix`) — but
the harness is not identical: the ESP8266 uses fewer GPIOs (8 panel signals instead of 13) and puts
three times as many bits on the wire per frame. It is rejected for refresh headroom, not for pin
count: bit-banging leaves little CPU for the microphone, the animation, and a wireless path. The
ESP8266 route survives as the PxMatrix fallback. Recorded as D24 in the
[architecture log](./00-architecture-decisions.md#d24); the student-facing explanation is the
resource bank's [1/16-scan entry](../modules/Z-resources-bank.md#hub75-scan).

## Common failures

- **Wrong colours or a shifted image:** ribbon orientation, a swapped R/G/B pair, or the wrong
  panel scan. Check the library example before blaming the sketch.
- **Flicker on bright frames:** common ground, thin power wires, no level shifter, or the brightness
  cap set too high. Add the bulk capacitor only with the correct polarity and voltage rating.
- **No link:** TX/RX swapped, missing ground, the wrong `Serial2` pins, or the monitor still on
  `Serial`. Print the raw received line on the panel's USB monitor.
- **Stick microphone flat:** wrong M5Unified version, the wrong Stick model, or the codec still in
  speaker mode. Run the M5Unified `Microphone` example first.
- **Stick upload fails:** the board recipe, USB CDC mode, or boot mode. Hold the side button and
  reconnect; the S3 can lose its serial port after bad firmware.
- **Speaker and microphone at once:** the ES8311 codec is half-duplex. Use a piezo on the panel
  controller or a second Stick.

## After the run

Record the evidence in the TODO and the ADR: what the pods built, which link they chose, where the
power table surprised them, and whether the play task produced a shareable hook. Move the module's
`DRAFT BOUNDARY` only after that evidence exists.
