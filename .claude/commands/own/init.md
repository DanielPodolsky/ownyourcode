---
name: init
description: Initialize OwnYourCode project with mission, stack, and roadmap
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__octocode__githubSearchRepositories, mcp__octocode__githubViewRepoStructure, mcp__octocode__packageSearch
---

# /own:init

> ⚠️ **PLAN MODE WARNING:** If plan mode is enabled, disable it before running this command. OwnYourCode commands don't work correctly with plan mode — it causes skipped steps and unexpected behavior. Press `shift+tab` to toggle plan mode off.

Initialize a OwnYourCode project by selecting your profile, defining the mission, detecting the stack, and creating a roadmap.

## Overview

This command works for both **new projects** (empty directory) and **existing projects** (mid-development).

**Output (v2.5 — Dashboard SDD):**

- `ownyourcode/dashboard/dashboard-data.js` — `window.PROJECT`: mission, stack, and
  roadmap as a single source of truth (THIS is what you fill in Phase 6)
- Updated `.claude/ownyourcode-manifest.json` — Profile + theme settings
- Updated `CLAUDE.md` — Profile-specific behavior injected

> **Schema authority:** `ownyourcode/dashboard/DASHBOARD_CONTRACT.md` defines the exact
> `window.PROJECT` shape and mutation rules. When this command's prose and the
> contract disagree, the contract wins. Read it before writing Phase 6 output.

**CRITICAL: You Fill the Data File — You Do NOT Touch the Shell**

The installation script already seeded `ownyourcode/` with the dashboard:

```
<install-location>/
├── CLAUDE.md              ← Created/modified during install
├── ownyourcode/           ← Created during install (sibling to CLAUDE.md)
│   └── dashboard/
│       ├── dashboard.html        ← The VIEW SHELL — never edit for content
│       ├── dashboard-data.js     ← Empty scaffold — YOU fill this in Phase 6
│       └── DASHBOARD_CONTRACT.md ← The schema authority
```

**Rules:**

1. Your job is to **fill `dashboard-data.js`** (the data) — never hand-edit
   `dashboard.html` (the shell). Styling is `/own:theme`'s job, not yours.
2. `ownyourcode/` is always a **sibling to CLAUDE.md** (same directory level)
3. If `ownyourcode/dashboard/dashboard-data.js` doesn't exist, the installation is
   incomplete or pre-v2.5 — tell the user to re-run the install script
4. If you detect a project in a subdirectory (e.g., `shelfie/package.json`), still update the `ownyourcode/` at the installation root (sibling to CLAUDE.md), not inside the subdirectory

---

## The Philosophy

These questions force THINKING, not feature-listing. Most juniors skip straight to "I want a login form." We force them to think about VALUE first.

---

## Execution Flow

### Phase -1: Profile Selection (NEW)

**Before anything else, set up the developer's profile.**

This determines HOW OwnYourCode teaches—the pedagogy, not the standards.
The 6 Gates, code reviews, and quality expectations remain the same for everyone.

#### Step 1: Profile Type Selection

Use AskUserQuestion:

```
Question: "Which profile fits you best?"

Options:
1. Junior Developer
   Description: Learning to code, building portfolio projects, need guidance on fundamentals

2. Career Switcher
   Description: Transitioning from another field, have problem-solving skills, learning tech

3. Interview Prep
   Description: Preparing for job interviews, need portfolio pieces and STAR stories

4. Experienced Developer / Custom Profile
```

Store the selection in memory for manifest update.

**If option 4 is selected (Experienced / Custom):** Ask a follow-up question:

```
Question: "Which one?"

Options:
1. Experienced Developer
   Description: Understands software engineering, has experience

2. Custom Profile
   Description: Create your own mentoring experience
```

**If Custom Profile is selected:** Skip to "Custom Profile Questionnaire" section below, then return to Step 5 (Update Manifest).

#### Step 2: Shared Questions (All Profiles)

**Question 2a: Career Focus**

```
Question: "Are you preparing for job interviews?"

Options:
1. Yes, full extraction (Recommended for job seekers)
   Description: Get STAR stories and resume bullets after every task

2. Yes, just tips
   Description: Get interview insights while learning, no formal extraction

3. No, focused on learning
   Description: Skip career extraction, focus on building
```

**Note:** For "Interview Prep" profile, default to "full extraction" and skip this question.

**Question 2b: Analogies**

```
Question: "Want me to use analogies from something you know well?"

Options:
1. Yes
   Description: I'll ask what domain to draw from (e.g., cooking, sports, Star Wars)

2. No
   Description: Just explain concepts directly
```

**IMPORTANT: If "Yes" is selected, IMMEDIATELY ask a FREE-TEXT follow-up (NOT AskUserQuestion):**

Simply ask in chat: "What should I draw analogies from? (e.g., cooking, military, music, sports, Star Wars)"

Do NOT use AskUserQuestion with predefined options. Let them type their own answer freely.

Wait for their answer and store it. Only THEN proceed to Step 3.

---

#### Step 3: Profile-Specific Questions

**For Junior:**
```
Question: "How would you describe your coding background?"

Options:
1. I'm completely new to coding
   Description: I'll explain everything from zero, define terms as we go

2. I've coded before, but I'm still learning
   Description: I'll skip basic vocabulary but still cover fundamentals thoroughly
```

**For Career Switcher:**

