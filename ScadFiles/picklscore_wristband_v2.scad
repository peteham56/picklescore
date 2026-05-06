// ============================================================
// PickleScore™ Wristband Enclosure — v3.0
// Parametric OpenSCAD model
// Pill-shaped capsule, curved back, 20mm quick-release straps
// Two-piece clamshell: top shell + bottom shell
// ============================================================
// TWO DESIGN PROFILES — switch with DESIGN variable below:
//
//   DESIGN = "prototype"
//     46 × 30 × 12mm — WS2812B 8×8 LED matrix display
//     Fits current electronics stack for bench testing
//     Seeed XIAO ESP32-C3 + LiPo (charging built-in)
//
//   DESIGN = "slim"
//     48 × 24 × 13mm — 0.91" SSD1306 128×32 OLED display
//     Fitbit Inspire 3 form factor (39 × 18.6 × 11.75mm)
//     Production target — Phase 3 with custom PCB
//
// ============================================================
// PRINT SETTINGS:
//   Material:      TPU 95A
//   Layer height:  0.15mm for best surface quality
//   Infill:        30% gyroid
//   Supports:      None needed
//   Orientation:
//     Top shell   → print face-down (display window on bed)
//     Bottom shell → print curved-side-down (add brim)
// ============================================================
// TO USE:
//   SHOW = "assembly"    — full preview with component stack
//   SHOW = "top"         — top shell only  (export STL)
//   SHOW = "bottom"      — bottom shell only (export STL)
// ============================================================

DESIGN = "slim";  // "prototype" | "slim"
SHOW   = "bottom";   // "assembly"  | "top" | "bottom"

// ============================================================
// PROFILE PARAMETERS
// ============================================================

// ── Standard profile — WS2812B 8×8 LED matrix ──────────────
proto_body_len  = 46;   // mm — trimmed from 60mm
proto_body_wid  = 30;   // mm — driven by 28mm LED matrix
proto_body_thk  = 12;   // mm — slimmed from 14mm
proto_top_h     =  5.0; // mm — top shell (holds matrix)
proto_bot_h     =  7.0; // mm — bottom shell (holds battery)
proto_win_w     = 24;   // mm — window width
proto_win_h     = 18;   // mm — window height
proto_matrix_w  = 28;   // mm — LED matrix PCB width
proto_matrix_h  = 20;   // mm — LED matrix PCB height
proto_matrix_thk =  4;  // mm — PCB + LED stack height
proto_batt_len  = 35;   // mm — EEMB 403048 LiPo
proto_batt_wid  = 25;   // mm
proto_batt_thk  =  5;   // mm — battery + foam
proto_fillet_r  =  4.0; // mm
proto_vent_offset = 10; // mm

// ── Slim profile — 0.91" SSD1306 OLED 128×32 ────────────────
slim_body_len  = 48;   // mm — along arm; fits XIAO(21) + LiPo(25) stacked in z
slim_body_wid  = 24;   // mm — across wrist; minimum for XIAO 17.5mm + walls
slim_body_thk  = 13;   // mm — bot_h(9) + top_h(4) reference only
slim_top_h     =  4.0; // mm — OLED + face plate
slim_bot_h     =  9.0; // mm — floor(1.5) + XIAO(4) + LiPo(3.5) stacked
slim_win_w     = 24;   // mm — 0.91" active area (128px direction)
slim_win_h     =  8;   // mm — 0.91" active area (32px direction)
slim_matrix_w  = 38;   // mm — 0.91" OLED PCB length (along arm)
slim_matrix_h  = 12;   // mm — 0.91" OLED PCB width (across wrist)
slim_matrix_thk =  2;  // mm — PCB + glass stack height
slim_batt_len  = 31;   // mm — 301230 (30mm cell) + 1mm clearance
slim_batt_wid  = 13;   // mm — 12mm LiPo + 1mm clearance
slim_batt_thk  =  3.5; // mm — 3mm LiPo + 0.5mm clearance
slim_fillet_r  =  3.0; // mm
slim_vent_offset =  8; // mm

// ============================================================
// RESOLVED PARAMETERS (auto-set from DESIGN selection)
// ============================================================

