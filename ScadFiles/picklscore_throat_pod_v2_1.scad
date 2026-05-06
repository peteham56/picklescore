// ============================================================
// PickleScore™ Throat Pod Enclosure — v4.0  2-BUTTON / LIPO
// Parametric OpenSCAD model
// ============================================================
// WHAT'S NEW IN v2.0:
//   - Tapered trapezoid body matching JOOLA Perseus throat taper
//   - Top width 65mm (at USA Approved level), bottom 27mm (grip collar)
//   - Height 65mm total — extends slightly above 25mm gap for fit
//   - Slim 7mm total thickness (down from 9mm in v1)
//   - XIAO nRF52840 oriented lengthwise (21mm along pod height)
//   - CR2032 holder stacked above XIAO chip (vertical stack layout)
//   - Clip arms at TOP of pod only (widest point, best grip)
//   - Full-length VHB pad on back face for secondary adhesion
//   - Buttons repositioned for tapered face geometry
// ============================================================
// PHASE 2 NOTE:
//   This design uses the Seeed XIAO nRF52840 (21×17.5mm)
//   for prototype builds. Phase 3 production will swap to
//   the Raytac MDBT50Q bare module (15.5×10.5×2mm) on a
//   custom PCB — enabling a pod that fits entirely within
//   the 25mm grip transition zone.
// ============================================================
// PRINT SETTINGS:
//   Material:      TPU 95A
//   Layer height:  0.15mm
//   Infill:        30% gyroid
//   Supports:      None needed
//   Orientation:
//     Top shell   → print face-down (buttons facing bed)
//     Bottom shell → print flat-side-down
// ============================================================
// TO USE:
//   SHOW = "assembly"    — full preview with components
//   SHOW = "top"         — top shell only (export STL)
//   SHOW = "bottom"      — bottom shell only (export STL)
// ============================================================

SHOW = "bottom";   // "assembly" | "top" | "bottom"

// ── Tapered body dimensions ──────────────────────────────────
// Trapezoid: wide at top (paddle face level), narrow at bottom (grip)
pod_h      = 30;    // mm — LiPo (25mm) + margins
pod_top_w  = 34;    // mm — 2-button layout, verify against paddle throat
pod_bot_w  = 27;    // mm — measured throat width
pod_thk    = 11;    // mm — floor(1.2) + XIAO(4) + LiPo(3.5) + top(1.8) stacked

// ── Shell thicknesses ────────────────────────────────────────
wall_t   = 1.8;  // mm — outer wall thickness all sides
top_t    = 1.8;  // mm — button face shell thickness
bot_h    =  9;  // mm — floor(1.2) + XIAO(4) + LiPo(3.5) stacked
floor_t  = 1.2;  // mm — bottom floor thickness

// ── Clip arms (grip paddle edge — TOP of pod only) ───────────
clip_gap    =  5.49; // mm — JOOLA Perseus edge guard height (measured)
clip_len    = 10.0;  // mm — arm length reaching over edge
clip_thk    =  1.8;  // mm — arm wall thickness
clip_offset = 10.0;  // mm — inset from left/right ends at top

// ── Button hole1s (inverted-triangle on tapered face) ─────────
// Positioned in upper portion of pod face, centered
btn_A_x  =  -8;  btn_A_y =   5;  btn_A_r = 5.0;  // Red  (left)  — short press = A scores, long = undo, 3s = reset
btn_B_x  =   8;  btn_B_y =   5;  btn_B_r = 5.0;  // Blue (right) — short press = B scores, long = undo, 3s = reset

// ── XIAO nRF52840 pocket (oriented lengthwise) ───────────────
// Board: 21mm long × 17.5mm wide × 3.5mm thick
// Positioned in upper half of pod
xiao_len  = 22.0;  // mm — board length + 0.5mm clearance
xiao_wid  = 18.5;  // mm — board width + 1mm clearance
xiao_thk  =  4.0;  // mm — board + component height
xiao_y    =  0;  // mm — centered in pod
xiao_x    =  0;  // mm — centered in pod
usbc_w    =  9.0;  // mm — USB-C cutout width
usbc_h    =  4.0;  // mm — USB-C cutout height