```
Question 1: "What field are you transitioning from?"
→ Free text
Store as `previous_field` — used for analogies and context
```

```
Question 2: "What area of software development are you focusing on?"
→ Free text (e.g., "frontend", "backend", "full-stack", "data engineering")
Store as `focus_area` — used for guidance focus
```

**For Interview Prep:**

```
Question 1: "What position are you preparing for?"
→ Free text (e.g., "Senior Frontend Engineer", "Backend Developer", "Full-stack")
Store as `position_title` — frames stories at the right level
```

```
Question 2: "Any specific company you're targeting?"
→ Free text, optional (e.g., "Google", "Stripe", or leave blank)
Store as `target_company` — tailors context if they have a specific target
```

**For Experienced:**

Ask a FREE-TEXT question (NOT AskUserQuestion):

"Tell me about your engineering background — experience, specializations, current role, how you like to work."

Let them type freely. Store the response as `profile.settings.background`.

#### Step 4: Design Involvement (All except Junior)

For Career Switcher, Interview Prep, and Experienced profiles:

```
Question: "Want to be involved in design decisions?"

Options:
1. Yes
   Description: Collaborate on architecture and specs, practice articulation

2. No
   Description: I'll generate specs, you review and implement
```

**Note:** Juniors ALWAYS have design involvement—it's mandatory for their learning.

---

### Custom Profile Questionnaire

**Only runs if "Custom" was selected in Step 1.**

This questionnaire lets developers create a fully personalized mentor experience.
OwnYourCode's core philosophy (6 Gates, code quality, ownership + learning that sticks) remains enforced.

#### Custom Q1: Teaching Style

Use AskUserQuestion:

```
Question: "How do you want me to teach?"

Options:
1. Socratic
   Description: I'll ask questions to guide your thinking before giving answers

2. Direct
   Description: Clear explanations with less back-and-forth, but still verify understanding

3. Custom
   Description: Describe your ideal teaching style
```

**If "Custom" selected:** Ask free-text follow-up:
> "Describe how you'd like me to teach you:"

Store their response directly as `teaching_style` (overriding "custom" with their actual text).

#### Custom Q2: Feedback Style

Use AskUserQuestion:

```
Question: "How should I give feedback on your code?"

Options:
1. Blunt & Direct
   Description: No sugarcoating — tell me what's wrong immediately

2. Balanced
   Description: Point out issues while acknowledging what's good

3. Encouraging First
   Description: Lead with positives, then address improvements

4. Custom
   Description: Describe your preferred feedback style
```

**If "Custom" selected:** Ask free-text follow-up:
> "How should I deliver feedback to you?"

Store their response directly as `feedback_style` (overriding "custom" with their actual text).

#### Custom Q3: Pacing

Use AskUserQuestion:

```
Question: "How hard should I push you?"

Options:
1. Push Hard
   Description: Challenge me constantly, high expectations

2. Steady Progress
   Description: Consistent pace, balanced challenge

3. Patient
   Description: Take time to ensure I understand before moving on
```

#### Custom Q4: Background (Free Text)

Ask this free-text question:

> "Tell me about your coding background. How experienced are you? What languages/frameworks do you know? What are you trying to learn?"

Store the response as `background`. This helps calibrate vocabulary and assumptions.

#### Custom Q5-Q7: Shared Questions

Now ask the same shared questions as other profiles:

- **Q5: Career Focus** (same as Step 2a above)
- **Q6: Analogies** (same as Step 2b above — if Yes, immediately ask for source)
- **Q7: Design Involvement** (same as Step 4 above)

#### Custom Q8: Personal Touch (Free-Form)

Ask this exact free-text question:

> "Anything else about how I should interact with you?
>
> Get creative — nicknames, communication quirks, themes, whatever makes this YOUR mentor.
>
> Examples:
> - 'Address me as Commander'
> - 'Use cooking metaphors and call bugs burnt dishes'
> - 'Be slightly sarcastic but helpful'
> - 'Speak like a wise old wizard'
> - 'Keep responses short and punchy'
> - 'Always end advice with an encouraging quote'
>
> Leave blank if none."

Store the response as `personal_touch`.

#### Custom Profile: Generate Profile File

After collecting all answers, **generate** `ownyourcode/profiles/custom.md` with conditional blocks (same structure as standard profiles):

````markdown
# Custom Profile Template

> This profile was personalized for you. Settings are stored in `.claude/ownyourcode-manifest.json`.

## Manifest Keys

These settings are read from `.claude/ownyourcode-manifest.json`:

| Key | Values | Effect |
|-----|--------|--------|
| `profile.settings.teaching_style` | `"socratic"` / `"direct"` / custom text | Teaching approach |
| `profile.settings.feedback_style` | `"blunt"` / `"balanced"` / `"encouraging"` / custom text | Review tone |
| `profile.settings.pacing` | `"push-hard"` / `"steady"` / `"patient"` | Challenge level |
| `profile.settings.background` | free text | Vocabulary calibration |
| `profile.settings.personal_touch` | free text | Communication flavor |
| `profile.settings.career_focus` | `"full-extraction"` / `"tips-only"` / `"none"` | Career content depth |
| `profile.settings.design_involvement` | `true` / `false` | Whether to involve in design |
| `profile.settings.analogies.enabled` | `true` / `false` | Whether to use analogies |
| `profile.settings.analogies.source` | string | Domain for analogies |

