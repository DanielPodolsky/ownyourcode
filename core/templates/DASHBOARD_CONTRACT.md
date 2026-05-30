# OwnYourCode — Dashboard Contract (v2.5)

> **Single source of truth for SDD state.** Every `/own:*` command reads and
> writes the dashboard. There are no per-page `mission.html`, `stack.html`,
> `roadmap.html`, `spec.html`, `design.html`, or `tasks.html` files anymore —
> the dashboard replaces all of them. This file is the authority; where any
> command's older prose conflicts with this, **this wins**.
>
> **Audiences (in priority order):**
> 1. **Future Claude executing `/own:*` commands** — the contract prevents schema
>    drift between commands as prompts evolve across model versions.
> 2. **The currently-running agent** — the contract is the single resolution point
>    when command prose is ambiguous.
> 3. **Human developers** — the contract is a readable reference explaining what's
>    in `dashboard-data.js` and what mutations are valid.

---

## 1. The two files

| File | Role | Who edits it |
|------|------|--------------|
| `ownyourcode/dashboard/dashboard.html` | **View shell** — layout, styling, render logic. Stable. | Only `/own:theme` or a deliberate design change. **Never** for content. |
| `ownyourcode/dashboard/dashboard-data.js` | **Data** — `window.PROJECT = {…}`. The SDD state. | Every `/own:init`, `/own:feature`, `/own:done`. This is the ONLY content file. |

The shell loads the data via `<script src="dashboard-data.js">` (works on
`file://`, unlike `fetch`). **Sync model:** a command rewrites
`dashboard-data.js`, then tells the user to **refresh the dashboard tab**
(`Cmd+R`). No server, no live-reload — refresh-after-command.

Both files are created by `/own:init` from
`ownyourcode/templates/dashboard.html.template` and
`ownyourcode/templates/dashboard-data.js.template`.

---

## 2. The schema

The entire SDD state of a project lives in one global JavaScript object:

```js
window.PROJECT = {
  meta:   { name, tagline, audience, mission, generated, version },
  dod:    [ { text, done } ],
  stack:  [ [layer, tech, version, source, purpose] ],
  phases: [ Phase ]
}
```

Where each `Phase` is:

```js
{
  n:           number,           // 1-indexed phase number, matches array position
  name:        string,           // Display name (e.g. "Foundation")
  slug:        string,           // kebab-case slug (e.g. "foundation")
  priority:    "high" | "medium" | "low",
  status:      "roadmap-only" | "specced" | "complete",
  description: string,           // 1-2 sentence phase summary

  // PRESENT ONLY WHEN status === "roadmap-only":
  items: [ string, ... ],        // Scope bullets — what this phase will cover

  // PRESENT ONLY WHEN status !== "roadmap-only":
  spec:   Spec,
  design: Design,
  tasks:  [ Task, ... ]
}
```

And the three composite structures:

```js
Spec = {
  overview:      string,                              // What we're building
  motivation:    string,                              // Why this feature exists
  userStories:   [ { actor, want, soThat } ],
  criteria:      [ string ],                          // Acceptance criteria
  edges:         [ [title, body] ],                   // Edge cases (title + explanation)
  outOfScope:    [ string ],
  openQuestions: [ string ]
}

Design = {
  overview:      string,
  diagram: {
    caption:     string,
    layers:      [ { label, nodes: [ string ] } ]     // Top-down dependency bands
  },
  flow:          [ string ],                          // Data-flow steps, rendered as stepper
  tradeoffs:     [ { title, chosen, rejected, why } ],
  components:    [ [name, responsibility, kind, location] ],
  openQuestions: [ string ]
}

Task = {
  id:     string,    // "<group#>.<task#>" e.g. "1.1", "2.3"
  group:  string,    // Sub-phase grouping (e.g. "Setup", "Implementation")
  text:   string,    // Short imperative task description
  detail: string,    // Optional extended description, shown when card expands
  done:   boolean    // Mutated by /own:done
}
```

---

## 3. Field semantics

### 3.1 `meta`

| Field | Type | Constraint | Source |
|---|---|---|---|
| `name` | string | Non-empty | `/own:init` (project name from working dir or user input) |
| `tagline` | string | One sentence max. Subtitle for dashboard header. | `/own:init` (mentor-written, derived from problem statement) |
| `audience` | enum | `"myself"` \| `"employers"` \| `"clients"` \| `"real-users"` | `/own:init` Phase 3 |
| `mission` | string | The PROBLEM statement (the *why* — not the solution) | `/own:init` Phase 2 |
| `generated` | string | ISO date `YYYY-MM-DD` | Set on every write that re-stamps |
| `version` | string | OwnYourCode version that generated/last-modified this file (e.g. `"2.5.0"`) | Source-of-truth: the OwnYourCode release at write time. NOT the user's project version. |

