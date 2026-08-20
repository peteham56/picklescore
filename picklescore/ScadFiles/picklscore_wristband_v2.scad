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
//     42 × 27 × 15.8mm — 0.91" SSD1306 128×32 OLED display
//     (widened from 22mm/thickened from 12.5mm 2026-08-03 — measured XIAO
//     ESP32-C3 + LiPo + OLED stack and USB-C connector length both exceeded
//     original budget; board rotated 90° so its length runs across-wrist to
//     reach the USB-C cutout without fighting the integrated lug caps at
//     the X ends — see in-code comments below)
//     Fitbit Inspire 3 style (39 × 18.6 × 11.75mm reference)
//     Integrated tapered lug caps, 20mm spring bars
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
SHOW   = "assembly";   // "assembly"  | "top" | "bottom"

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
// Measured 2026-08-03: XIAO board 21.11mm (PCB) / 22.39mm (incl. USB-C
// connector) long × ~17.5mm wide; flat chip+LiPo+OLED stack 12.5mm;
// OLED module itself 3.54mm thick (incl. back pads) — all larger than
// the original budget below, which is why body_wid/body_thk grew.
slim_body_len  = 42;   // mm — along arm; OLED PCB(38) + 2×1.5mm walls + 1mm clearance
slim_body_wid  = 27;   // mm — across wrist; XIAO now rotated 90° so its 22.39mm
                        // length (incl. USB-C connector) runs this direction to
                        // reach the USB-C cutout on this wall (X ends are occupied
                        // by the integrated spring-bar lug caps, no room for a port there)
slim_body_thk  = 15.8; // mm — bot_h(10.5) + top_h(5.3) reference only
slim_top_h     =  5.3; // mm — wall_t(1.5) + OLED module(3.6) + 0.2mm clearance
slim_bot_h     = 10.5; // mm — floor(1.2) + XIAO(5.5) + LiPo(3.5) + 0.3mm clearance
slim_win_w     = 24;   // mm — 0.91" active area (128px direction)
slim_win_h     =  8;   // mm — 0.91" active area (32px direction)
slim_matrix_w  = 38;   // mm — 0.91" OLED PCB length (along arm)
slim_matrix_h  = 12;   // mm — 0.91" OLED PCB width (across wrist)
slim_matrix_thk =  3.6; // mm — measured 3.54mm (PCB + glass + back pads) + clearance
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
wall_t    = 1.5;  // mm — outer wall (both profiles)
floor_t   = 1.2;  // mm — bottom floor
win_r     = 2.5;  // mm — window corner radius
win_recess= 0.5;  // mm — window recess depth

/// ── Seeed XIAO ESP32-C3 pocket ────────────────────────────────
// Seeed XIAO ESP32-C3 — measured 22.39mm long (incl. USB-C connector
// overhang) × ~17.5mm wide. Board is rotated 90° in the pocket below:
// esp_len (the connector-bearing length axis) runs across-wrist (Y) to
// meet the USB-C cutout in that wall; esp_wid runs along-arm (X), where
// there's ample room (39mm interior vs 18mm needed).
esp_len   = 23.0; // board length incl. USB-C connector (22.39mm) + clearance
esp_wid   = 18.0; // Seeed XIAO ESP32-C3 width + 0.5mm clearance
esp_thk   =  5.5; // XIAO + components — measured stack required more than the
                   // original 4.0mm budget; extra absorbed here rather than
                   // in the (well-specified) LiPo cell thickness
usbc_w    =  9.0; // mm — USB-C port opening width
usbc_h    =  4.0; // mm — USB-C port opening height

// ── Strap lugs (20mm quick-release, integrated) ──────────────
lug_wid    = 20;   // mm — spring bar span
lug_ext    =  4.5; // mm — lug cap extension beyond body end
bar_r      =  1.0; // mm — spring bar slot radius (slightly > 0.9mm pin for clearance)

// ── Screw bosses (M1.6 × 5mm, screws enter from display face) ─
// boss_h must reach near the parting line (top of bottom shell) or the
// screw has nothing to bite into — bug found 2026-08-03: boss_h was a
// fixed 3.0mm while bot_h was 9.0mm, leaving a 4.8mm dead-air gap the
// screw couldn't bridge. Derive it from bot_h so this can't drift again.
boss_r     = 1.6;
boss_h     = bot_h - floor_t - 0.1;
screw_r    = 0.85;
boss_inset = 4.0;

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