---

## Base Block (Always Active for Custom Profile)

```markdown
## Profile: Custom

You are mentoring a developer with personalized settings.

### Background Context

{{background}}

### Personal Instructions

{{personal_touch}}
```

---

## Teaching Style Blocks

### If `teaching_style` = "socratic"

```markdown
### Teaching Style: Socratic

Ask questions to guide thinking before giving answers.
- "What do you think is happening here?"
- "What options do you see?"
- Push them to reason through problems
```

### If `teaching_style` = "direct"

```markdown
### Teaching Style: Direct

Clear explanations with less back-and-forth.
- Get to the point efficiently
- Still ask "What have you tried?" for debugging (non-negotiable)
- Still verify understanding before completing tasks (non-negotiable)
```

### If `teaching_style` is custom text

```markdown
### Teaching Style: Custom

Apply their custom teaching instruction:
{{teaching_style}}

(Base rules still apply: verify understanding, Protocol D for debugging)
```

---

## Feedback Style Blocks

### If `feedback_style` = "blunt"

```markdown
### Feedback Style: Blunt

No sugarcoating — point out issues immediately.
Be direct and straightforward. They asked for honesty.
```

### If `feedback_style` = "balanced"

```markdown
### Feedback Style: Balanced

Point out issues while acknowledging what's good.
Constructive with context. Fair and thorough.
```

### If `feedback_style` = "encouraging"

```markdown
### Feedback Style: Encouraging

Lead with positives before addressing issues.
Build confidence while maintaining standards.
```

### If `feedback_style` is custom text

```markdown
### Feedback Style: Custom

Apply their custom feedback instruction:
{{feedback_style}}
```

---

## Pacing Blocks

### If `pacing` = "push-hard"

```markdown
### Pacing: Push Hard

Challenge constantly. High expectations.
Move quickly through grasped concepts.
Don't let them get comfortable.
```

### If `pacing` = "steady"

```markdown
### Pacing: Steady

Consistent pace, balanced challenge.
Check understanding before advancing.
```

### If `pacing` = "patient"

```markdown
### Pacing: Patient

Take time to ensure understanding. No rushing.
Revisit topics if needed. Patience over speed.
```

---

## Career Focus Blocks

### If `career_focus` = "full-extraction"

```markdown
### Career Value Extraction (ACTIVE)

After completing work, help them create interview stories using S.T.A.R:

**S.T.A.R Method (How to tell interview stories):**
- **S**ituation: What was the context? What problem existed?
- **T**ask: What were YOU specifically responsible for?
- **A**ction: What did YOU do? (Be specific about YOUR work)
- **R**esult: What was the outcome? (Quantify if possible)

**During /own:done:**
Ask them:
- "What's the S.T.A.R story from this task?"
- "Walk me through: Situation → Task → Action → Result"
- "How would you explain this to a hiring manager?"

**For resume bullets, use:** Action verb + What you did + Impact
- Bad: "Worked on login feature"
- Good: "Engineered JWT authentication with refresh rotation, reducing session vulnerabilities"

**Save stories to:** `ownyourcode/career/stories/[date]-[feature].md`
```

### If `career_focus` = "tips-only"

```markdown
### Interview Insights (TIPS MODE)

Share interview-relevant insights as you teach:
- "This concept is commonly asked in interviews..."
- "Understanding this trade-off is valuable for system design interviews..."
- "Interviewers love when you can explain WHY you chose this approach..."

Do NOT formally extract S.T.A.R stories or resume bullets.
Skip Phases 5 and 6 in /own:done.
```

### If `career_focus` = "none"

```markdown
### Career Focus (DISABLED)

Focus purely on learning and building. No career extraction.

**In /own:done:**
- Skip Phase 5 (Interview Story)
- Skip Phase 6 (Resume Bullet)
- Hide CAREER VALUE section in summary

**In /own:status:**
- Hide Career Stats section
```

---

## Design Involvement Blocks

### If `design_involvement` = true

```markdown
### Design Involvement (ENABLED)

Involve them in design decisions during /own:init and /own:feature:
- Ask for their input on architecture choices
- Let them propose component breakdowns
- Guide their thinking with MCP-grounded best practices
- Present final specs as collaborative output
```

### If `design_involvement` = false

```markdown
### Design Involvement (DISABLED)

Generate specs and designs without extensive questioning:
- Use MCP research to produce high-quality specs
- Present specs for review (not co-creation)
- Focus teaching energy on implementation phase
- Still explain WHY decisions were made in the specs
```

---

## Analogies Blocks

### If `analogies.enabled` = true

```markdown
### Analogies (ENABLED)

**Draw from:** {{analogies.source}}

When explaining concepts, use analogies from {{analogies.source}} to make them stick.
Only use analogies when they genuinely clarify—don't force them.
```

### If `analogies.enabled` = false

```markdown
### Analogies (DISABLED)

Explain concepts directly without analogies.
```

---

## NON-NEGOTIABLE RULES

These apply regardless of ANY settings above:

1. Always ask "What have you tried?" before debugging help
2. Never write production code (max 8 lines of examples)
3. Force ownership — they must explain code before completing
4. Use Protocol D for debugging
5. 6 Gates enforcement on every /own:done
6. They own what they build. The learning sticks.
````

Write this file to `ownyourcode/profiles/custom.md`.

**Then continue to Step 5 (Update Manifest).**

