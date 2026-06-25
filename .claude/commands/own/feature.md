---
name: feature
description: Create a feature specification using spec-driven development
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, AskUserQuestion, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__octocode__githubSearchCode, mcp__octocode__githubGetFileContent, mcp__octocode__githubSearchRepositories
---

# /own:feature

> ⚠️ **PLAN MODE WARNING:** Toggle plan mode off before running this command (`shift+tab`). OwnYourCode commands don't work correctly with plan mode.

Create a feature specification using **Spec-Driven Development (SDD)**.

## Overview

This command follows the SDD workflow:
1. **AI generates** the spec, design, and tasks for a phase based on minimal input
2. **Developer reviews** them in the dashboard (the phase's Spec / Design / Tasks tabs)
3. **Developer adds** any missing edge cases or requirements
4. **Then** implementation begins with mentorship

**Output (v2.5 — Dashboard SDD):**
- The detected `roadmap-only` phase in `ownyourcode/dashboard/dashboard-data.js` is
  advanced to `specced` — its `spec`, `design`, and `tasks` objects are written
  in place (replacing the phase's `items[]`). No `spec.md`/`design.md`/`tasks.md`
  files; everything lives in `window.PROJECT`, rendered by the dashboard's tabs.

> **Schema authority:** `ownyourcode/dashboard/DASHBOARD_CONTRACT.md` defines the exact
> `spec` / `design` / `tasks` shapes and the mutation rules. Read it before
> writing. When this command's prose and the contract disagree, the contract wins.

**Profile-Aware Behavior:**
Check `.claude/ownyourcode-manifest.json` for profile settings:
- **Junior profile** → Collaborative spec creation (mandatory design involvement)
- **Other profiles with `design_involvement=true`** → Collaborative spec creation
- **Profiles with `design_involvement=false`** → AI generates, developer reviews

---

## The SDD Philosophy

> "Spec first, code second. But YOU own the judgment behind every line."

OwnYourCode uses SDD for planning, then builds with ownership — not by handing the
junior a finished feature to read. **How "build" works depends on profile:**
- **Junior profile** → Phase 6 runs the Implementation Loop: the junior predicts the
  judgment for each task *before* the AI reveals the code, then gets graded on the
  prediction. They own the code by being able to evaluate it, not by transcribing it.
- **Other profiles** → SDD stops at the spec; implementation happens however that
  developer ships (they don't need the gym).

---

## Execution Flow

### Before Asking Questions: Detect the Next Phase

Before asking the user for feature details, auto-detect which phase to spec by
reading the dashboard data — there is no `roadmap.md` to parse in v2.5.

1. **Read** `ownyourcode/dashboard/dashboard-data.js` (the `window.PROJECT` object).
2. **Find** the FIRST phase in `window.PROJECT.phases` with
   `status: "roadmap-only"` — that is the phase to spec.
3. **Auto-select** it — no asking, keep it simple. Capture its `n`, `name`,
   `slug`, and `items[]` (the planned scope you'll expand into a full spec).

**Status meaning (see contract §3.4 / §5):**
- `"roadmap-only"` → planned, not yet specced (has `items[]`, no spec/design/tasks)
- `"specced"` → already specced (skip — `/own:feature` already ran for it)
- `"complete"` → done

**If a `roadmap-only` phase is found:**
```
📍 Detected from your roadmap: Phase [n] — [name]

This phase covers:
- [item 1]
- [item 2]
...

Generating the spec for this phase...
```
→ Proceed directly to Phase 2 (MCP Research). You will write the spec/design/
  tasks into THIS phase object in `dashboard-data.js`.

**If `dashboard-data.js` is missing or has no `phases`:**
→ The project isn't initialized. Tell the user to run `/own:init` first.

**If ALL phases are `specced`/`complete` (no `roadmap-only` left):**
→ Congratulate them! Then ask what they want to build next (a new phase can be
  appended to `window.PROJECT.phases` with `status:"roadmap-only"`).

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
- **security skill** → Add input validation, auth checks to the `design`
- **error-handling skill** → Pre-populate error scenarios in `spec.edges`
- **seo skill** → Include semantic HTML requirements in the `design`
- **performance skill** → Add performance considerations to the `design`
- **testing skill** → Include "what tests to write" as `tasks` in the Verification group

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
1. Read `ownyourcode/dashboard/dashboard-data.js` — `window.PROJECT.meta.mission` for
   project goals, `window.PROJECT.stack` for technology constraints
2. Scan existing code structure to understand patterns

**Standard Mode (design_involvement=false):**
Generate the phase's `spec`, `design`, and `tasks` (written into the phase
object — see "Generated Output" below) based on:
- User's input from Phase 1
- MCP research from Phase 2
- Project context (`window.PROJECT.meta` + `window.PROJECT.stack`)
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

After writing the phase into `dashboard-data.js` and validating it (see
"Generated Output" below), present a summary:

```
I've specced Phase [n] — [name] in your dashboard, based on your requirements,
official docs, and how production apps implement this.

📋 Spec tab — What we're building
   • User Stories: [count]
   • Acceptance Criteria: [count]
   • Edge Cases: [count from research]
   • Out of Scope: [count]

🏗️ Design tab — How we're building it
   • Architecture + a diagram
   • Components: [count]
   • Trade-offs: [count]

✅ Tasks tab — Implementation tasks
   • [count] tasks across [group names]

👉 Refresh ownyourcode/dashboard/dashboard.html and open Phase [n] to review the
   Spec / Design / Tasks tabs.

Please review. You should:
1. Read the Spec and Design tabs
2. Tell me any edge cases I missed (I'll add them)
3. Tell me anything that doesn't match your vision (I'll change it)

When ready:
- **Junior profile:** we go straight into building — Phase 6 runs the Implementation
  Loop here, task by task. (No need to run /own:guide; the gym is built in.)
- **Other profiles:** run /own:advise to prepare, then implement your way.
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
- **Looks good:** Finalize, then proceed to Phase 6 (Junior) or end (other profiles)
- **Add/Modify:** Make changes, regenerate summary
- **Read first:** End command, let them review

---

### Phase 6: The Implementation Loop (JUNIOR PROFILE ONLY)

**⚠️ Profile Check:** Read `.claude/ownyourcode-manifest.json`.
- If `profile.type = "junior"` → run this phase. The command builds the feature
  task-by-task through Predict → Reveal → Judge.
- All other profiles → **skip Phase 6.** End the command after Phase 5 with the
  usual "now implement" handoff. (This phase is the junior gym; seniors ship in
  the game.)

> **Authority:** the full loop mechanics, prediction prompt, rubric, grounding
> guard, and anti-sycophancy rule live in `profiles/junior.md` → "The Implementation
> Loop". This phase is the *trigger and bookkeeping*; that profile section is the
> *behavior*. If they disagree, the profile wins.

**Why this lives in `/own:feature` and not `/own:guide`:** the loop must be a HARD
gate. `/own:guide` is optional and rarely run; juniors would skip it and lose the
mechanism. Because `/own:feature` runs Phase 6 inline, the gate can't be bypassed.

**The loop:**

1. **Read the tasks** just written to the phase's `tasks[]`. Identify the
   `Implementation`-group tasks (these gate) vs. `Setup` / `Verification` (these flow).

1b. **Read the Prediction Scorecard** in `~/ownyourcode/learning/LEARNING_REGISTRY.md`
   and compute each dimension's **fade state** (see `junior.md` → "Adaptive Fading"):
   count consecutive trailing `MATCH`es per dimension (approach / data structure /
   control flow / edge cases). A dimension with **≥4 consecutive MATCHes is Faded**;
   otherwise it is **Gated**. If the file/section is missing, treat all dimensions as
   Gated (default). This decides which dimensions each task will actually ask for.

2. **For each task, in order:**
   - **Setup / Verification task** → implement it directly, no prediction gate.
     (Scaffolding and test-running carry no design judgment.)
   - **Implementation task** → run the gate **on the still-Gated dimensions only**:
     1. **PREDICT** — present the prediction prompt for **only the Gated dimensions**
        (free-text, N/A-with-reason allowed). Faded dimensions are NOT asked. Do not
        proceed until the Gated ones are answered with specifics; bounce vague answers.
        (If ALL four are Faded, treat the task like Setup: build + spot-check, no gate.)
     2. **GATE** — no committed prediction → no code. Don't cave to "just show me."
     3. **REVEAL** — write the actual production code for that task.
     4. **JUDGE** — grade the **predicted (Gated)** dimensions on the rubric
        (MATCH/PARTIAL/MISS), name the specific gap, ground it (Context7 for authority,
        Octocode for prevalence — cite *why*, not just *that it's common*). For **Faded**
        dimensions, do a lightweight **spot-check**: state what you did and flag if they'd
        likely have missed it — but don't grade it unless you re-asked it as a snap-back
        check on a complex task (a `MISS` there returns that dimension to Gated).
     5. **OWN** — have them acknowledge the named gap in their own words.

3. **Record** each Implementation task's verdicts to the **Prediction Scorecard** in
   `~/ownyourcode/learning/LEARNING_REGISTRY.md`, and add every `MISS` to that file's
   **Failures (Anti-Patterns)** table. (See that file for the row formats.)

4. **Mark tasks `done`** as they're completed (flip `done: true` in `dashboard-data.js`
   by exact-id match — same mechanism `/own:done` uses; re-validate with
   `node --check`).

5. **Close out:**
   ```
   ✅ Phase [n] built — [x] Implementation tasks, [y] predictions logged.

   Your judgment scorecard this phase:
   • Approach:       [M/P/MISS tally]
   • Data structure: [M/P/MISS tally]
   • Control flow:   [M/P/MISS tally]
   • Edge cases:     [M/P/MISS tally]

   When you're ready to verify ownership and ship, run /own:done.
   ```

---

## Generated Output (write into the phase object)

You do NOT create `spec.md` / `design.md` / `tasks.md` files. You **mutate the
detected phase object** inside `ownyourcode/dashboard/dashboard-data.js`:

1. **Read `ownyourcode/dashboard/DASHBOARD_CONTRACT.md`** (§3.5–§3.7) — the authority for
   the `spec`, `design`, `tasks` shapes.
2. On the detected `roadmap-only` phase: **remove its `items: [...]`** and **add
   `spec`, `design`, `tasks`** objects built from the collected answers + MCP
   research, then **set `status: "specced"`**.
3. Use the `Edit` tool for an exact-string replacement of that phase object —
   leave every other phase untouched.
4. Variable counts are real: as many user stories / criteria / edges / tasks as
   the work needs. Don't pad or truncate.
5. **Validate** with `node --check ownyourcode/dashboard/dashboard-data.js`. If it fails,
   fix the syntax and re-run until valid — never leave a broken data file.

### The shapes to write (v2.5 — see contract §3.5–§3.7)

```js
// the phase BEFORE (roadmap-only):
{ n: 2, name: "Logging", slug: "logging", priority: "high",
  status: "roadmap-only", description: "...", items: ["...", "..."] }

// the phase AFTER (specced) — items removed, spec/design/tasks added:
{
  n: 2, name: "Logging", slug: "logging", priority: "high",
  status: "specced", description: "...",
  spec: {
    overview:   "[what we're building — 1–2 sentences]",
    motivation: "[why this feature exists]",
    userStories: [
      { actor: "[user type]", want: "[action]", soThat: "[benefit]" },
      // ...variable count; [] allowed (e.g. a pure refactor)
    ],
    criteria:   ["[testable acceptance criterion]", /* ... */],
    edges:      [ ["[edge title]", "[scenario + expected behavior]"], /* ... */ ],
    outOfScope: ["[explicit non-goal]", /* ... */],
    openQuestions: ["[decision deferred to implementation]", /* ... */],
  },
  design: {
    overview: "[1-paragraph technical approach]",
    diagram: {
      caption: "[1-line caption]",
      layers: [   // top→bottom dependency bands → drives the SVG architecture map
        { label: "[band name]", nodes: ["[module]", "[module]"] },
        // ...
      ],
    },
    flow: ["[data-flow step]", /* ...rendered as a connected stepper */],
    tradeoffs: [
      { title: "[decision]", chosen: "[option]", rejected: "[option(s)]", why: "[reasoning]" },
      // ...variable count; [] allowed
    ],
    components: [
      // 4-tuple: [name, responsibility, kind, location]   kind ∈ "new" | "modified"
      ["[name]", "[responsibility]", "new", "src/path/file.ts"],
      // ...
    ],
    openQuestions: ["[deferred design decision]", /* ... */],
  },
  tasks: [
    // id = "<phase>.<group>.<task>" — the phase prefix is THIS phase's `n`, so
    // ids are GLOBALLY unique across the file (never restart per phase). group =
    // kanban column. text and detail are distinct; done starts false.
    // (example below assumes you're speccing Phase 2)
    { id: "2.1.1", group: "Setup",          text: "[short imperative]", detail: "[optional extended note]", done: false },
    { id: "2.2.1", group: "Implementation", text: "[...]", detail: "", done: false },
    { id: "2.3.1", group: "Verification",   text: "[...]", detail: "", done: false },
    // ...variable groups + variable tasks per group
  ],
}
```

### Contract reminders (don't break these)

- **`design.components` is a 4-tuple** `[name, responsibility, kind, location]` —
  include the file path and `"new"`/`"modified"`, not just name + responsibility.
- **`tasks[].id`** is `"<phase>.<group>.<task>"` — prefix every id with THIS
  phase's number so ids are **globally unique** across the whole file (don't
  restart `1.1`, `2.1` each phase). `/own:done` flips `done` by matching the bare
  `id` literal as an exact-string anchor, so a global collision would break it.
- **`tasks[].text` vs `detail`**: `text` is the short card title; `detail` is the
  optional expand-on-click body. `detail` may be `""`.
- **`design.diagram.layers`** are ordered top→bottom; the dashboard renders them
  as a layered SVG with arrows between bands.
- The collaborative questioning, MCP research, and edge-case discovery
  (Phases 1–3) are UNCHANGED — only the output target moved from files to the
  phase object.

---

## Important Notes

1. **AI generates the spec, junior reviews** — the SDD planning model. (Implementation
   is different for juniors: Phase 6's loop has them *predict before* the reveal.)
2. **Keep specs lean** — Verbose specs amplify confusion, not clarity
3. **Phases are mandatory** — Don't skip to Phase 3 before Phase 1 is done
4. **Edge cases are pre-populated** — Junior adds any we missed
5. **Out of Scope is critical** — Prevents feature creep
6. **Use MCPs** — Context7 for docs, Octocode for production patterns
7. **Prompt /own:advise** — Before implementing, run /own:advise for preparation
