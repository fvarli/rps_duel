#!/usr/bin/env bash
# Capture a phone screenshot from a connected Android device or emulator.
#
# Usage:  ./capture.sh <frame_number>
# Writes: screenshot_<frame_number>.png in this directory.
#
# Requires: adb on PATH + a device listed by `adb devices` + USB debugging on.
# See CAPTURE_GUIDE.md for which game state each frame should show.

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <frame_number>" >&2
  exit 1
fi

n="$1"
case "$n" in
  ''|*[!0-9]*)
    echo "error: frame_number must be a positive integer, got: $n" >&2
    exit 1
    ;;
esac

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="${script_dir}/screenshot_${n}.png"

if ! command -v adb >/dev/null 2>&1; then
  echo "error: adb not found on PATH. Install Android SDK platform-tools." >&2
  exit 1
fi

if ! adb get-state >/dev/null 2>&1; then
  echo "error: no Android device/emulator connected. Run 'adb devices' to verify." >&2
  exit 1
fi

adb exec-out screencap -p > "$out"
echo "saved: $out"
