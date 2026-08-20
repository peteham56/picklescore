// ============================================================
// PickleScore™ Throat Pod Enclosure — v4.0  2-BUTTON / LIPO
// Parametric OpenSCAD model
// ============================================================
// WHAT'S NEW IN v4.0:
//   - Height 24mm — XIAO long side (21mm) along pod height, USB-C at bottom wall
//   - USB-C bottom wall (y-): cable exits toward grip, fully clear of clip arms
//   - Clip gap updated to 7.5mm (measured JOOLA Perseus lip at top)
//   - Bottom width 28mm (measured 24.5mm paddle center + wall clearance)
//   - 2-button layout: Red (A) left, Blue (B) right — 0.8mm TPU membrane domes
//   - LiPo 301225 stacked above XIAO in z — charges via USB-C through XIAO charger
//   - VHB tape recess on back face for secondary adhesion
// ============================================================
// v4.1 FIX (found before 3rd reprint):
//   - bot_h (=floor+XIAO+LiPo) left NO room for the 5mm switches — the
//     LiPo pocket's top surface was flush with the button membrane, so a
//     seated switch would sit directly on top of the battery pouch.
//   - Fix: raised bosses (btn_boss_h=4mm) added under each button so the
//     switch cavity sits clear of the LiPo stack, without thickening the
//     rest of the (slim) pod.
// ============================================================
// PHASE 2 NOTE:
//   Prototype uses Seeed XIAO nRF52840 (21×17.5mm).
//   Phase 3 production: Raytac MDBT50Q bare module (15.5×10.5×2mm)
//   on custom PCB — pod shrinks to fit entirely within throat zone.
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

SHOW = "top";   // "assembly" | "top" | "bottom"

// ── Tapered body dimensions ──────────────────────────────────
// Trapezoid: wide at top (paddle face level), narrow at bottom (grip)
pod_h      = 24;    // mm — XIAO long side (21mm) along height; needs 22mm + margin
pod_top_w  = 47.0;  // mm — measured: 65mm total paddle width − 2×9mm lips at 24mm height
pod_bot_w  = 30.0;  // mm — widened from 28mm 2026-08-20: at 28mm the lower screw
                     // bosses (x=±9, same formula as xiao_wid/2=9) sat flush against
                     // the XIAO pocket edge with zero clearance — inserting the rigid
                     // board flexed/bent the boss sideways, throwing off the lower
                     // screw holes relative to the top shell. 30mm gives room to move
                     // the bosses clear (see boss_inset_x_bot below).
pod_thk    = 11.3;  // mm — floor(1.5) + XIAO(4) + LiPo(3.5) + top(1.8) stacked

// ── Shell thicknesses ────────────────────────────────────────
wall_t   = 1.8;  // mm — outer wall thickness all sides
top_t    = 1.8;  // mm — button face shell thickness
top_rim_h = 1.5;  // mm — perimeter wall height above top_t (edge strength at hidden seam; screw holes here are clearance-only, not threaded)
bot_h    =  9;  // mm — floor(1.2) + XIAO(4) + LiPo(3.5) stacked
floor_t  = 1.5;  // mm — bottom floor thickness (leaves 1.1mm under VHB recess)

// ── Clip arms (grip paddle edge — TOP of pod only) ───────────
clip_gap    =  9.0;  // mm — JOOLA Perseus lip width at top of pod (measured at 24mm height)
clip_len    = 10.0;  // mm — arm length reaching over edge
clip_thk    =  1.8;  // mm — arm wall thickness
clip_offset = 10.0;  // mm — inset from left/right ends at top

// ── Button hole1s (inverted-triangle on tapered face) ─────────
// Positioned in upper portion of pod face, centered
btn_A_x  =  -8;  btn_A_y =   5;  // Red  (left)  — short press = A scores, long = undo, 3s = reset
btn_B_x  =   8;  btn_B_y =   5;  // Blue (right) — short press = B scores, long = undo, 3s = reset

// Switch cavity footprint (stadium: two hulled circles) — sized for the
// Same Sky TS40 SMD switch's actual solderable footprint (gull-wing legs
// splayed past the 6x6mm body), per datasheet recommended pad layout:
// 10.0mm x 5.6mm envelope. A plain r=5.0mm round bore (fit only to the
// 6x6mm body) clips the leg corners by ~0.8mm — this replaces it.
btn_cav_r        = 3.1;  // mm — stadium end-cap radius (= half the 6.2mm short dimension, incl. tolerance)
btn_cav_x_offset = 2.1;  // mm — offset of each end-cap center from button center (long axis = x)
                          //      total length = 2*btn_cav_x_offset + 2*btn_cav_r = 10.4mm

