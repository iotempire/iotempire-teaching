// Module 6 reference: 32x32 HUB75 panel on a classic ESP32 Dev Module.
// Link from the M5StickC-S3: Serial2, GPIO32 (RX) / GPIO33 (TX), 115200.
// Protocol: "L <0..100>\n" and "H <0..255>\n".
//
// The panel breathes on its own; the incoming level scales it and the hue colours it.
// Cap the brightness after measuring the panel current on the 5 V 4 A supply.

#include <Arduino.h>
#include <ESP32-HUB75-MatrixPanel-I2S-DMA.h>
#include <Adafruit_GFX.h>
#include <esp_system.h>

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

// Runtime state that the diagnostics report. `bright_cap` starts at MAX_BRIGHTNESS
// and can be changed from the serial console with '+' / '-' while debugging.
bool panel_ok = false;
uint8_t bright_cap = MAX_BRIGHTNESS;
uint8_t applied_brightness = 0;
uint32_t frames = 0;

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

// Beacon step: white at one brightness, announced on serial so a dark panel can be
// told apart from a panel that is merely too dim to see.
static void beacon(uint8_t b) {
  Serial.printf("selftest: white at brightness %u\n", b);
  display.setBrightness8(b);
  display.fillScreen(display.color565(255, 255, 255));
  delay(600);
}

// Corner and axis frame: four 6x6 corner blocks — red top-left, green top-right, blue
// bottom-left, white bottom-right — plus a red ramp along the middle row (black at the
// left, bright at the right) and a green ramp down the middle column (black at the top,
// bright at the bottom). This is the only frame that proves the address lines A-D are in
// the right order, because a solid fill looks identical with the rows permuted. Blocks and
// mid-panel ramps instead of single pixels: one-pixel markers are unreadable at arm's
// length, and a lone red pixel next to a lone green one just looks yellow. Also reachable
// from the console with 'c'.
static void corner_frame(uint16_t ms) {
  const int B = 6;  // corner block edge in pixels
  const int mid = PANEL_RES_Y / 2;

  display.fillScreen(display.color565(0, 0, 0));
  display.drawRect(0, 0, PANEL_RES_X, PANEL_RES_Y, display.color565(48, 48, 48));
  display.fillRect(0, 0, B, B, display.color565(255, 0, 0));                                 // top-left red
  display.fillRect(PANEL_RES_X - B, 0, B, B, display.color565(0, 255, 0));                   // top-right green
  display.fillRect(0, PANEL_RES_Y - B, B, B, display.color565(0, 0, 255));                   // bottom-left blue
  display.fillRect(PANEL_RES_X - B, PANEL_RES_Y - B, B, B, display.color565(255, 255, 255)); // bottom-right white
  for (int i = 0; i < PANEL_RES_X; i++) display.drawPixel(i, mid, display.color565(i * 8, 0, 0));
  for (int i = 0; i < PANEL_RES_Y; i++) display.drawPixel(mid, i, display.color565(0, i * 8, 0));
  delay(ms);
}

static void selftest() {
  static const uint8_t steps[] = {16, 48, 96, 160, 255};
  Serial.println("selftest: brightness beacon - note the step at which the panel lights up");
  for (uint8_t s : steps) beacon(s);

  Serial.printf("selftest: red green blue, then white held for the current meter (cap %u)\n",
                bright_cap);
  display.setBrightness8(bright_cap);
  solid(display.color565(255, 0, 0), 900);
  solid(display.color565(0, 255, 0), 900);
  solid(display.color565(0, 0, 255), 900);
  solid(display.color565(255, 255, 255), 2500);
  display.fillScreen(display.color565(0, 0, 0));
  corner_frame(2500);
}
#endif

// Why the board restarted. "brownout" means the 5 V supply or the wiring sagged;
// "external pin" or silence at boot means GPIO 0 was held low (download mode).
static const char *reset_reason_name(esp_reset_reason_t r) {
  switch (r) {
    case ESP_RST_POWERON:   return "power-on";
    case ESP_RST_EXT:       return "external pin (reset/BOOT held)";
    case ESP_RST_SW:        return "software";
    case ESP_RST_PANIC:     return "panic";
    case ESP_RST_INT_WDT:   return "interrupt watchdog";
    case ESP_RST_TASK_WDT:  return "task watchdog";
    case ESP_RST_WDT:       return "other watchdog";
    case ESP_RST_DEEPSLEEP: return "deep sleep";
    case ESP_RST_BROWNOUT:  return "brownout - check the 5 V supply and grounds";
    case ESP_RST_SDIO:      return "sdio";
    default:                return "unknown";
  }
}

// Printed at boot and on demand with '?'. A monitor attached after boot misses the
// boot lines, so the banner can be re-requested instead of forcing a reset.
static void print_banner() {
  Serial.println();
  Serial.println("=== module6 panel controller ===");
  Serial.printf("build      : %s %s\n", __DATE__, __TIME__);
  Serial.printf("panel      : %dx%d, chain %d, brightness cap %u\n",
                PANEL_RES_X, PANEL_RES_Y, PANEL_CHAIN, bright_cap);
  Serial.printf("hub75 pins : R1=%d G1=%d B1=%d R2=%d G2=%d B2=%d A=%d B=%d C=%d D=%d E=%d LAT=%d OE=%d CLK=%d\n",
                R1_PIN, G1_PIN, B1_PIN, R2_PIN, G2_PIN, B2_PIN,
                A_PIN, B_PIN, C_PIN, D_PIN, E_PIN, LAT_PIN, OE_PIN, CLK_PIN);
  Serial.printf("uart link  : Serial2 RX=%d TX=%d, 115200 8N1\n", LINK_RX, LINK_TX);
  Serial.printf("boot       : reset reason %u (%s)\n",
                (unsigned)esp_reset_reason(), reset_reason_name(esp_reset_reason()));
  Serial.println("console    : ? banner+diag, t self-test, c corners, +/- brightness, r reboot");
}

