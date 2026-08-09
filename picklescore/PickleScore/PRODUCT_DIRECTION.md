# PickleScore — Product Direction & Design Notes

Last updated: 2026-08-09

## Product goal

A scorekeeping aid for older recreational pickleball players who have trouble tracking the score and who is serving. Two devices:

- **ThroatPod** — paddle-mounted BLE button pod (XIAO nRF52840). Two buttons; one press after each point.
- **Wristband** — BLE score display (currently XIAO ESP32-C3 + OLED).

Firmware is tested and working.

## Decision: accessory, not an integrated paddle

An integrated "smart paddle" was considered and rejected. Reasons:

- **Regulatory.** USA Pickleball's approval criteria exclude electronics. An integrated paddle can never be listed as approved, so it can't be marketed as tournament-legal, and organized leagues that inspect paddles are closed off. With an accessory, the customer keeps a legal paddle for sanctioned play.
- **Customer fit.** The target demographic is paddle-loyal — weight, grip circumference, and control choices are often tied to shoulder or elbow history. "Use the paddle you already own" is a far smaller ask than "replace your paddle."
- **Manufacturing.** Paddles are composite layup: contract manufacturer, tooling, MOQs in the hundreds to thousands, inventory capital, warranty exposure on a $100+ item. An accessory can be printed in batches of 20 and revised weekly.

If integration is ever revisited: validate demand with the accessory first, then approach an established paddle maker about a white-label version. Bring proven demand + firmware; they bring molds and distribution.

## Next phase — open design work

### Wristband

- Consider moving from XIAO ESP32-C3 to XIAO nRF52840. The ESP32-C3 BLE stack draws considerably more idle current. In a Fitbit-sized battery (~100–150 mAh) that is roughly "charge nightly" vs. "charge weekly." Also collapses both devices onto one toolchain and one firmware idiom.
- Display: OLED washes out in direct sun, which is the primary use condition. Evaluate a reflective segment LCD (sunlight improves readability, near-zero power draw) or e-paper. The display only needs three large digits — target ~12 mm digit height, not graphics.
- Thickness is driven by battery and connector, not the PCB. A USB-C receptacle is often the tallest component. Two magnetic pogo pins + a small dock allows a sealed case and easier handling for arthritic hands.
- Consider standard 20 mm strap lugs so straps can be sourced rather than designed.

### ThroatPod

- Buttons are the core design tension. Slimming pushes toward low-travel domes, but users with reduced finger sensation need clear tactile feedback and a target findable without looking. Bias toward larger, well-separated, higher-force domes even at a cost of 1–2 mm of height.
- Add press confirmation — a short haptic buzz or chirp on the wristband when a press registers. A silently missed press produces a wrong score, and one wrong score permanently destroys user trust in the system.
- Mounting must not rotate under sweat over a two-hour session, and must fit throat geometries that vary across paddle brands. A conformable pad plus a wraparound strap generalizes better than a rigid printed cradle sized to one paddle.

## Open question

Is the user's real bottleneck pressing something, or remembering to? If the latter, an audible spoken score ("four, two, two") from a small speaker may be a stronger differentiator than any display — and that is a firmware change, not a hardware one.

## Next Steps

Concrete follow-ups derived from the open design work above. Ordered roughly by priority; item 0 gates the display work.

0. **Resolve the open question first.** Ask the target user directly: is the bottleneck *pressing* the button or *remembering* to press it? If remembering is the real problem, prioritize a spoken-score firmware feature (below) over any display hardware change — don't sink time into segment-LCD/e-paper evaluation until this is answered.
1. **Wristband: nRF52840 power comparison.** Order one XIAO nRF52840, flash a minimal BLE-advertise-scan loop matching current Wristband behavior, and bench-measure idle current draw against the existing ESP32-C3 build. Decide migration only after seeing real numbers, not the datasheet estimate.
2. **Wristband: display eval.** Source one reflective segment LCD module and one e-paper module sized for 3 large digits (~12mm height). Bench-test outdoor/direct-sun legibility against the current OLED before committing to a redesign. Blocked by item 0.
3. **Wristband: charging dock.** Prototype a 2-pin magnetic pogo dock as an alternative to the USB-C receptacle cutout — evaluate whether it actually shrinks enclosure thickness enough to justify redesigning `picklscore_wristband_v2.scad`'s connector wall.
4. **Wristband: strap lugs.** Current SCAD already targets 20mm lugs (see shopping list: 20mm silicone band + spring bars) — verify a generic off-the-shelf 20mm band fits the current `_lug_cap()` geometry before treating this as open.
5. **ThroatPod: button rework.** Source larger/higher-force tactile domes (bigger footprint, more separation) and update `picklscore_throat_pod_v2_1.scad`'s button boss geometry, accepting 1–2mm added height at the button location.
6. **ThroatPod → Wristband: press confirmation.** Requires a haptic motor or piezo buzzer added to the Wristband BOM/enclosure (no such component exists today) plus a firmware ack: Wristband fires haptic/tone immediately on receiving a real score-changing BLE packet from ThroatPod. Scope as a small hardware + firmware addition, not a ThroatPod change.
7. **ThroatPod: mounting rework.** Design a conformable pad + wraparound strap mount to replace the current rigid JOOLA-Perseus-specific clip; validate fit against at least one other paddle brand's throat geometry.
8. **Spoken-score firmware (conditional on item 0).** If remembering is the real bottleneck, add a small speaker to the Wristband and a firmware path that speaks the score ("four, two, two") on each real change — pure firmware/BOM addition, no new enclosure geometry required beyond a speaker cutout.

## Tooling notes

- Enclosure geometry: OpenSCAD (text-based, so Claude Code can write and iterate on it directly) or FreeCAD for contour-matching work.
- Concept renders, product naming, packaging, and a landing page for early testers: Claude Design.
- Claude Design cannot produce CAD or printable geometry.
