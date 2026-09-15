#!/usr/bin/env bash
# Install OpenSCAD on the Grok Bot cloud Linux computer if missing.
set -euo pipefail

if command -v openscad >/dev/null 2>&1; then
  echo "openscad already on PATH: $(command -v openscad)"
  openscad --version || true
  exit 0
fi

if [ -x /usr/bin/openscad ]; then
  echo "openscad at /usr/bin/openscad"
  /usr/bin/openscad --version || true
  exit 0
fi

echo "OpenSCAD not found. Installing..."

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y openscad || true
fi

if command -v openscad >/dev/null 2>&1; then
  echo "installed via apt"
  openscad --version || true
  exit 0
fi

# AppImage fallback (no GUI integration required for CLI renders).
mkdir -p "$HOME/.local/bin"
appimage="$HOME/.local/bin/OpenSCAD.AppImage"
if [ ! -x "$appimage" ]; then
  url="https://files.openscad.org/OpenSCAD-2021.01-x86_64.AppImage"
  echo "downloading $url"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$appimage" "$url"
  else
    wget -O "$appimage" "$url"
  fi
  chmod +x "$appimage"
fi

ln -sfn "$appimage" "$HOME/.local/bin/openscad"
export PATH="$HOME/.local/bin:$PATH"

if command -v openscad >/dev/null 2>&1; then
  echo "installed AppImage as $HOME/.local/bin/openscad"
  openscad --version || true
  exit 0
fi

echo "BLOCKED: could not install OpenSCAD" >&2
exit 1
