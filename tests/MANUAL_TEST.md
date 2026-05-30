# OwnYourCode v2.5 — Manual Test (run it for real)

> The automated suite (`bash tests/run.sh`) proves the dashboard *renders* every
> state and the installer *seeds* the right files. What it can't prove is whether
> the **agent follows the command prose** end-to-end. That's this walkthrough.
> You run OwnYourCode from scratch and confirm the whole flow feels right.
>
> Time: ~15–20 min. You'll need: a clean throwaway directory, Claude Code, and a
> browser to open the dashboard.

---

## 0. Set up a clean test project

```bash
mkdir -p ~/Desktop/oyc-manual-test && cd ~/Desktop/oyc-manual-test
# No need to create CLAUDE.md — the installer creates it if absent (the common
# fresh-project case). Install from this working copy (adjust the path if needed):
bash "</absolute/path/to>/ownyourcode/scripts/project-install.sh"
```

**Expect:** the installer reports "Created CLAUDE.md at project root" and
"Dashboard seeded — open ownyourcode/dashboard/dashboard.html, then run /own:init".

**Check the seed (before touching Claude):**
```bash
ls ownyourcode/                 # dashboard/, DASHBOARD_CONTRACT.md, .theme/, templates/, …
ls ownyourcode/dashboard/       # dashboard.html, dashboard-data.js
open ownyourcode/dashboard/dashboard.html # opens the EMPTY-STATE dashboard
```
- [ ] The dashboard opens by **double-click / `open`** (no server needed).
- [ ] It shows a Terminal-Futurism empty state (dark, green accent) with a
      "Run `/own:init`" message — NOT a blank page, NOT a broken stylesheet.
- [ ] No `ownyourcode/product/` folder exists; no `templates/html/` folder.

---

## 1. `/own:init` — define the project

Open Claude Code in `~/Desktop/oyc-manual-test` and run `/own:init`. Answer the
prompts (pick **Junior** profile to see the collaborative flow; give a real
problem, an audience, ~4 Definition-of-Done items, a stack, and propose ~4
roadmap phases).

**Expect at the end:** a `node --check` validation, then a summary pointing you
to open `dashboard.html`.

**Check:**
- [ ] `ownyourcode/dashboard/dashboard-data.js` now has your real `meta`, `dod`, `stack`,
      and `phases` (open it — it's readable JS).
- [ ] Every phase is `status: "roadmap-only"` with an `items: [...]` list (no
      `spec`/`design`/`tasks` yet).
- [ ] `node --check ownyourcode/dashboard/dashboard-data.js` passes.
- [ ] Refresh `dashboard.html` → your project renders: mission in Overview, your
      stack table (with source badges), your phases in the sidebar, the DoD
      tracker at 0%.
- [ ] Phase 0.5 told you whether `frontend-design` was detected (and asked
      inline if not) — and did NOT block init either way.

---

## 2. `/own:feature` — spec the first phase

Run `/own:feature`. It should auto-detect Phase 1 (the first `roadmap-only`).
Go through the collaborative spec questions.

**Check:**
- [ ] It detected Phase 1 from the dashboard data without asking which phase.
- [ ] Afterward, Phase 1 in `dashboard-data.js` is `status: "specced"`, its
      `items` are gone, and it now has `spec`, `design`, `tasks` objects.
- [ ] `node --check` passes.
- [ ] Refresh the dashboard, open Phase 1 → the **Spec / Design / Tabs** appear:
  - [ ] Spec tab: overview, user stories, acceptance criteria, edge cases
        (numbered "Edge 01…"), out-of-scope chips.
  - [ ] Design tab: the **SVG architecture diagram** renders, plus a data-flow
        stepper, trade-off cards, and component cards with `new`/`modified`
        badges + file paths.
  - [ ] Tasks tab: a progress ring at 0% and a kanban with your task groups.
- [ ] The big **ghost numeral** "01" sits above the phase title.
- [ ] Phase 1 shows the pulsing "Active" treatment in the sidebar.

---

## 3. Build something, then `/own:done`

Pick the first task. (You don't have to really build it for the test — but doing
a tiny real change makes the 6-Gates flow honest.) Run `/own:done`.

**Check:**
- [ ] The 6 Gates, code review, and (if your profile enables it) the STAR story
      / resume bullet phases all still run — unchanged from before.
- [ ] In `dashboard-data.js`, the finished task's `done` flipped `false → true`
      (and only that task).
- [ ] If the task satisfied a Definition-of-Done item, that DoD item flipped too
      (conservatively — Claude shouldn't over-claim).
- [ ] `node --check` passes; you're told to refresh.
- [ ] Refresh → the Tasks ring ticks up, the task card is struck through, the
      sidebar DoD bar moves if a DoD item completed.
- [ ] Complete ALL tasks in the phase via `/own:done` → the phase flips to
      `status: "complete"`, its sidebar dot turns green, and the **Active**
      highlight moves to the next phase.

---

## 4. `/own:status` — read progress

Run `/own:status`.

**Check:**
- [ ] Roadmap progress reflects the real phase statuses (complete / specced /
      roadmap-only) and counts — read from `dashboard-data.js`, not any `.md`.
- [ ] The active phase + per-phase task progress + DoD progress are correct.
- [ ] It points you at the dashboard's Tasks tab.

---

## 5. `/own:theme` — restyle the dashboard

Run `/own:theme`, pick **Regenerate from current brief** (or **Change brief** and
tweak a color).

**Check:**
- [ ] It detected `frontend-design` via the skill list (not a filesystem path).
- [ ] It backed up the current `dashboard.html` to `.theme/.history/<ts>/`
      BEFORE writing.
- [ ] Only the `<style>` + font `<link>` changed — refresh the dashboard and it
      still renders all your content (the render JS + data untouched).
- [ ] The post-write integrity check passed (the command confirms render logic
      survived).
- [ ] `/own:theme --revert` offers the backup and restores it.

---

## 6. The "is it nicer for the end user?" gut check

This is the subjective half — the whole reason for v2.5. Sit with the dashboard:

- [ ] Is the project's state **legible at a glance** (vs. hunting through six
      separate Markdown/HTML files)?
- [ ] Do the **tabs** make a phase's spec/design/tasks feel like one coherent
      thing rather than a long scroll?
- [ ] Does it look **hand-crafted** (Terminal-Futurism), not generic-AI?
- [ ] Would you be happy to screenshot this in a portfolio / LinkedIn post?

If any answer is "no," note it — that's the feedback that matters before release.

---

## Pass criteria

All checkboxes above tick, and nothing in the flow produced a `.md` SDD file,
a `product/` folder, or a broken/blank dashboard. If something's off, capture
the exact step + what you saw and bring it back — that's a release blocker.
