# OpenSCAD print loop (Grok Build + Grok Bot)

You describe a real object. **Grok Build** writes the `.scad`. **Grok Bot** opens it in OpenSCAD on the Bot’s cloud computer, looks at the solid, and files correction requests. Grok Build patches. You only do the last print check.

Official Grok Build cannot send a message into Grok Bot. This repo is the shared inbox.

```
you (requirement)
    → Grok Build writes spec + .scad + loop/HANDOFF.md
        → you paste HANDOFF to Grok Bot (or git push, then tell Bot to pull)
            → Bot: install OpenSCAD, CLI renders, GUI orbit
            → Bot writes review/REVIEW.md + HANDOFF for Build
        ← you paste that back into Grok Build (or git pull)
    → Build fixes, new HANDOFF
    → … until Bot PASS
you open STL, then print
```

## This computer

Project root: `C:\Users\leung\openscad-print-loop`

Open Grok Build **in this folder** (`cd` then `grok`).

## First-time Bot setup

Follow `grok-bot/CREATE_THIS_BOT.md`. Smoke-test with `scad/smoke_test.scad` before a real assignment.

## Contract

`PROTOCOL.md` is the source of truth for file formats and who may edit what.

## Git (recommended)

```text
cd C:\Users\leung\openscad-print-loop
git remote add origin <your empty GitHub repo>
git push -u origin main
```

Then the Bot clones that URL to `/workspace/openscad-print-loop`.
