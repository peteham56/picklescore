# PickleScore

Wireless pickleball scoreboard. A thumb-sized pod clips to your paddle throat and broadcasts the score via BLE to a wristband display.

- **ThroatPod v4.0** — Seeed XIAO nRF52840, two-button TPU membrane shell, 301225 LiPo (~60–80mAh)
- **Wristband v3.0** — Seeed XIAO ESP32-C3, 0.91" 128×32 SSD1306 OLED, 301230 LiPo (~90mAh), 20mm quick-release band

---

## How it works

Press the button for the team that won the rally. PickleScore handles the pickleball side-out scoring rules automatically — if the non-serving team wins, it rotates servers before awarding a point.

| Action | ThroatPod |
|--------|-----------|
| Team A scores | Tap button A |
| Team B scores | Tap button B |
| Undo last point | Hold either button 1.5 s |
| Reset game | Hold either button 3 s |

The wristband updates immediately over BLE. First to 11, win by 2.

---

## Repo layout

```
PickleScore_ThroatPod/   Arduino sketch for XIAO nRF52840
PickleScore_Wristband/   Arduino sketch for XIAO ESP32-C3
ScadFiles/               OpenSCAD source + exported STLs for both enclosures
PickleScore/
  ASSEMBLY.md            Full BOM and step-by-step build guide
  sim.py                 Desktop simulator for testing scoring logic
```

---

## Building the firmware

### ThroatPod (nRF52840)

1. Install the [Seeed nRF52 board package](https://wiki.seeedstudio.com/XIAO_BLE/) in Arduino IDE.
2. Install library: **Adafruit Bluefruit nRF52** (for `bluefruit.h`).
3. Open `PickleScore_ThroatPod/PickleScore_ThroatPod.ino`, select **Seeed XIAO nRF52840**, upload.

### Wristband (ESP32-C3)

1. Install the [Seeed ESP32-C3 board package](https://wiki.seeedstudio.com/XIAO_ESP32C3_Getting_Started/) in Arduino IDE.
2. Install libraries: **NimBLE-Arduino**, **Adafruit SSD1306**, **Adafruit GFX**.
3. Open `PickleScore_Wristband/PickleScore_Wristband.ino`, select **XIAO_ESP32C3**, upload.

Flash both boards before sealing them in their enclosures.

---

## Printing the enclosures

Both shells print in **TPU 95A**. See `ScadFiles/` for source files and `PickleScore/ASSEMBLY.md` for print orientations and settings.

---

## Assembly

Full instructions with photos references, torque notes, and critical gotchas are in [`PickleScore/ASSEMBLY.md`](PickleScore/ASSEMBLY.md).

---

## Testing scoring logic

Run the desktop simulator without any hardware:

```
python3 PickleScore/sim.py
```
