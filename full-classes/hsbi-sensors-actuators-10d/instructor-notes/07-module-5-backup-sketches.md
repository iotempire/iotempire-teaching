# Module 5 — Backup Sketches (Instructor)

> **Instructor backup.** Use these only if the AI agents or the editor tooling are unavailable during the session, and as the answer key when a pod asks “what should the agent have produced?”. They are **not** part of the student path — [Module 5](../modules/05-leds-and-light-output.md) sends students to the two stage prompts instead.

[Module 5](../modules/05-leds-and-light-output.md) · [Module 5 studio](./05-module-5-studio.md) · [All instructor notes](./README.md)

Both sketches assume the MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`) and `monitor_speed = 115200`. Uncomment `#include <Arduino.h>` for PlatformIO; the Arduino IDE includes it automatically.

## Stage 2 — discrete RGB LED

Common-cathode by default; set `COMMON_ANODE` to `true` if your part is common anode. The serial parser accepts `255 0 0`, `255,0,0`, and rejects trailing junk. Wiring: R=GPIO16, G=GPIO17, B=GPIO18, 220 Ω per channel, common to GND (or 3.3 V for common anode).

```cpp
// Stage 2 — discrete RGB LED, common cathode by default.
// PlatformIO: uncomment the next line. Arduino IDE includes it automatically.
// #include <Arduino.h>

#define COMMON_ANODE false

const int R_PIN = 16;
const int G_PIN = 17;
const int B_PIN = 18;

int clamp8(int v) { return v < 0 ? 0 : (v > 255 ? 255 : v); }

void apply(int r, int g, int b) {
  r = clamp8(r); g = clamp8(g); b = clamp8(b);
  int lr = r, lg = g, lb = b;              // echo the logical values
  if (COMMON_ANODE) { r = 255 - r; g = 255 - g; b = 255 - b; }
  analogWrite(R_PIN, r);
  analogWrite(G_PIN, g);
  analogWrite(B_PIN, b);
  Serial.printf("RGB(%d,%d,%d)\n", lr, lg, lb);
}

void setup() {
  Serial.begin(115200);
  Serial.println("RGB: <r> <g> <b> (0-255), space or comma separated");
}

void loop() {
  if (!Serial.available()) return;
  String line = Serial.readStringUntil('\n');
  line.trim();

  int r, g, b; char extra;
  int n = sscanf(line.c_str(), "%d,%d,%d%c", &r, &g, &b, &extra);
  if (n != 3) n = sscanf(line.c_str(), "%d %d %d%c", &r, &g, &b, &extra);

  if (n == 3) apply(r, g, b);
  else Serial.println("? RGB: <r> <g> <b> (0-255)");
}
```

## Stage 3 — 8× WS2812B strip

8 LEDs on GPIO 16, `SetLuminance(80)`, `index R G B` and `clear`. The color order is GRB; change the feature if your strip differs. Wiring: 5 V and GND from the MiniKit USB rail, DIN to GPIO 16, common ground. Stage 3 reuses GPIO 16 — unplug the Stage 2 red channel first.

```cpp
// PlatformIO: uncomment the next line. Arduino IDE includes it automatically.
// #include <Arduino.h>
#include <NeoPixelBus.h>

const uint16_t LED_COUNT = 8;
const uint16_t DATA_PIN = 16;

NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s1Ws2812xMethod> strip(LED_COUNT, DATA_PIN);
// One working method for the MiniKit. If it does not build on your core version,
// pick another ESP32 I2S/RMT method: https://github.com/Makuna/NeoPixelBus/wiki/ESP32-NeoMethods

int clamp8(int v) { return v < 0 ? 0 : (v > 255 ? 255 : v); }

void setup() {
  Serial.begin(115200);
  strip.Begin();
  strip.SetLuminance(80);          // power guardrail, not full white
  strip.ClearTo(RgbColor(0));
  strip.Show();
  Serial.println("pixel: <index 0-7> <r> <g> <b> | clear");
}

void loop() {
  if (!Serial.available()) return;
  String line = Serial.readStringUntil('\n');
  line.trim();

  if (line == "clear") {
    strip.ClearTo(RgbColor(0));
    strip.Show();
    Serial.println("cleared");
    return;
  }

  int i, r, g, b; char extra;
  if (sscanf(line.c_str(), "%d %d %d %d%c", &i, &r, &g, &b, &extra) == 4
      && i >= 0 && i < LED_COUNT) {
    r = clamp8(r); g = clamp8(g); b = clamp8(b);
    strip.SetPixelColor(i, RgbColor(r, g, b));
    strip.Show();
    Serial.printf("pixel %d = RGB(%d,%d,%d)\n", i, r, g, b);
  } else {
    Serial.println("? pixel: <index 0-7> <r> <g> <b> | clear");
  }
}
```

## If you have to teach this without AI

The manual route is [Appendix B](../modules/05-leds-and-light-output.md#appendix-b) in the module. The short version: install `pio` via `uv`, `pio project init --board mhetesp32minikit`, write `platformio.ini` and `src/main.cpp` from these sketches, `pio run -t upload`, `pio device monitor`. The background, the resistor arithmetic, and the failure-mode table are in [Appendix A](../modules/05-leds-and-light-output.md#appendix-a).