// ── LiPo battery (stacked above XIAO in z) ───────────────────
// Target: 301230 (3mm × 12mm × 30mm, ~90mAh)
// XIAO nRF52840 has built-in LiPo charger — USB-C charges both
lipo_len   = 26.0;  // mm — 25mm cell + 1mm clearance
lipo_wid   = 13.0;  // mm — 12mm cell + 1mm clearance
lipo_thk   =  3.5;  // mm — 3mm cell + 0.5mm clearance
lipo_y     =    0;  // mm — centered in pod
lipo_x     =    0;  // mm — centered in pod

// ── VHB adhesive pad recess (full back face) ─────────────────
// Slightly inset from edges for clean appearance
pad_margin = 4;    // mm — margin from pod edge
pad_depth  = 0.8;  // mm — recess depth

// ── Screw bosses (M1.6) ──────────────────────────────────────
boss_r     = 1.8;
boss_h     = 3.0;
screw_r    = 0.85;
boss_inset_x = 5.0;  // mm from left/right edge
boss_inset_y = 5.0;  // mm from top/bottom edge

// ── Fillet radius ─────────────────────────────────────────────
fillet_r = 3.0;

// ============================================================
// TRAPEZOID HELPER
// The pod tapers linearly from pod_top_w at top (y = +pod_h/2)
// to pod_bot_w at bottom (y = -pod_h/2).
// width_at(y) returns the pod half-width at a given y position.
// ============================================================

function width_at(y) =
    (pod_top_w/2) * (0.5 + y/pod_h) +
    (pod_bot_w/2) * (0.5 - y/pod_h);

// Build tapered body using hull of rounded boxes at top and bottom
module tapered_body(thk) {
    hull() {
        // Top end — full top width
        translate([0, pod_h/2 - fillet_r, 0])
            hull() {
                for (sx = [-1, 1])
                    translate([sx * (pod_top_w/2 - fillet_r), 0, 0])
                        cylinder(r=fillet_r, h=thk, $fn=32);
            }
        // Bottom end — narrow bottom width
        translate([0, -(pod_h/2 - fillet_r), 0])
            hull() {
                for (sx = [-1, 1])
                    translate([sx * (pod_bot_w/2 - fillet_r), 0, 0])
                        cylinder(r=fillet_r, h=thk, $fn=32);
            }
    }
}

// Interior hollow — walls on all sides
module tapered_hollow(thk) {
    hull() {
        translate([0, pod_h/2 - fillet_r, 0])
            hull() {
                for (sx = [-1, 1])
                    translate([sx * (pod_top_w/2 - wall_t - fillet_r + 1), 0, 0])
                        cylinder(r=max(fillet_r-1.5, 1), h=thk+0.2, $fn=32);
            }
        translate([0, -(pod_h/2 - fillet_r), 0])
            hull() {
                for (sx = [-1, 1])
                    translate([sx * (pod_bot_w/2 - wall_t - fillet_r + 1), 0, 0])
                        cylinder(r=max(fillet_r-1.5, 1), h=thk+0.2, $fn=32);
            }
    }
}

// Screw boss at position
module screw_boss(x, y, z_base) {
    translate([x, y, z_base])
        difference() {
            cylinder(r=boss_r, h=boss_h, $fn=24);
            cylinder(r=screw_r, h=boss_h+0.1, $fn=18);
        }
}

// ============================================================
// TOP SHELL (button face)
// ============================================================
module top_shell() {
    difference() {
        // Outer tapered body
        tapered_body(top_t + 1.5);

        // Interior hollow
        translate([0, 0, top_t])
            tapered_hollow(top_t + 2);

        // Button A — 0.8mm TPU membrane dome (tactile switch presses from inside)
        translate([btn_A_x, btn_A_y, 0.8])
            cylinder(r=btn_A_r, h=top_t + 2.6, $fn=32);

        // Button B — 0.8mm TPU membrane dome
        translate([btn_B_x, btn_B_y, 0.8])
            cylinder(r=btn_B_r, h=top_t + 2.6, $fn=32);

    }
}

