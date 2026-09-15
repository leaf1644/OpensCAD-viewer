# Create the reviewer Bot (once)

Preferred: the Bot computer runs **OpenSCAD and** the `grok` CLI, so reviews and code fixes stay on that machine. You still create the Bot once. You are not the messenger after `grok login` works.

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

6. Smoke test OpenSCAD: paste the current `loop/HANDOFF.md` to the Bot.
7. Then tell the Bot: `bash scripts/install-grok-build.sh` and try `grok --version`. If it asks to log in, take over Agent Computer, run `grok login` in the Bot terminal, or submit an API key through the Bot secure form (not chat).
8. Confirm a dummy `grok -p "reply PONG only"` works. After that, the Bot should call `scripts/invoke-grok-build.sh` itself instead of asking you to paste reviews back here.

## Each real part afterwards

1. Tell this Grok Build **or** the Bot the object (sizes, what it must fit).
2. If Bot `grok` works: one message to the Bot — run the tight loop in PROTOCOL.md. You wait until it says PASS or hits 6 rounds.
3. If Bot `grok` does not work: paste `loop/HANDOFF.md` each round as before.
4. You open the STL / OpenSCAD yourself, then print.
