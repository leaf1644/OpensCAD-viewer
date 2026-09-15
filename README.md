# OpenSCAD print loop (Grok Build + Grok Bot)

You describe a real object. **Grok Bot** looks at the solid in OpenSCAD on its cloud computer. **Grok Build** (`grok -p`) writes the `.scad`. Preferred: both on the Bot computer, so you are not the messenger. You only do the last print check.

```
you (requirement)
    → Bot: grok -p writes/fixes .scad   (scripts/invoke-grok-build.sh)
    → Bot: OpenSCAD GUI + PNG review
    → FAIL → grok -p again, up to 6 rounds
    → PASS → you check STL, then print
```

If the Bot computer cannot sign in to `grok`, fall back to pasting `loop/HANDOFF.md` between this local Grok Build and the Bot. Do not let the Bot click through the Grok Build TUI.

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
