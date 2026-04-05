#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <input-1024.png> <output.icns>" >&2
  echo "Example: $0 ./Sources/MyTarget/Resources/AppIcon.png ./Sources/MyTarget/Resources/AppIcon.icns" >&2
  exit 1
fi

INPUT="$1"
OUTPUT="$2"

for cmd in sips iconutil; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command not found: $cmd" >&2
    exit 1
  fi
done

if ! [[ -f "$INPUT" ]]; then
  echo "Error: Input file not found: $INPUT" >&2
  exit 1
fi

W=$(sips -g pixelWidth "$INPUT" 2>/dev/null | awk '/pixelWidth/ {print $2}')
H=$(sips -g pixelHeight "$INPUT" 2>/dev/null | awk '/pixelHeight/ {print $2}')
if [[ "$W" != "1024" || "$H" != "1024" ]]; then
  echo "Error: input must be 1024x1024, got ${W}x${H}." >&2
  exit 1
fi

ICONSET_DIR=$(mktemp -d /tmp/macos-iconset.XXXXXX).iconset
mkdir -p "$ICONSET_DIR"
cleanup() { rm -rf "$ICONSET_DIR"; }
trap cleanup EXIT

sips -z 16 16     "$INPUT" --out "$ICONSET_DIR/icon_16x16.png" >/dev/null
sips -z 32 32     "$INPUT" --out "$ICONSET_DIR/icon_16x16@2x.png" >/dev/null
sips -z 32 32     "$INPUT" --out "$ICONSET_DIR/icon_32x32.png" >/dev/null
sips -z 64 64     "$INPUT" --out "$ICONSET_DIR/icon_32x32@2x.png" >/dev/null
sips -z 128 128   "$INPUT" --out "$ICONSET_DIR/icon_128x128.png" >/dev/null
sips -z 256 256   "$INPUT" --out "$ICONSET_DIR/icon_128x128@2x.png" >/dev/null
sips -z 256 256   "$INPUT" --out "$ICONSET_DIR/icon_256x256.png" >/dev/null
sips -z 512 512   "$INPUT" --out "$ICONSET_DIR/icon_256x256@2x.png" >/dev/null
sips -z 512 512   "$INPUT" --out "$ICONSET_DIR/icon_512x512.png" >/dev/null
cp "$INPUT" "$ICONSET_DIR/icon_512x512@2x.png"

mkdir -p "$(dirname "$OUTPUT")"
iconutil -c icns "$ICONSET_DIR" -o "$OUTPUT"

echo "Wrote: $OUTPUT"