body_len  = (DESIGN == "slim") ? slim_body_len  : proto_body_len;
body_wid  = (DESIGN == "slim") ? slim_body_wid  : proto_body_wid;
body_thk  = (DESIGN == "slim") ? slim_body_thk  : proto_body_thk;
top_h     = (DESIGN == "slim") ? slim_top_h     : proto_top_h;
bot_h     = (DESIGN == "slim") ? slim_bot_h     : proto_bot_h;
win_w     = (DESIGN == "slim") ? slim_win_w     : proto_win_w;
win_h     = (DESIGN == "slim") ? slim_win_h     : proto_win_h;
matrix_w  = (DESIGN == "slim") ? slim_matrix_w  : proto_matrix_w;
matrix_h  = (DESIGN == "slim") ? slim_matrix_h  : proto_matrix_h;
matrix_thk= (DESIGN == "slim") ? slim_matrix_thk: proto_matrix_thk;
batt_len  = (DESIGN == "slim") ? slim_batt_len  : proto_batt_len;
batt_wid  = (DESIGN == "slim") ? slim_batt_wid  : proto_batt_wid;
batt_thk  = (DESIGN == "slim") ? slim_batt_thk  : proto_batt_thk;
fillet_r  = (DESIGN == "slim") ? slim_fillet_r  : proto_fillet_r;
vent_offset=(DESIGN == "slim") ? slim_vent_offset: proto_vent_offset;

// ── Shared parameters ────────────────────────────────────────
wall_t    = 1.8;  // mm — outer wall (both profiles)
floor_t   = 1.5;  // mm — bottom floor
curve_sag = 2.5;  // mm — wrist concavity
win_r     = 2.5;  // mm — window corner radius
win_recess= 0.5;  // mm — window recess depth

/// ── Seeed XIAO ESP32-C3 pocket ────────────────────────────────
// Seeed XIAO ESP32-C3 — 21×17.5mm — built-in LiPo charging
esp_len   = 21.5; // Seeed XIAO ESP32-C3 + 0.5mm clearance
esp_wid   = 18.0; // Seeed XIAO ESP32-C3 + 0.5mm clearance
esp_thk   =  4.0; // XIAO + components clearance
usbc_w    =  9.0; // mm — USB-C port opening width
usbc_h    =  4.0; // mm — USB-C port opening height

// ── Strap lugs (20mm quick-release) ──────────────────────────
lug_wid    = 20;
lug_outer  = 22;
lug_thk    =  1.8;
lug_h      =  3.5; // mm — match top_h
lug_angle  =  0;
bar_r      =  0.9;
bar_offset =  4.0;

// ── Screw bosses (M1.6) ───────────────────────────────────────
boss_r     = 1.8;
boss_h     = 3.5;
screw_r    = 0.85;
boss_inset = 4.5;

// ── Vent slots ────────────────────────────────────────────────
vent_len = 8;
vent_wid = 1.8;

// ============================================================
// HELPERS
// ============================================================

module rounded_box(l, w, h, r) {
    hull() {
        for (sx = [-1,1], sy = [-1,1])
            translate([sx*(l/2-r), sy*(w/2-r), 0])
                cylinder(r=r, h=h, $fn=32);
    }
}

module rounded_window(w, h, r, depth) {
    hull() {
        for (sx = [-1,1], sy = [-1,1])
            translate([sx*(w/2-r), sy*(h/2-r), 0])
                cylinder(r=r, h=depth+0.2, $fn=24);
    }
}

module screw_boss(x, y, z_base) {
    translate([x, y, z_base])
        difference() {
            cylinder(r=boss_r, h=boss_h, $fn=24);
            cylinder(r=screw_r, h=boss_h+0.1, $fn=18);
        }
}

// ============================================================
// TOP SHELL
// ============================================================

module top_shell() {
    difference() {
        union() {
            rounded_box(body_len, body_wid, top_h, fillet_r);
            // Right lug
            translate([body_len/2, -(lug_outer/2), 0])
                cube([bar_offset + 2, lug_thk, lug_h]);
            translate([body_len/2, (lug_outer/2 - lug_thk), 0])
                cube([bar_offset + 2, lug_thk, lug_h]);
            // Left lug
            translate([-(body_len/2 + bar_offset + 2), -(lug_outer/2), 0])
                cube([bar_offset + 2, lug_thk, lug_h]);
            translate([-(body_len/2 + bar_offset + 2), (lug_outer/2 - lug_thk), 0])
                cube([bar_offset + 2, lug_thk, lug_h]);
        }

        // Interior hollow
        translate([0, 0, wall_t])
            rounded_box(body_len - 2*wall_t, body_wid - 2*wall_t,
                        top_h, fillet_r - 1.2);

        // Display window cutout
        translate([0, 0, -0.1])
            rounded_window(win_w, win_h, win_r, top_h + 0.2);

        // Window recess rim
        translate([0, 0, wall_t - win_recess])
            rounded_window(win_w + 1.5, win_h + 1.5, win_r + 0.8, win_recess + 0.2);

        // USB-C removed from top shell — see bottom shell side wall
    }

