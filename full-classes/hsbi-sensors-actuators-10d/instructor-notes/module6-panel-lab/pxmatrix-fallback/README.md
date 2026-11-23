# Plan B — 32×32 panel on an ESP8266 (Wemos D1 mini)

> Fallback for a pod that only has ESP8266 boards, or a control experiment for an ESP32 build
> that stays dark. Flash this before you conclude that the panel or the ribbon is broken.
> Architecture decision and its trade-off: [D24](../../00-architecture-decisions.md#d24).

Same panel, same 5 V supply, different controller. The self-test, the brightness beacon and the
serial console behave exactly like [`../panel`](../panel/src/main.cpp), so the two builds are
compared the same way.

## Why earlier years worked with the ESP8266 — the trick

A HUB75 panel has **six** colour inputs (R1, G1, B1, R2, G2, B2) that are six separate shift
registers. An ESP8266 has **one** SPI data line. What people actually did was not clever pin
squeezing, it was **chaining the six registers into one** with five jumpers between the panel's
input (`PI`) and output (`PO`) header:

| `PI` | `PO` |
|---|---|
| `R2` | `R1` |
| `G1` | `R2` |
| `G2` | `G1` |
| `B1` | `G2` |
| `B2` | `B1` |

Now one SPI data line feeds the whole chain and the image still arrives correctly, because the
library knows the order. That is the whole hack, and it is why a D1 mini could drive a panel that
"needs six data lines". (If the input connector is labelled `R0` instead of `R1`, chain
`R1→R0, G0→R1, G1→G0, B0→G1, B1→B0` and drive `R0`.)

The catch: the frame is now 3× longer on the wire, so the ESP8266 is CPU-bound — no DMA, lower
refresh, lower colour depth. That is the trade recorded in D24, and it is why the class build uses
the ESP32.

## Wiring

Use the **signal names printed on the panel connector**, not pin numbers — the pin order differs
between cables and panel revisions.

| Panel signal | D1 mini | GPIO |
|---|---|---|
| `A` | D1 | 5 |
| `B` | D2 | 4 |
| `C` | D8 | 15 |
| `D` | D6 | 12 |
| `CLK` | D5 | 14 |
| `LAT` / `STB` | D0 | 16 |
| `OE` | D4 | 2 |
| `R1` (or `R0`) | D7 | 13 |
| `GND` | GND | — |
| 5 V | panel supply **+5 V**, never the board | — |

Not connected: `R2`, `G2`, `B2` (chained through the jumpers above), and `E` (a 16-pin 1/16-scan
panel has none). `D3` (GPIO 0) stays free — do not wire the panel's `E` there even if it exists.

Two boot-strap notes, the ESP8266 version of the ESP32's GPIO-12 trap:

- `D8` (GPIO 15) carries `C` and **must be LOW at boot**. If the board will not start with the
  ribbon attached, unplug it to flash, or check whether the panel pulls that input up.
- `D3` (GPIO 0) is what the USB bridge pulls low to enter the bootloader. Leave it unwired.

## Build and flash

```sh
cd pxmatrix-fallback
pio run -t upload                    # add --upload-port /dev/ttyUSB0 if autodetect fails
pio device monitor                   # 115200
```

Reset first, then attach the monitor — the same CH340 DTR behaviour that puts the ESP32 into
download mode applies here.

## Reading the result

The boot output and the console are the same as the ESP32 build: banner, brightness beacon
(16 / 48 / 96 / 160 / 255), red-green-blue-white, corner and ramp frame, then breathing, with an
`alive …` line every two seconds and `?` / `t` / `c` / `+` / `-` / `r` on the console (`c` re-shows
just the corner frame).

What it tells you:

| This build | The ESP32 build | Conclusion |
|---|---|---|
| lights up | stays black | the panel, ribbon and supply are fine; the fault is in the ESP32 harness (`OE` on GPIO 15, `CLK` on GPIO 16, the common ground) |
| stays black | stays black | panel or supply; measure 5 V at the panel terminals and check the ribbon seating |
| lights up | lights up | wiring is fine in both; differences are panel configuration, not hardware |

## Panel variants

If the picture arrives in shifted blocks, call `display.setScanPattern(ZIGZAG)` after
`display.begin()`. If only part of the image appears, add `display.setMuxDelay(1, 1, 1, 1, 1)`.
If red and blue are swapped, `display.setColorOrder(RRBBGG)` (and the other orders). All three are
one line in `src/main.cpp`, next to `display.begin(PANEL_SCAN)`.

## Limits of this build

- **No Stick link.** The D1 mini's only UART is the USB console, so the `L`/`H` protocol is not
  implemented; `level` and `hue` are fixed in the source. Use ESP-NOW, or stay on the ESP32 build,
  for the microphone and IMU path.
- **Pinned libraries.** `PxMatrix LED MATRIX library@1.8.2` is the last registry release; the Git
  master has moved towards ESP32-only driver work. If a later panel needs the newer driver, change
  `lib_deps` deliberately.
- **160 MHz** in `platformio.ini` because the refresh is CPU-bound; 80 MHz works but flickers.

## Sources

- [PxMatrix](https://github.com/2dom/PxMatrix) — the cabling tables in the library README are the
  authority for the jumpers and the pin default.
- [Brian Lough's ESP8266 matrix tutorial](http://www.instructables.com/id/RGB-LED-Matrix-With-an-ESP8266/)
  — the wiring walk-through the earlier cohorts used.
