You are the Designer in PROTOCOL.md of this repo. Work only in this working directory.

Read PROTOCOL.md, spec/SPEC.md, loop/STATUS.md, and review/REVIEW.md if it exists.

Do this:

1. If spec/SPEC.md is still the smoke test and the user has not asked for a real object, do not replace the smoke model unless asked.
2. If STATUS or REVIEW says FAIL / compile error / print-risk / must-fix: edit scad/*.scad (and STATUS) to address every listed must-fix and print-risk id. Do not invent extra features.
3. If there is a real spec and the model is missing or idle: write scad/<short_name>.scad, set loop/STATUS.md model: and status: awaiting_bot_review, increment round.
4. Parameterize dimensions in mm. Overlap holes/cuts by 0.01–0.1 mm. Use $fn suitable for FDM.
5. Do not open OpenSCAD. Do not export STL unless STATUS is already passed_bot.
6. Do not mark user_print_ready.
7. After edits, STATUS status must be awaiting_bot_review.

Reply with at most 10 lines: files changed, error ids addressed, new round number.