// ============================================================
// BOTTOM SHELL (component housing)
// ============================================================
module bottom_shell() {
    difference() {
        union() {
            // Main tapered body
            tapered_body(bot_h);

            // Clip arms — TOP edge of pod only (widest point)
            // Left clip arm pair
            translate([-(pod_top_w/2), pod_h/2 - clip_len, 0])
                cube([clip_thk, clip_len, bot_h]);
            translate([-(pod_top_w/2 + clip_gap + clip_thk), pod_h/2 - clip_len, 0])
                cube([clip_thk, clip_len, bot_h]);
            // Horizontal connector top of left clip
            translate([-(pod_top_w/2 + clip_gap + clip_thk), pod_h/2 - clip_len, bot_h - clip_thk])
                cube([clip_gap + clip_thk*2, clip_thk, clip_thk]);

            // Right clip arm pair
            translate([(pod_top_w/2 - clip_thk), pod_h/2 - clip_len, 0])
                cube([clip_thk, clip_len, bot_h]);
            translate([(pod_top_w/2 + clip_gap), pod_h/2 - clip_len, 0])
                cube([clip_thk, clip_len, bot_h]);
            // Horizontal connector top of right clip
            translate([(pod_top_w/2 - clip_thk), pod_h/2 - clip_len, bot_h - clip_thk])
                cube([clip_gap + clip_thk*2, clip_thk, clip_thk]);
        }

        // Interior hollow
        translate([0, 0, floor_t])
            tapered_hollow(bot_h);

        // XIAO nRF52840 pocket (upper half, lengthwise)
       translate([xiao_x - xiao_wid/2, xiao_y - xiao_len/2, floor_t - 0.1])
            cube([xiao_wid, xiao_len, xiao_thk + 0.1]);

        // USB-C port — through top wall (programs XIAO + charges LiPo)
        translate([xiao_x - usbc_w/2, pod_h/2 - wall_t - 0.1, floor_t + 0.5])
            cube([usbc_w, wall_t + 0.3, usbc_h]);

        // LiPo pocket — above XIAO in z (stacked)
        translate([lipo_x - lipo_wid/2, lipo_y - lipo_len/2, floor_t + xiao_thk])
            cube([lipo_wid, lipo_len, lipo_thk + 0.1]);

        // VHB tape recess on back face (full-length, inset from edges)
        hull() {
            translate([0, pod_h/2 - pad_margin - fillet_r, -0.1])
                hull() {
                    for (sx=[-1,1])
                        translate([sx*(pod_top_w/2 - pad_margin - fillet_r), 0, 0])
                            cylinder(r=fillet_r-1, h=pad_depth+0.2, $fn=24);
                }
            translate([0, -(pod_h/2 - pad_margin - fillet_r), -0.1])
                hull() {
                    for (sx=[-1,1])
                        translate([sx*(pod_bot_w/2 - pad_margin - fillet_r), 0, 0])
                            cylinder(r=fillet_r-1, h=pad_depth+0.2, $fn=24);
                }
        }

        // Screw holes (4 corners matched to top shell bosses)
        for (sx=[-1,1]) {
            translate([sx*(pod_top_w/2 - boss_inset_x), pod_h/2 - boss_inset_y, -0.1])
                cylinder(r=screw_r, h=floor_t+0.2, $fn=16);
            translate([sx*(pod_bot_w/2 - boss_inset_x), -(pod_h/2 - boss_inset_y), -0.1])
                cylinder(r=screw_r, h=floor_t+0.2, $fn=16);
        }
    }

