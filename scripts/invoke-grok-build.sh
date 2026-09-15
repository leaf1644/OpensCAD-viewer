#!/usr/bin/env bash
# Headless Designer step. Grok Bot calls this; it must not edit .scad by hand.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export PATH="$HOME/.local/bin:$HOME/.grok/bin:/usr/local/bin:$PATH"

if ! command -v grok >/dev/null 2>&1; then
  bash "$ROOT/scripts/install-grok-build.sh"
fi
if ! command -v grok >/dev/null 2>&1; then
  echo "BLOCKED: grok CLI missing" >&2
  exit 1
fi

PROMPT_FILE="$ROOT/loop/BUILD_PROMPT.md"
if [ ! -f "$PROMPT_FILE" ]; then
  echo "missing $PROMPT_FILE" >&2
  exit 1
fi

# Extra instruction from the Bot (error ids, round notes) — optional argv.
EXTRA="${1:-}"

echo "invoke grok in $ROOT"
set +e
grok --no-auto-update --always-approve --cwd "$ROOT" --max-turns 40 \
  --output-format plain \
  -p "$(cat "$PROMPT_FILE")

Additional instruction from the reviewer Bot:
${EXTRA}
"
rc=$?
set -e
if [ "$rc" -ne 0 ]; then
  echo "BLOCKED: grok exited $rc (auth? permissions?). Do not type .scad by hand." >&2
  exit "$rc"
fi
echo "grok finished ok"
