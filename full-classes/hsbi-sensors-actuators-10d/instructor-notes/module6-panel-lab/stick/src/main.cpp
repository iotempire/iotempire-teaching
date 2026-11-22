// Module 6 reference: M5StickC-S3 reads the microphone and IMU and sends
// "L <0..100>" and "H <0..255>" to the panel controller over Serial2.
//
// Link (HAT2 header): G1 (TX) -> panel GPIO32 (RX); G2 (RX) <- panel GPIO33 (TX); GND.
// The ES8311 codec is half-duplex; do not use the speaker while recording.

#include <M5Unified.h>
#include <math.h>

#define LINK_RX 2  // HAT2 G2
#define LINK_TX 1  // HAT2 G1

int16_t micBuf[256];
uint8_t level = 0;
uint8_t hue = 0;
uint32_t lastSend = 0;

void setup() {
  auto cfg = M5.config();
  M5.begin(cfg);

  M5.Display.setTextSize(2);
  M5.Display.fillScreen(0x0000);
  M5.Display.setCursor(0, 0);
  M5.Display.println("panel link");

  if (!M5.Mic.begin()) {
    M5.Display.println("mic failed");
  }
  M5.Mic.setSampleRate(8000);

  M5.Imu.begin();
  Serial2.begin(115200, SERIAL_8N1, LINK_RX, LINK_TX);
  Serial.begin(115200);
}

void loop() {
  M5.update();

  // One short block; tune the noise floor and the divisor on your Stick.
  if (M5.Mic.record(micBuf, 256, 8000)) {
    while (M5.Mic.isRecording()) delay(1);

    int64_t sum = 0;
    for (int i = 0; i < 256; i++) {
      int32_t sample = micBuf[i];
      sum += sample * sample;
    }
    float rms = sqrtf((float)sum / 256.0f);
    int mapped = (int)((rms - 80.0f) / 12.0f);
    level = (uint8_t)constrain(mapped, 0, 100);
  }

  float ax, ay, az;
  if (M5.Imu.getAccel(&ax, &ay, &az)) {
    int mapped = (int)((ax + 1.0f) * 127.5f);
    hue = (uint8_t)constrain(mapped, 0, 255);
  }

  if (millis() - lastSend >= 50) {
    lastSend = millis();
    Serial2.printf("L %u\n", level);
    Serial2.printf("H %u\n", hue);

    M5.Display.setCursor(0, 24);
    M5.Display.printf("L %3u H %3u\n", level, hue);
  }

  delay(2);
}
