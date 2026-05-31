# OwnYourCode tests

Dev-only regression suite for the v2.5 Dashboard SDD model. **Not shipped to
users** — `project-install.sh` copies only named directories (commands, skills,
profiles, guides, dashboard templates), never `tests/`.

## Run

```bash
bash tests/run.sh      # all layers, with a pass/fail summary
```

Requires only `bash` + `node`. No network, no other dependencies. Everything
runs in temp dirs and cleans up after itself.

## Layers

| File | What it proves |
|------|----------------|
| `install.test.sh` | `project-install.sh` seeds the dashboard (`dashboard.html`, `dashboard-data.js`, `DASHBOARD_CONTRACT.md`, `.theme/theme-prompt.md`), leaves no dead v2.4 dirs (`product/`, `templates/html/`, `theme.css`), and the seeded JS is valid. |
| `dashboard-render.test.js` | The dashboard's **actual** render JS (from `dashboard.html.template`) turns a canonical fixture into the expected DOM — every schema state: complete/specced/roadmap-only phases, all 4 source badges, 4-tuple components, kanban, the ghost numeral, the empty-state guard. |
| `commands.test.sh` | Static contract checks over the `/own:*` command prose: no dead-path references, correct frontmatter tool grants, the dashboard-data.js single-source contract, and the Terminal-Futurism default in the template. |

`fixtures/sample-project.dashboard-data.js` is the shared canonical `window.PROJECT`.

## What this does NOT test

Whether the **agent follows the command prose** at runtime — that's inherently
not unit-testable in an agentic codebase. `MANUAL_TEST.md` covers it: a real
fresh-install walkthrough (install → init → feature → done → status → theme)
with an expected-outcome checklist.