// ── Button boss (raised turret over each button) ─────────────
// Button footprint sits directly over the LiPo pocket (bot_h is sized
// exactly floor+XIAO+LiPo, with no allowance for switch height) — this
// raises the switch cavity clear of the battery instead of growing the
// whole pod's thickness.
// Sized for a 3.5mm-tall tactile switch (was 5mm) — lower-profile part,
// purchase 6x6x3.5mm switches to replace the 6x6x5mm ones on hand.
btn_switch_h = 3.5;  // mm — tactile switch height (was 5.0mm)
btn_boss_h = 2.5;  // mm — extra height added above the main shell face (was 4.0mm)
btn_boss_r = 7.0;  // mm — boss outer radius (clears the 10.4mm-long stadium cavity's end tips by ~1.8mm wall)
btn_boss_total_h = top_t + top_rim_h + btn_boss_h;  // full boss height from shell base (z=0)
btn_dome_cap_h = 1.2;  // mm — height of the rounded "bubble" cap (flattened, not a full ball)
btn_membrane_t  = 0.8;  // mm — membrane thickness left at the boss tip (user-press surface)
btn_seat_clear  = 0.2;  // mm — clearance above switch body before membrane (fit tolerance/glue)
// Switch cavity is uniformly switch-width for its FULL depth, open at the
// base (parting line, z=0) so the switch can be dropped in from inside
// during assembly and slides straight up until its top lands snug against
// the membrane underside — no narrower choke point anywhere along the path.
// (Previously had a narrow "wire bore" stage below a wider switch pocket —
// backwards for an SMD switch inserted whole, not through a pin hole.)
btn_switch_bore_h = btn_switch_h + btn_seat_clear;  // depth of switch-body bore, directly under membrane
btn_seat_z = btn_boss_total_h - btn_membrane_t - btn_switch_bore_h;  // z height where the switch body starts (visual/position reference only, no shoulder)
btn_cavity_total_h = btn_seat_z + btn_switch_bore_h;  // full open cavity height, z=0 up to just under the membrane

// ── XIAO nRF52840 pocket (long side along pod height) ────────────────
// Board: 21mm long × 17.5mm wide — long side runs along pod height (y)
// USB-C faces bottom wall (y-)
xiao_len  = 22.0;  // mm — board long side (21mm) + 1mm clearance, along pod height (y)
xiao_wid  = 18.0;  // mm — board short side (17.5mm) + 0.5mm clearance, along pod width (x)
xiao_thk  =  4.0;  // mm — board + component height
xiao_y    =  0;    // mm — centered in pod
xiao_x    =  0;    // mm — centered in pod
usbc_w    =  9.0;  // mm — USB-C cutout width (along x)
usbc_h    =  4.0;  // mm — USB-C cutout height (along z)

// ── LiPo battery (stacked above XIAO in z, rotated 90°) ──────────────
// Target: 301225 (3mm × 12mm × 25mm, ~60mAh) — short 12mm side along pod height
// XIAO nRF52840 has built-in LiPo charger — USB-C charges both
lipo_len   = 13.0;  // mm — cell short side (12mm) + 1mm clearance, along pod height (y)
lipo_wid   = 26.0;  // mm — cell long side (25mm) + 1mm clearance, along pod width (x)
lipo_thk   =  3.5;  // mm — 3mm cell + 0.5mm clearance
lipo_y     =    0;  // mm — centered in pod
lipo_x     =    0;  // mm — centered in pod

// ── VHB adhesive pad recess (full back face) ─────────────────
// Slightly inset from edges for clean appearance
pad_margin = 4;    // mm — margin from pod edge
pad_depth  = 0.4;  // mm — recess depth (0.4mm leaves 0.8mm floor, no fiber bleed-through)

// ── Screw bosses (M1.6) ──────────────────────────────────────
boss_r     = 1.8;
boss_h     = 7.5;  // reaches near parting plane so top-entry screws engage immediately
screw_r    = 0.85;
boss_inset_x     = 5.0;  // mm from left/right edge — TOP row only (pod_top_w=47, no XIAO conflict)
// BOTTOM row: xiao_wid=18mm pocket occupies x=-9..+9. Boss must clear that edge
// by boss_r + margin, i.e. center at >= 9 + 1.8 + 1.0 = 11.8mm. With the widened
// pod_bot_w=30mm (half=15), that's boss_inset_x_bot = 15 - 11.8 = 3.2mm.
boss_inset_x_bot = 3.2;  // mm from left/right edge — BOTTOM row (clears XIAO pocket, see pod_bot_w note above)
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

// Switch-body cavity footprint — stadium shape (hull of two circles) sized
// to the TS40's actual 10.0x5.6mm SMD leg footprint, not just the 6x6mm body.
module switch_cavity(h) {
    hull() {
        translate([-btn_cav_x_offset, 0, 0]) cylinder(r=btn_cav_r, h=h, $fn=32);
        translate([ btn_cav_x_offset, 0, 0]) cylinder(r=btn_cav_r, h=h, $fn=32);
    }
}

// Rounded "bubble" button boss — cylindrical wall + gently flattened dome cap
// (not a full hemisphere — dome_cap_h keeps it a soft bump, not a ball)
module bubble_boss(r, total_h, dome_cap_h) {
    cyl_h = total_h - dome_cap_h;
    union() {
        cylinder(r=r, h=cyl_h, $fn=48);
        translate([0, 0, cyl_h])
            scale([1, 1, dome_cap_h / r])
                sphere(r=r, $fn=48);
    }
}

