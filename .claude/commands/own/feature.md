---
name: feature
description: Create a feature specification using spec-driven development
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__octocode__githubSearchCode, mcp__octocode__githubGetFileContent, mcp__octocode__githubSearchRepositories
---

# /own:feature

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Create a feature specification using **Spec-Driven Development (SDD)**.

## Overview

This command follows the SDD workflow:
1. **AI generates** spec.md, design.md, tasks.md based on minimal input
2. **Developer reviews** the generated specs
3. **Developer adds** any missing edge cases or requirements
4. **Then** implementation begins with mentorship

**Output:**
- `ownyourcode/specs/active/phase-[N]-[phase-name]/spec.md` — Feature specification
- `ownyourcode/specs/active/phase-[N]-[phase-name]/design.md` — Technical design
- `ownyourcode/specs/active/phase-[N]-[phase-name]/tasks.md` — Phased implementation checklist

**Naming convention:** `phase-1-foundation`, `phase-2-core-features`, `phase-3-polish`
This gives clear visibility of which phase you're working on.

**Profile-Aware Behavior:**
Check `.claude/ownyourcode-manifest.json` for profile settings:
- **Junior profile** → Collaborative spec creation (mandatory design involvement)
- **Other profiles with `design_involvement=true`** → Collaborative spec creation
- **Profiles with `design_involvement=false`** → AI generates, developer reviews

---

## The SDD Philosophy

> "Spec first, code second. But YOU write the code."

Unlike other SDD tools where AI writes code, OwnYourCode uses SDD for PLANNING only.
The implementation phase is where the junior learns by doing.

---

## Execution Flow

### Before Asking Questions: Check the Roadmap

Before asking the user for feature details, automatically check the roadmap:

1. **Read** `ownyourcode/product/roadmap.md`
2. **Find** the first phase with any incomplete tasks (`- [ ]`)
3. **Auto-select** that phase — no asking, keep it simple

**Completion criteria:**
- A phase is COMPLETE when: All tasks marked `[x]`
- A phase is INCOMPLETE if: Any task is `[ ]`

**If roadmap found with incomplete phase:**
```
📍 Detected from roadmap: Phase [N] — [Phase Name]

This phase covers:
- [Task 1]
- [Task 2]
...

Generating specs for this phase...
```
→ Proceed directly to Phase 2 (MCP Research)
→ Spec folder: `ownyourcode/specs/active/phase-[N]-[phase-name]/`

**If NO roadmap exists:**
→ Ask user for feature details (proceed to "Core Requirements" section below)

**If ALL phases complete:**
→ Congratulate them! Then ask what they want to build next.

---

### Phase 1: Core Requirements (Minimal Input)

Ask only what's needed to generate specs:

**1a. Feature Name:**
> "What are you building? Give it a short name (e.g., 'login form', 'user settings', 'dark mode')."

Generate slug: `login-form`, `user-settings`, `dark-mode`

**1b. One-Line Description:**
> "In one sentence, what does this feature do?"

**1c. User Story (Keep it simple):**
> "Complete this: As a [user type], I want to [action] so that [benefit]."

Push back ONLY if they skip the 'so that' part — that's the value.

---

### Phase 2: MCP-Powered Research (MANDATORY: Use BOTH)

Before generating specs, gather intelligence using **BOTH** MCPs. Never rely on just one source.

#### Context7 — Official Documentation (ALWAYS USE)
Fetch latest docs for relevant libraries:
```
Use mcp__context7__get-library-docs for:
- Form handling (if form feature)
- Authentication (if auth feature)
- Data fetching (if API feature)
- State management patterns
- Latest API patterns and version-specific features
```

#### Octocode — Production Implementations (ALWAYS USE)
Search GitHub for how real apps implement similar features:
```
Use mcp__octocode__githubSearchCode to find:
- How popular projects implement this feature
- Common patterns and approaches
- Edge cases handled in production

Example: For "login form", search:
- "login form react" in popular repos
- "authentication flow next.js"
- "form validation typescript"
```

**BOTH sources are required.** If you only use one, research is incomplete.

Present research findings:
```
📖 Documentation (Context7):
- React 19 recommends [pattern] for forms
- Key API: useActionState for async form handling

🔍 Production Examples (Octocode):
- [popular-app] implements login with [approach]
- Common pattern: separate validation logic
- Edge case often handled: rate limiting
```

---

### Phase 2.5: Internal Skill Mapping (DO NOT SHOW TO JUNIOR)

Based on the feature type, internally note which skills apply. These skills are used **during planning** (to shape the spec) AND **during review** (to check the code) — never mentioned to the junior.

**Available Skills:**
frontend, backend, database, security, performance, error-handling, engineering, testing, seo, accessibility, documentation, debugging

| Feature Type | Skills to Apply Silently |
|--------------|--------------------------|
| Frontend UI | frontend, accessibility, seo (if public-facing), testing |
| Backend API | backend, security, error-handling, performance, testing |
| Forms | frontend, accessibility, security, error-handling, testing |
| Database operations | backend, database, security, performance, testing |
| Full-stack feature | frontend, backend, security, error-handling, testing |
| Any code | engineering, testing, documentation |

