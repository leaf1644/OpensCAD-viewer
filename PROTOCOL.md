# CAD loop protocol

Grok Build writes OpenSCAD. Grok Bot reviews the model on **its cloud computer** with OpenSCAD. The user is the messenger until git remote is connected. The user does the final print check.

There is no official API between Grok Build and Grok Bot. The contract is these files.

## Roles

| Role | Who | May edit |
|---|---|---|
| Designer | Grok Build (this coding agent) | `scad/`, `spec/`, `loop/STATUS.md`, `loop/HANDOFF.md` |
| Reviewer | Grok Bot | `review/`, `renders/`, `loop/STATUS.md`, `loop/HANDOFF.md` |
| Printer | User | final yes/no to print; never skip Bot PASS |

Grok Bot **must not** edit `.scad` files. If geometry is wrong, it files a correction request. Grok Build **must not** mark print-ready until Bot verdict is `PASS` and the user confirms.

## Files

| Path | Owner | Meaning |
|---|---|---|
| `spec/SPEC.md` | Build | What the real object must do and measure |
| `scad/*.scad` | Build | The model. One active file named in STATUS |
| `review/REVIEW.md` | Bot | Latest review only |
| `renders/` | Bot | PNG views + `openscad.log` |
| `export/` | Build after PASS | STL / 3MF for the user to print |
| `loop/STATUS.md` | both | Machine-readable loop state |
| `loop/HANDOFF.md` | both | Paste-ready message for the other agent |

## `loop/STATUS.md` fields

```
round: <integer, starts at 0>
status: idle | awaiting_bot_review | awaiting_build_fix | passed_bot | user_print_ready | blocked
model: scad/<file>.scad
spec: spec/SPEC.md
last_review: review/REVIEW.md
blocked_reason:
notes:
```

Allowed transitions:

- `idle` → `awaiting_bot_review` (Build wrote or updated the model)
- `awaiting_bot_review` → `awaiting_build_fix` (Bot verdict `FAIL`)
- `awaiting_bot_review` → `passed_bot` (Bot verdict `PASS`)
- `awaiting_bot_review` → `blocked` (OpenSCAD missing, syntax error, cannot open GUI and cannot render)
- `awaiting_build_fix` → `awaiting_bot_review` (Build applied requested fixes)
- `passed_bot` → `user_print_ready` (user said the print check passed)
- `blocked` → `awaiting_bot_review` (block cleared) or `awaiting_build_fix` (syntax/geometry must be fixed first)

## `review/REVIEW.md` format

Bot overwrites this file each round. Required header:

```
# Review round <N>
verdict: FAIL | PASS | BLOCKED
openscad_version: <text>
render_ok: true | false
gui_opened: true | false
model: scad/<file>.scad

## Errors
- id: E1
  severity: must-fix | print-risk | nit
  where: <module or feature>
  evidence: <which PNG or GUI camera>
  request: <exact change for Grok Build>

## Spec check
| dim | spec | observed | ok |

## Printability
- manifold:
- min_wall_mm:
- holes_clearance:
- overhangs:
- sitting_face:

## Notes
```

`PASS` is allowed only if: `render_ok` is true, every `must-fix` and `print-risk` is empty, and spec dimensions that can be judged from the model match `spec/SPEC.md`. Nits may remain on `PASS`.

`FAIL` if any `must-fix` or `print-risk` exists.

`BLOCKED` if OpenSCAD cannot run, the file does not compile, or the Bot cannot see the model.

## Designer (Grok Build) steps

When the user describes a real object:

1. Write `spec/SPEC.md` from the requirement (units in mm, what it must fit, print constraints).
2. Write or update `scad/<name>.scad`. Parameterize dimensions. Use overlap on holes/cuts. `$fn` high enough for print.
3. Set STATUS `round` += 1 (or 1 if still 0), `status: awaiting_bot_review`, `model:` the active file.
4. Write `loop/HANDOFF.md` as the exact message the user pastes to Grok Bot.
5. Tell the user to send that handoff to the Bot (or `git push` then tell the Bot to pull).

When the user returns a Bot review (file, paste, or screenshot of REVIEW.md):

1. Read `review/REVIEW.md` and `spec/SPEC.md`.
2. Fix every `must-fix` and `print-risk`. Do not "fix" nits unless they are cheap and safe.
3. Increment `round`, set `status: awaiting_bot_review`, write a new HANDOFF listing which error ids were addressed.
4. Do not export STL until `passed_bot` and the user asks to print.

## Reviewer (Grok Bot) steps

On each handoff:

1. Sync the project onto the cloud computer (`/workspace/openscad-print-loop` or the path in the handoff).
2. Run `scripts/install-openscad.sh` if `openscad` is missing.
3. Run `scripts/bot-review.sh scad/<file>.scad`.
4. Open the same file in the OpenSCAD **GUI** on the Agent Computer (`openscad scad/<file>.scad &`). Orbit: isometric, front, top, right, underside. Look inside holes and difference cuts.
5. Compare what you see to `spec/SPEC.md`.
6. Write `review/REVIEW.md`. Copy PNGs already written under `renders/`.
7. Update STATUS and write `loop/HANDOFF.md` for Grok Build (verdict + error ids).
8. Do not change `.scad`.

If GUI cannot start, still fill the review from PNGs and say `gui_opened: false`. `PASS` without GUI is allowed only for the smoke test. For a real part, prefer `FAIL` or `BLOCKED` if you could not orbit the solid.

## Handoff to the user (Printer)

After Bot `PASS`, Grok Build exports STL to `export/` and sets `status: passed_bot`. The user opens the STL (or OpenSCAD) themselves, then says print OK. Only then STATUS becomes `user_print_ready`.
