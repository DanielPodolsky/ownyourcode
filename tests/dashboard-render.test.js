#!/usr/bin/env node
/* ════════════════════════════════════════════════════════════════════
   Dashboard render test (headless, no browser, no deps).

   WHY this exists: the dashboard's render logic lives as inline JS in
   core/templates/dashboard.html.template and turns window.PROJECT into DOM.
   We can't unit-test the agent prose in the /own:* commands, but we CAN run
   the dashboard's *actual* render functions against a canonical data fixture
   and assert every schema state produces the expected markup.

   HOW: stub a minimal DOM (document/createElement/querySelector...), capture
   every innerHTML / className / textContent write, eval the fixture (sets
   window.PROJECT) then eval the template's inline <script> (which boots and
   renders), and assert on the captured output. This mirrors how the browser
   loads the page (data via window.PROJECT, then the render script runs).

   v2.6 notes: the elevated shell also uses matchMedia / location / timers /
   rAF / navigator-guarded labels — stubbed below. matchMedia reports
   prefers-reduced-motion so the boot sequence resolves synchronously.
   ════════════════════════════════════════════════════════════════════ */
const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const TEMPLATE = path.join(ROOT, "core/templates/dashboard.html.template");
const FIXTURE = path.join(__dirname, "fixtures/sample-project.dashboard-data.js");

const cap = []; // every DOM write, flattened to strings, for assertions

function makeEl() {
  return {
    dataset: {}, style: { setProperty() {} }, hidden: false,
    set innerHTML(v) { this._h = v; cap.push(v); },
    get innerHTML() { return this._h || ""; },
    set className(v) { this._c = v; cap.push("CLASS:" + v); },
    get className() { return this._c || ""; },
    set textContent(v) { this._t = v; cap.push("TEXT:" + v); },
    get textContent() { return this._t || ""; },
    appendChild(c) { if (c && c._h) cap.push(c._h); },
    addEventListener() {}, removeEventListener() {}, remove() {}, focus() {},
    classList: { add() {}, remove() {}, toggle() {}, contains() { return false; } },
    querySelector() { return makeEl(); },
    querySelectorAll() { return []; },
    closest() { return null; },
  };
}

global.document = {
  _title: "",
  set title(v) { this._title = v; },
  get title() { return this._title; },
  body: makeEl(),
  querySelector() { return makeEl(); },
  querySelectorAll() { return []; },
  createElement() { return makeEl(); },
  addEventListener() {},
};
global.window = { addEventListener() {}, removeEventListener() {} };
global.matchMedia = () => ({ matches: true }); // reduced motion → boot skips
global.location = { hash: "" };
global.performance = { now: () => 0 };
global.requestAnimationFrame = () => {};
global.setInterval = () => 0;   // tmux clock — don't keep node alive
global.setTimeout = () => 0;    // boot auto-dismiss — never fires here
global.clearTimeout = () => {};

// 1) load the fixture → sets window.PROJECT (mirrors <script src="dashboard-data.js">)
eval(fs.readFileSync(FIXTURE, "utf8"));

// 2) extract + run the template's inline render <script> (boots + renders)
const html = fs.readFileSync(TEMPLATE, "utf8");
const scripts = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m => m[1]);
if (!scripts.length) { console.error("✗ no inline <script> found in template"); process.exit(1); }
eval(scripts.join("\n;\n"));

const all = cap.join("\n");
// the stub captures each view twice (innerHTML set + appendChild) — exact
// counts must run against a single capture of the overview view
const overview = cap.find(s => typeof s === "string" && s.includes("Mission track")) || "";

