#include <NimBLEDevice.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 32
#define OLED_RESET -1
#define SCREEN_ADDRESS 0x3C
#define SDA_PIN 6
#define SCL_PIN 7

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
int score_a = 0;
int score_b = 0;
char serving = 'A';
int server = 2;
volatile bool score_dirty = false;

bool gameWon() {
  if (score_a >= 11 && score_a - score_b >= 2) return true;
  if (score_b >= 11 && score_b - score_a >= 2) return true;
  return false;
}

void showScore() {
  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);

  if (gameWon()) {
    // "A WINS!" or "B WINS!" — textSize 3, centered vertically (24px tall in 32px)
    display.setTextSize(3);
    display.setCursor(1, 4);
    display.print(score_a > score_b ? 'A' : 'B');
    display.print(" WINS!");
  } else {
    // Row 1 — scores, textSize 2 (16px tall): "A:08    B:05"
    display.setTextSize(2);
    char sa[5], sb[5];
    snprintf(sa, sizeof(sa), "A:%02d", score_a);
    snprintf(sb, sizeof(sb), "B:%02d", score_b);
    display.setCursor(0, 0);
    display.print(sa);
    display.setCursor(80, 0);   // right-align: 4 chars × 12px = 48px, start at 128-48=80
    display.print(sb);

    // Row 2 — serving info, textSize 1 (8px tall): "Srv:A  #2"
    display.setTextSize(1);
    display.setCursor(0, 22);
    display.print("Srv:");
    display.print(serving);
    display.print("  #");
    display.print(server);
  }

  display.display();
}

class MyScanCallbacks: public NimBLEScanCallbacks {
 void onResult(const NimBLEAdvertisedDevice* advertisedDevice) {
    if (advertisedDevice->haveManufacturerData()) {
      std::string data = advertisedDevice->getManufacturerData();
      int idx = data.find("PS:");
      if (idx != std::string::npos) {
        const char* payload = data.c_str() + idx + 3;
        int sa, sb, sn;
        char sv;
        if (sscanf(payload, "%d,%d,%c,%d", &sa, &sb, &sv, &sn) == 4) {
          score_a = sa;
          score_b = sb;
          serving = sv;
          server = sn;
          score_dirty = true;
          Serial.printf("Score: %d-%d Srv:%c #%d\n", sa, sb, sv, sn);
        }
      }
    }
  }
};
void setup() {
  Serial.begin(115200);
  Wire.begin(SDA_PIN, SCL_PIN);
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println("OLED failed!");
    while (1);
  }
  showScore();
  NimBLEDevice::init("");
  NimBLEScan* pScan = NimBLEDevice::getScan();
  pScan->setScanCallbacks(new MyScanCallbacks());
  pScan->setActiveScan(true);
  pScan->setDuplicateFilter(false);
  pScan->setInterval(100);
  pScan->setWindow(99);
  pScan->start(0, false);
  Serial.println("PickleScore Wristband Ready!");
}

void loop() {
  if (score_dirty) {
    score_dirty = false;
    showScore();
  }
  delay(100);
}