**How skills shape the spec:**
- **frontend skill** → Component structure, state management patterns
- **backend skill** → API design, request/response handling, middleware
- **accessibility skill** → Add edge cases for keyboard navigation, screen readers
- **security skill** → Add input validation, auth checks to design.md
- **error-handling skill** → Pre-populate error scenarios in edge cases
- **seo skill** → Include semantic HTML requirements in design.md
- **performance skill** → Add performance considerations to design.md
- **testing skill** → Include "what tests to write" in tasks.md

**How skills shape code review:**
- During `/own:done`, apply skill checklists naturally
- Never say "according to the accessibility skill" — just give the guidance

Example internal note (not shown to junior):
```
Feature: Login Form
Applicable skills: frontend, backend, security, accessibility, error-handling, testing

Spec impact:
- Frontend: Component structure, form state management
- Backend: Auth endpoint design, session handling
- Security: CSRF protection, rate limiting, password hashing
- Accessibility: Screen reader announces errors, keyboard-only login
- Error-handling: Network failures, validation errors, auth failures
- Testing: Unit tests for validation, integration tests for auth flow
```

---

### Phase 3: AI Generates Specs (The SDD Part)

**⚠️ Profile Check First:**
Read `.claude/ownyourcode-manifest.json` to determine spec generation mode:
- If `profile.type = "junior"` → Use **Collaborative Mode** (below)
- If `profile.settings.design_involvement = true` → Use **Collaborative Mode**
- Otherwise → Use **Standard Mode** (AI generates, developer reviews)

**Read the project context:**
1. Check `ownyourcode/product/mission.md` for project goals
2. Check `ownyourcode/product/stack.md` for technology constraints
3. Scan existing code structure to understand patterns

**Standard Mode (design_involvement=false):**
Generate all three files based on:
- User's input from Phase 1
- MCP research from Phase 2
- Project context
- Technology stack
- Best practices from documentation AND production examples

**Collaborative Mode (Junior or design_involvement=true):**

Instead of generating silently, involve the developer in design thinking.

**IMPORTANT: Use FREE-TEXT questions, NOT AskUserQuestion with options.**
The goal is to make them THINK, not pick from a list. All questions below should be asked as free-text prompts that require them to articulate their thoughts:

#### Step 1: Component Breakdown
> "What components do you think this feature needs?"
> "How would you break this down into parts?"

Let them propose. Guide with questions:
> "What about [component they missed]?"
> "Where would [specific logic] live?"

#### Step 2: Data Flow Thinking
> "When the user clicks [trigger], what happens? Walk me through the flow."
> "Where does the data come from? Where does it go?"

Push for specifics:
> "What state needs to update?"
> "What API calls are needed?"

#### Step 3: Edge Case Discovery
> "What could go wrong here?"
> "What if the network fails? What if the user does something unexpected?"

Use MCPs to add edge cases they missed:
> "Looking at how production apps handle this, they also consider [edge case]."

#### Step 4: Collaborative Refinement
- Build on their ideas with MCP-grounded best practices
- Fill gaps they missed, but credit their thinking
- Use their terminology and structure as the foundation

#### Step 5: Generate with Attribution
When generating final specs:
- Structure reflects their proposed breakdown
- Add professional polish and completeness
- Include sections for edge cases they discovered

Present as: "These specs reflect YOUR thinking, refined through our discussion"

---

### Phase 4: Present Specs for Review

After generating, present a summary:

```
I've generated your feature specs based on your requirements, official docs,
and how production apps implement this.

📋 spec.md — What we're building
   • User Story: [their story]
   • Acceptance Criteria: [3-4 items I generated]
   • Edge Cases: [4-5 I identified from research]
   • Out of Scope: [2-3 exclusions]

🏗️ design.md — How we're building it
   • Components: [list]
   • Data Flow: [summary]
   • State: [where it lives]
   • Patterns: [based on Context7 + Octocode research]

✅ tasks.md — Implementation phases
   • Phase 1: Foundation [X tasks]
   • Phase 2: Core Logic [X tasks]
   • Phase 3: Integration [X tasks]
   • Phase 4: Polish [X tasks]

Please review these specs. You should:
1. Read through spec.md and design.md
2. ADD any edge cases I missed
3. MODIFY anything that doesn't match your vision
4. REMOVE anything out of scope

When ready:
- Run /own:advise to prepare for implementation
- Then /own:guide to start Phase 1
```

---

### Phase 5: Junior Review & Acceptance

Use AskUserQuestion:

```
Question: "Have you reviewed the specs?"

Options:
1. Yes, they look good
   Description: Ready to start implementation

2. I want to add edge cases
   Description: Tell me what scenarios I missed

3. I want to modify something
   Description: Tell me what needs to change

4. Let me read them first
   Description: Take your time — run this command again when ready
```

Based on response:
- **Looks good:** Finalize and move to implementation
- **Add/Modify:** Make changes, regenerate summary
- **Read first:** End command, let them review

---

## Generated File Templates

### spec.md