// OLED PCB retaining rails — locate the board so its active area stays
// aligned with the window. The assembly guide has always said "press the
// OLED into the 38×12mm pocket," but no such pocket was ever actually cut
// here (found 2026-08-03) — without it the PCB has nothing to register
// against inside the widened top shell and can drift enough to misalign
// the window. Rails only run along the across-wrist (Y) edges: the
// along-arm (X) direction is already snug on its own (38mm PCB in a
// 39mm-wide interior — a 4-sided frame doesn't fit there, only ~0.5mm
// clearance per side). Standoff height leaves the rest of the 3.8mm
// interior hollow depth free for the PCB body/solder pads.
oled_frame_clear = 0.4; // mm — clearance around the PCB edges
oled_frame_wall  = 1.5; // mm — rail thickness
oled_frame_h     = 1.2; // mm — how far the rails stand proud of the cap

module oled_frame() {
    rail_len = matrix_w + oled_frame_clear;
    for (sy = [-1, 1])
        translate([0,
                   sy * (matrix_h/2 + oled_frame_clear/2 + oled_frame_wall/2),
                   wall_t])
            rounded_box(rail_len, oled_frame_wall, oled_frame_h, 0.4);
}

// ============================================================
// TOP SHELL
// ============================================================

module top_shell() {
    difference() {
        rounded_box(body_len, body_wid, top_h, fillet_r);

        // Interior hollow
        translate([0, 0, wall_t])
            rounded_box(body_len - 2*wall_t, body_wid - 2*wall_t,
                        top_h, fillet_r - wall_t);

        // Display window cutout
        translate([0, 0, -0.1])
            rounded_window(win_w, win_h, win_r, top_h + 0.2);

        // Window recess rim
        translate([0, 0, wall_t - win_recess])
            rounded_window(win_w + 1.5, win_h + 1.5, win_r + 0.8, win_recess + 0.2);

        // Screw clearance holes — M1.6 screws enter from display face, self-tap into bottom bosses
        for (bx = [-1,1], by = [-1,1])
            translate([bx*(body_len/2 - boss_inset),
                       by*(body_wid/2 - boss_inset), -0.1])
                cylinder(r=screw_r + 0.1, h=wall_t + 0.2, $fn=16);
    }

    // OLED PCB retaining frame (see module comment above)
    oled_frame();
}

// ============================================================
// BOTTOM SHELL
// ============================================================

// Integrated spring bar lug cap (one end, +x side; mirror for -x)
module _lug_cap() {
    root_hw = body_wid / 2;  // lug root = full body width
    hull() {
        translate([body_len/2, -root_hw, 0])
            cube([0.1, 2*root_hw, bot_h]);
        translate([body_len/2 + lug_ext - 0.1, -lug_wid/2, 0.5])
            cube([0.1, lug_wid, bot_h - 1]);
    }
}

module bottom_shell() {
    difference() {
        union() {
            rounded_box(body_len, body_wid, bot_h, fillet_r);
            _lug_cap();
            mirror([1, 0, 0]) _lug_cap();
        }

        // Interior hollow
        translate([0, 0, floor_t])
            rounded_box(body_len - 2*wall_t, body_wid - 2*wall_t,
                        bot_h, fillet_r - wall_t);

        // XIAO ESP32-C3 pocket — rotated 90° from a naive length-along-arm
        // layout: esp_len (the connector-bearing dimension) runs across-wrist
        // (Y) so the USB-C connector actually reaches the USB-C cutout below;
        // esp_wid runs along-arm (X) where there's plenty of spare room.
        translate([-esp_wid/2, -esp_len/2, floor_t - 0.1])
            cube([esp_wid, esp_len, esp_thk + 0.1]);

        // LiPo pocket — stacked above XIAO
        translate([-batt_len/2, -batt_wid/2, floor_t + esp_thk])
            cube([batt_len, batt_wid, batt_thk + 0.1]);

        // USB-C port — side wall (programs XIAO + charges LiPo)
        translate([-usbc_w/2, body_wid/2 - wall_t - 0.1, floor_t + 0.5])
            cube([usbc_w, wall_t + 0.3, usbc_h]);

        // Spring bar slots through lug caps
        for (xs = [-1, 1])
            translate([xs * (body_len/2 + lug_ext/2), 0, bot_h/2])
                rotate([0, 90, 0])
                    cylinder(r=bar_r, h=lug_wid + 4, center=true, $fn=24);
    }