    // Screw bosses
    screw_boss(-body_len/2 + boss_inset, -body_wid/2 + boss_inset, wall_t);
    screw_boss( body_len/2 - boss_inset, -body_wid/2 + boss_inset, wall_t);
    screw_boss(-body_len/2 + boss_inset,  body_wid/2 - boss_inset, wall_t);
    screw_boss( body_len/2 - boss_inset,  body_wid/2 - boss_inset, wall_t);
}

// ============================================================
// BOTTOM SHELL
// ============================================================

module bottom_shell() {
    difference() {
        rounded_box(body_len, body_wid, bot_h, fillet_r);

        // Interior hollow
        translate([0, 0, floor_t])
            rounded_box(body_len - 2*wall_t, body_wid - 2*wall_t,
                        bot_h, fillet_r - 1.2);

        // Concave wrist curve
        translate([0, 0, -(curve_sag * 20 - curve_sag)])
            scale([1, body_len / (body_len + 10), 1])
                sphere(r = curve_sag * 20, $fn=64);

        // XIAO ESP32-C3 pocket
        translate([-esp_len/2, -esp_wid/2, floor_t - 0.1])
            cube([esp_len, esp_wid, esp_thk + 0.1]);

        // LiPo pocket — stacked above XIAO
        translate([-batt_len/2, -batt_wid/2, floor_t + esp_thk])
            cube([batt_len, batt_wid, batt_thk + 0.1]);

        // USB-C port — side wall (programs XIAO + charges LiPo)
        translate([-usbc_w/2, body_wid/2 - wall_t - 0.1, floor_t + 0.5])
            cube([usbc_w, wall_t + 0.3, usbc_h]);

        // Screw holes
        for (bx = [-1,1], by = [-1,1])
            translate([bx*(body_len/2 - boss_inset),
                       by*(body_wid/2 - boss_inset), -0.1])
                cylinder(r=screw_r, h=floor_t + 0.2, $fn=16);
    }
}

// ============================================================
// ASSEMBLY PREVIEW
// ============================================================

module assembly() {
    color("DimGray", 0.88)
        translate([0, 0, bot_h])
            top_shell();

    color("SlateGray", 0.82)
        bottom_shell();

    // Smoked acrylic window
    color("MidnightBlue", 0.35)
        translate([0, 0, bot_h + wall_t - win_recess])
            rounded_window(win_w, win_h, win_r, 1.2);

    // Display (LED matrix or OLED)
    color("ForestGreen", 0.8)
        translate([0, 0, bot_h + wall_t])
            cube([matrix_w, matrix_h, matrix_thk], center=true);

    // XIAO ESP32-C3 (bottom of interior)
    color("SaddleBrown", 0.8)
        translate([0, 0, floor_t + esp_thk/2])
            cube([esp_len, esp_wid, esp_thk], center=true);

    // LiPo battery (stacked above XIAO)
    color("Goldenrod", 0.75)
        translate([0, 0, floor_t + esp_thk + batt_thk/2])
            cube([batt_len, batt_wid, batt_thk], center=true);
}

// ============================================================
// RENDER
// ============================================================

if      (SHOW == "top")    top_shell();
else if (SHOW == "bottom") bottom_shell();
else                       assembly();

// ============================================================
// QUICK REFERENCE
// ============================================================
// PROTOTYPE profile (DESIGN = "prototype"):
//   Body:        46 × 30 × 12 mm
//   Window:      24 × 18 mm
//   Display:     WS2812B 8×8 LED matrix (28 × 20mm)
//   Battery:     EEMB 403048 LiPo (35 × 25 × 5mm)
//   ESP32:       SuperMini 22.5 × 18mm ← MEASURE YOURS, update esp_len/esp_wid
//
// SLIM profile (DESIGN = "slim"):
//   Body:        48 × 24 × 13mm  (along arm × across wrist × thick)
//   Window:      24 × 8mm  ← 0.91" 128×32 active area
//   Display:     0.91" SSD1306 OLED 128×32 — PCB 38×12mm, pins on short end
//   Battery:     301230 LiPo (3mm × 12mm × 30mm, ~90mAh) stacked above XIAO
//   XIAO:        ESP32-C3, 21×17.5mm — built-in LiPo charging via USB-C
//   USB-C:       Side wall (body_wid face) — programs + charges
//   Straps:      20mm quick-release spring bars
//   Material:    TPU 95A recommended
//   Assembly:    4× M1.6 screws
//
// SHARED:
//   Straps:      20mm quick-release spring bars
//   Assembly:    4× M1.6 screws
//   Wall:        1.8mm all sides
//   Wrist curve: 2.5mm concavity
//   USB-C:       9 × 4mm, right side
// ============================================================