// 3) assertions — one per schema feature the dashboard must render
const checks = [
  // header / meta
  ["title set from meta.name",            () => document.title.includes("momentum")],
  // overview
  ["overview mission renders",            () => all.includes("makes effort visible")],
  ["DoD checklist renders (zero-padded)", () => all.includes("Daily log entries persist")],
  ["DoD tracker shows 1 / 4 complete",    () => all.includes("TEXT:1 / 4 complete")],
  // stack — all four source-badge variants
  ["stack 5-col table (Source header)",   () => all.includes("<th>Source</th>")],
  ["source badge: package.json",          () => all.includes('class="src package-json"')],
  ["source badge: mcp",                   () => all.includes('class="src mcp"')],
  ["source badge: verify",                () => all.includes('class="src verify"')],
  ["source badge: manual",                () => all.includes('class="src manual"')],
  // sidebar phase states
  ["complete phase dot",                  () => all.includes('class="d complete"')],
  ["specced phase dot",                   () => all.includes('class="d specced"')],
  ["roadmap-only phase dot",              () => all.includes('class="d roadmap-only"')],
  ["active-phase highlight applied",      () => all.includes("CLASS:nav active-phase")],
  ["active 'Active' tag",                 () => all.includes('class="atag">Active')],
  // signature motif (v2.6 numerals carry aria-hidden)
  ["ghost numeral on phase header (01)",  () => /class="phase-numeral"[^>]*>01</.test(all)],
  ["ghost numeral 02",                    () => /class="phase-numeral"[^>]*>02</.test(all)],
  // specced phase tabs + content
  ["Spec/Design/Tasks tabs render",       () => all.includes('data-t="spec"') && all.includes('data-t="design"') && all.includes('data-t="tasks"')],
  ["user story renders",                  () => all.includes("returning user")],
  ["acceptance criterion renders",        () => all.includes("persists across refresh")],
  ["edge case renders (ghost index)",     () => all.includes("Edge 01") && all.includes("Duplicate same-day")],
  ["out-of-scope chip renders",           () => all.includes("Streak math")],
  ["trade-off renders",                   () => all.includes("controlled (useState)")],
  // design tab
  ["SVG architecture diagram",            () => all.includes("<svg viewBox=") && all.includes("al-box")],
  ["data-flow stepper",                   () => all.includes("safeWrite")],
  ["component 4-tuple: kind 'new'",       () => all.includes("class='kind new'")],
  ["component 4-tuple: kind 'modified'",  () => all.includes("class='kind modified'")],
  ["component 4-tuple: file location",    () => all.includes("src/lib/storage/safe.ts")],
  // tasks tab — ids are "<phase>.<group>.<task>" (globally unique)
  ["kanban task id from Phase 1 (1.1.1)", () => all.includes('data-task="1.1.1"')],
  ["kanban task id from Phase 2 (2.2.3)", () => all.includes('data-task="2.2.3"')],
  ["progress ring renders",               () => all.includes('class="ring"')],
  ["done task struck (kcard done)",       () => all.includes("kcard done")],
  // roadmap-only phase
  ["roadmap-only planned scope",          () => all.includes("Calendar heatmap")],
  ["roadmap-only 'not specced yet' note", () => all.includes("isn't specced yet")],
  // ── v2.6 elevations ──────────────────────────────────────────────
  ["mission track renders all 4 nodes",   () => (overview.match(/class="tnode /g) || []).length === 4],
  ["mission track marks active phase",    () => all.includes('class="tnode active"')],
  ["mission track marks complete phase",  () => all.includes('class="tnode complete"')],
  ["track progress line carries width",   () => /track-line[\s\S]*?data-w="/.test(all)],
  ["task burn: one row per phase",        () => (overview.match(/class="row( hollow)?"/g) || []).length === 4],
  ["task burn: roadmap rows hollow",      () => (overview.match(/class="row hollow"/g) || []).length === 2],
  ["tmux bar: brand + phase + tasks",     () => all.includes("OWN v") && all.includes("phase 2/4") && all.includes("tasks <b>5/9</b>")],
  ["tmux bar: dod percent",               () => all.includes("dod <b>25%</b>")],
  ["palette shortcut label rendered",     () => all.includes("K</kbd>")],
  ["kanban column progress bars",         () => all.includes('class="kprog"')],
  ["stat numbers use count-up hooks",     () => all.includes("data-count=")],
  // segbar cells are <i> elements; done items get className "on" (1 in fixture)
  ["DoD segmented LED bar: done cell lit", () => cap.includes("CLASS:on")],
  ["overview prompt line motif",          () => all.includes("prompt-line")],
  // CONTRACT INVARIANT: task ids must be globally unique (the /own:done anchor).
  // This guards the multi-phase mutation case the render-only tests can't reach:
  // Phase 1 and Phase 2 are BOTH specced here, so a phase-local scheme would
  // collide. (See DASHBOARD_CONTRACT §6.4.)
  ["task ids are globally unique across all phases", () => {
    const ids = window.PROJECT.phases.flatMap(p => (p.tasks || []).map(t => t.id));
    return ids.length > 0 && new Set(ids).size === ids.length;
  }],
  ["every task id is phase-prefixed (<phase>.<group>.<task>)", () => {
    return window.PROJECT.phases.every(p =>
      (p.tasks || []).every(t => t.id.startsWith(p.n + ".") && t.id.split(".").length === 3));
  }],
];

let pass = 0, fail = 0;
for (const [label, fn] of checks) {
  let ok = false; try { ok = !!fn(); } catch (_) { ok = false; }
  console.log((ok ? "  ✓ " : "  ✗ ") + label);
  ok ? pass++ : fail++;
}
console.log(`\ndashboard-render: ${pass}/${checks.length} passed`);
process.exit(fail ? 1 : 0);
