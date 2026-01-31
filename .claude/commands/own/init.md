---
name: init
description: Initialize OwnYourCode project with mission, stack, and roadmap
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__octocode__githubSearchRepositories, mcp__octocode__githubViewRepoStructure
---

# /own:init

Initialize a OwnYourCode project by defining the mission, detecting the stack, and creating a roadmap.

## Overview

This command works for both **new projects** (empty directory) and **existing projects** (mid-development).

**Output:**
- `ownyourcode/product/mission.md` — Project purpose and vision
- `ownyourcode/product/stack.md` — Technology decisions and rationale
- `ownyourcode/product/roadmap.md` — Phased development plan

---

## The Philosophy

These questions force THINKING, not feature-listing. Most juniors skip straight to "I want a login form." We force them to think about VALUE first.

---

## Execution Flow

### Phase 0: MCP Check

Before anything else, verify MCPs are available:

1. **Check for Context7:** Try to use `mcp__context7__resolve-library-id` silently
2. **Check for Octocode:** Try to use `mcp__octocode__githubSearchRepositories` silently

**If MCPs NOT available:** Show this message:

```
⚠️ MCP servers not fully configured.

OwnYourCode uses these MCPs to provide accurate, up-to-date guidance:

📖 Context7 — Official documentation lookup
🔍 Octocode — GitHub best practices search

To install (takes 30 seconds each):
  claude mcp add --transport http context7 https://mcp.context7.com/mcp

📖 Full setup guide: ownyourcode/guides/context7-setup.md
```

3. **If available:** Continue silently to Phase 1.

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
> - Bad: 'A medication reminder app'
> - Good: 'People forget to take their medications on time, which leads to health issues'
>
> What problem are you solving?"

**Wait for their response.** This forces them to think about VALUE, not features.

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

Then for JS/TS stacks, ask about package manager:

```
Question: "Which package manager do you want to use?"

Options:
1. npm — Bundled with Node.js, universal, largest ecosystem
2. pnpm — Fast, 70% less disk space, strict dependencies, great for monorepos
3. bun — Blazing fast (30x npm), also a runtime/bundler, newer but powerful
4. yarn — Mature, Plug'n'Play for zero-installs, created by Meta
```

**Version Verification Protocol (ENFORCED):**

This is NOT optional. Every technology in stack.md MUST have a verified version with source attribution.

**FOR EXISTING PROJECTS (has package.json):**
1. Version source = package.json (these are THE SOURCE OF TRUTH)
2. Use MCPs (Context7 + Octocode) to check if versions are outdated
3. If outdated, show warning but DO NOT override package.json versions:
   > "Your package.json shows [X] version [old]. The latest stable is [new]. Consider upgrading."
4. In stack.md, source = "package.json"

**FOR NEW PROJECTS (empty/no package.json):**
1. MUST query Context7 and/or Octocode for current stable versions
2. If MCP succeeds → use those versions, source = "MCP verified (YYYY-MM-DD)"
3. If MCP fails → do NOT use hardcoded versions like "React 18+" — instead:
   - Version = "—" (dash)
   - Source = "Verify at [official docs URL]"
   - Example: `| Frontend | React | — | Verify at react.dev | UI framework |`
4. NEVER show hardcoded version numbers. Either verify or be honest.

**Finding Official Docs:**
When MCP verification fails, use Context7 or web search to find the official documentation URL for the technology. The "Verify at" link should always point to official docs (e.g., "Verify at react.dev" not "Verify at some-blog.com").

**Optional Octocode Research:**
> "Let me check Octocode to find well-structured projects using [stack] for inspiration..."

Use `githubSearchRepositories` to find reference projects.

---

### Phase 5.5: Scaffolding Option (Fresh Projects Only)

**Only for new/empty projects with no existing code:**

Use AskUserQuestion:

```
Question: "Would you like me to scaffold the project structure?"

Options:
1. Yes, scaffold it — Set up folders, configs, and boilerplate
2. No, I'll set it up myself — I prefer to learn by doing
```

