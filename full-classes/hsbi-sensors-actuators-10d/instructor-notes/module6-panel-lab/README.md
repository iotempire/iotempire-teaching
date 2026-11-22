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

Same protocol, no wire. Put both boards in station mode on the same Wi-Fi channel, read the
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

The StickS3 is not an official PlatformIO board. `stick/platformio.ini` uses
`board = esp32-s3-devkitc-1`, 8 MB partitions, `qio_opi`, USB CDC, and M5Unified, which is the
recipe from the [M5 docs](https://docs.m5stack.com/en/core/StickS3).

## Test

1. Open the panel monitor. It prints `panel ready`; the panel shows a dim breathing colour.
2. Open the Stick monitor. Speak or clap: the level rises, the panel brightens. Tilt the Stick: the
   hue changes. The Stick display shows `L` and `H`.
3. Cover the panel at 100 % white and measure the current with the meter in series with the 5 V
   supply. Lower `MAX_BRIGHTNESS` in `panel/src/main.cpp` until you have margin on the 4 A supply.
4. If the link is silent: swap TX/RX, check the common ground, and confirm both `Serial2` pin
   pairs. Print the raw received line on the panel monitor.

## Known issues

- **Wrong colours or a shifted image:** ribbon orientation, a swapped colour pair, or the wrong
  panel scan. Run the library example before blaming the sketch.
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
