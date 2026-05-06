# PickleScore™ Assembly Guide

---

## ThroatPod v4.0

### Bill of Materials

| # | Item | Qty | Spec / Notes |
|---|------|-----|--------------|
| 1 | Seeed XIAO nRF52840 | 1 | BLE + built-in LiPo charger |
| 2 | LiPo battery | 1 | 301225 (3×12×25mm, ~60–80mAh) — **must have JST 1.25mm SH 2-pin connector** |
| 3 | Tactile switch | 2 | 6×6×5mm through-hole |
| 4 | M1.6 × 4mm screw | 4 | Pan or flat head |
| 5 | 3M VHB 4910 tape | 1 small sheet | Cut to recess shape (~24×20mm approx) |
| 6 | Hookup wire | short lengths | 28–30 AWG, for button leads |
| 7 | CA glue | trace | Switch body retention only — do NOT glue actuator |
| 8 | TPU 95A filament | — | For top shell + bottom shell |

### Printed Parts

| Part | SHOW setting | Orientation | Material |
|------|-------------|-------------|----------|
| Bottom shell | `SHOW = "bottom"` | Flat side down | TPU 95A |
| Top shell | `SHOW = "top"` | Button face down (buttons on bed) | TPU 95A |

File: `ScadFiles/picklscore_throat_pod_v2_1.scad`

### Assembly Steps

1. **Flash firmware** — connect XIAO nRF52840 via USB-C, upload `PickleScore_ThroatPod.ino` in Arduino IDE before installing in shell.

2. **Prep switches** — bend tactile switch legs flat if needed to fit 6×6×5mm footprint. Do not trim legs.

3. **Solder button leads** — cut two ~50mm lengths of 28–30 AWG wire. Solder one end to each switch (one leg = signal, one leg = GND). Solder other ends to XIAO:
   - Switch A → D1 + GND
   - Switch B → D2 + GND

4. **Seat switches in top shell** — press each switch against the underside of its 0.8mm TPU membrane dome. Apply a small dot of CA glue to the **switch body only** (not the actuator pin). Hold 30 sec to set.

5. **Install XIAO in bottom shell** — drop XIAO into pocket (centered, USB-C end toward top wall). Pocket is 22×18.5×4mm; board should sit flush at floor level.

6. **Route button wires** — drape switch leads so they clear the LiPo pocket. Verify they won't pinch when shells close.

7. **Connect and place LiPo** — plug 301225 JST 1.25mm connector into XIAO battery port. Lay cell flat in LiPo pocket on top of XIAO. Cell sits at z = floor + 4mm.

8. **Check USB-C alignment** — with LiPo seated, verify the XIAO USB-C port lines up with the 9×4mm cutout in the top wall. Adjust XIAO fore/aft if needed.

9. **Close shells** — lower top shell onto bottom shell. Align 4 screw boss holes at corners. Press together; TPU will flex slightly.

10. **Drive screws** — install 4× M1.6×4mm screws at corners. Snug only — over-torquing strips TPU bosses.

11. **Apply VHB tape** — cut 3M VHB 4910 to fit the recess on the back face. Press firmly for 30 sec. Full bond strength develops in 72 hrs.

12. **Functional test** — press each button; wristband should update score. Hold each button 1.5s for undo, 3s for reset.

---

## Wristband v3.0

### Bill of Materials

| # | Item | Qty | Spec / Notes |
|---|------|-----|--------------|
| 1 | Seeed XIAO ESP32-C3 | 1 | BLE scanner + built-in LiPo charger |
| 2 | OLED display | 1 | 0.91" SSD1306 I2C, 128×32 px — search "0.91 inch OLED SSD1306 I2C" |
| 3 | LiPo battery | 1 | 301230 (3×12×30mm, ~90mAh) — **must have JST 1.25mm SH 2-pin connector** |
| 4 | M1.6 × 5mm screw | 4 | Pan or flat head |
| 5 | 20mm quick-release spring bar | 2 | Standard lug width |
| 6 | 20mm silicone sport band | 1 | Any 20mm quick-release band |
| 7 | Hookup wire | short lengths | 28–30 AWG, 4-wire I2C harness ~60mm |
| 8 | TPU 95A filament | — | For top shell + bottom shell |

### Printed Parts

| Part | SHOW setting | Orientation | Material |
|------|-------------|-------------|----------|
| Bottom shell | `SHOW = "bottom"` | Curved side down (add brim) | TPU 95A |
| Top shell | `SHOW = "top"` | Display window face down | TPU 95A |

File: `ScadFiles/picklscore_wristband_v2.scad` — use `DESIGN = "slim"`

### Assembly Steps

1. **Flash firmware** — connect XIAO ESP32-C3 via USB-C, upload `PickleScore_Wristband.ino` before installing in shell.

2. **Solder I2C harness** — cut 4 wires ~60mm each (28–30 AWG). Solder to XIAO pads:
   - SDA → pin 6
   - SCL → pin 7
   - VCC → 3.3V
   - GND → GND

3. **Connect harness to OLED** — solder the other ends to the OLED's 4-pin I2C header (GND, VCC, SCL, SDA — verify your module's pin order before soldering).

4. **Install XIAO in bottom shell** — place XIAO ESP32-C3 into the 21.5×18×4mm pocket in the bottom shell floor. USB-C end toward the side wall with the port cutout.

5. **Connect and place LiPo** — plug 301230 JST 1.25mm into XIAO battery port. Lay cell in 31×13×3.5mm pocket on top of XIAO.

6. **Check USB-C alignment** — confirm USB-C port lines up with 9×4mm cutout in side wall (body_wid face).

7. **Seat OLED in top shell** — press OLED PCB into the 38×12mm pocket in the underside of the top shell. Active area must align over the 24×8mm window. OLED pins exit toward one short end.

8. **Route I2C wires** — arrange the 4-wire harness so it loops neatly between shells. Wires should not cross the screw boss locations.

9. **Mate shells** — lower top shell onto bottom shell. Align 4 boss holes. Press together.

10. **Drive screws** — install 4× M1.6×5mm screws. Snug only.

11. **Install spring bars** — insert 20mm quick-release spring bars through the lug channels on each end.

12. **Attach band** — click sport band ends onto spring bars.

13. **Functional test** — power on, verify OLED shows "A:00  B:00 / Srv:A #2". Press ThroatPod buttons and confirm display updates.

---

## Critical Notes (both devices)

- **JST connector:** XIAO nRF52840 and ESP32-C3 both use JST 1.25mm SH 2-pin. Most LiPos ship with JST 2.0mm PH — order cells specifically with JST 1.25mm or swap connectors before assembly.
- **TPU screws:** M1.6 bosses in TPU strip easily. Use a hand screwdriver, not a powered one. Stop at snug.
- **Paddle fit (ThroatPod):** `pod_top_w = 34mm` is an estimate against the JOOLA Perseus. Measure your paddle throat at the attachment point before final print — adjust parameter if needed.
- **CA glue (ThroatPod):** Apply only to tactile switch body, not the actuator. Any glue on the actuator pin will bind the button.
