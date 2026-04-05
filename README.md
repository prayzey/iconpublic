# macos-app-icon-polish (Codex skill)

A small [Codex](https://github.com/openai/codex) skill for fixing macOS app icons that look too large, too sharp, or show dark edges in the Dock and Cmd-Tab compared to native apps.

## What it does

- Suggests a **padded 1024×1024** workflow (default **820×820** content on a transparent canvas) so icons read at a similar visual scale as system apps.
- Includes shell helpers to normalize PNGs and build **`.icns`** for shipped bundles.

## Requirements

- **ImageMagick** (`magick`) for padding/resizing.
- **`sips`** and **`iconutil`** (ships with Xcode / macOS).

## Install (Codex)

Clone this repo, then copy the repo root into your Codex skills directory under the skill name:

```bash
mkdir -p ~/.codex/skills
cp -R /path/to/iconpublic ~/.codex/skills/macos-app-icon-polish
```

Alternatively, symlink the folder to `~/.codex/skills/macos-app-icon-polish`.

## Scripts

From the skill root (or `scripts/` relative to it):

```bash
./scripts/make_padded_icon.sh <input.png> <output.png> [content-size]
# default content-size: 820 (on 1024 canvas)

./scripts/make_icns.sh <normalized-1024.png> <output.icns>
```

## License

MIT — see [LICENSE](LICENSE).