**If they choose scaffolding:**

1. Use OctoCode to research modern project structures for their stack
2. Search for well-rated starter templates
3. Generate appropriate:
   - Folder structure (src/, components/, etc.)
   - Config files (tsconfig.json, .eslintrc, etc.)
   - Basic boilerplate
4. Explain each file/folder created so they understand the structure
5. Document the structure in stack.md

---

### Phase 6: Generate Outputs

Based on collected information, generate:

#### mission.md

```markdown
# Project Mission

## The Problem

[User's problem statement - in their words]

## Who Is This For?

[Based on selection: Myself/Employers/Client/Real Users]

## Definition of Done

When these things work, the project is COMPLETE:

- [ ] [From user's definition of done]
- [ ] [Break down into specific checkboxes]
- [ ] [Be concrete and measurable]

## Why This Matters

[Brief statement connecting problem to solution - written by mentor based on their answers]
```

#### stack.md

```markdown
# Technology Stack

## Detected/Chosen Stack

| Layer | Technology | Version | Source | Purpose |
|-------|------------|---------|--------|---------|
| Frontend | [Name] | [Version or —] | [package.json / MCP verified (date) / Verify at URL] | [Purpose] |
| Backend | [Name] | [Version or —] | [Source] | [Purpose] |
| Database | [Name] | [Version or —] | [Source] | [Purpose] |
| Styling | [Name] | [Version or —] | [Source] | [Purpose] |
| Build | [Name] | [Version or —] | [Source] | [Purpose] |

**Source Legend:**
- `package.json` — Version from your installed dependencies (source of truth)
- `MCP verified (YYYY-MM-DD)` — Confirmed via Context7/Octocode on this date
- `Verify at [URL]` — Could not verify; check official docs for current version

## Package Manager

**Using:** [npm/pnpm/bun/yarn]

[Brief education snippet from Phase 5]

## Why These Choices?

[If detected: "These were already in your project."]
[If chosen: Brief rationale for the stack choice]

## Version Notes

[Any outdated versions detected and recommendations]

## Reference Projects (via Octocode)

[List 1-2 well-structured GitHub repos using similar stack for reference]

## Key Files

| File | Purpose |
|------|---------|
| [Auto-detected entry point] | [Purpose] |
| [Config files] | [Purpose] |

## Version Freshness

⚠️ **Generated**: [YYYY-MM-DD]

Technology versions change frequently. If this document is more than 30 days old, re-run `/own:init` or check the official documentation for each technology listed above.
```

#### roadmap.md

```markdown
# Project Roadmap

## Current Status

[New project / Existing project description]

## Phase 1: Foundation

Priority: HIGH

- [ ] Project setup complete
- [ ] Core structure in place
- [ ] [Based on their Definition of Done]

## Phase 2: Core Features

Priority: MEDIUM

- [ ] [Derived from their problem statement]
- [ ] [Break down logically]

## Phase 3: Polish & Deploy

Priority: LOW

- [ ] Testing and bug fixes
- [ ] Documentation
- [ ] Deployment
```

---

### Phase 7: Summary & Next Step (HARD STOP)

After generating files, provide this summary and **STOP**:

```
✅ OwnYourCode initialized!

Problem: [One-line from their answer]
For: [Who they selected]
Done when: [Summary of their definition]
Stack: [Technologies]

Created:
- ownyourcode/product/mission.md
- ownyourcode/product/stack.md
- ownyourcode/product/roadmap.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 NEXT: Run /own:feature to plan your first phase
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your roadmap has [N] phases. /own:feature will auto-detect
Phase 1 and generate specs for you to review.

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
└──────────────────────────────────────────────┘

💡 Your learnings persist across ALL projects.
   Every /own:retro feeds the global registry.
   Every /own:advise queries your past wins & failures.
   The more you use it, the smarter it gets.
```

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