### 3.2 `dod` (Definition of Done items)

```js
dod: [
  { text: "Daily commit count tracked", done: false },
  { text: "Streak visualization renders",  done: false }
]
```

| Field | Type | Constraint |
|---|---|---|
| `text` | string | One concrete, measurable outcome |
| `done` | boolean | `false` at init; flipped by `/own:done` when the underlying work satisfies it |

**Variable count.** A project can have 1, 3, 7 DoD items. No padding to a default.

### 3.3 `stack`

Each row is a fixed 5-tuple:

```js
stack: [
  ["Frontend", "React",    "19.0.0",   "package.json",       "UI rendering"],
  ["Backend",  "Express",  "5.0.1",    "mcp:2026-05-28",     "HTTP API"],
  ["Database", "Postgres", "16",       "verify:postgresql.org", "Persistence"],
]
```

| Position | Field | Type | Constraint |
|---|---|---|---|
| 0 | `layer` | string | Categorical (Frontend / Backend / Database / Styling / Build / Deploy / etc.). One row per layer the project actually has — skip irrelevant layers. |
| 1 | `tech` | string | Technology name |
| 2 | `version` | string | Specific version, or `"—"` if not applicable |
| 3 | `source` | enum string | Version attribution. One of:<br/>• `"package.json"` — read from user's installed deps<br/>• `"mcp:YYYY-MM-DD"` — verified via Context7/Octocode on that date<br/>• `"verify:URL"` — could not verify; URL points to official docs<br/>• `"manual"` — user-provided, unverified |
| 4 | `purpose` | string | One-line reason this tech is in the stack |

### 3.4 `phases[]`

Top-level phase array. Order matches `phases[i].n` (1-indexed).

| Field | Type | Constraint |
|---|---|---|
| `n` | number | 1-indexed phase number. `phases[0].n === 1`. |
| `name` | string | Display name (e.g. "Foundation", "Auth System") |
| `slug` | string | kebab-case of `name` (e.g. "foundation", "auth-system"). **Immutable** once written — downstream commands use it as a stable identifier. |
| `priority` | enum | `"high"` \| `"medium"` \| `"low"`. Rendered as a color-coded badge. |
| `status` | enum | `"roadmap-only"` \| `"specced"` \| `"complete"`. See §5 lifecycle. |
| `description` | string | 1-2 sentence phase summary. Always present, all statuses. |
| `items` | string[] | **Only present when `status === "roadmap-only"`.** Scope bullets (what this phase will cover). Replaced by `spec/design/tasks` when status advances. |
| `spec` | Spec | **Present when `status !== "roadmap-only"`.** See §3.5. |
| `design` | Design | **Present when `status !== "roadmap-only"`.** See §3.6. |
| `tasks` | Task[] | **Present when `status !== "roadmap-only"`.** See §3.7. |

### 3.5 `Spec` (per phase)

| Field | Type | Constraint |
|---|---|---|
| `overview` | string | What we're building. 1-2 sentences. |
| `motivation` | string | Why this feature exists. Pulls from `meta.mission` + phase-specific reasoning. |
| `userStories` | Array | `[ { actor, want, soThat } ]`. Each story has 3 string fields. Multi-actor stories encoded in `actor` ("admin or user"). Empty array `[]` allowed (e.g. pure refactor phase). |
| `criteria` | string[] | Acceptance criteria. Each item is one testable outcome. Empty array allowed. |
| `edges` | `[title, body][]` | Edge cases as `[title, body]` tuples. `title` is a short label; `body` is the scenario + expected behavior. Empty allowed. |
| `outOfScope` | string[] | Explicit non-goals (prevents scope creep). Empty allowed. |
| `openQuestions` | string[] | Decisions deferred until implementation. Empty allowed. |

### 3.6 `Design` (per phase)

