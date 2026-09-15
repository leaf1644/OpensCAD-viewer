# Create the reviewer Bot (once)

Grok Build cannot message Grok Bot. You create one Bot and then paste `loop/HANDOFF.md` each round.

## Need

- Grok Bot desktop app ([x.ai/bot](https://x.ai/bot))
- Eligible plan (SuperGrok Plus/Heavy or paid Cursor)
- This folder on a git remote **or** willingness to copy the folder onto the Bot computer

## Steps

1. Open Grok Bot → New Agent.
2. Name: `OpenSCAD Reviewer`
3. Paste the full text of `REVIEWER_PROMPT.md` into the Bot description / job.
4. Open **Agent Computer**. Confirm you can see a Linux desktop.
5. Copy this project onto the Bot computer, pick one:

**A. Git (best)**

```text
On your PC, in openscad-print-loop:
  git remote add origin <your GitHub repo URL>
  git push -u origin main

Then tell the Bot:
  Clone <URL> to /workspace/openscad-print-loop and review scad/smoke_test.scad
```

**B. Copy files**

In the Bot conversation, attach this project (zip) or ask the Bot to save uploaded `.scad` + `PROTOCOL.md` + `scripts/` under `/workspace/openscad-print-loop`. Then paste `loop/HANDOFF.md`.

**C. Local execution (optional)**

If you enable Settings → Agent → Execution on Local Computer, the Bot can read `C:\Users\leung\openscad-print-loop` on this PC. Keep approval on. The OpenSCAD GUI it uses for review should still be the **cloud** Agent Computer, not silently driving your desktop.

6. Smoke test: paste the current `loop/HANDOFF.md` to the Bot.
7. When it writes a review, paste `loop/HANDOFF.md` / `review/REVIEW.md` back into Grok Build (or `git pull` here and say “Bot finished round N”).

## Each real part afterwards

1. Tell Grok Build the object (sizes, what it must fit).
2. Grok Build updates `spec/`, `scad/`, `loop/HANDOFF.md`.
3. You paste that handoff to the Bot (after `git push` if using git).
4. Bot reviews → you paste the Bot handoff back here.
5. Repeat until Bot `PASS`.
6. You open the STL / OpenSCAD yourself, then print.
