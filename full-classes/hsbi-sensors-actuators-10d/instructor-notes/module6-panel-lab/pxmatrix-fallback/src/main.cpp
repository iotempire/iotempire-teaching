// Module 6 plan B: 32x32 HUB75 panel on an ESP8266 (Wemos D1 mini) through PxMatrix.
//
// Same behaviour as ../panel: brightness beacon, wiring self-test, breathing, and the
// same serial console, so the two builds are compared the same way. The language on the
// UART link to the Stick is unchanged ("L <0..100>" / "H <0..255>").
//
// PxMatrix clocks the panel through the hardware SPI data line only, so the panel's six
// colour inputs are chained into one shift register with five jumpers - see README.md.

#include <Arduino.h>
#include <PxMatrix.h>

#define PANEL_RES_X 32
#define PANEL_RES_Y 32
#define PANEL_SCAN 16  // 1/16 scan: address lines A-D, no E

// Wemos D1 mini labels -> GPIO numbers. PxMatrix wants the numbers.
#define P_LAT 16  // D0
#define P_OE 2    // D4
#define P_A 5     // D1
#define P_B 4     // D2
#define P_C 15    // D8  (ESP8266 boot strap: must be LOW at boot)
#define P_D 12    // D6

// Start low and raise only after the current check on the 5 V supply. 0..255 here,
// because PxMatrix uses the full byte range for its own brightness scaling.
#define MAX_BRIGHTNESS 96

#define SELFTEST_ON_BOOT 1

PxMATRIX display(PANEL_RES_X, PANEL_RES_Y, P_LAT, P_OE, P_A, P_B, P_C, P_D);

// Fixed for this build: the D1 mini has one UART and the console owns it, so the
// Stick link lives in the ESP32 build. Change these to try a colour manually.
uint8_t level = 40;  // 0..100
uint8_t hue = 0;     // 0..255

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

// Hold one colour for a while. PxMatrix only pushes pixels when display() is called,
// so every pause in this sketch is a refresh loop, never a delay().
static void show(uint16_t colour, uint16_t ms) {
  display.fillScreen(colour);
  uint32_t end = millis() + ms;
  while ((int32_t)(millis() - end) < 0) display.display(10);
}

#if SELFTEST_ON_BOOT
// Corner and axis frame: four 6x6 corner blocks (red TL, green TR, blue BL, white BR),
// a red ramp along the middle row and a green ramp down the middle column. The only frame
// that proves the address lines A-D are in the right order. Blocks and mid-panel ramps
// instead of single pixels, because one-pixel markers are unreadable at arm's length.
// Also reachable with 'c'.
static void corner_frame(uint16_t ms) {
  const int B = 6;
  const int mid = PANEL_RES_Y / 2;

  display.fillScreen(0);
  display.drawRect(0, 0, PANEL_RES_X, PANEL_RES_Y, display.color565(48, 48, 48));
  display.fillRect(0, 0, B, B, display.color565(255, 0, 0));
  display.fillRect(PANEL_RES_X - B, 0, B, B, display.color565(0, 255, 0));
  display.fillRect(0, PANEL_RES_Y - B, B, B, display.color565(0, 0, 255));
  display.fillRect(PANEL_RES_X - B, PANEL_RES_Y - B, B, B, display.color565(255, 255, 255));
  for (int i = 0; i < PANEL_RES_X; i++) display.drawPixel(i, mid, display.color565(i * 8, 0, 0));
  for (int i = 0; i < PANEL_RES_Y; i++) display.drawPixel(mid, i, display.color565(0, i * 8, 0));
  uint32_t end = millis() + ms;
  while ((int32_t)(millis() - end) < 0) display.display(10);
}

static void selftest() {
  static const uint8_t steps[] = {16, 48, 96, 160, 255};
  Serial.println("selftest: brightness beacon - note the step at which the panel lights up");
  for (uint8_t s : steps) {
    Serial.printf("selftest: white at brightness %u\n", s);
    display.setBrightness(s);
    show(display.color565(255, 255, 255), 700);
  }

  Serial.printf("selftest: red green blue, then white held for the current meter (cap %u)\n",
                bright_cap);
  display.setBrightness(bright_cap);
  show(display.color565(255, 0, 0), 900);
  show(display.color565(0, 255, 0), 900);
  show(display.color565(0, 0, 255), 900);
  show(display.color565(255, 255, 255), 2500);

  // Corner and axis frame: red top-left, green top-right, blue bottom-left, white
  // bottom-right, plus a ramp along row 1 and down column 1.
  corner_frame(2500);

  display.fillScreen(0);
  display.display(10);
}
#endif

