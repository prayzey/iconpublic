#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <input.png> <output.png> [content-size]" >&2
  echo "Example: $0 ./source.png ./Sources/MyTarget/Resources/AppIcon.png 820" >&2
  exit 1
fi

INPUT="$1"
OUTPUT="$2"
CONTENT_SIZE="${3:-820}"
CANVAS_SIZE=1024

if ! command -v magick >/dev/null 2>&1; then
  echo "Error: ImageMagick 'magick' command is required." >&2
  exit 1
fi

if ! [[ -f "$INPUT" ]]; then
  echo "Error: Input file not found: $INPUT" >&2
  exit 1
fi

if ! [[ "$CONTENT_SIZE" =~ ^[0-9]+$ ]]; then
  echo "Error: content-size must be an integer." >&2
  exit 1
fi

if (( CONTENT_SIZE <= 0 || CONTENT_SIZE > CANVAS_SIZE )); then
  echo "Error: content-size must be between 1 and $CANVAS_SIZE." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"

# Create transparent 1024 canvas and center resized artwork.
magick "$INPUT" \
  -resize "${CONTENT_SIZE}x${CONTENT_SIZE}!" \
  -background none \
  -gravity center \
  -extent "${CANVAS_SIZE}x${CANVAS_SIZE}" \
  -strip \
  PNG32:"$OUTPUT"

echo "Wrote: $OUTPUT"
sips -g pixelWidth -g pixelHeight "$OUTPUT" >/dev/null
BOUNDS=$(magick "$OUTPUT" -alpha extract -threshold 0 -trim -format "%wx%h+%X+%Y" info:)
echo "Alpha bounds: $BOUNDS"
