# Agent rules (this repo)

CAD workspace for the Grok Build ↔ Grok Bot OpenSCAD loop.

- Read `PROTOCOL.md` before writing a part or applying a review.
- Active model path is `loop/STATUS.md` field `model:`.
- Only Grok Build edits `scad/*.scad`. Only Grok Bot writes `review/REVIEW.md` and PNGs under `renders/`.
- After any model change: increment `round`, set `status: awaiting_bot_review`, rewrite `loop/HANDOFF.md` as the paste for Grok Bot.
- After a Bot `FAIL`: fix `must-fix` and `print-risk` ids listed in `review/REVIEW.md`, then hand off again. Do not invent extra geometry the spec does not ask for.
- Export STL to `export/` only when STATUS is `passed_bot` (or the user explicitly asks for a draft STL).
- Units: millimetres. Holes and cuts overlap the solid by a small epsilon (0.01–0.1 mm).
- Talk to the user in Traditional Chinese. Keep `.scad` identifiers and protocol field names in English.