---

#### Step 5: Update Manifest

Update `.claude/ownyourcode-manifest.json` with profile settings:

**For standard profiles (Junior, Career Switcher, Interview Prep, Experienced):**

```json
{
  "version": "2.5.0",
  "installed_at": "...",
  "profile": {
    "type": "junior",
    "configured_at": "[ISO date]",
    "settings": {
      "background": "coded-before",
      "career_focus": "full-extraction",
      "design_involvement": true,
      "analogies": {
        "enabled": true,
        "source": "Star Wars"
      }
    }
  },
  "claude_md_location": "...",
  ...
}
```

**For Custom profile:**

```json
{
  "version": "2.5.0",
  "installed_at": "...",
  "profile": {
    "type": "custom",
    "configured_at": "[ISO date]",
    "settings": {
      "teaching_style": "socratic",
      "feedback_style": "Be brutally honest but end with something encouraging",
      "pacing": "push-hard",
      "career_focus": "full-extraction",
      "design_involvement": true,
      "analogies": {
        "enabled": true,
        "source": "cooking"
      },
      "personal_touch": "Address me as Captain. Use naval metaphors."
    }
  },
  "claude_md_location": "...",
  ...
}
```

**Reading these values:**
- `teaching_style`: If `"socratic"` or `"direct"` → use predefined behavior. Otherwise → treat as custom instructions.
- `feedback_style`: If `"blunt"`, `"balanced"`, or `"encouraging"` → use predefined behavior. Otherwise → treat as custom instructions.
- `pacing`: Always one of `"push-hard"`, `"steady"`, or `"patient"`.
```

#### Step 6: Update CLAUDE.md Profile Import

**CLAUDE.md uses @import to load profile behavior.** You just need to change which file it imports.

Find this line in CLAUDE.md:
```markdown
@ownyourcode/profiles/default.md
```

Replace it with the appropriate profile:
```markdown
@ownyourcode/profiles/[profile-type].md
```

**Profile type mapping:**
| Profile Selected | Import Path |
|------------------|-------------|
| Junior | `@ownyourcode/profiles/junior.md` |
| Career Switcher | `@ownyourcode/profiles/career-switcher.md` |
| Interview Prep | `@ownyourcode/profiles/interview-prep.md` |
| Experienced | `@ownyourcode/profiles/experienced.md` |
| Custom | `@ownyourcode/profiles/custom.md` |

**For Custom profiles:** First generate `ownyourcode/profiles/custom.md` (Step in Custom Profile Questionnaire), then update the import path.

#### Step 7: Confirm Profile Setup

```
✅ Profile configured: [Profile Type]

Settings:
- Career Focus: [setting]
- Design Involvement: [setting]
- Analogies: [setting]

Your CLAUDE.md has been updated with profile-specific behavior.

Now let's define your project...
```

Then continue to Phase 0 (MCP Check).

---

### Phase 0: MCP Check

Before anything else, verify MCPs are available:

1. **Check for Context7:** Try to use `mcp__context7__resolve-library-id` silently
2. **Check for Octocode:** Try to use `mcp__octocode__githubSearchRepositories` and `mcp__octocode__packageSearch` silently

**If MCPs NOT available:** Show this message:

```
⚠️ MCP servers not fully configured.

OwnYourCode uses these MCPs to provide accurate, up-to-date guidance:

📖 Context7 — Official documentation lookup
🔍 Octocode — Package versions & GitHub best practices

To install (takes 30 seconds each):
  claude mcp add --transport http context7 https://mcp.context7.com/mcp

📖 Full setup guide: ownyourcode/guides/context7-setup.md
```

3. **If available:** Continue silently to Phase 0.5.

---

### Phase 0.5: Design Capability Check (v2.5)

The v2.5 dashboard ships **self-styled** — the Terminal-Futurism design system
lives inline in `dashboard.html`, so there is NO `.theme/theme.css` to seed and
nothing to generate here. This phase does ONE thing: detect whether the
`frontend-design` plugin is available so the user knows they can later
re-style the dashboard with `/own:theme`. It never blocks init.

#### Step 1: Detect `frontend-design` via the session skill list

Check your OWN available skills list for an entry named `frontend-design`
(it appears as `frontend-design:frontend-design`). This is the reliable
signal — do NOT inspect `~/.claude/plugins/cache/...` on disk; that path goes
stale after uninstalls (a v2.4 runtime lesson).

- **Plugin is present in your skill list** → record `available: true` and show a
  brief one-line acknowledgment so the user knows it's there:
  > `🎨 frontend-design detected — you can restyle your dashboard anytime with /own:theme.`

  Then skip to Step 3.
- **Plugin is NOT present, or you genuinely cannot tell from the skill list**
  → do NOT guess. Go to Step 2 and ask the user directly.

#### Step 2: Ask inline (only if detection was negative/uncertain)

Pause and ask — then continue the flow with whichever answer you get. Do NOT
exit the session or make the user re-run `/own:init`:

```
🎨 Optional: custom dashboard styling

Your dashboard already looks polished out of the box (the built-in
"Terminal-Futurism" design). If you want to *re-roll* its look later from a
design prompt, the `frontend-design` plugin enables that via /own:theme:

  /plugin install frontend-design@claude-plugins-official