static void print_banner() {
  Serial.println();
  Serial.println("=== module6 panel controller (PxMatrix fallback) ===");
  Serial.printf("build      : %s %s\n", __DATE__, __TIME__);
  Serial.printf("panel      : %dx%d, %d/%d scan, brightness cap %u\n",
                PANEL_RES_X, PANEL_RES_Y, 1, PANEL_SCAN, bright_cap);
  Serial.printf("pins       : LAT=%d OE=%d A=%d B=%d C=%d D=%d (CLK=14, DATA=13 fixed by SPI)\n",
                P_LAT, P_OE, P_A, P_B, P_C, P_D);
  Serial.printf("cpu        : %u MHz, heap %u\n",
                (unsigned)ESP.getCpuFreqMHz(), (unsigned)ESP.getFreeHeap());
  Serial.println("console    : ? banner+diag, t self-test, c corners, +/- brightness, r reboot");
}

static void print_diag() {
  Serial.printf("diag       : uptime=%lus frames=%lu bright=%u/%u heap=%u\n",
                (unsigned long)(millis() / 1000), (unsigned long)frames,
                applied_brightness, bright_cap, (unsigned)ESP.getFreeHeap());
}

void setup() {
  Serial.begin(115200);
  delay(200);
  Serial.println();
  Serial.println("boot: PxMatrix fallback; silence here means the board is in the ROM bootloader");
  print_banner();

  display.begin(PANEL_SCAN);
  display.clearDisplay();
  display.setBrightness(0);

  // Not all 32x32 panels are linear; if the image arrives in shifted blocks, try
  // display.setScanPattern(ZIGZAG). If the rows are partial, add setMuxDelay(1,1,1,1,1).

#if SELFTEST_ON_BOOT
  selftest();
  Serial.println("selftest done - breathing");
#endif
  print_diag();
}

void loop() {
  // Console on the serial side: a late-attached monitor can pull the banner back.
  while (Serial.available()) {
    int c = Serial.read();
    if (c == '?' || c == 'i') {
      print_banner();
      print_diag();
    } else if (c == 't') {
#if SELFTEST_ON_BOOT
      selftest();
      Serial.println("selftest done - breathing");
#else
      Serial.println("self-test compiled out (SELFTEST_ON_BOOT 0)");
#endif
    } else if (c == 'c') {
#if SELFTEST_ON_BOOT
      Serial.println("corner frame 6 s: red TL, green TR, blue BL, white BR; red ramp points right, green ramp points down");
      display.setBrightness(bright_cap);
      corner_frame(6000);
      display.fillScreen(0);
      display.display(10);
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

  // The Stick link is not implemented here: the D1 mini's only UART is the USB
  // console. This build answers the question "is the panel and harness good?" and
  // nothing else - see README.md.

  uint32_t now = millis();
  static uint32_t last_refresh = 0;
  static uint32_t last_draw = 0;
  static uint32_t last_beat = 0;
  static float phase = 0.0f;

  // PxMatrix has no DMA: the refresh is this call. Keep it tight.
  if (now - last_refresh >= 2) {
    last_refresh = now;
    display.display(10);
  }

  if (now - last_beat >= 2000) {
    last_beat = now;
    Serial.printf("alive %lus  L=%u H=%u  bright=%u/%u  frames=%lu  heap=%u\n",
                  (unsigned long)(now / 1000), level, hue, applied_brightness, bright_cap,
                  (unsigned long)frames, (unsigned)ESP.getFreeHeap());
  }

  if (now - last_draw >= 40) {
    last_draw = now;
    phase += 0.02f;
    if (phase > 2.0f * PI) phase -= 2.0f * PI;

    float breath = 0.55f + 0.45f * (0.5f + 0.5f * cosf(phase));
    float base = level / 100.0f;
    uint8_t brightness = (uint8_t)(255.0f * breath * base);
    if (brightness > bright_cap) brightness = bright_cap;
    applied_brightness = brightness;
    display.setBrightness(brightness);

    uint8_t r, g, b;
    hsv2rgb(hue, 255, 255, r, g, b);
    display.fillScreen(display.color565(r, g, b));
    frames++;
  }
}
