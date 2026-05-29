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
   ════════════════════════════════════════════════════════════════════ */
const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const TEMPLATE = path.join(ROOT, "core/templates/dashboard.html.template");
const FIXTURE = path.join(__dirname, "fixtures/sample-project.dashboard-data.js");

const cap = []; // every DOM write, flattened to strings, for assertions

function makeEl() {
  return {
    dataset: {}, style: {}, hidden: false,
    set innerHTML(v) { this._h = v; cap.push(v); },
    get innerHTML() { return this._h || ""; },
    set className(v) { this._c = v; cap.push("CLASS:" + v); },
    get className() { return this._c || ""; },
    set textContent(v) { this._t = v; cap.push("TEXT:" + v); },
    get textContent() { return this._t || ""; },
    appendChild(c) { if (c && c._h) cap.push(c._h); },
    addEventListener() {},
    classList: { add() {}, remove() {}, toggle() {} },
    querySelector() { return makeEl(); },
    querySelectorAll() { return []; },
    closest() { return null; },
  };
}

global.document = {
  _title: "",
  set title(v) { this._title = v; },
  get title() { return this._title; },
  querySelector() { return makeEl(); },
  querySelectorAll() { return []; },
  createElement() { return makeEl(); },
};
global.window = {};

// 1) load the fixture → sets window.PROJECT (mirrors <script src="dashboard-data.js">)
eval(fs.readFileSync(FIXTURE, "utf8"));

// 2) extract + run the template's inline render <script> (boots + renders)
const html = fs.readFileSync(TEMPLATE, "utf8");
const scripts = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m => m[1]);
if (!scripts.length) { console.error("✗ no inline <script> found in template"); process.exit(1); }
eval(scripts.join("\n;\n"));

const all = cap.join("\n");

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
  // signature motif
  ["ghost numeral on phase header (01)",  () => all.includes('class="phase-numeral">01')],
  ["ghost numeral 02",                    () => all.includes('class="phase-numeral">02')],
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
  // tasks tab
  ["kanban task by unique id (1.1)",      () => all.includes('data-task="1.1"')],
  ["kanban task by unique id (3.1)",      () => all.includes('data-task="3.1"')],
  ["progress ring renders",               () => all.includes('class="ring"')],
  ["done task struck (kcard done)",       () => all.includes("kcard done")],
  // roadmap-only phase
  ["roadmap-only planned scope",          () => all.includes("Calendar heatmap")],
  ["roadmap-only 'not specced yet' note", () => all.includes("isn't specced yet")],
];

let pass = 0, fail = 0;
for (const [label, fn] of checks) {
  let ok = false; try { ok = !!fn(); } catch (_) { ok = false; }
  console.log((ok ? "  ✓ " : "  ✗ ") + label);
  ok ? pass++ : fail++;
}
console.log(`\ndashboard-render: ${pass}/${checks.length} passed`);
process.exit(fail ? 1 : 0);