| Field | Type | Constraint |
|---|---|---|
| `overview` | string | 1-paragraph technical approach summary. |
| `diagram.caption` | string | 1-line caption for the architecture map. |
| `diagram.layers` | Array | `[ { label, nodes: [string] } ]`. Each layer is a top-down dependency band (UI → Repos → Primitives → Browser, etc.). `label` is the band name; `nodes` are module names rendered as boxes. Layers render top-to-bottom in the SVG. |
| `flow` | string[] | Data-flow steps, rendered as a connected stepper with `→` arrows between items. Each item is one step (e.g. "User clicks Submit"). |
| `tradeoffs` | Array | `[ { title, chosen, rejected, why } ]`. 1-vs-1 trade-offs only in v2.5. Multi-option encoded by listing all rejected in `rejected` string ("Approach B (too slow); Approach C (security risk)"). Empty allowed. |
| `components` | `[name, responsibility, kind, location][]` | 4-tuple per component. `kind` is `"new"` or `"modified"`. `location` is the file path (e.g. `src/components/Streak.tsx`). Empty allowed. |
| `openQuestions` | string[] | Deferred design decisions. Empty allowed. |

### 3.7 `Task` (per phase)

```js
tasks: [
  { id: "1.1", group: "Setup",          text: "Install dependencies", detail: "...", done: false },
  { id: "1.2", group: "Setup",          text: "Configure env vars",   detail: "",    done: false },
  { id: "2.1", group: "Implementation", text: "Build streak logic",   detail: "...", done: false }
]
```

| Field | Type | Constraint |
|---|---|---|
| `id` | string | `"<group#>.<task#>"` format. `<group#>` is the 1-indexed group ordinal (Setup=1, Implementation=2, etc.); `<task#>` is the 1-indexed position within the group. **Unique within the phase's `tasks[]` array.** Used as the anchor for `/own:done` exact-string mutation. |
| `group` | string | Sub-phase grouping label. Renders as a kanban column header. |
| `text` | string | Short imperative task description (≤ 80 chars recommended). |
| `detail` | string | Extended description shown when the task card expands. May be empty (`""`). Plain text; newlines render as paragraph breaks. |
| `done` | boolean | `false` at creation. Flipped to `true` by `/own:done` when the task is completed. |

---

## 4. Mutation rules (per command)

These rules constrain what each `/own:*` command may write. Any command violating them is buggy.

### 4.1 `/own:init`

- Writes the ENTIRE `window.PROJECT` from scratch.
- Sets `meta.version` to the current OwnYourCode version.
- All `dod` items have `done: false`.
- All `phases[]` start with `status: "roadmap-only"` and `items: [...]` populated. No `spec/design/tasks` exist yet.
- Triggers a `node --check` validation after writing.

### 4.2 `/own:feature`

- Reads `window.PROJECT.phases[]`. Finds the first phase with `status === "roadmap-only"`.
- Runs the unchanged collaborative spec-creation flow (Phase 1 questions, Phase 2 MCP research, Phase 2.5 internal skill mapping, Phase 3 synthesis).
- **The ONLY mutation:** on the detected phase object:
  - Set `status: "specced"`
  - Remove `items`
  - Add `spec`, `design`, `tasks` objects matching the contract
  - All tasks start with `done: false`
  - All task `id`s are unique within the phase
- Triggers `node --check`.

### 4.3 `/own:done`

- Reads `window.PROJECT.phases[]`. Finds the phase containing the just-completed task.
- **Mutations** (in order):
  1. Flip the matching task's `done: false` → `done: true`. Anchor by unique `id` (e.g., find the line containing `"id": "2.1"` and flip `done` on the same task object).
  2. For zero or more `dod` items the completed task materially advances, flip `done: false` → `done: true`. **This is an agent judgment, not a deterministic mapping.** Claude reads the task's `text`/`detail` and reasons about which DoD items (if any) the work satisfies. Be conservative — only mark a DoD item complete when the work clearly advances it. The user can always manually flip any DoD item via direct edit if Claude's judgment is wrong.
  3. If ALL `tasks[*].done === true` in the phase, set the phase `status: "specced"` → `"complete"`.
- Triggers `node --check`.

### 4.4 `/own:status`

- **READ-ONLY** against `window.PROJECT`. No writes to `dashboard-data.js`.
- Computes:
  - Roadmap progress: count of phases by status.
  - Active phase: first phase with `status !== "complete"`.
  - Task progress: per-phase, `done / total`.
  - DoD progress: `dod.filter(d => d.done).length / dod.length`.
- Career and learning stats still read from their own files (unchanged).

---

## 5. Phase status lifecycle

