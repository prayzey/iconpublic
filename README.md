# macos-app-icon-polish (Codex + Claude Code skill)

A small skill for fixing macOS app icons that look too large, too sharp, or show dark edges in the Dock and Cmd-Tab compared to native apps. It works with both [Codex](https://github.com/openai/codex) and [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## What it does

- Suggests a **padded 1024×1024** workflow (default **820×820** content on a transparent canvas) so icons read at a similar visual scale as system apps.
- Includes shell helpers to normalize PNGs and build `**.icns`** for shipped bundles.

## Requirements

- **ImageMagick** (`magick`) for padding/resizing.
- `**sips`** and `**iconutil**` (ships with Xcode / macOS).

## Install (Codex)

Clone this repo, then copy the repo root into your Codex skills directory under the skill name:

```bash
mkdir -p ~/.codex/skills
cp -R /path/to/iconpublic ~/.codex/skills/macos-app-icon-polish
```

Alternatively, symlink the folder to `~/.codex/skills/macos-app-icon-polish`.

## Install (Claude Code)

Claude Code expects skills under `~/.claude/skills`. You can copy or symlink this repo there:

```bash
mkdir -p ~/.claude/skills
cp -R /path/to/iconpublic ~/.claude/skills/macos-app-icon-polish
```

Or use a symlink:

```bash
ln -s /path/to/iconpublic ~/.claude/skills/macos-app-icon-polish
```

## Publish and share

There is no separate upload form for skills.sh. The usual flow is:

1. Put the skill in a public GitHub repo.
2. Keep the standard `SKILL.md` structure in the repo root or in a skill folder.
3. Share the repo URL directly, or have users install it with the `skills` CLI.

Examples:

```bash
npx skills add prayzey/iconpublic
npx skills add https://github.com/prayzey/iconpublic
```

Skills can be discovered through skills.sh and the Vercel ecosystem once people install them, so public GitHub is the main distribution path.

## Scripts

From the skill root (or `scripts/` relative to it):

```bash
./scripts/make_padded_icon.sh <input.png> <output.png> [content-size]
# default content-size: 820 (on 1024 canvas)

./scripts/make_icns.sh <normalized-1024.png> <output.icns>
```

## License

MIT — see [LICENSE](LICENSE).