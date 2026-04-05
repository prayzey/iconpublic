---
name: macos-app-icon-polish
description: Fix and standardize macOS app icon rendering for Swift/SwiftUI projects, especially when icons look too sharp, too large, or show dark edge artifacts in Dock/Cmd-Tab. Use when working on app icon sizing, corner softness, alpha edges, AppDelegate runtime icon assignment, `.icns` generation, and `CFBundleIconFile` packaging.
---

# macos-app-icon-polish

Follow this workflow to make custom app icons look native on macOS.

## Quick workflow

1. Diagnose the current pipeline.
2. Normalize the source icon to padded 1024 PNG.
3. Choose runtime masking or bundle `.icns` packaging.
4. Validate in Dock and Cmd-Tab at multiple sizes.

## Diagnose first

Run these checks before editing code:

```bash
sips -g pixelWidth -g pixelHeight <icon.png>
file <icon.png>
magick <icon.png> -format "TL:%[pixel:p{0,0}] TR:%[pixel:p{1023,0}] BL:%[pixel:p{0,1023}] BR:%[pixel:p{1023,1023}]\n" info:
```

Interpret quickly:

- `RGB` (no alpha) on a full-bleed 1024 icon usually looks oversized.
- Fully transparent outer corners with alpha bounds around `820x820+102+102` are usually in the right size range.
- Dark fringe near rounded edges usually means alpha/compositing problems from image preprocessing.

## Normalize icon asset

Use `scripts/make_padded_icon.sh` to create a clean `1024x1024` icon with centered content (default `820x820`).

```bash
scripts/make_padded_icon.sh <input.png> <output.png>
```

Use this as `Resources/AppIcon.png` for SwiftPM resources.

## Choose icon rendering path

### Path A: SwiftPM runtime icon override (common in `swift run`)

Load `AppIcon.png` via `Bundle.module` and set `NSApp.applicationIconImage`.

If corners still look sharp, clip the **content rect** (10% inset) instead of the full 1024 canvas. This is critical when the icon is padded.

### Path B: Bundled app icon (`.icns`) for packaged app

Generate `.icns` from normalized PNG:

```bash
scripts/make_icns.sh <normalized-1024.png> <AppIcon.icns>
```

Then ensure the app bundle sets `CFBundleIconFile` to the icon basename.

## Avoid common mistakes

- Avoid masking only the outer 1024 rect when the actual artwork is inset.
- Avoid repeatedly baking rounded corners with lossy or incorrect alpha steps.
- Avoid shipping only a single PNG for packaged desktop distribution when `.icns` is expected.

## Verification checklist

1. Run app and compare against Apple Music/Finder in Dock.
2. Check icon at small and large Dock sizes.
3. Open Cmd-Tab switcher to confirm edge quality.
4. Re-check PNG alpha corners and content bounds.

## Resources

- `scripts/make_padded_icon.sh`: Create normalized padded icon.
- `scripts/make_icns.sh`: Build multi-size `.icns` from 1024 source.
- `references/apple-icon-sources.md`: Primary Apple references to cite when needed.
