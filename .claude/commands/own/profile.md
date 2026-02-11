---
name: profile
description: View or change your OwnYourCode profile settings
allowed-tools: Read, Write, Edit, AskUserQuestion
---

# /own:profile

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

View or change your OwnYourCode profile settings without re-running full `/own:init`.

## Overview

This command allows you to:
1. **View** your current profile and settings
2. **Switch** to a different profile
3. **Modify** individual settings (career focus, analogies, etc.)

**Files affected:**
- `.claude/ownyourcode-manifest.json` — Profile settings storage
- `CLAUDE.md` — Profile import path (updated on change)
- `ownyourcode/profiles/custom.md` — Only for Custom profile (generated/updated)

---

## Execution Flow

### Step 1: Read Current Profile

Read `.claude/ownyourcode-manifest.json` and display current settings:

```
┌─────────────────────────────────────────┐
│         CURRENT PROFILE                 │
├─────────────────────────────────────────┤
│ Profile: [Junior / Career Switcher /    │
│          Interview Prep / Experienced]  │
│ Configured: [date]                      │
├─────────────────────────────────────────┤
│ SETTINGS                                │
│ ─────────────                           │
│ Career Focus:      [full-extraction /   │
│                     tips-only / none]   │
│ Design Involvement: [Yes / No]          │
│ Analogies:         [Disabled / Enabled] │
│   └── Source:      [source if enabled]  │
│ Background:        [if Junior]          │
│ Workflow:          [if Experienced]     │
└─────────────────────────────────────────┘
```

If no profile is configured:
```
No profile configured yet. Run /own:init to set up your profile,
or continue below to configure now.
```

---

### Step 2: Ask What They Want to Do

```
Question: "What would you like to do?"

Options:
1. Switch to a different profile
   Description: Change from [current] to another profile type

2. Modify a setting
   Description: Change career focus, analogies, or other settings

3. Just viewing
   Description: No changes needed
```

---

### Step 3a: Switch Profile (if selected)

**IMPORTANT:** Read the current profile type from `.claude/ownyourcode-manifest.json` and EXCLUDE it from the options. Only show profiles the user can switch TO (not their current one).

**Available profiles (show only those NOT matching current):**

| Profile | Description |
|---------|-------------|
| Junior Developer | Learning to code, building portfolio projects, need guidance on fundamentals |
| Career Switcher | Transitioning from another field, have problem-solving skills, learning tech |
| Interview Prep | Preparing for job interviews, need portfolio pieces and STAR stories |
| Experienced Developer | Know how to code (or learning a new language), want quality checks and velocity |
| Custom | Create your own personalized mentor experience |

```
Question: "Which profile would you like to switch to?"

Options: [Build dynamically — exclude current profile]
Example if current = "junior":
1. Career Switcher
2. Interview Prep
3. Experienced Developer
4. Custom
```

After selection, ask the profile-specific questions (same as /own:init Phase -1).

**If Custom is selected:** Run the full Custom Profile Questionnaire from /own:init, then generate `ownyourcode/profiles/custom.md`.

Then:
1. Update manifest with new profile
2. Update CLAUDE.md @import path (see "Updating CLAUDE.md Import" section below)
3. Confirm the change

```
✅ Profile switched to [New Profile]

Your CLAUDE.md import path has been updated.
Existing product files (mission.md, stack.md, roadmap.md) are unchanged.
```

---

### Step 3b: Modify Setting (if selected)

```
Question: "Which setting do you want to change?"

Options:
1. Career Focus
   Description: Currently: [current setting]

2. Design Involvement
   Description: Currently: [Yes/No]

3. Analogies
   Description: Currently: [Enabled from X / Disabled]

4. Other profile-specific settings
   Description: Background, workflow preference, etc.
```

Based on selection, ask the appropriate question:

**Career Focus:**
```
Question: "Are you preparing for job interviews?"

Options:
1. Yes, full extraction
   Description: Get STAR stories and resume bullets after every task

2. Yes, just tips
   Description: Get interview insights while learning, no formal extraction

3. No, focused on learning
   Description: Skip career extraction, focus on building
```

**Design Involvement:**
```
Question: "Want to be involved in design decisions?"

Options:
1. Yes
   Description: Collaborate on architecture and specs

2. No
   Description: AI generates specs, you review and implement
```

**Analogies:**
```
Question: "Want me to use analogies?"

Options:
1. Yes
   Description: I'll ask what domain to draw from

2. No
   Description: Just explain concepts directly
```

If Yes, follow up: "What should I draw analogies from?"

After any change:
1. Update manifest
2. **If Custom profile:** Update `ownyourcode/profiles/custom.md` (find and replace the relevant section)
3. Confirm (CLAUDE.md automatically loads updated profile via @import)

```
✅ Setting updated: [Setting] → [New Value]

Profile behavior updated. Changes are active.
```

---

### Step 3c: Just Viewing (if selected)

```
No changes made. Your current profile settings remain active.

To change settings later, run /own:profile again.
```

---

## Updating CLAUDE.md Import

**CLAUDE.md uses @import to load profile behavior.** When switching profiles, you just need to change which file it imports.

### For Profile Switching

Find this line in CLAUDE.md (under `## Profile Settings`):
```markdown
@ownyourcode/profiles/[current-profile].md
```

Replace it with the new profile path:
```markdown
@ownyourcode/profiles/[new-profile].md
```

**Profile type mapping:**
| Profile Selected | Import Path |
|------------------|-------------|
| Junior | `@ownyourcode/profiles/junior.md` |
| Career Switcher | `@ownyourcode/profiles/career-switcher.md` |
| Interview Prep | `@ownyourcode/profiles/interview-prep.md` |
| Experienced | `@ownyourcode/profiles/experienced.md` |
| Custom | `@ownyourcode/profiles/custom.md` |

### For Setting Changes (Standard Profiles)

Standard profiles use static template files. When a setting changes:
1. Update the manifest — this is the single source of truth
2. No CLAUDE.md change needed — Claude reads settings from manifest

### For Setting Changes (Custom Profile)

Custom profiles use a dynamically generated file. When a setting changes:

**Step 1: Update `ownyourcode/profiles/custom.md`**

Find and replace the section that changed:

| Setting Changed | Section to Update in custom.md |
|-----------------|-------------------------------|
| `career_focus` | `## Career Focus` |
| `teaching_style` | `## Teaching Style` |
| `feedback_style` | `## Feedback Style` |
| `pacing` | `## Pacing` |
| `design_involvement` | `## Design Involvement` |
| `analogies` | `## Analogies` |
| `personal_touch` | `## Personal Instructions` |
| `background` | `## Background` |

Use the same text generation logic from `/own:init` Custom Profile Questionnaire section.

**Step 2:** No CLAUDE.md change needed — @import automatically loads the updated custom.md

---

## Important Notes

1. **Non-destructive** — Changing profile doesn't affect product files (mission.md, etc.)
2. **Immediate effect** — CLAUDE.md updates take effect in the current session
3. **Junior design involvement** — Cannot be disabled for Junior profile (it's mandatory)
4. **Interview Prep career focus** — Defaults to full-extraction but can be changed here