    // Screw bosses at 4 corners (adapting to taper)
    screw_boss(-(pod_top_w/2 - boss_inset_x),  pod_h/2 - boss_inset_y,  floor_t);
    screw_boss( (pod_top_w/2 - boss_inset_x),  pod_h/2 - boss_inset_y,  floor_t);
    screw_boss(-(pod_bot_w/2 - boss_inset_x), -(pod_h/2 - boss_inset_y), floor_t);
    screw_boss( (pod_bot_w/2 - boss_inset_x), -(pod_h/2 - boss_inset_y), floor_t);
}

// ============================================================
// ASSEMBLY PREVIEW
// ============================================================
module assembly() {
    // Top shell (button face)
    color("DarkSlateGray", 0.9)
        translate([0, 0, bot_h])
            top_shell();

    // Bottom shell
    color("SlateGray", 0.85)
        translate([0, 0, 0])
            bottom_shell();

    // Tactile switches — 6×6×5mm, seated under membrane domes
    color("DimGray", 0.9) {
        translate([btn_A_x - 3, btn_A_y - 3, bot_h + 0.8])
            cube([6, 6, 5]);
        translate([btn_B_x - 3, btn_B_y - 3, bot_h + 0.8])
            cube([6, 6, 5]);
    }

    // XIAO nRF52840 board
    color("ForestGreen", 0.8)
        translate([xiao_x - xiao_wid/2, xiao_y - xiao_len/2, floor_t + 0.2])
            cube([xiao_wid, xiao_len, xiao_thk]);

    // LiPo battery (stacked above XIAO)
    color("SteelBlue", 0.75)
        translate([lipo_x - lipo_wid/2, lipo_y - lipo_len/2, floor_t + xiao_thk + 0.2])
            cube([lipo_wid, lipo_len, lipo_thk]);

    // VHB tape pad visualization
    color("Black", 0.4)
        translate([0, 0, -0.5])
            hull() {
                translate([0, pod_h/2 - pad_margin - fillet_r, 0])
                    hull() {
                        for (sx=[-1,1])
                            translate([sx*(pod_top_w/2-pad_margin-fillet_r),0,0])
                                cylinder(r=fillet_r-1, h=0.6, $fn=20);
                    }
                translate([0, -(pod_h/2-pad_margin-fillet_r), 0])
                    hull() {
                        for (sx=[-1,1])
                            translate([sx*(pod_bot_w/2-pad_margin-fillet_r),0,0])
                                cylinder(r=fillet_r-1, h=0.6, $fn=20);
                    }
            }
}

// ============================================================
// RENDER
// ============================================================
if      (SHOW == "top")     top_shell();
else if (SHOW == "bottom")  bottom_shell();
else                        assembly();

// ============================================================
// QUICK REFERENCE — Key dimensions  (v4.0)
// ============================================================
// Pod exterior:        34mm wide (top) → 27mm wide (bottom) × 30mm tall × 11mm thick
// vs v2.1 original:    was 44 × 13mm × 38mm  (~52% volume reduction)
// Taper follows:       JOOLA Perseus throat — verify pod_top_w against your paddle
// Button layout:       2-button — Red (left) Blue (right), centered on face
//   Short press:       score for that team
//   Hold ≥ 1.5s:       undo last point
//   Hold ≥ 3.0s:       reset game
// Clip arms:           TOP of pod only — clips over 5.49mm edge guard (measured)
// VHB recess:          Full-length back face, 0.8mm deep
// XIAO nRF52840:       22 × 18.5 × 4mm pocket (z: floor to floor+4mm)
// LiPo battery:        13 × 26 × 3.5mm pocket (z: floor+4mm to floor+7.5mm, stacked above XIAO)
//   Recommended cell:  251225  (2.5mm × 12mm × 25mm, ~60mAh) or 301225 (~80mAh)
// USB-C cutout:        9 × 4mm through TOP wall — programs XIAO + charges LiPo
// Assembly:            4× M1.6 screws (corner positions adapt to taper)
// Material:            TPU 95A recommended (flexible, grippy clip arms)
// Phase 2 chip:        Seeed XIAO nRF52840 (21 × 17.5mm)
// Phase 3 chip:        Raytac MDBT50Q (15.5 × 10.5 × 2mm) — custom PCB
// ============================================================