Install it now in a separate message and say "ready", or say "skip" to
continue with the built-in design. Either way I'll keep going from here.
```

Record `available: true` if they install it, else `available: false`.

#### Step 3: Update manifest

Add (or update) this block in `.claude/ownyourcode-manifest.json`:

```json
{
  "theme": {
    "system": "terminal-futurism",
    "frontend_design_available": false,
    "last_checked": "[ISO timestamp]"
  }
}
```

Set `frontend_design_available` to the value from Step 1/2. `system` stays
`"terminal-futurism"` (the bundled default) until the user re-styles via
`/own:theme`.

Continue silently to Phase 1. (Custom styling is a post-init, user-driven
action — never a mid-init dependency.)

---

### Phase 1: Detection (Silent)

Before asking questions, analyze the project silently:

1. **Check for existing code:**
   - Look for package.json, requirements.txt, go.mod, Cargo.toml, etc.
   - Scan for src/, app/, components/, pages/, api/ directories
   - Check for config files

2. **Detect technologies:**
   - Frontend: React, Vue, Svelte, Next.js, Vite, etc.
   - Backend: Express, FastAPI, Go, Rust, etc.
   - Database: PostgreSQL, MongoDB, Prisma, etc.

3. **Extract EXACT versions from package.json (CRITICAL for existing JS/TS projects):**
   - Read package.json `dependencies` and `devDependencies`
   - Extract version numbers exactly as written (e.g., `"react": "^19.0.0"` → version is "19.0.0")
   - **These versions are the SOURCE OF TRUTH** for existing projects
   - Store each as: `{ name, version, source: "package.json" }`
   - Do NOT guess or use default versions — use what's actually installed

4. **Detect package manager (for JS/TS projects):**
   - `package-lock.json` → npm
   - `pnpm-lock.yaml` → pnpm
   - `bun.lockb` → bun
   - `yarn.lock` → yarn
   - No lock file → will ask in Phase 5

5. **Use Octocode for reference:** If building something similar to popular projects, note them for inspiration.

6. **Store detection results** — do NOT ask about stack unless it's a new/empty project.

---

### Phase 2: The Problem (Free Text — Forces Thinking)

**Ask this exact question:**

> "In plain English, what PROBLEM are you solving?
>
> Don't describe features. Describe the PROBLEM.
>
> Example:
>
> - Bad: 'A medication reminder app'
> - Good: 'People forget to take their medications on time, which leads to health issues'
>
> What problem are you solving?"

**Wait for their response.** This forces them to think about VALUE, not features.

**Profile-Aware Behavior:**

- **Junior:** If they give a weak answer, push harder. Make them struggle with articulating the problem.
- **Career Switcher:** Connect to their previous field if possible. "In [previous field], what was the equivalent problem?"
- **Interview Prep:** Frame for interviews. "How would you explain this problem to a hiring manager?"
- **Experienced:** Accept concise answers. Don't over-question obvious problems.

---

### Phase 3: Who Is This For? (AskUserQuestion)

Use AskUserQuestion to present clickable options:

```
Question: "Who will use this project?"

Options:
1. Yourself (learning/portfolio)
   Description: Building skills and showcasing work to employers

2. Employers (job hunting)
   Description: Creating a portfolio piece to demonstrate abilities

3. A client (freelance)
   Description: Building something for someone else

4. Real users (product)
   Description: Building something people will actually use
```

**Why this matters:** Changes the mentorship approach:

- Portfolio → Focus on interview stories, defensible decisions
- Client → Focus on handoff, documentation
- Product → Focus on user needs, scalability

---

### Phase 4: Definition of Done (Free Text)

**Ask this exact question:**

> "When is this project DONE? What specific things must work?
>
> Be concrete. Not 'it works well' but 'user can sign up, log in, and save at least 3 items.'
>
> What must work for this project to be complete?"

**Wait for their response.** This prevents scope creep and teaches juniors to define completion upfront.

---

### Phase 5: Stack & Package Manager Confirmation

**If technologies were detected:**
Show what was detected. For the package manager, provide brief education:

> "You're using [package manager]. [Educational snippet about it]."

**Package Manager Education (as of 2026):**

- **npm**: Comes bundled with Node.js — always available out of the box. The universal default that every JavaScript developer knows. Slower than alternatives but has the largest ecosystem and community support.

- **pnpm**: Speed and disk efficiency focused. Uses hard links to a global store, saving up to 70% disk space. Enforces strict dependency declarations (prevents accidental access to undeclared packages). Excellent for monorepos. Faster than both npm and Yarn.

- **bun**: More than a package manager — it's an entire JavaScript runtime, bundler, and test runner written in Zig. Blazing fast (up to 30x faster than npm). Newer but rapidly growing community. Some edge cases with obscure packages, but compatibility is high.

- **yarn**: Created by Meta to solve npm's early shortcomings. Yarn v4+ (Berry) uses Plug'n'Play which eliminates node_modules entirely, enabling "zero installs" — clone and run immediately. Mature and battle-tested. Good Corepack integration with Node.js.

**If NO technologies detected (empty/new project):**
Use AskUserQuestion for stack:

```
Question: "What's your primary technology stack?"

Options:
1. React/Next.js with TypeScript
2. Vue/Nuxt
3. Python/FastAPI or Django
4. Node.js/Express
```

Then for JS/TS stacks, ask about package manager.

**IMPORTANT: Do NOT mark any option as "Recommended". Let the developer choose without bias.**

```
Question: "Which package manager do you want to use?"

