#!/usr/bin/env bash
# Install the grok CLI (Grok Build) on the Grok Bot Linux computer.
set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.grok/bin:/usr/local/bin:$PATH"

if command -v grok >/dev/null 2>&1; then
  echo "grok already on PATH: $(command -v grok)"
  grok --version || true
  exit 0
fi

echo "Installing Grok Build CLI..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL https://x.ai/cli/install.sh | bash
elif command -v npm >/dev/null 2>&1; then
  npm i -g @xai-official/grok
else
  echo "BLOCKED: need curl or npm to install grok" >&2
  exit 1
fi

export PATH="$HOME/.local/bin:$HOME/.grok/bin:/usr/local/bin:$PATH"

if ! command -v grok >/dev/null 2>&1; then
  echo "BLOCKED: grok installed but not on PATH. Open a new shell or export PATH." >&2
  exit 1
fi

echo "grok $(grok --version 2>&1 | tr '\n' ' ')"
echo "If grok -p fails with auth: user must grok login on Agent Computer, or set GROK_CODE_XAI_API_KEY / XAI_API_KEY via the Bot secure form (not chat)."
