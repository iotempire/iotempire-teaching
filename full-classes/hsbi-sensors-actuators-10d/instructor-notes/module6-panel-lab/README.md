# Module 6 reference lab — panel + Stick

> Instructor reference for [Module 6](../../modules/06-led-animation-sound-and-installations.md).
> It is tracked instructor material; students may read it as an example. Flash it, break it, and
> improve it before the session; keep a known-good `task1-panel/` from it.

Two PlatformIO projects:

```
module6-panel-lab/
├── panel/     ESP32 Dev Module + 32×32 HUB75 panel (ESP32-HUB75-MatrixPanel-DMA)
└── stick/     M5StickC-S3: microphone + IMU → UART → panel
```

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

The 5 V supply stays separate and the ground stays common — the ribbon carries signals, not LED
current.

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

1. Open the panel monitor. It prints `panel ready`, then `selftest: …`.
2. Watch the sequence, about a second each:
   - solid **red**, **green**, **blue**, **white**;
   - a grey border with four corner pixels: **red** top-left, **green** top-right, **blue**
     bottom-left, **white** bottom-right;
   - a ramp along row 1 fading red → black left to right, and one down column 1 fading green →
     black top to bottom;
   - then the dim breathing colour and `selftest done - breathing` in the monitor.
3. Read the failure here, while only the panel is in the loop:

   | You see | Look at |
   |---|---|
   | nothing at all | 5 V on the panel terminals, common ground, OE wiring; `panel init failed` in the monitor would have stopped it earlier |
   | one colour missing or wrong | that colour pair (R1/R2, G1/G2, B1/B2) or the ribbon orientation |
   | corners in the wrong place, image mirrored or rotated | ribbon orientation; panel scan / mapping |
   | shifted, doubled, or torn image | ribbon seating, scan rate / mapping, level shifter |
   | flicker on bright frames | common ground, thin power wires, missing 74HCT245, brightness cap too high |

4. While the solid white is up, measure the current with the meter in series with the 5 V supply.
   That white is at `MAX_BRIGHTNESS` (96, not 255), so it is the number that matters. Lower
   `MAX_BRIGHTNESS` in `panel/src/main.cpp` until you have margin on the 4 A supply.

### Step 2 — panel + Stick (UART)

1. Open the panel monitor and the Stick monitor.
2. Speak or clap: the level rises and the panel brightens. Tilt the Stick: the hue changes. The
   Stick display shows `L` and `H`.
3. If the link is silent: swap TX/RX, check the common ground, and confirm both `Serial2` pin
   pairs. Print the raw received line on the panel monitor.

## Known issues

- **Wrong colours or a shifted image:** ribbon orientation, a swapped colour pair, or the wrong
  panel scan. Run the library example before blaming the sketch.
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