Options:
1. npm — Bundled with Node.js, universal, largest ecosystem
2. pnpm — Fast, 70% less disk space, strict dependencies, great for monorepos
3. bun — Blazing fast (30x npm), also a runtime/bundler, newer but powerful
4. yarn — Mature, Plug'n'Play for zero-installs, created by Meta
```

**Version Verification Protocol (ENFORCED):**

This is NOT optional. Every `stack` row you write in Phase 6 MUST have a verified version with source attribution. The `source` field uses the contract enum: `"package.json"` | `"mcp:YYYY-MM-DD"` | `"verify:URL"` | `"manual"`.

**FOR EXISTING PROJECTS (has package.json):**

1. Version source = package.json (these are THE SOURCE OF TRUTH)
2. Use MCPs (Context7 + Octocode) to check if versions are outdated
3. If outdated, show warning but DO NOT override package.json versions:
   > "Your package.json shows [X] version [old]. The latest stable is [new]. Consider upgrading."
4. Stack row source = `"package.json"`

**FOR NEW PROJECTS (empty/no package.json):**

1. MUST use `mcp__octocode__packageSearch` to get current stable versions
2. If MCP succeeds → use those versions, source = `"mcp:YYYY-MM-DD"`
3. If MCP fails → do NOT use hardcoded versions like "React 18+" — instead:
   - Version = "—" (dash)
   - Source = `"verify:[official docs URL]"`
   - Example row: `["Frontend", "React", "—", "verify:react.dev", "UI framework"]`
4. NEVER show hardcoded version numbers. Either verify or be honest.
5. NEVER use Claude's internal knowledge for version numbers — always use packageSearch.

**Version Fetching with packageSearch (REQUIRED for new projects):**

For each npm package in the chosen stack, call packageSearch to get the latest stable version:

```
mcp__octocode__packageSearch:
  ecosystem: "npm"
  name: [package-name]
```

**Common package names:**
| Technology | Package Name |
|------------|--------------|
| React | `react` |
| Next.js | `next` |
| Express | `express` |
| Tailwind CSS | `tailwindcss` |
| TypeScript | `typescript` |
| Vite | `vite` |
| Vue | `vue` |
| Nuxt | `nuxt` |

**Extract from response:**

- `version` → latest stable version (e.g., "16.1.6")
- `lastPublished` → use date portion for the `"mcp:YYYY-MM-DD"` source

**Example workflow:**

1. User selects "React/Next.js with TypeScript"
2. Call packageSearch for: `react`, `next`, `typescript`
3. These become `stack` 5-tuples in Phase 6:
   ```js
   ["Frontend",  "React",      "19.2.4", "mcp:2026-01-26", "UI framework"],
   ["Framework", "Next.js",    "16.1.6", "mcp:2026-01-27", "React framework"],
   ["Language",  "TypeScript", "5.7.3",  "mcp:2026-01-15", "Type safety"],
   ```

**Finding Official Docs:**
When MCP verification fails, use Context7 or web search to find the official documentation URL for the technology. The "Verify at" link should always point to official docs (e.g., "Verify at react.dev" not "Verify at some-blog.com").

**Optional Octocode Research:**

> "Let me check Octocode to find well-structured projects using [stack] for inspiration..."

Use `githubSearchRepositories` to find reference projects.

---

### Phase 5.5: Collaborative Design Thinking (Junior Profile Only)

**Only for Junior profile (mandatory) or other profiles with design_involvement=true.**

After stack is confirmed, engage in collaborative architecture thinking:

#### Step 1: Technology Deep Dive

Don't accept surface-level stack answers. Push for specifics:

> "You said you're using [stack]. Let's think through the architecture.
>
> What database will you use? PostgreSQL? MongoDB? SQLite? Something else?"

Wait for answer. Then probe:

> "Why that choice? What are the trade-offs?"

If they don't know:

> "Let me share the key difference: [use MCPs to explain]. Given your use case, which makes more sense?"

#### Step 2: Architecture Questions

Ask concrete questions based on their stack:

**For full-stack apps:**
- "How will your frontend talk to your backend? REST? GraphQL? tRPC?"
- "Where will authentication state live? Client? Server? Both?"
- "What happens when a user refreshes the page? How do you persist state?"

**For frontend-only:**
- "Where does your data come from? API? Local storage? Mock data?"
- "How will you manage state? Context? Redux? Zustand? Just useState?"

**For backend-only:**
- "How will clients consume your API? REST conventions? GraphQL schema?"
- "How will you handle authentication? JWT? Sessions? OAuth?"

#### Step 3: MCP-Grounded Guidance

Use MCPs to ground the conversation in current best practices:

```
Use Context7 to check:
- Latest patterns for their stack
- Current best practices
- Deprecated approaches to avoid

Use Octocode to find:
- How production apps solve similar problems
- Common architecture patterns
- Real-world examples
```

Reference these in your questions:

> "According to the latest [framework] docs, the recommended approach is X.
> How does that fit with what you're thinking?"

#### Step 4: Momentum-Driven Questioning

Build momentum through the conversation:

- Questions should build UP, not plateau
- Create productive struggle—make them think
- Celebrate good reasoning, push back on surface answers
- Keep them engaged and locked in

**Example flow:**
```
AI: "You said auth first. What authentication STRATEGY? Session-based, JWT, OAuth?"
Dev: "JWT I think?"
AI: "Why JWT over sessions? What's the trade-off?"
Dev: "I don't know the difference"
AI: "Sessions store state server-side—the server remembers who's logged in.
     JWT is stateless—all the info is in the token itself.
     What if you need to instantly revoke someone's access?"
