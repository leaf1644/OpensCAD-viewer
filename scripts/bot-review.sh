#!/usr/bin/env bash
# Render multi-view PNGs of a .scad file for the reviewer Bot.
# Usage: bash scripts/bot-review.sh scad/smoke_test.scad
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MODEL="${1:-}"
if [ -z "$MODEL" ]; then
  if [ -f loop/STATUS.md ]; then
    MODEL="$(awk -F': ' '/^model:/{print $2; exit}' loop/STATUS.md | tr -d '\r')"
  fi
fi
if [ -z "$MODEL" ]; then
  echo "usage: bash scripts/bot-review.sh scad/<file>.scad" >&2
  exit 1
fi
if [ ! -f "$MODEL" ]; then
  echo "missing model: $MODEL" >&2
  exit 1
fi

if ! command -v openscad >/dev/null 2>&1; then
  bash "$ROOT/scripts/install-openscad.sh"
fi
if ! command -v openscad >/dev/null 2>&1; then
  echo "BLOCKED: openscad not on PATH" >&2
  exit 1
fi

STEM="$(basename "$MODEL" .scad)"
OUT="$ROOT/renders/$STEM"
mkdir -p "$OUT"
LOG="$OUT/openscad.log"
: > "$LOG"

echo "openscad $(openscad --version 2>&1 | tr '\n' ' ')" | tee -a "$LOG"
echo "model $MODEL" | tee -a "$LOG"

# Compile check (CSG render to STL in /tmp-equivalent under renders).
STL="$OUT/check.stl"
set +e
openscad -o "$STL" --render "$MODEL" >>"$LOG" 2>&1
rc=$?
set -e
if [ "$rc" -ne 0 ] || [ ! -s "$STL" ]; then
  echo "COMPILE_FAIL rc=$rc" | tee -a "$LOG"
  echo "See $LOG" >&2
  exit 2
fi
echo "COMPILE_OK $STL" | tee -a "$LOG"

# camera = translatex,y,z, rotx,y,z, dist  --viewall --autocenter
render_view() {
  local name="$1"
  shift
  local png="$OUT/${name}.png"
  set +e
  openscad -o "$png" --imgsize=1280,960 --render --viewall --autocenter \
    --projection=o "$@" "$MODEL" >>"$LOG" 2>&1
  local vrc=$?
  set -e
  if [ "$vrc" -ne 0 ] || [ ! -s "$png" ]; then
    echo "VIEW_FAIL $name rc=$vrc" | tee -a "$LOG"
    return 0
  fi
  echo "VIEW_OK $png" | tee -a "$LOG"
}

# rot: x, y, z (OpenSCAD --camera after the three translate zeros)
render_view iso   --camera=0,0,0,55,0,25,400
render_view front --camera=0,0,0,90,0,0,400
render_view top   --camera=0,0,0,0,0,0,400
render_view right --camera=0,0,0,90,0,90,400
render_view under --camera=0,0,0,90,180,0,400

echo "PNG_DIR $OUT"
echo "Next: open GUI with:  openscad $MODEL"
echo "Then write review/REVIEW.md  (do not edit the .scad)"
