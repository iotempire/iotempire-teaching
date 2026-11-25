# Module 6 reference lab — panel + Stick

> Instructor reference for [Module 6](../../modules/06-led-animation-sound-and-installations.md).
> It is tracked instructor material; students may read it as an example. Flash it, break it, and
> improve it before the session; keep a known-good `task1-panel/` from it.

Three PlatformIO projects:

```
module6-panel-lab/
├── panel/               MH-ET LIVE ESP32 MiniKit + 32×32 HUB75 panel (ESP32-HUB75-MatrixPanel-DMA)
├── stick/               M5StickC-S3: microphone + IMU → UART → panel
└── pxmatrix-fallback/   plan B: Wemos D1 mini + PxMatrix, panel-only diagnostic
```

The fallback exists for two reasons: a pod that only has ESP8266 boards, and a control experiment
when the ESP32 build stays dark — if the D1 mini lights the panel, the panel, ribbon and supply are
proven good and the fault is in the ESP32 harness. It also documents the five-jumper trick that made
the ESP8266 recipe work in earlier years. See [`pxmatrix-fallback/README.md`](pxmatrix-fallback/README.md),
rationale in [D24](../00-architecture-decisions.md#d24).

The protocol is deliberately tiny:

```text
L <0..100>\n     sound level
H <0..255>\n     hue
```

## Wiring lives in the student module

The complete wiring reference — the panel's printed pin numbers, the two ribbon readings (straight
and mirrored), the MiniKit header tables, the `TDO`/GPIO 15 labels, the strapping pins and the level
shifter — is **student material** now:

> [Module 6, Appendix A — Panel facts, wiring, power, and the link](../../modules/06-led-animation-sound-and-installations.md#appendix-a)

Keep it there. This page describes how to run the lab against that diagram; if a wiring fact changes,
change it in the module and not here, or the two will drift apart the way the pin numbering did.

## Optional audio (if the modules arrive)

An Adafruit I2S amplifier plus speaker (for example the MAX98357A breakout) gives real sound output
without the Stick’s half-duplex codec conflict. It needs a free I2S peripheral and pins: on the
classic ESP32 the HUB75 driver already uses one I2S peripheral, so check what is free on the board
you choose before wiring. A piezo remains the simple fallback.

## Build and flash

```sh
cd panel
pio run -t upload
pio device monitor          # 115200, panel debug output

cd ../stick
pio run -t upload
pio device monitor          # 115200, level/hue debug output
```

**Board ID.** `panel/platformio.ini` uses `board = mhetesp32minikit`. `esp32dev` also builds and
flashes this board, and the two are interchangeable here. Their PlatformIO definitions differ only in
the Arduino `variant` and one `-D` macro (`-DARDUINO_MH_ET_LIVE_ESP32MINIKIT` vs
`-DARDUINO_ESP32_DEV`); the MCU, 4 MB flash, `dio` flash mode, 40 MHz flash frequency and the 460800
upload speed are identical, so the flash method does not change. The pin map lives in
`panel/src/main.cpp` anyway. Keep `mhetesp32minikit` as the recorded value so the repository states
what the class actually uses.

Open the monitor **after** the board has started, not before. On this board the USB bridge's DTR
line holds GPIO 0 low, so pressing RESET while a monitor is attached lands in download mode and you
see `waiting for download` instead of the sketch. Reset first, then attach the monitor. If you
missed the boot output, the sketch can repeat it:

| Type in the monitor | Effect |
|---|---|
| `?` | reprint the config banner and the current diagnostic line |
| `t` | run the self-test again (beacon, colours, corners) |
| `c` | show only the corner/ramp frame for 6 s — the wiring check, nothing else |
| `+` / `-` | raise / lower the brightness cap by 32 while running |
| `r` | reboot |

The panel sketch runs a self-test at boot before the breathing starts — do step 1 of the Test
below right after the first upload. Set `SELFTEST_ON_BOOT` to `0` in `panel/src/main.cpp` once the
panel is known good.

The StickS3 is not an official PlatformIO board. `stick/platformio.ini` uses
`board = esp32-s3-devkitc-1`, 8 MB partitions, `qio_opi`, USB CDC, and M5Unified, which is the
recipe from the [M5 docs](https://docs.m5stack.com/en/core/StickS3).

## Test

Two steps, in this order. Do step 1 before you connect the Stick: with the UART already wired, a
silent panel could be wiring, level shifter, power, or protocol all at once.

### Step 1 — panel only (no Stick connected)

Flash `panel/` with nothing on the UART pins. `setup()` runs the self-test, then hands over to the
breathing.

1. Attach the monitor *after* a reset (see Build and flash). The order is:
   `boot: reset reason: …` → a `=== module6 panel controller ===` banner with the pin map →
   `panel ready` → `selftest: …` → `selftest done - breathing` → a
   `alive <seconds> L=… H=… bright=…/<cap> frames=… heap=…` line **every two seconds**. That
   heartbeat is the difference between "the sketch is running and the panel is dark" and "no sketch
   is running at all"; `frames` climbing proves the panel is being written to.
2. Read the reset reason on the first line. `power-on` after you press the button is normal;
   `brownout` means the 5 V supply or the grounds sagged (the panel's current, not the code);
   `external pin` or **no output whatsoever** means GPIO 0 was held low and the chip sat in the ROM
   bootloader instead of starting the sketch.
3. The self-test starts with a **brightness beacon**: solid white at 16, 48, 96, 160, 255, each
   announced on serial. Note the step at which the panel first lights up. Lights at 255 but nothing
   lower is a dim or high-resistance path (or a very dark room measurement); nothing at any step
   means power, ground, or OE — not brightness.
4. Then the colour sequence, about a second each:
   - solid **red**, **green**, **blue**, **white**;
   - four **6×6 corner blocks**: **red** top-left, **green** top-right, **blue** bottom-left,
     **white** bottom-right;
   - a red ramp across the **middle row**, black at the left → bright red at the right (it points
     right), and a green ramp down the **middle column**, black at the top → bright green at the
     bottom (it points down);
   - a dim grey border around the whole 32×32 area;
   - then the dim breathing colour and `selftest done - breathing` in the monitor.

   Judge the frame by **position, not by colour mixing**: a red block next to a green one looks
   yellow at 5 mm pitch, and blue next to green looks cyan. Four blocks in four different corners,
   one ramp pointing right, one pointing down — anything else is a wiring fault, not optics.

   The corner frame is the only one that tests the address lines; press `c` to bring it back without
   re-running the whole sequence.
5. Read the failure here, while only the panel is in the loop:

   | You see | Look at |
   |---|---|
   | nothing at any beacon step | 5 V on the panel terminals, common ground, OE wiring; `panel init FAILED` in the monitor lists the same checks |
   | lights only at 160/255 | brightness setting, not a fault — raise the cap with `+` |
   | no blue anywhere, white looks yellow | the blue pair: pins 3/7 (`B1`/`B2`) wired into the ground holes, or `B1`/`B2` really at GND |
   | red and green exchanged (the red phase is green, the green phase red) | pins 1/2 (`R1`/`G1`), or 5/6 (`R2`/`G2`) |
   | one colour missing or wrong | that colour pair (R1/R2, G1/G2, B1/B2) or the ribbon orientation |
   | corners in the wrong place, image mirrored or rotated | ribbon orientation; panel scan / mapping |
   | shifted, doubled, or torn image | ribbon seating, scan rate / mapping, level shifter |
   | flicker on bright frames | common ground, thin power wires, missing 74HCT245, brightness cap too high |

   **The pair-swap signature.** Red and green exchanged *and* no blue at all (the beacon's white
   comes out yellow) means pairs 1–2 and 3–4 — and 7–8 as well if it affects both halves — are
   crossed: `R1` sits in the `G1` hole, `B1` in the `GND` hole. It is the same mistake as a swapped
   `CLK`/`LAT`, just in pairs that fail quietly instead of dark. Solid colours also hide crossed
   `A`/`B` and `C`/`D` (pins 9–12), because a solid fill looks identical with the row order
   permuted — that one only shows up in the corner and ramp frame, so look at it.

6. While the solid white is up, measure the current with the meter in series with the 5 V supply.
   That white is at `MAX_BRIGHTNESS` (96, not 255), so it is the number that matters. Lower
   `MAX_BRIGHTNESS` in `panel/src/main.cpp` until you have margin on the 4 A supply.

### Step 2 — panel + Stick (UART)

1. Open the panel monitor and the Stick monitor.
2. Speak or clap: the level rises and the panel brightens. Tilt the Stick: the hue changes. The
   Stick display shows `L` and `H`.
3. If the link is silent: swap TX/RX, check the common ground, and confirm both `Serial2` pin
   pairs. Print the raw received line on the panel monitor.

## Known issues

- **Panel completely dark, driver running (`panel ready`, `alive …` with `frames` climbing, dark at
  beacon 255):** in this order — 5 V measured at the panel terminals, common ground, the two ribbon
  readings mixed up (`CLK`/`LAT` are in the same pair, see
  [Module 6 Appendix A](../../modules/06-led-animation-sound-and-installations.md#appendix-a)),
  `CLK` (pin 13 → IO16) and `LAT` (pin 14 → IO4), then `OE` (pin 15 → `TDO`). Beep those three with
  a multimeter; "the wire looks right" is not a measurement. If they all check out, flash the
  [ESP8266 fallback](pxmatrix-fallback/README.md) to prove the panel and ribbon independently.
- **Wrong colours or a shifted image:** ribbon orientation, a swapped colour pair, or the wrong
  panel scan. Run the library example before blaming the sketch.
- **Reset lands in download mode, and the monitor stays silent:** GPIO 0 is LOW at reset, so the ROM
  bootloader runs and no sketch starts. Three causes, in order of likelihood: (a) a monitor was
  attached when you pressed RESET — the USB bridge's DTR holds GPIO 0 low, so reset first and attach
  the monitor afterwards; (b) you bridged `GND` to `IO0` to force a flash — a common workaround when
  the auto-reset misbehaves — **remove that link**, with it in place every reset re-enters download
  mode; (c) a stuck BOOT button or a faulty USB-bridge auto-reset. The first serial line names the
  reset reason, and `alive …` every two seconds proves the sketch is actually running.
- **Board will not boot or upload with the panel connected:** GPIO 12 (G2) is a strapping pin and
  must be LOW at reset. Flash with the ribbon unplugged, or add a 10 kΩ pulldown. The full note is
  under *Strapping pins* in
  [Module 6 Appendix A](../../modules/06-led-animation-sound-and-installations.md#appendix-a).
- **`TDO` / `TDI` on the MiniKit silkscreen:** those are GPIO 15 and 12, and they are the panel's
  `OE` and `G2`. Full mapping in the same appendix.
- **`ESP32-HUB75-MatrixPanel-DMA.h: No such file or directory`:** the library ships
  `ESP32-HUB75-MatrixPanel-I2S-DMA.h` — the `I2S` is part of the header name, the C++ class is
  still `MatrixPanel_I2S_DMA`. `platformio.ini` pulls the library from Git without a tag, so a
  future upstream rename shows up here first. If you want reproducibility, pin `lib_deps` to a
  commit (`…MatrixPanel-DMA.git#<sha>`).
- **Flicker on bright frames:** common ground, thin power wires, missing level shifter, or the
  brightness cap too high.
- **Stick microphone flat:** wrong M5Unified version or the codec still in speaker mode. Run the
  `M5Unified` `Microphone` example first.
- **Stick upload fails:** USB CDC / boot mode. Hold the side button while reconnecting.
- **Speaker and microphone at once:** the ES8311 codec is half-duplex. Use a piezo on the panel
  controller or a second Stick.

## Sources

- [Adafruit 2026 panel](https://www.adafruit.com/product/2026) · [RGB matrix basics](https://learn.adafruit.com/32x16-32x32-rgb-led-matrix)
- [ESP32-HUB75-MatrixPanel-DMA](https://github.com/mrcodetastic/ESP32-HUB75-MatrixPanel-DMA)
- [M5StickS3 docs](https://docs.m5stack.com/en/core/StickS3) · [M5Unified](https://github.com/m5stack/M5Unified)