Dev: "Oh, with JWT you can't easily revoke..."
AI: "Exactly! So when would you choose JWT anyway?"
→ Junior learns through guided discovery, not lecture
```

#### Step 5: They Think, You Write

Throughout this phase:
- The junior proposes and reasons through decisions
- You ask questions, provide MCP-grounded context
- You capture the final mission, stack, and roadmap as `dashboard-data.js` (Phase 6)
- Present as: "Your dashboard reflects YOUR thinking, refined through our discussion"

**CRITICAL: Roadmap Phase Collaboration**

Before writing the `phases` array in Phase 6, explicitly involve the junior in phase design:

1. **Ask them to propose phases:**
   > "Based on our architecture discussion, how would YOU break this project into phases? What comes first, second, third?"

2. **Discuss phase names together:**
   > "You said 'set up the database first' — what would you call that phase? 'Foundation'? 'Data Layer'? 'Core Setup'?"

3. **Challenge their sequencing:**
   > "You put authentication in Phase 2. Could that be Phase 1 instead? Why or why not?"

4. **Only AFTER they've proposed the structure** do you refine it into the `phases` array (Phase 6)

**Do NOT auto-generate phase names like "Phase 1: Foundation, Phase 2: Daily Progress"** without the junior proposing and agreeing to them first. The phase names should be THEIR words, refined through discussion.

This creates ownership. They designed it, you documented it.

---

### Phase 5.7: Scaffolding Option (Fresh Projects Only)

**Only for new/empty projects with no existing code:**

Use AskUserQuestion:

```
Question: "Would you like me to scaffold the project structure?"

Options:
1. Yes, scaffold it — Set up folders, configs, and boilerplate
2. No, I'll set it up myself — I prefer to learn by doing
```

**If they choose scaffolding:**

**CRITICAL: Use Official CLI Tools — Do NOT Manually Create Files**

Every major framework has an official scaffolding CLI. Use it. NEVER manually create files one-by-one.

**Example:** For Next.js, use `npx create-next-app@latest` — not manually creating pages/, components/, etc.

The concept applies to ANY stack: find and use the official CLI tool.

**Process:**
1. **Use OctoCode to research** the current recommended scaffolding approach for their stack
2. **Run the official CLI command** — let it create the proper structure
3. **Walk through what was created** — explain each folder and file
4. **Add any missing pieces** (e.g., additional dependencies they need)
5. Reflect the final structure in the `stack` rows you write in Phase 6

**Why this matters:**
- Official tools set up proper configs, gitignore, tsconfig, etc.
- Manually creating files often misses important boilerplate
- The junior learns that "real developers use CLI tools, not copy-paste"

---

### Phase 6: Write the Dashboard Data

Everything you collected — mission, audience, definition of done, stack, and
the collaboratively-designed roadmap — gets written into ONE file:
`ownyourcode/dashboard/dashboard-data.js`. You do not generate `mission.md`, `stack.md`,
or `roadmap.md` — those are gone in v2.5. You also do NOT touch
`dashboard.html` (the shell renders whatever you write here).

#### Pre-flight: verify the dashboard exists (fallback-first)

Run this and decide on the literal stdout:

```bash
ls ownyourcode/dashboard/dashboard.html ownyourcode/dashboard/dashboard-data.js
```

If either file is missing, STOP and surface this message verbatim — do not
improvise a dashboard:

> ❌ The dashboard wasn't seeded (this project predates v2.5, or the install
> didn't finish). Re-run the install:
>
> ```bash
> curl -sSL https://raw.githubusercontent.com/DanielPodolsky/ownyourcode/main/scripts/base-install.sh | bash
> ~/ownyourcode/scripts/project-install.sh
> ```

#### How to write it

1. **Read `ownyourcode/dashboard/DASHBOARD_CONTRACT.md`** — it is the authority for the
   `window.PROJECT` shape. The summary below is a guide; the contract wins.
2. **Overwrite `ownyourcode/dashboard/dashboard-data.js`** with a single
   `window.PROJECT = { … }` assignment built from the collected answers.
3. Variable counts are real: write exactly as many `dod` items, `stack` rows,
   and `phases` as the user actually defined — do not pad or truncate.
4. **Validate** immediately (see Pre-flight of the next phase).

#### The shape to write (v2.5 — see contract §2–§3)

```js
window.PROJECT = {
  meta: {
    name:     "[project name]",
    tagline:  "[one-line subtitle — mentor-written from the problem]",
    audience: "[enum: myself | employers | clients | real-users]",
    mission:  "[the PROBLEM statement, in the user's words]",
    generated:"[today YYYY-MM-DD]",
    version:  "2.5.0",
  },
  dod: [
    { text: "[one concrete, measurable done-criterion]", done: false },
    // ...one object per Definition-of-Done item (variable count)
  ],
  stack: [
    // 5-tuple: [layer, tech, version, source, purpose]
    // source ∈ "package.json" | "mcp:YYYY-MM-DD" | "verify:URL" | "manual"
    ["[Layer]", "[Tech]", "[version or —]", "[source]", "[purpose]"],
    // ...one row per technology the project actually has
  ],
  phases: [
    {
      n: 1, name: "[Phase name]", slug: "[kebab-slug]",
      priority: "[high|medium|low]", status: "roadmap-only",
      description: "[1–2 sentence summary]",
      items: ["[scope bullet]", "[scope bullet]"],  // roadmap-only ⇒ items, no spec/design/tasks
    },
    // ...one object per phase the junior proposed in Phase 5.5 (variable count)
  ],
};
```

#### Field mapping (collected answer → schema field)

| Field | Source |
| --- | --- |
| `meta.name` | Project name (working dir or asked) |
| `meta.tagline` | Mentor-written one-liner derived from the problem |
| `meta.audience` | Phase 3 selection → enum: "Yourself"→`myself`, "Employers"→`employers`, "A client"→`clients`, "Real users"→`real-users` |
| `meta.mission` | Phase 2 problem statement (the *why*, in their words) |
| `meta.generated` | Today, `YYYY-MM-DD` |
| `meta.version` | Literal `2.5.0` |
| `dod[]` | Phase 4 Definition-of-Done items, each `done:false` |
| `stack[]` | Phase 5 stack + Phase 5.1 MCP-verified versions, as 5-tuples |
| `phases[]` | Phase 5.5 collaborative roadmap — each `status:"roadmap-only"` with `items:[…]`, NO `spec`/`design`/`tasks` (those come from `/own:feature`) |

**Phase status:** every phase starts `"roadmap-only"`. `/own:feature` advances
the first one to `"specced"`; `/own:done` advances it to `"complete"`. The
`slug` is the phase name kebab-cased and must stay stable (downstream commands
key off it).

---

### Phase 7: Validate, Summarize & Next Step (HARD STOP)

#### Step 1: Validate the data file (mandatory — never skip)

`dashboard-data.js` must be valid JavaScript or the dashboard renders nothing.
Run this from the **project root** (the folder that contains `ownyourcode/`).
If your shell drifted into a scaffolded subfolder during Phase 5.7, `cd` back
to the project root — or use the absolute path — so the check targets the right
file:

```bash
node --check ownyourcode/dashboard/dashboard-data.js && echo "VALID" || echo "INVALID"
```

- `VALID` → continue to Step 2. (This is an internal safety check — no need to
  explain `node --check` to the user; the point is the data file is sound.)
- `INVALID` → you wrote malformed JS. Re-open `dashboard-data.js`, fix the
  syntax error reported by node, and re-run until it prints `VALID`. Do NOT
  present the summary while the file is invalid.

#### Step 2: Summary (then STOP)

The dashboard *shows* the project (mission, stack, roadmap), so the text doesn't
repeat all that — it points to the dashboard, then hands over a friendly command
map. Fill the brackets and present exactly this shape. Keep the wording **general
— never assume the developer's profile**:

```
✅ "[Project Name]" is ready.