// ============================================================
// TOP SHELL (button face)
// ============================================================
module top_shell() {
    difference() {
        union() {
            // Outer tapered body — solid slab, full height (top_t + top_rim_h).
            // Previously this had a hollow ring cut into the top_rim_h portion
            // (pure material savings); filled solid per user request so the
            // rim is as solid as the shell around it — no height change, no
            // overlap with the bottom shell (rim sits entirely above bot_h,
            // world Z 10.8-12.3mm, well clear of the component cavity below).
            tapered_body(top_t + top_rim_h);

            // Raised bubble bosses — lift switch cavities clear of the LiPo stack below
            translate([btn_A_x, btn_A_y, 0])
                bubble_boss(btn_boss_r, btn_boss_total_h, btn_dome_cap_h);
            translate([btn_B_x, btn_B_y, 0])
                bubble_boss(btn_boss_r, btn_boss_total_h, btn_dome_cap_h);
        }

        // Button A — full-width cavity, open at the interior (z=0), switch
        // drops straight in and slides up until it lands snug under the membrane
        translate([btn_A_x, btn_A_y, 0])
            switch_cavity(btn_cavity_total_h);

        // Button B — same
        translate([btn_B_x, btn_B_y, 0])
            switch_cavity(btn_cavity_total_h);

        // Screw clearance holes — M1.6 screws enter from button face, self-tap into bottom bosses
        for (sx = [-1, 1]) {
            translate([sx*(pod_top_w/2 - boss_inset_x),  pod_h/2 - boss_inset_y, -0.1])
                cylinder(r=screw_r + 0.1, h=top_t + 1.6 + 0.2, $fn=16);
            translate([sx*(pod_bot_w/2 - boss_inset_x_bot), -(pod_h/2 - boss_inset_y), -0.1])
                cylinder(r=screw_r + 0.1, h=top_t + 1.6 + 0.2, $fn=16);
        }
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

        // USB-C port — bottom wall, centered in x (cable exits toward grip)
        translate([-usbc_w/2, -pod_h/2 - 0.1, floor_t + 0.5])
            cube([usbc_w, wall_t + 2.0, usbc_h]);

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

    }

    // Screw bosses at 4 corners (adapting to taper)
    screw_boss(-(pod_top_w/2 - boss_inset_x),  pod_h/2 - boss_inset_y,  floor_t);
    screw_boss( (pod_top_w/2 - boss_inset_x),  pod_h/2 - boss_inset_y,  floor_t);
    screw_boss(-(pod_bot_w/2 - boss_inset_x_bot), -(pod_h/2 - boss_inset_y), floor_t);
    screw_boss( (pod_bot_w/2 - boss_inset_x_bot), -(pod_h/2 - boss_inset_y), floor_t);
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

    // Tactile switches — 6×6×3.5mm, seated on the boss counterbore shoulder
    color("DimGray", 0.9) {
        translate([btn_A_x - 3, btn_A_y - 3, bot_h + btn_seat_z])
            cube([6, 6, btn_switch_h]);
        translate([btn_B_x - 3, btn_B_y - 3, bot_h + btn_seat_z])
            cube([6, 6, btn_switch_h]);
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
// Pod exterior:        47mm wide (top) → 28mm wide (bottom) × 24mm tall × 11mm thick
// Taper follows:       JOOLA Perseus throat — measured: 65mm total × 9mm lips at top; 28mm at bottom
// Lips:                9mm at top (measured at 24mm height) — clip arms span full lip width
// Components:          XIAO long side (21mm) along pod height; USB-C at bottom wall (y-)
// USB-C:               Bottom wall, centered — cable exits toward grip, fully clear of clip arms
// Button layout:       2-button — Red (left) Blue (right), centered on face
//   Short press:       score for that team
//   Hold ≥ 1.5s:       undo last point
//   Hold ≥ 3.0s:       reset game
// Clip arms:           TOP of pod only — clips over 7.5mm lip (measured; bottom lip is 6.4mm)
// VHB recess:          Full-length back face, 0.4mm deep (0.8mm floor remaining)
// XIAO nRF52840:       18 × 22 × 4mm pocket (z: floor to floor+4mm); long side along y, USB-C at bottom
// LiPo battery:        26 × 13 × 3.5mm pocket (z: floor+4mm to floor+7.5mm, stacked above XIAO)
//   Recommended cell:  301225 (3mm × 12mm × 25mm, ~60mAh)
// USB-C cutout:        9 × 4mm through BOTTOM wall (y-) — programs XIAO + charges LiPo
// Assembly:            4× M1.6 × 6mm screws — enter from button face, self-tap into bottom bosses (7.5mm tall)
// Material:            TPU 95A recommended (flexible, grippy clip arms)
// Phase 2 chip:        Seeed XIAO nRF52840 (21 × 17.5mm)
// Phase 3 chip:        Raytac MDBT50Q (15.5 × 10.5 × 2mm) — custom PCB
// ============================================================
