#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT  32
#define OLED_RESET     -1
#define SDA_PIN 6
#define SCL_PIN 7

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void setup() {
  Serial.begin(115200);
  delay(2000);  // give serial monitor time to connect
  Wire.begin(SDA_PIN, SCL_PIN);

  // Scan all I2C addresses
  Serial.println("Scanning I2C...");
  int found = 0;
  uint8_t oled_addr = 0;
  for (uint8_t addr = 1; addr < 127; addr++) {
    Wire.beginTransmission(addr);
    if (Wire.endTransmission() == 0) {
      Serial.print("  Found device at 0x");
      Serial.println(addr, HEX);
      oled_addr = addr;
      found++;
    }
  }
  if (found == 0) {
    Serial.println("  No I2C devices found — check wiring");
    return;
  }

  // Try to init OLED at found address
  if (!display.begin(SSD1306_SWITCHCAPVCC, oled_addr)) {
    Serial.print("  OLED init failed at 0x");
    Serial.println(oled_addr, HEX);
    return;
  }

  Serial.println("OLED OK");
  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);
  display.setTextSize(2);
  display.setCursor(0, 0);
  display.print("A:00");
  display.setCursor(80, 0);
  display.print("B:00");
  display.setTextSize(1);
  display.setCursor(0, 22);
  display.print("Srv:A  #2   OLED OK");
  display.display();
}

void loop() {
  Serial.println("running...");
  delay(2000);
}
