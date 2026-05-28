---
name: theme
description: View, change, or regenerate the visual theme of your OwnYourCode HTML files (v2.4.0+)
allowed-tools: Read, Write, Edit, Bash, Glob, AskUserQuestion, Skill
---

# /own:theme

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Manage the visual styling of your project's HTML files (mission, stack, roadmap, spec, design, tasks).

## Overview

This command lets you:

1. **View** the current theme prompt
2. **Change** the theme by giving a custom design prompt
3. **Pick** a bundled preset (apple-light, apple-dark, terminal, paper, brutalist)
4. **Regenerate** the theme CSS using the existing prompt (re-roll the design)
5. **Revert** to a previous theme via `/own:theme --revert`

**The theme is a single CSS file.** All 6 HTML files reference it via `<link>`, so changing the theme is instant — no HTML files need regenerating.

## Files affected

- `ownyourcode/.theme/theme-prompt.md` — the active theme prompt
- `ownyourcode/.theme/theme.css` — the generated CSS (overwritten on each run)
- `ownyourcode/.theme/.history/[ISO-timestamp]/` — backup of previous theme prompt + CSS (created on every write)
- `.claude/ownyourcode-manifest.json` — `theme.fallback_mode` flag, `theme.last_updated` timestamp

## Hard constraints

- **Theme = visual styling ONLY.** This command must never alter the workflow, the SDD purpose of any HTML file, or any data-* contract used by other commands. If the user's custom prompt suggests workflow changes, reject those modifications and surface a warning.
- **Backup-before-write is non-negotiable.** Always copy current `theme-prompt.md` and `theme.css` to `.history/[timestamp]/` BEFORE generating new ones. Enables revert.
- **Frontend-design plugin is a soft dependency.** If unavailable, fall back to `theme-fallback.css` (shipped with the install) but never block the user.

---

## Execution Flow

### Phase 0: Argument detection

Check if the user invoked with `--revert`:

- `/own:theme --revert` → jump to **Revert Flow** section below
- `/own:theme` (no args) → continue to Phase 1

### Phase 1: Pre-flight check

Run these checks silently:

1. **Verify install:** `ownyourcode/.theme/` directory exists.
   - If not, this project doesn't have a theme set up yet. Tell the user:
     > "Your project doesn't have an HTML theme configured.
     >
     > - If this is a new project on v2.4.0+, run `/own:init` to set up the theme.
     > - If you have an existing Markdown project to convert, `/own:migrate` will land in a future v2.4.0 PR — until then, you can manually create `ownyourcode/.theme/` by running `/own:init` in a clean copy."
   - **STOP execution.**

2. **Read current state:** Read `ownyourcode/.theme/theme-prompt.md` (first 8 lines for preview).

3. **Detect frontend-design plugin:** Run silently:
   ```bash
   ls ~/.claude/plugins/cache/claude-plugins-official/frontend-design 2>/dev/null
   ```
   - Exists → `plugin_available = true`
   - Missing → `plugin_available = false`. Note: fallback CSS will be used.

### Phase 2: Show current state + action menu

Display:

```
🎨 Current theme prompt (preview):

   [first 8 lines of theme-prompt.md, indented]
   ...

Plugin status: [✓ frontend-design installed | ⚠️ using fallback CSS]
Last updated: [theme.last_updated from manifest]
```

Then use `AskUserQuestion` to present the action menu:

```
Question: "What do you want to do?"

Options:
1. Change theme prompt — Provide your own design description (free text)
2. Pick a preset — Choose from bundled presets (apple-light, apple-dark, etc.)
3. Regenerate current — Re-roll the CSS using the existing prompt
4. View full prompt — Read-only display of the current theme-prompt.md
```

Branch to the matching phase below.

### Phase 3a: Change theme prompt (free text)

Ask the user in chat (NOT AskUserQuestion — free text required):

