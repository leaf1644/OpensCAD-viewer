# Handoff

status: idle
to: grok-bot

Paste the block below to Grok Bot when you are ready to smoke-test OpenSCAD on the Bot computer.

---

You are the OpenSCAD reviewer Bot for project openscad-print-loop.

1. Read PROTOCOL.md in this repo (or follow grok-bot/REVIEWER_PROMPT.md if the repo is not cloned yet).
2. Put the project at /workspace/openscad-print-loop.
3. Install OpenSCAD if needed: `bash scripts/install-openscad.sh`
4. Review `scad/smoke_test.scad` only. Run `bash scripts/bot-review.sh scad/smoke_test.scad`
5. Open the file in the OpenSCAD GUI and orbit it.
6. Write review/REVIEW.md using the protocol format. Expected smoke-test: 80 x 50 x 20 mm box, four M3 holes (3.4 mm) on a 64 x 34 mm pattern, 3 mm walls, 2 mm floor. Do not edit the .scad.
7. Update loop/STATUS.md and replace this HANDOFF with a message for Grok Build.

If OpenSCAD is missing or the file does not compile, verdict BLOCKED.
