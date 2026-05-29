---
name: theme
description: Restyle your OwnYourCode dashboard — regenerate dashboard.html's inline <style> from a design brief (v2.5)
allowed-tools: Read, Write, Edit, Bash, Glob, AskUserQuestion, Skill
---

# /own:theme

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Restyle your project **dashboard**. The dashboard is self-styled — its CSS lives
inline in `dashboard.html`. This command re-cooks that inline `<style>` block
(and the Google-Fonts `<link>`) from your design brief, using the
`frontend-design` plugin when you have it, otherwise Claude's own design skills.

## Overview

1. **View** the current design brief
2. **Change** the brief (free-text design description) → regenerate
3. **Regenerate** from the existing brief (re-roll the look)
4. **Revert** to a previous design via `/own:theme --revert`

## Files affected

- `ownyourcode/.theme/theme-prompt.md` — the active design brief (you edit this)
- `ownyourcode/dashboard.html` — its `<style>` block + font `<link>` are regenerated
- `ownyourcode/.theme/.history/[ISO-timestamp]/` — backup of the prior
  `dashboard.html` + `theme-prompt.md` (created on every write; enables revert)
- `.claude/ownyourcode-manifest.json` — `theme.system`, `theme.last_updated`

## Hard constraints

- **Visual only.** Restyle, never restructure. The dashboard's render JS expects
  a fixed set of class names and the `window.PROJECT` contract — NEVER rename,
  remove, or add classes, change the HTML structure, or touch the `<script>`
  blocks. If a brief asks for layout/behavior/data changes, refuse those parts
  and warn.
- **Never touch `dashboard-data.js`.** That's project content, not styling.
- **`file://` rules:** CSS stays inline (no external stylesheet `<link>`); web
  fonts via `<link>` in `<head>` are fine (the page is always online).
- **Backup-before-write is non-negotiable.** Copy the current `dashboard.html` +
  `theme-prompt.md` to `.history/[timestamp]/` BEFORE regenerating.

---

## Execution Flow

### Phase 0: Argument detection

- `/own:theme --revert` → jump to **Revert Flow** below
- `/own:theme` (no args) → continue to Phase 1

### Phase 1: Pre-flight

1. **Verify the dashboard exists:** confirm `ownyourcode/dashboard.html` and
   `ownyourcode/.theme/theme-prompt.md` are present.
   ```bash
   ls ownyourcode/dashboard.html ownyourcode/.theme/theme-prompt.md
   ```
   If either is missing, the project isn't initialized on v2.5 — tell the user to
   run `/own:init` (or re-run the install) and **STOP**.

2. **Read current state:** read `ownyourcode/.theme/theme-prompt.md`.

3. **Detect `frontend-design` via the session skill list** (NOT the filesystem
   cache — that path goes stale, a v2.4 runtime lesson). Check your own available
   skills for `frontend-design` (appears as `frontend-design:frontend-design`).
   - Present → `plugin_available = true`
   - Absent → `plugin_available = false` (Claude will generate directly)

### Phase 2: Show current state + action menu

```
🎨 Current design brief (preview):

   [first 8 lines of theme-prompt.md, indented]
   ...

frontend-design: [✓ available | — not installed (Claude will design directly)]
```

Then `AskUserQuestion`:

```
Question: "What do you want to do?"

Options:
1. Change the design brief — describe a new look (free text), then regenerate
2. Regenerate from current brief — re-roll the look, same brief
3. View full brief — read-only display of theme-prompt.md
```

(Revert is via `/own:theme --revert`.)

### Phase 3a: Change the design brief (free text)

Ask in chat (free text, NOT AskUserQuestion):