```markdown
# Feature: [Feature Name]

> Generated by OwnYourCode. Review and modify as needed.

## User Story

As a [user type], I want to [action] so that [benefit].

## Acceptance Criteria

When these pass, the feature is DONE:

- [ ] [Criterion 1 - specific and testable]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
- [ ] [Criterion 4]

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Empty input | Show validation error, focus on field |
| Network failure | Show error message, allow retry |
| Double submission | Disable button after first click |
| [From Octocode research] | [Appropriate handling] |
| [From Octocode research] | [Appropriate handling] |

> **Junior:** Add any edge cases I missed below:
> - [ ] _Your edge case here_

## Out of Scope

What this feature does NOT include (keeps focus):

- [Exclusion 1 — future feature]
- [Exclusion 2 — different feature]
- [Exclusion 3 — out of MVP]

## Dependencies

Before starting:
- [ ] [Any prerequisites]
- [ ] [APIs that must exist]
- [ ] [Components that must be built first]

## Research References

- Context7: [Library docs referenced]
- Octocode: [Repos examined for patterns]
```

### design.md

```markdown
# Technical Design: [Feature Name]

> Generated by OwnYourCode based on your stack, official docs, and production patterns.

## Overview

[One paragraph explaining the technical approach, based on project stack and research]

## Architecture

```
[ASCII diagram showing component relationships]
```

## Components

| Component | Purpose | New/Modified | Location |
|-----------|---------|--------------|----------|
| [Component 1] | [What it does] | New | src/components/ |
| [Component 2] | [What it does] | Modified | src/pages/ |

## Data Flow

1. **Trigger:** [User action that starts this]
2. **Frontend:** [What happens in UI]
3. **State Update:** [How state changes]
4. **API Call:** [If applicable]
5. **Response:** [What comes back]
6. **UI Update:** [How UI reflects result]

## State Management

| State | Type | Location | Initial Value |
|-------|------|----------|---------------|
| [state name] | boolean | useState | false |
| [state name] | object | [per stack] | null |

## Error Handling

| Error Type | User Sees | Code Does |
|------------|-----------|-----------|
| Validation | "Please enter a valid email" | Prevent submit, focus field |
| Network | "Something went wrong. Try again." | Log error, show retry button |
| Auth | "Please log in to continue" | Redirect to login |

## Security Considerations

- [ ] Input validation on frontend AND backend
- [ ] No sensitive data in localStorage
- [ ] [Other considerations based on feature]

## Patterns from Research

Based on Context7 and Octocode research:
- [Pattern 1 from docs or production apps]
- [Pattern 2]
- [Anti-pattern to avoid]
```

### tasks.md

```markdown
# Implementation Tasks: [Feature Name]

> Work through these phases IN ORDER. Each phase builds on the previous.

## Before You Start

- [ ] Read and understand spec.md
- [ ] Read and understand design.md
- [ ] Run /own:advise for pre-work preparation
- [ ] Check that dependencies are met
- [ ] Ask mentor if anything is unclear

---

## Phase 1: Foundation
> Build the skeleton. No logic yet.

- [ ] Create component file(s) at correct location
- [ ] Set up basic structure (HTML/JSX only)
  └── Depends on: Component file exists
- [ ] Add placeholder styling
  └── Depends on: Basic structure

**Checkpoint:** You should see the component render (empty/unstyled is fine).

---

## Phase 2: Core Logic
> Add the main functionality.

- [ ] [First core task]
  └── Depends on: Phase 1 complete
- [ ] [Second core task]
  └── Depends on: [specific task]
- [ ] [Third core task]
  └── Depends on: [specific task]

**Checkpoint:** Core functionality works with happy path.

---

## Phase 3: Edge Cases
> Handle what can go wrong.

- [ ] Handle empty/invalid input
- [ ] Handle network failures
- [ ] Handle loading states
- [ ] [Other edge cases from spec]

**Checkpoint:** Feature handles errors gracefully.

---

## Phase 4: Polish
> Make it production-ready.

- [ ] Add proper error messages
- [ ] Add loading indicators
- [ ] Final styling pass
- [ ] Test against acceptance criteria

**Checkpoint:** All acceptance criteria pass.

---

## Completion

- [ ] Self-review: Does it match the spec?
- [ ] Run /own:done for 6 Gates + code review + STAR story
- [ ] Run /own:retro to capture learnings

## Progress Tracking

| Phase | Status | Started | Completed |
|-------|--------|---------|-----------|
| Foundation | Not Started | - | - |
| Core Logic | Not Started | - | - |
| Edge Cases | Not Started | - | - |
| Polish | Not Started | - | - |

---

*Remember: YOU write the code. Ask your mentor when stuck.*
```

---

## Important Notes

1. **AI generates, junior reviews** — This is the SDD model
2. **Keep specs lean** — Verbose specs amplify confusion, not clarity
3. **Phases are mandatory** — Don't skip to Phase 3 before Phase 1 is done
4. **Edge cases are pre-populated** — Junior adds any we missed
5. **Out of Scope is critical** — Prevents feature creep
6. **Use MCPs** — Context7 for docs, Octocode for production patterns
7. **Prompt /own:advise** — Before implementing, run /own:advise for preparation
