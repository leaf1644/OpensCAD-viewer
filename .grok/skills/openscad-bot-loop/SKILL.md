---
name: openscad-bot-loop
description: >
  OpenSCAD CAD loop with Grok Bot as visual reviewer. Use when the user describes
  a physical object to model, pastes a Bot review/HANDOFF, says print, OpenSCAD,
  or Grok Bot CAD.
---

# OpenSCAD ↔ Grok Bot loop

Project root: `C:\Users\leung\openscad-print-loop`

Read `PROTOCOL.md` in that folder. Follow it. Do not improvise a second protocol.

## When the user describes a real object

1. Write files **only** under that project root (not the home directory).
2. Replace `spec/SPEC.md` with mm dimensions, fit constraints, print notes.
3. Write `scad/<short_name>.scad` (parametric, overlapped cuts, `$fn` for print).
4. Update `loop/STATUS.md`: increment `round`, `status: awaiting_bot_review`, set `model:`.
5. Write `loop/HANDOFF.md` as the exact English message for Grok Bot (model path, round, what to inspect).
6. Tell the user to paste that handoff to the OpenSCAD Reviewer Bot (after `git push` if they use git). Stop. Do not pretend the Bot has already seen the model.

## When the user returns a Bot review

Read `review/REVIEW.md` (or the pasted text). Apply `must-fix` and `print-risk` only. Hand off again. Do not edit `.scad` on a `PASS`.

## Print

Export STL under `export/` after Bot `PASS`. User does the last visual check. Set `user_print_ready` only when they confirm.

## Smoke test

If they have not yet proven the Bot can open OpenSCAD, ask them to send the current `loop/HANDOFF.md` for `scad/smoke_test.scad` before a real part.