> "Describe how you want your dashboard to look. Be specific — name a direction,
> exact colors, typography, dark/light, motion. Vague briefs ('modern and clean')
> produce generic AI-looking output.
>
> Keep the Technical-constraints section of the brief intact (file:// rules).
>
> Your brief:"

Then: **Phase 5 (backup)** → write the new brief to
`ownyourcode/.theme/theme-prompt.md` → **Phase 6 (regenerate)** → **Phase 7**.

### Phase 3b: Regenerate from current brief

No brief change. **Phase 5 (backup)** → **Phase 6 (regenerate)** → **Phase 7**.

### Phase 3c: View full brief

Read `ownyourcode/.theme/theme-prompt.md` and display it in full (fenced). No
backup, no regeneration. **STOP.**

---

### Phase 5: Backup-before-write

```bash
BACKUP_TS=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
BACKUP_DIR="ownyourcode/.theme/.history/${BACKUP_TS}"
mkdir -p "$BACKUP_DIR"
cp ownyourcode/dashboard.html         "$BACKUP_DIR/dashboard.html"
cp ownyourcode/.theme/theme-prompt.md "$BACKUP_DIR/theme-prompt.md"
```

Tell the user: `"📦 Previous dashboard backed up to .theme/.history/${BACKUP_TS}/"`

### Phase 6: Regenerate the dashboard's styling

You are regenerating **only** the `<head>` font `<link>` and the `<style>`
block of `ownyourcode/dashboard.html`. Everything else — the `<body>` markup and
both `<script>` blocks (the data load + the render logic) — is UNTOUCHABLE.

**The class contract is the current `<style>` itself.** Read the existing
`<style>` block in `dashboard.html` to learn the complete set of selectors the
render JS depends on (`.app`, `.hd`, `.sb`, `.nav`, `.tile`, `.bento`, `.kcard`,
`.ring`, `.phase-numeral`, `.src`, `.bdg`, `.al-*`, etc.). The regenerated CSS
MUST style that exact same selector set — same class names, same structural
roles — only the visual treatment changes per the brief.

**Generation:**
- Read the brief: `ownyourcode/.theme/theme-prompt.md`.
- **If `plugin_available`:** apply the `frontend-design` skill's methodology to
  drive the design from the brief. (If the Skill can be invoked for guidance,
  use it; if not, apply its principles directly — either way Claude writes the
  final CSS. This avoids depending on mid-flow skill output, a v2.4 lesson.)
- **If not:** Claude designs directly from the brief using its own design skills
  plus the brief's anti-AI-UI rules.
- **Write** the new `<head>` font `<link>` + `<style>` into `dashboard.html`
  using the `Edit` tool — replace ONLY those regions. Do not regenerate the file
  from scratch (that risks dropping the render JS). Keep `prefers-reduced-motion`
  handling and the `file://` inline-CSS rule.

### Phase 7: Verify render integrity + confirm

**Integrity check (mandatory)** — confirm the restyle didn't break the render
contract. The file must still contain its render logic and structure:

```bash
grep -c "window.PROJECT" ownyourcode/dashboard.html      # expect >= 1
grep -c "function renderViews" ownyourcode/dashboard.html # expect 1
grep -c "<style>" ownyourcode/dashboard.html              # expect 1
```

If any check fails, the regeneration damaged the file — **restore the backup**
(`cp .theme/.history/${BACKUP_TS}/dashboard.html ownyourcode/dashboard.html`),
tell the user, and stop. Never leave a broken dashboard.

Then update the manifest (`theme.system` = a short slug for the brief, e.g.
`"terminal-futurism"` or `"custom"`; `theme.last_updated` = ISO timestamp) and
confirm:

```
✅ Dashboard restyled.

   Brief:  ownyourcode/.theme/theme-prompt.md
   Styled: ownyourcode/dashboard.html  (inline <style> regenerated)
   Backup: ownyourcode/.theme/.history/${BACKUP_TS}/

Refresh the dashboard tab to see it. To revert: /own:theme --revert
```

Offer to open it:

```bash
case "$(uname -s)" in
  Darwin*) open ownyourcode/dashboard.html ;;
  Linux*)  xdg-open ownyourcode/dashboard.html ;;
  *)       echo "Open this file: ownyourcode/dashboard.html" ;;
esac
```
(On Windows PowerShell: `Start-Process "ownyourcode/dashboard.html"`.)

**END.**

---

## Revert Flow (`/own:theme --revert`)

### Step 1: List backups

```bash
ls -1t ownyourcode/.theme/.history/ 2>/dev/null
```
If empty: `"No theme backups found. Nothing to revert to."` **STOP.**

### Step 2: Present via AskUserQuestion

Show up to 4 most-recent backups (newest first), each labeled with its timestamp
+ the first line of that backup's `theme-prompt.md` for context. If more than 4,
add "Show more".

### Step 3: Restore (backing up current first, so a revert is itself undoable)

```bash
CURRENT_TS=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
PRE="ownyourcode/.theme/.history/${CURRENT_TS}-pre-revert"
mkdir -p "$PRE"
cp ownyourcode/dashboard.html         "$PRE/dashboard.html"
cp ownyourcode/.theme/theme-prompt.md "$PRE/theme-prompt.md"

cp "ownyourcode/.theme/.history/${SELECTED_TS}/dashboard.html"   ownyourcode/dashboard.html
cp "ownyourcode/.theme/.history/${SELECTED_TS}/theme-prompt.md"  ownyourcode/.theme/theme-prompt.md
```

### Step 4: Confirm

```
✅ Dashboard reverted to ${SELECTED_TS}.
Your previous look was backed up to .history/${CURRENT_TS}-pre-revert/.
Refresh the dashboard tab.
```

**END.**

---

## Important Notes

1. **Never hand-edit `dashboard.html`'s `<style>` outside this command** — edit
   `theme-prompt.md` and regenerate, or your changes drift from the brief.
2. **The brief is a design spec, not prose.** Specific colors, fonts, vibe,
   motion — vague briefs produce generic output.
3. **Briefs that try to change behavior/structure** ("hide the checkboxes",
   "remove the Tasks tab") MUST be refused — restyle only.
4. **History grows.** `.theme/.history/` accumulates; a future `/own:theme --gc`
   could prune. Not in v2.5.