> "Describe how you want OwnYourCode to look.
>
> Tip: be specific. Mention typography, exact colors, vibe, dark/light mode behavior. Vague prompts ('modern and clean') produce generic AI-looking output.
>
> Example:
>   'A warm paper-like document. Serif headings (Charter or Georgia). Soft cream background (#F8F4E8). No dark mode. Slim 1px borders in #D4CFC0. Inline tables with no zebra striping.'
>
> Your prompt:"

Wait for the user's free-text response. Then:

1. Run **Phase 5: Backup-before-write**
2. Write the new prompt to `ownyourcode/.theme/theme-prompt.md`
3. Run **Phase 6: Regenerate CSS**
4. Run **Phase 7: Confirm + preview**

### Phase 3b: Pick a preset

Use AskUserQuestion to list the bundled presets. (Presets are stored in `ownyourcode/templates/html/presets/[name].md` — load names by listing that directory.)

```
Question: "Pick a preset:"

Options (load dynamically from ownyourcode/templates/html/presets/):
1. apple-light — Light-mode Apple Documentation aesthetic
2. apple-dark — Dark-mode Apple Documentation aesthetic
3. terminal — Retro terminal aesthetic (mono, green-on-black)
4. paper — Print-document aesthetic (serif, paper background)
```

(If presets don't yet exist in the install — v2.4.0 may ship without all presets — only show those that exist.)

When the user picks one:

1. Run **Phase 5: Backup-before-write**
2. Copy `ownyourcode/templates/html/presets/[name].md` → `ownyourcode/.theme/theme-prompt.md`
3. Run **Phase 6: Regenerate CSS**
4. Run **Phase 7: Confirm + preview**

### Phase 3c: Regenerate current

No prompt change — use the existing `theme-prompt.md`. Useful for re-rolling when frontend-design produces a result the user doesn't love.

1. Run **Phase 5: Backup-before-write**
2. (No prompt copy — leave `theme-prompt.md` unchanged)
3. Run **Phase 6: Regenerate CSS**
4. Run **Phase 7: Confirm + preview**

### Phase 3d: View full prompt

Read-only display. Read `ownyourcode/.theme/theme-prompt.md` and show the entire content:

```
📄 Current theme prompt (ownyourcode/.theme/theme-prompt.md):

[full file content, fenced as a code block]

To change this prompt, re-run /own:theme and pick "Change theme prompt".
```

**STOP execution.** No backup, no regeneration.

---

### Phase 5: Backup-before-write

Generate a timestamp: `BACKUP_TS=$(date -u +"%Y-%m-%dT%H-%M-%SZ")`.

Create backup directory and copy current state:

```bash
BACKUP_DIR="ownyourcode/.theme/.history/${BACKUP_TS}"
mkdir -p "$BACKUP_DIR"
cp ownyourcode/.theme/theme-prompt.md "$BACKUP_DIR/theme-prompt.md" 2>/dev/null
cp ownyourcode/.theme/theme.css       "$BACKUP_DIR/theme.css"       2>/dev/null
```

Tell the user (briefly): `"📦 Previous theme backed up to .theme/.history/${BACKUP_TS}/"`

### Phase 6: Regenerate CSS

**If `plugin_available = true`:**

Invoke the `frontend-design` skill with the prompt:

```
Skill: frontend-design (from plugin claude-plugins-official:frontend-design)
Input: contents of ownyourcode/.theme/theme-prompt.md
Output target: ownyourcode/.theme/theme.css
Additional constraint to inject into the skill's prompt:
  "Generate ONLY a CSS file. The CSS must style the following semantic
   classes used by OwnYourCode HTML templates: [list selectors from
   theme-fallback.css]. Do NOT generate HTML, JS, or any other files.
   Honor prefers-color-scheme if the prompt mentions dark mode."
```

**If `plugin_available = false`:**

Tell the user:

> "⚠️ The `frontend-design` plugin isn't installed. Using the bundled fallback CSS, which approximates the prompt's aesthetic but isn't custom-generated.
>
> To get a fully custom theme based on your prompt, install the plugin:
>   /plugin install frontend-design@claude-plugins-official
>
> Then re-run /own:theme."

Then copy `ownyourcode/templates/html/theme-fallback.css` → `ownyourcode/.theme/theme.css`.

Update manifest: `theme.fallback_mode = true`.

### Phase 7: Confirm + preview offer

Display:

```
✅ Theme updated.

   Prompt: ownyourcode/.theme/theme-prompt.md
   CSS:    ownyourcode/.theme/theme.css
   Backup: ownyourcode/.theme/.history/${BACKUP_TS}/

All 6 HTML files now use the new theme (no regeneration needed —
they reference theme.css via <link>).

To revert: /own:theme --revert
```

Then ask:

```
Question: "Want to preview the new theme in your browser?"

Options:
1. Yes — open mission.html now
2. No — I'll check it later
```

If yes, open the file using the platform-appropriate command. Detect the OS and branch:

```bash
# Detect platform and open mission.html in the default browser.
case "$(uname -s)" in
  Darwin*)  open ownyourcode/product/mission.html ;;
  Linux*)   xdg-open ownyourcode/product/mission.html ;;
  CYGWIN*|MINGW*|MSYS*) start ownyourcode/product/mission.html ;;
  *)        echo "Open this file manually: ownyourcode/product/mission.html" ;;
esac
```

On Windows PowerShell sessions (where `uname` may be absent), use:

```powershell
Start-Process "ownyourcode/product/mission.html"
```

If no preview tool is available on the host, surface the path so the user can open it themselves rather than silently no-op.

Update manifest: `theme.last_updated = [ISO timestamp]`.

**END.**

---

## Revert Flow (`/own:theme --revert`)

### Step 1: List available backups

```bash
ls -1t ownyourcode/.theme/.history/ 2>/dev/null
```

If empty:
> "No theme backups found. Nothing to revert to."

**STOP.**

### Step 2: Present backups via AskUserQuestion

Show up to 4 most recent backups (newer first). Format each label as the ISO timestamp + first 30 chars of that backup's prompt for context:

```
Question: "Which theme do you want to restore?"

Options:
1. 2026-05-28T14-12-30Z — "A warm paper-like document. Serif…"
2. 2026-05-27T22-08-15Z — "Default OwnYourCode Theme — Apple…"
...
```

If more than 4 exist, add a "Show more" option that lists all in chat.

### Step 3: Restore selected backup

Copy backup files back to active location (and backup CURRENT state first, so user can undo a revert):

```bash
CURRENT_TS=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
mkdir -p "ownyourcode/.theme/.history/${CURRENT_TS}-pre-revert"
cp ownyourcode/.theme/theme-prompt.md "ownyourcode/.theme/.history/${CURRENT_TS}-pre-revert/"
cp ownyourcode/.theme/theme.css       "ownyourcode/.theme/.history/${CURRENT_TS}-pre-revert/"

cp "ownyourcode/.theme/.history/${SELECTED_TS}/theme-prompt.md" ownyourcode/.theme/theme-prompt.md
cp "ownyourcode/.theme/.history/${SELECTED_TS}/theme.css"       ownyourcode/.theme/theme.css
```

### Step 4: Confirm

```
✅ Theme reverted to ${SELECTED_TS}.

Your previous theme was backed up to .history/${CURRENT_TS}-pre-revert/
in case you want to undo this revert.
```

**END.**

---

## Important Notes

1. **Never edit theme.css by hand.** Edit `theme-prompt.md` and re-run `/own:theme`. Hand-edits will be overwritten next regenerate.
2. **The theme prompt is a CSS spec, not a Markdown formatting choice.** It tells `frontend-design` how to generate CSS rules — be specific.
3. **History grows.** `.theme/.history/` can accumulate. Future enhancement: `/own:theme --gc` to prune backups older than N days. Not in v2.4.0.
4. **Custom prompts that try to change semantics (e.g., "hide the checkboxes") MUST be rejected.** The theme is visual only — never alter the data-* contracts. Surface a warning if a prompt seems to violate this.