static void print_diag() {
  Serial.printf("diag       : uptime=%lus frames=%lu panel=%s bright=%u/%u heap=%u min=%u\n",
                (unsigned long)(millis() / 1000), (unsigned long)frames,
                panel_ok ? "ok" : "FAILED", applied_brightness, bright_cap,
                (unsigned)ESP.getFreeHeap(), (unsigned)ESP.getMinFreeHeap());
}

void setup() {
  Serial.begin(115200);
  delay(200);  // give a freshly opened monitor time to attach
  Serial.println();
  Serial.printf("boot: reset reason %u (%s)\n",
                (unsigned)esp_reset_reason(), reset_reason_name(esp_reset_reason()));
  Serial.println("boot: 'waiting for download' instead of this line means GPIO0 was low at reset");
  Serial.flush();

  Serial2.begin(115200, SERIAL_8N1, LINK_RX, LINK_TX);

  print_banner();

  panel_ok = display.begin();
  if (!panel_ok) {
    Serial.println("panel init FAILED - the panel stays dark; serial diagnostics keep running");
    Serial.println("  * OE is GPIO15 (header label 'TDO'): a missing OE wire leaves the panel blank");
    Serial.println("  * G2 is GPIO12 (strapping): must be low at boot, unplug the ribbon to flash");
    Serial.println("  * ribbon GND (pins 3, 7, 16) and the 5 V supply GND must be one net");
    Serial.println("  * measure 5 V at the panel terminals, not at the ESP32");
    Serial.println("  * 't' retries the test, '+' raises the brightness cap");
  } else {
    Serial.println("panel ready");
    display.setBrightness8(0);
    display.fillScreen(display.color565(0, 0, 0));
  }

#if SELFTEST_ON_BOOT
  if (panel_ok) {
    selftest();
    Serial.println("selftest done - breathing");
  }
#endif
  print_diag();
  Serial.flush();
}

void loop() {
  // Console on the USB side. Commands let a late-attached monitor pull the boot
  // banner back and re-run the self-test without touching the board.
  while (Serial.available()) {
    int c = Serial.read();
    if (c == '?' || c == 'i') {
      print_banner();
      print_diag();
    } else if (c == 't') {
#if SELFTEST_ON_BOOT
      if (panel_ok) {
        selftest();
        Serial.println("selftest done - breathing");
      } else {
        Serial.println("panel not initialised - nothing to test");
      }
#else
      Serial.println("self-test compiled out (SELFTEST_ON_BOOT 0)");
#endif
    } else if (c == 'c') {
#if SELFTEST_ON_BOOT
      if (panel_ok) {
        Serial.println("corner frame 6 s: red TL, green TR, blue BL, white BR; red ramp points right, green ramp points down");
        display.setBrightness8(bright_cap);
        corner_frame(6000);
        display.fillScreen(display.color565(0, 0, 0));
      } else {
        Serial.println("panel not initialised - nothing to show");
      }
#else
      Serial.println("corner frame compiled out (SELFTEST_ON_BOOT 0)");
#endif
    } else if (c == '+' || c == '-') {
      int v = (int)bright_cap + ((c == '+') ? 32 : -32);
      if (v < 8) v = 8;
      if (v > 255) v = 255;
      bright_cap = (uint8_t)v;
      Serial.printf("brightness cap = %u\n", bright_cap);
    } else if (c == 'r') {
      Serial.println("rebooting");
      Serial.flush();
      ESP.restart();
    }
  }

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

  // Keep-alive: one line every two seconds while the sketch is running.
  // Silence means the board is not running this sketch at all (download mode,
  // wrong port) or it is stuck before the first pass through loop().
  static uint32_t last_beat = 0;
  if (now - last_beat >= 2000) {
    last_beat = now;
    Serial.printf("alive %lus  L=%u H=%u  bright=%u/%u  frames=%lu  heap=%u\n",
                  (unsigned long)(now / 1000), level, hue,
                  applied_brightness, bright_cap, (unsigned long)frames,
                  (unsigned)ESP.getFreeHeap());
  }

  if (panel_ok && now - last >= 20) {
    last = now;
    phase += 0.02f;
    if (phase > 2.0f * PI) phase -= 2.0f * PI;

    float breath = 0.55f + 0.45f * (0.5f + 0.5f * cosf(phase));
    float base = level / 100.0f;
    uint8_t brightness = (uint8_t)(255.0f * breath * base);
    if (brightness > bright_cap) brightness = bright_cap;
    applied_brightness = brightness;
    display.setBrightness8(brightness);

    uint8_t r, g, b;
    hsv2rgb(hue, 255, 255, r, g, b);
    display.fillScreen(display.color565(r, g, b));
    frames++;
  }
}
