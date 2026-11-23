# Module 6 reference lab — panel + Stick

> Instructor reference for [Module 6](../../modules/06-led-animation-sound-and-installations.md).
> It is tracked instructor material; students may read it as an example. Flash it, break it, and
> improve it before the session; keep a known-good `task1-panel/` from it.

Three PlatformIO projects:

```
module6-panel-lab/
├── panel/               ESP32 Dev Module + 32×32 HUB75 panel (ESP32-HUB75-MatrixPanel-DMA)
├── stick/               M5StickC-S3: microphone + IMU → UART → panel
└── pxmatrix-fallback/   plan B: Wemos D1 mini + PxMatrix, panel-only diagnostic
```

The fallback exists for two reasons: a pod that only has ESP8266 boards, and a control experiment
when the ESP32 build stays dark — if the D1 mini lights the panel, the panel, ribbon and supply are
proven good and the fault is in the ESP32 harness. It also documents the five-jumper trick that made
the ESP8266 recipe work in earlier years. See
[`pxmatrix-fallback/README.md`](pxmatrix-fallback/README.md), rationale in
[D24](../00-architecture-decisions.md#d24).

The protocol is deliberately tiny:

```text
L <0..100>\n     sound level
H <0..255>\n     hue
```

## Wiring

### Panel

| HUB75 | ESP32 | HUB75 | ESP32 |
|---|---:|---|---:|
| R1 | 25 | R2 | 14 |
| G1 | 26 | G2 | 12 |
| B1 | 27 | B2 | 13 |
| A | 23 | B | 19 |
| C | 5 | D | 17 |
| E | — (1/16 scan) | LAT | 4 |
| OE | 15 | CLK | 16 |
| GND | GND | | |

Power the panel through its **5 V/GND** terminals from the 5 V 4 A supply. The ribbon carries the
signals, not the LED current. Common ground between the panel supply, the ESP32, and the level
shifter.

### The connector as you see it

**Mirrored** — the class case: the flat ribbon comes towards you. Each row reads left to right; the
number is the pin position, counted in pairs (1‑2, 3‑4, …) from the pin‑1 end. The right-hand
columns say where that wire goes on the MiniKit.

| # | Signal | GPIO | MiniKit | # | Signal | GPIO | MiniKit |
|---:|---|---:|---|---:|---|---:|---|
| 1 | `G1` | 26 | left-inner `IO26` | 2 | `R1` | 25 | right-outer `IO25` |
| 3 | `GND` | — | any `GND` | 4 | `B1` | 27 | right-outer `IO27` |
| 5 | `G2` | 12 | right-outer `TDI` | 6 | `R2` | 14 | left-outer `TMS` |
| 7 | `GND` | — | any `GND` | 8 | `B2` | 13 | left-inner `TCK` |
| 9 | `B` | 19 | left-inner `IO19` | 10 | `A` | 23 | left-inner `IO23` |
| 11 | `D` | 17 | right-inner `IO17` | 12 | `C` | 5 | left-inner `IO5` |
| 13 | `LAT` | 4 | right-outer `IO4` | 14 | `CLK` | 16 | right-inner `IO16` |
| 15 | `OE` | 15 | right-inner `TDO` | 16 | `GND` | — | any `GND` |

**Unmirrored** — the same connector seen from the other side, for male–female dupont wires. Same
rows, the two halves swapped:

| # | Signal | GPIO | MiniKit | # | Signal | GPIO | MiniKit |
|---:|---|---:|---|---:|---|---:|---|
| 2 | `R1` | 25 | right-outer `IO25` | 1 | `G1` | 26 | left-inner `IO26` |
| 4 | `B1` | 27 | right-outer `IO27` | 3 | `GND` | — | any `GND` |
| 6 | `R2` | 14 | left-outer `TMS` | 5 | `G2` | 12 | right-outer `TDI` |
| 8 | `B2` | 13 | left-inner `TCK` | 7 | `GND` | — | any `GND` |
| 10 | `A` | 23 | left-inner `IO23` | 9 | `B` | 19 | left-inner `IO19` |
| 12 | `C` | 5 | left-inner `IO5` | 11 | `D` | 17 | right-inner `IO17` |
| 14 | `CLK` | 16 | right-inner `IO16` | 13 | `LAT` | 4 | right-outer `IO4` |
| 16 | `GND` | — | any `GND` | 15 | `OE` | 15 | right-inner `TDO` |

The ribbon carries sixteen pins and **no `E`** (unused at 1/16 scan); the third ground shares the last
pair with `OE`. The signal in the cell is what you wire — if your panel prints the standard HUB75
numbers (1 = `R1`, 2 = `G1`, …), the numbers here are only an orientation aid, because a mirrored
ribbon swaps the two members of each pair. Verify one panel with a continuity tester before you trust
any number.

**Level shifter (74HCT245).** 3.3 V signals on the A side, panel signals on the B side,
VCC = 5 V, OE = GND, DIR = 3.3 V, common ground, 100 nF decoupling. Many panels work at 3.3 V on a
short ribbon; the shifter is the reliable choice.

### Board labels: `TDO` is GPIO 15

Some boards print the JTAG function instead of the GPIO number. On the classic ESP32 the mapping
is fixed, so read the number, not the name:

| Silkscreen | GPIO | Used here as |
|---|---:|---|
| `TDI` / `MTDI` | 12 | G2 |
| `TDO` / `MTDO` | 15 | OE |
| `TCK` / `MTCK` | 13 | B2 |
| `TMS` / `MTMS` | 14 | R2 |

On an Espressif **ESP32-Ethernet-Kit** (or a clone with a JTAG DIP block) those four GPIOs are
wired to the on-board FT2232H while their DIP switches are **on**. Turn them **off**, or the panel
signals and the debug chip drive the same lines.

### Strapping pins: why the panel can stop the board booting

GPIO 5, 12 and 15 are *strapping* pins — sampled at reset to configure the chip. The panel and the
level shifter can hold them at the wrong level before the ESP32 has configured them:

| GPIO | Used here as | Must be at reset | Otherwise |
|---|---|---|---|
| 12 (`MTDI`) | G2 | **LOW** | flash voltage is selected as 1.8 V and the board does not boot |
| 5 | C | **HIGH** | wrong SDIO timing / can drop into download mode |
| 15 (`MTDO`) | OE | **HIGH** | boot log on UART0 is silenced (annoying, not fatal) |

Two habits make that a non-issue:

- **Flash with the ribbon unplugged** if the board refuses to boot or upload; reconnect it afterwards.
  Once booted, all three pins behave as ordinary outputs.
- If it still misbehaves, add a **10 kΩ pulldown from GPIO 12 to GND** on the ESP32 side of the
  shifter. That is the pin that breaks boot, and the fix is one resistor.
- If you would rather not add the resistor, move G2 off the strapping pin: **GPIO 18 is free** in
  this build. Change `#define G2_PIN 12` to `18` in `panel/src/main.cpp` and that one wire in the
  table above — nothing else changes.

How the panel addresses its rows (and why `E` is unused here) is explained under
[1/16 scan](../../modules/Z-resources-bank.md#hub75-scan) in the resource bank.

### Finding these pins on the MH-ET LIVE MiniKit

The silk screen prints function names, not GPIO numbers, and the JTAG quartet sits on the header
where you would look for GPIO 12–15. The board has two double-row headers; read down each column
(GPIO numbers in brackets). Ribbon on the left, board on the right, same rows — the `H<n>` marks
tie a board pin to a HUB75 pin above.

**Mirrored ribbon** (the class case):

| HUB75 | | | left-outer | left-inner | | right-inner | right-outer |
|---|---|---|---|---|---|---|---|
| `1` `G1` | `2` `R1` | | `GND` | `RST` | | `TXD` (1) | `GND` |
| `3` `GND` | `4` `B1` | | `NC` | `SVP` (36) | | `RXD` (3) | `IO27` **H4** |
| `5` `G2` | `6` `R2` | | `SVN` (39) | `IO26` **H1** | | `IO22` | `IO25` **H2** |
| `7` `GND` | `8` `B2` | | `IO35` | `IO18` | | `IO21` | `IO32` |
| `9` `B` | `10` `A` | | `IO33` | `IO19` **H9** | | `IO17` **H11** | `TDI` (12) **H5** |
| `11` `D` | `12` `C` | | `IO34` | `IO23` **H10** | | `IO16` **H14** | `IO4` **H13** |
| `13` `LAT` | `14` `CLK` | | `TMS` (14) **H6** | `IO5` **H12** | | `GND` | `IO0` |
| `15` `OE` | `16` `GND` | | `NC` | `3V3` | | `VCC` | `IO2` |
| | | | `SD2` (9) | `TCK` (13) **H8** | | `TDO` (15) **H15** | `SD1` (8) |
| | | | `CMD` (11) | `SD3` (10) | | `SD0` (7) | `CLK` (6) |

**Unmirrored ribbon** (male–female dupont, board seen the other way):

| HUB75 | | | left-outer | left-inner | | right-inner | right-outer |
|---|---|---|---|---|---|---|---|
| `2` `R1` | `1` `G1` | | `GND` | `RST` | | `TXD` (1) | `GND` |
| `4` `B1` | `3` `GND` | | `NC` | `SVP` (36) | | `RXD` (3) | `IO27` **H4** |
| `6` `R2` | `5` `G2` | | `SVN` (39) | `IO26` **H1** | | `IO22` | `IO25` **H2** |
| `8` `B2` | `7` `GND` | | `IO35` | `IO18` | | `IO21` | `IO32` |
| `10` `A` | `9` `B` | | `IO33` | `IO19` **H9** | | `IO17` **H11** | `TDI` (12) **H5** |
| `12` `C` | `11` `D` | | `IO34` | `IO23` **H10** | | `IO16` **H14** | `IO4` **H13** |
| `14` `CLK` | `13` `LAT` | | `TMS` (14) **H6** | `IO5` **H12** | | `GND` | `IO0` |
| `16` `GND` | `15` `OE` | | `NC` | `3V3` | | `VCC` | `IO2` |
| | | | `SD2` (9) | `TCK` (13) **H8** | | `TDO` (15) **H15** | `SD1` (8) |
| | | | `CMD` (11) | `SD3` (10) | | `SD0` (7) | `CLK` (6) |

`H<n>` is the HUB75 pin number from the tables above, so the three views agree. The remaining header
pins carry no panel signal: **`IO22` is unused**, as are `IO21`, `IO32`, `IO18`, `IO0`, `IO2`,
`IO33`, `IO34`, `IO35`, `SVP`, `SVN` — `IO18` is the spare that can take over G2 if GPIO 12
misbehaves.

Which label carries which panel signal:

| Signal | GPIO | Printed on the board |
|---|---:|---|
| R1 | 25 | `IO25` |
| G1 | 26 | `IO26` |
| B1 | 27 | `IO27` |
| R2 | 14 | `TMS` |
| G2 | 12 | `TDI` |
| B2 | 13 | `TCK` |
| A | 23 | `IO23` |
| B | 19 | `IO19` |
| C | 5 | `IO5` |
| D | 17 | `IO17` |
| LAT | 4 | `IO4` |
| OE | 15 | `TDO` |
| CLK | 16 | `IO16` |

The four JTAG names are exactly the four pins this panel needs: `TDI` = G2, `TCK` = B2, `TMS` = R2,
`TDO` = OE. That is why the board seems to have no GPIO 12–15.

**Do not use** `SD0`, `SD1`, `SD2`, `SD3`, `CLK`, `CMD` (GPIO 6–11): the internal flash bus.
`SVP`/`SVN` (36/39) and `IO34`/`IO35` are **input-only** and cannot drive a panel line. `TXD`/`RXD`
(1/3) are the USB console and stay free.

### UART link (default)

| StickS3 HAT2 | ESP32 Dev Module |
|---|---|
| G1 (TX) | GPIO32 (RX) |
| G2 (RX) | GPIO33 (TX) |
| GND | GND |

`Serial2.begin(115200, SERIAL_8N1, RX, TX)` on both sides. The Stick's Grove port is G9/G10 if you
prefer the Grove cable; verify the TX/RX order. Do not use SoftwareSerial on the S3; it competes
with the I2S microphone and the panel DMA.

### ESP-NOW (`◇`)

Same protocol, no wire. You can do this instead of the UART version, but it is riskier.
Put both boards in station mode on the same Wi-Fi channel, read the
receiver MAC from its serial output, add it as a peer, and send the same two messages. The HUB75
driver uses I2S DMA, not the radio, so it coexists with ESP-NOW. Sources:
[Arduino ESP-NOW](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/espnow.html),
[Random Nerd tutorial](https://randomnerdtutorials.com/esp-now-esp32-arduino-ide/).

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

Open the monitor **after** the board has started, not before. On this board the USB bridge's DTR
line holds GPIO 0 low, so pressing RESET while a monitor is attached lands in download mode and you
see `waiting for download` instead of the sketch. Reset first, then attach the monitor. If you
missed the boot output, the sketch can repeat it:

| Type in the monitor | Effect |
|---|---|
| `?` | reprint the config banner and the current diagnostic line |
| `t` | run the self-test again (beacon, colours, corners) |
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
   - a grey border with four corner pixels: **red** top-left, **green** top-right, **blue**
     bottom-left, **white** bottom-right;
   - a ramp along row 1 fading red → black left to right, and one down column 1 fading green →
     black top to bottom;
   - then the dim breathing colour and `selftest done - breathing` in the monitor.
5. Read the failure here, while only the panel is in the loop:

   | You see | Look at |
   |---|---|
   | nothing at any beacon step | 5 V on the panel terminals, common ground, OE wiring; `panel init FAILED` in the monitor lists the same checks |
   | lights only at 160/255 | brightness setting, not a fault — raise the cap with `+` |
   | one colour missing or wrong | that colour pair (R1/R2, G1/G2, B1/B2) or the ribbon orientation |
   | corners in the wrong place, image mirrored or rotated | ribbon orientation; panel scan / mapping |
   | shifted, doubled, or torn image | ribbon seating, scan rate / mapping, level shifter |
   | flicker on bright frames | common ground, thin power wires, missing 74HCT245, brightness cap too high |

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
  beacon 255):** in this order — 5 V measured at the panel terminals, common ground, `CLK`
  (H14 → IO16), `OE` (H15 → `TDO`). Beep the last two with a multimeter; "the wire looks right" is
  not a measurement. If all four check out, flash the
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
  must be LOW at reset. Flash with the ribbon unplugged, or add a 10 kΩ pulldown from GPIO 12 to
  GND. See *Strapping pins* under Wiring.
- **`TDO` / `TDI` on the silkscreen:** those are GPIO 15 and 12. The board-label table under Wiring
  has the full mapping.
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
