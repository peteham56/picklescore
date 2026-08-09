# PickleScore

Wireless pickleball scoreboard: a paddle-mounted button pod (ThroatPod) broadcasts score/serve over BLE to a wristband display (Wristband). See `README.md` for build/flash instructions, `PickleScore/ASSEMBLY.md` for the BOM and physical build guide, and `PickleScore/PRODUCT_DIRECTION.md` for product strategy and open design work.

## Standing product decision — do not revisit without being asked

PickleScore is an **accessory**, not an integrated smart paddle. This was deliberately decided against (regulatory: USA Pickleball excludes electronics from paddle approval; customer fit: target users are paddle-loyal; manufacturing: paddles require composite layup/tooling/MOQs an accessory avoids). Do not propose or default toward integrating the electronics into the paddle itself. Full rationale in `PickleScore/PRODUCT_DIRECTION.md`.

## Current hardware

- **ThroatPod v4.1** — Seeed XIAO nRF52840, 2-button TPU membrane shell, 301225 LiPo.
- **Wristband v3.0** — Seeed XIAO ESP32-C3, 0.91" 128×32 SSD1306 OLED, 301230 LiPo, TPU 95A shell.
- Both enclosures: OpenSCAD source in `ScadFiles/`. Firmware: Arduino sketches in `PickleScore_ThroatPod/` and `PickleScore_Wristband/`.

Next-phase hardware changes under consideration (nRF52840 migration for Wristband, sunlight-readable display, magnetic charging dock, bigger ThroatPod buttons, press-confirmation haptics) are tracked as an ordered list in `PickleScore/PRODUCT_DIRECTION.md` under "Next Steps" — check there before starting new hardware work so effort matches current priority.

## Working conventions for this repo

- Before trusting any SCAD dimension as ground truth, cross-check it against the actual `difference()`/`union()` cut features, not just the `assembly()` preview — several past bugs were preview-only geometry that never existed in the real shells (see memory / git history).
- Before a print order, dry-fit-and-measure real components (calipers) rather than trusting assumed dimensions — this has caught stack-height and interference bugs before wasted reprints.
- Verify OpenSCAD renders (`openscad -o out.stl file.scad`, check for "Simple: yes" / no CGAL errors) before treating a `.scad` change as print-ready.
- LiPo battery pads are bare solder pads (no pre-installed JST plug) on XIAO boards — verify polarity with a multimeter before soldering, don't trust wire color alone.