```
   ┌──────────────┐    /own:feature    ┌─────────┐    /own:done (all tasks)    ┌──────────┐
   │ roadmap-only │ ─────────────────→ │ specced │ ──────────────────────────→ │ complete │
   └──────────────┘                    └─────────┘                              └──────────┘
   has: items[]                        has: spec, design, tasks                 (terminal)
   no:  spec/design/tasks              no:  items
```

**Transitions:**
- `roadmap-only → specced` is exclusive to `/own:feature`.
- `specced → complete` is exclusive to `/own:done` when all tasks complete.
- Status NEVER moves backward without manual intervention (no command does this).

**Skipped phases:** v2.5 does not model "skipped" status. If a user decides not to do a phase, they delete it from `window.PROJECT.phases[]`. Acceptable for v2.5; future versions may add `"skipped"` to the enum.

---

## 6. Mutation safety

These rules apply to EVERY write to `dashboard-data.js`.

### 6.1 Always-valid JavaScript

After every mutation, the command MUST run:

```bash
node --check ownyourcode/dashboard/dashboard-data.js
```

If `node --check` fails, the command must:
1. Revert the write.
2. Surface the syntax error to the user.
3. Stop the slash-command flow.

Never proceed with an invalid data file.

### 6.2 Prefer exact-string Edit over regeneration

Single-task mutations (e.g., `/own:done` flipping `done: false` → `done: true`) MUST use the `Edit` tool with a unique anchor (the task's `id`). Do NOT regenerate the entire phase or file.

Rationale: surface area of an Edit ≪ surface area of a rewrite. Smaller writes have smaller blast radius.

### 6.3 Never edit `dashboard.html` for content

`dashboard.html` is the view shell. It is mutated ONLY by:
- `/own:theme` (when it regenerates the inline `<style>` block via `frontend-design`)
- Deliberate design changes by maintainers

`/own:init`, `/own:feature`, `/own:done`, `/own:status` MUST NOT write to `dashboard.html`.

### 6.4 Unique IDs are load-bearing

Every `Task.id` MUST be unique within its phase's `tasks[]` array. `/own:done`'s exact-string mutation depends on this. Duplicate IDs cause silent wrong-task completion.

---

## 7. Computed values (NOT stored in the schema)

These are derived by the dashboard's render JS from `window.PROJECT`. Commands MUST NOT store these as fields.

| Computed value | Derivation |
|---|---|
| Active phase | First phase with `status !== "complete"`. If all complete, no active phase. |
| Roadmap progress | Count of phases grouped by `status`. |
| Task progress (per phase) | `phase.tasks.filter(t => t.done).length / phase.tasks.length` |
| DoD progress | `dod.filter(d => d.done).length / dod.length` |
| Phase priority badge color | Mapped from `priority` enum |
| Source attribution badge | Mapped from `stack[i][3]` value (the `source` field) |

---

## 8. MVP constraints (explicit v2.5 simplifications)

The following are intentional simplifications. Each has a noted future-evolution path.

| Constraint | Why | Future path |
|---|---|---|
| Trade-offs are 1-vs-1 (`chosen` vs `rejected`) | Most decisions reduce to "we picked A, considered B". | If multi-option becomes common, evolve to `{title, chosen, rejected: [], why}`. |
| Diagram only supports `layers` topology | Most software architectures are layered. | Future schema could add `diagram.kind: "layered" \| "mesh" \| "tree"`. |
| Status enum has 3 values (no `"skipped"`, no `"blocked"`) | Deletion suffices for skip. Blocked is rare and can be encoded in `description` short-term. | Add enum values when real usage demands. |
| `userStories[].actor` is a single string | Multi-actor handled by writing "admin or user" in the string. | Could evolve to `actor: string | string[]`. |
| Tasks have no `dependsOn` field | Order in array is the implicit dependency order. | Add `dependsOn: [id]` field if task graphs get complex. |
| DoD propagation is an agent judgment | No `task.satisfies: [dodId]` field. `/own:done` infers which DoD items a task advances from `text`/`detail`. | If false positives become common, add explicit `satisfies: [dodId]` mapping at `/own:feature` time. |

---

## 9. When this contract evolves

Schema changes require:
1. A version bump (`window.PROJECT.meta.version` advances).
2. A note in CHANGELOG describing the schema change.
3. Update of all `/own:*` command prose to match the new contract.
4. Update of this file BEFORE any command changes.

Breaking changes (removing/renaming fields, changing enum values) require a major version bump.

---

*End of contract draft.*