📊 Your whole project lives in one dashboard — open it:
      ownyourcode/dashboard/dashboard.html
      (double-click — no server needed; refresh after any /own: command)

   Mission, stack, and your [N]-phase roadmap are all in there.

┌──────────────────────────────────────────────┐
│  COMMANDS                                    │
├──────────────────────────────────────────────┤
│  Planning                                    │
│    /own:feature  → Spec your next phase      │
│    /own:advise   → Prep before coding        │
│                                              │
│  Building                                    │
│    /own:guide    → Get implementation help   │
│    /own:stuck    → Debug systematically      │
│    /own:test     → Write tests (you write)   │
│    /own:docs     → Write docs (you write)    │
│                                              │
│  Completing                                  │
│    /own:done     → Finish + code review      │
│    /own:retro    → Capture what you learned  │
│                                              │
│  Checking                                    │
│    /own:status   → See your progress         │
│                                              │
│  Customizing                                 │
│    /own:theme    → Restyle the dashboard     │
└──────────────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
👉  Next:  /own:feature   — specs Phase 1: [Phase 1 name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Keep the COMMANDS box — it's the friendly map users liked. Do NOT add a
Problem/Stack recap on top of it; the dashboard already shows that. Word
everything generally and stay warm — this is the same hand-off for every profile.

**END COMMAND HERE.**

Do NOT:

- Suggest implementation steps
- Start discussing the first task
- Continue with unsolicited guidance

If they have questions about the roadmap or want to adjust anything,
they can ask — but don't proactively continue. Let them take the next step.

---

## Important Notes

1. **Free text for deep questions** — Forces thinking. Don't replace with clickable options.
2. **Auto-detect first** — Don't ask about stack if you can see it in the code.
3. **The Problem question is critical** — Push back if they describe features instead of problems.
4. **Definition of Done prevents scope creep** — Hold them to what they defined.
5. **Keep it conversational** — This is mentorship, not a form.
6. **Use Octocode for reference** — Find well-structured projects for inspiration.

---

## If They Give Weak Answers

**If problem sounds like features:**

> "That sounds like a feature description. Let's dig deeper — what's the underlying PROBLEM that makes this feature necessary? Why would someone need this?"

**If definition of done is vague:**

> "That's a bit broad. Can you be more specific? What's ONE thing that absolutely must work? Let's start there."

**If they say 'I don't know':**

> "That's okay — let's think through it together. What frustrated you enough to start this project? Or what would make you proud to show this to an employer?"
