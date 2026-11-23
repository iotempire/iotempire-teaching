// Module 6 reference: 32x32 HUB75 panel on a classic ESP32 Dev Module.
// Link from the M5StickC-S3: Serial2, GPIO32 (RX) / GPIO33 (TX), 115200.
// Protocol: "L <0..100>\n" and "H <0..255>\n".
//
// The panel breathes on its own; the incoming level scales it and the hue colours it.
// Cap the brightness after measuring the panel current on the 5 V 4 A supply.

#include <Arduino.h>
#include <ESP32-HUB75-MatrixPanel-I2S-DMA.h>
#include <Adafruit_GFX.h>

#define PANEL_RES_X 32
#define PANEL_RES_Y 32
#define PANEL_CHAIN 1

// Classic ESP32 HUB75 default pins. Change only together with the wiring.
#define R1_PIN 25
#define G1_PIN 26
#define B1_PIN 27
#define R2_PIN 14
#define G2_PIN 12
#define B2_PIN 13
#define A_PIN 23
#define B_PIN 19
#define C_PIN 5
#define D_PIN 17
#define E_PIN -1
#define LAT_PIN 4
#define OE_PIN 15
#define CLK_PIN 16

#define LINK_RX 32
#define LINK_TX 33

// Start low. Raise only after the power table shows margin on the 4 A supply.
const uint8_t MAX_BRIGHTNESS = 96;

// Boot self-test: proves the wiring, the colour pairs, the orientation and the axis
// mapping before any UART traffic exists. Set to 0 on a known-good panel.
#define SELFTEST_ON_BOOT 1

HUB75_I2S_CFG::i2s_pins pins = {
    R1_PIN, G1_PIN, B1_PIN,
    R2_PIN, G2_PIN, B2_PIN,
    A_PIN, B_PIN, C_PIN, D_PIN, E_PIN,
    LAT_PIN, OE_PIN, CLK_PIN
};
HUB75_I2S_CFG mxconfig(PANEL_RES_X, PANEL_RES_Y, PANEL_CHAIN, pins);
MatrixPanel_I2S_DMA display(mxconfig);

uint8_t level = 40;  // 0..100
uint8_t hue = 0;     // 0..255
char line[32];
size_t line_len = 0;

void hsv2rgb(uint8_t h, uint8_t s, uint8_t v, uint8_t &r, uint8_t &g, uint8_t &b) {
  uint8_t region = h / 43;
  uint8_t remainder = (h - region * 43) * 6;
  uint8_t p = (v * (255 - s)) >> 8;
  uint8_t q = (v * (255 - ((s * remainder) >> 8))) >> 8;
  uint8_t t = (v * (255 - ((s * (255 - remainder)) >> 8))) >> 8;
  switch (region) {
    case 0: r = v; g = t; b = p; break;
    case 1: r = q; g = v; b = p; break;
    case 2: r = p; g = v; b = t; break;
    case 3: r = p; g = q; b = v; break;
    case 4: r = t; g = p; b = v; break;
    default: r = v; g = p; b = q; break;
  }
}

void handleLine(char *text) {
  while (*text == ' ') text++;
  if (*text == 'L' || *text == 'l') {
    level = (uint8_t)constrain(atoi(text + 1), 0, 100);
  } else if (*text == 'H' || *text == 'h') {
    hue = (uint8_t)constrain(atoi(text + 1), 0, 255);
  } else {
    return;
  }
  Serial.printf("L=%u H=%u\n", level, hue);
}

// Boot self-test: four solid colours, then a frame whose corners and axes show whether
// the ribbon, the colour pairs and the scan mapping are right. White is held long enough
// to read the current meter on the 5 V supply.
#if SELFTEST_ON_BOOT
static void solid(uint16_t colour, uint16_t ms) {
  display.fillScreen(colour);
  delay(ms);
}

static void selftest() {
  Serial.println("selftest: red green blue white (hold white for the current meter), then corners");
  solid(display.color565(255, 0, 0), 900);
  solid(display.color565(0, 255, 0), 900);
  solid(display.color565(0, 0, 255), 900);
  solid(display.color565(255, 255, 255), 2500);
  display.fillScreen(display.color565(0, 0, 0));

  display.drawRect(0, 0, PANEL_RES_X, PANEL_RES_Y, display.color565(64, 64, 64));
  display.drawPixel(0, 0, display.color565(255, 0, 0));                  // top-left     red
  display.drawPixel(PANEL_RES_X - 1, 0, display.color565(0, 255, 0));    // top-right    green
  display.drawPixel(0, PANEL_RES_Y - 1, display.color565(0, 0, 255));    // bottom-left  blue
  display.drawPixel(PANEL_RES_X - 1, PANEL_RES_Y - 1,                      // bottom-right white
                    display.color565(255, 255, 255));
  // Axis ramps: row 1 fades red -> black left to right, column 1 green -> black top to bottom.
  for (int i = 0; i < PANEL_RES_X; i++) display.drawPixel(i, 1, display.color565(i * 8, 0, 0));
  for (int i = 0; i < PANEL_RES_Y; i++) display.drawPixel(1, i, display.color565(0, i * 8, 0));
  delay(2500);
}
#endif

void setup() {
  Serial.begin(115200);
  Serial2.begin(115200, SERIAL_8N1, LINK_RX, LINK_TX);

  if (!display.begin()) {
    Serial.println("panel init failed");
    while (true) delay(1000);
  }
  display.setBrightness8(MAX_BRIGHTNESS);
  display.fillScreen(display.color565(0, 0, 0));
  Serial.println("panel ready");

#if SELFTEST_ON_BOOT
  selftest();
  Serial.println("selftest done - breathing");
#endif
}

void loop() {
  // Non-blocking line parser.
  while (Serial2.available()) {
    char c = Serial2.read();
    if (c == '\n' || c == '\r') {
      if (line_len > 0) {
        line[line_len] = '\0';
        handleLine(line);
        line_len = 0;
      }
    } else if (line_len < sizeof(line) - 1) {
      line[line_len++] = c;
    }
  }

  // Slow breathing: a cosine on top of the incoming level.
  static uint32_t last = 0;
  static float phase = 0.0f;
  uint32_t now = millis();
  if (now - last >= 20) {
    last = now;
    phase += 0.02f;
    if (phase > 2.0f * PI) phase -= 2.0f * PI;

    float breath = 0.55f + 0.45f * (0.5f + 0.5f * cosf(phase));
    float base = level / 100.0f;
    uint8_t brightness = (uint8_t)(255.0f * breath * base);
    if (brightness > MAX_BRIGHTNESS) brightness = MAX_BRIGHTNESS;
    display.setBrightness8(brightness);

    uint8_t r, g, b;
    hsv2rgb(hue, 255, 255, r, g, b);
    display.fillScreen(display.color565(r, g, b));
  }
}