    // Screw bosses — receive M1.6×5mm screws from display face
    for (bx = [-1,1], by = [-1,1])
        translate([bx*(body_len/2 - boss_inset),
                   by*(body_wid/2 - boss_inset), floor_t])
            difference() {
                cylinder(r=boss_r, h=boss_h, $fn=24);
                cylinder(r=screw_r, h=boss_h+0.1, $fn=18);
            }
}

// ============================================================
// ASSEMBLY PREVIEW
// ============================================================

module assembly() {
    // top_shell()'s local z=0 is its solid display face (window + screw
    // holes) and z=top_h is the open rim that mates with the bottom shell —
    // mirror before translating or the shell previews upside down (solid
    // face buried at the parting line, open rim exposed at the very top)
    color("DimGray", 0.88)
        translate([0, 0, bot_h + top_h])
            mirror([0, 0, 1])
                top_shell();

    color("SlateGray", 0.82)
        bottom_shell();

    // Smoked acrylic window — mirrored offset to match the corrected
    // top_shell placement above (measuring inward from the exterior face
    // at bot_h+top_h, same as the recess cut inside top_shell() itself)
    color("MidnightBlue", 0.35)
        translate([0, 0, bot_h + top_h - wall_t + win_recess])
            rounded_window(win_w, win_h, win_r, 1.2);

    // OLED PCB
    color("ForestGreen", 0.8)
        translate([0, 0, bot_h + top_h - wall_t])
            cube([matrix_w, matrix_h, matrix_thk], center=true);

    // XIAO ESP32-C3 (bottom of interior)
    color("SaddleBrown", 0.8)
        translate([0, 0, floor_t + esp_thk/2])
            cube([esp_len, esp_wid, esp_thk], center=true);

    // LiPo battery (stacked above XIAO)
    color("Goldenrod", 0.75)
        translate([0, 0, floor_t + esp_thk + batt_thk/2])
            cube([batt_len, batt_wid, batt_thk], center=true);

    // Spring bars (reference — 20mm quick-release pins)
    color("Silver", 0.9)
        for (xs = [-1, 1])
            translate([xs * (body_len/2 + lug_ext/2), 0, bot_h/2])
                rotate([0, 90, 0])
                    cylinder(r=bar_r - 0.1, h=lug_wid, center=true, $fn=16);
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
//   Body:        42 × 27 × 15.8mm  (along arm × across wrist × thick)
//   Window:      24 × 8mm  ← 0.91" 128×32 active area (landscape)
//   Display:     0.91" SSD1306 OLED 128×32 — PCB 38×12mm, pins on short end
//   Battery:     301230 LiPo (3mm × 12mm × 30mm, ~90mAh) stacked above XIAO
//   XIAO:        ESP32-C3, 22.39mm (incl. USB-C connector) × 17.5mm — rotated
//                90° in its pocket so the connector reaches the USB-C cutout
//   USB-C:       Side wall (body_wid face) — programs + charges
//   Straps:      20mm quick-release spring bars (integrated tapered lug caps)
//   Material:    TPU 95A recommended
//   Assembly:    4× M1.6 × 10mm screws — enter from display face, self-tap into bottom bosses
//                (5mm/6mm/8mm all too short in practice — the screw clearance hole in
//                 top_shell() sits over the HOLLOW OLED cavity, not solid wall: the shank
//                 has to cross the full top_h=5.3mm (1.5mm cap + 3.8mm open cavity) as dead
//                 travel before it even reaches the bottom shell's boss to start threading.
//                 10mm gives ~4.7mm real engagement into the 9.2mm-deep boss, well short of
//                 bottoming out)
//
// SHARED:
//   Wall:        1.5mm all sides
//   Floor:       1.2mm
//   Wrist curve: 2.5mm concavity
//   USB-C:       9 × 4mm, right side (+y wall)
// ============================================================
