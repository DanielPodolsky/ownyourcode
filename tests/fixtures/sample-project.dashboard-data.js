/* ════════════════════════════════════════════════════════════════════
   Canonical test fixture — a realistic window.PROJECT that exercises EVERY
   schema state the dashboard must render. Shared by the render test and
   usable as a reference example. Mirrors DASHBOARD_CONTRACT.md.

   Coverage:
   - phase states: complete (1), specced + active (2), roadmap-only (3, 4)
   - stack source types: package.json, mcp:DATE, verify:URL, manual  (all 4)
   - components: 4-tuple with both "new" and "modified" kinds + file paths
   - tasks: multiple groups, mixed done/undone, unique ids
   - DoD: partial (some done, some not)
   - meta.audience: a valid enum value
   ════════════════════════════════════════════════════════════════════ */
window.PROJECT = {
  meta: {
    name: "momentum",
    tagline: "see your progress · ship the project",
    audience: "employers",
    mission: "I procrastinate on side projects because I can't see my own progress over time. momentum makes effort visible so it compounds instead of evaporating.",
    generated: "2026-05-30",
    version: "2.5.0-dev",
  },
  dod: [
    { text: "Daily log entries persist across refresh", done: true },
    { text: "Streak heatmap visualizes activity", done: false },
    { text: "Stalled projects flagged (7+ days)", done: false },
    { text: "Weekly summary exports as Markdown", done: false },
  ],
  stack: [
    ["Framework", "Next.js", "16.2.6", "package.json", "App Router, routing, build"],
    ["UI", "React", "19.2.4", "package.json", "Component model + hooks"],
    ["Language", "TypeScript", "5.9.3", "package.json", "Type-safe domain + storage"],
    ["Styling", "Tailwind CSS", "4.3.0", "mcp:2026-05-28", "Utility-first CSS"],
    ["Storage", "localStorage", "—", "manual", "Client persistence, no backend"],
    ["Runtime", "bun", "1.3.5", "verify:bun.sh", "Package manager + runtime"],
  ],
  phases: [
    {
      n: 1, name: "Foundation", slug: "foundation", priority: "high", status: "complete",
      description: "App shell + domain types + the storage repository seam every later phase reads through.",
      spec: {
        overview: "Stand up the app shell, define domain types, and build the single storage seam all persistence flows through.",
        motivation: "The storage repository is the most important architectural decision — get it right and the localStorage→Postgres migration is a one-file change.",
        userStories: [
          { actor: "first-time user", want: "open the dashboard and see a clear empty-state", soThat: "my first impression isn't a blank white screen" },
          { actor: "developer maintaining this", want: "a single typed storage module", soThat: "swapping the DB later is a one-file change" },
        ],
        criteria: ["/ renders cleanly on server + after hydration", "Domain types defined + exported", "repos expose list/get/add/remove over a shared safe primitive"],
        edges: [
          ["SSR pass", "window/localStorage undefined on server — reads return safe defaults, never throw"],
          ["Corrupted JSON", "JSON.parse throws — repo catches, warns, returns fallback"],
          ["Quota exceeded", "setItem throws — safeWrite catches, warns, returns false"],
        ],
        outOfScope: ["Create-project UI (Phase 2)", "Streak algorithm (Phase 3)"],
        openQuestions: ["zod vs hand-rolled type guards for v1? (Lean hand-rolled.)"],
      },
      design: {
        overview: "A thin client-rendered React tree talking to a pure, React-free storage layer wrapping localStorage.",
        diagram: {
          caption: "One-way dependency: UI → repositories → safe primitive → the browser store.",
          layers: [
            { label: "UI · client", nodes: ["page.tsx", "empty-state.tsx"] },
            { label: "Repositories", nodes: ["projects-repo", "log-entries-repo"] },
            { label: "Primitive", nodes: ["safe.ts — SSR · parse · quota"] },
            { label: "Browser", nodes: ["localStorage — momentum:v1:*"] },
          ],
        },
        flow: [
          "Browser requests / — SSR guard returns []",
          "HTML hydrates; repos read real localStorage",
          "Component branches: empty → EmptyState, else dashboard",
        ],
        tradeoffs: [
          { title: "Per-entity repos over a generic store", chosen: "projectsRepo / logEntriesRepo with typed CRUD", rejected: "Generic store<T>(key) with stringly-typed keys", why: "Per-entity APIs give autocomplete + type safety and room to grow." },
          { title: "Repos return safe defaults, never throw", chosen: "Reads return typed fallback + warn; writes return boolean", rejected: "Throwing on failure", why: "The dashboard's only valid response to 'storage broke' is render empty-state and continue." },
        ],
        components: [
          ["safe.ts", "safeRead/safeWrite — SSR, parse, quota guards", "new", "src/lib/storage/safe.ts"],
          ["projects-repo.ts", "Typed CRUD over Project[]", "new", "src/lib/storage/projects-repo.ts"],
          ["page.tsx", "Dashboard route — reads projectsRepo.list()", "modified", "src/app/page.tsx"],
        ],
        openQuestions: [],
      },
      tasks: [
        { id: "1.1", group: "Setup", text: "Mark page.tsx as a client component", detail: "App Router renders Server Components by default; localStorage needs the client boundary.", done: true },
        { id: "2.1", group: "Implementation", text: "Create src/lib/types.ts", detail: "Type the domain before the UI — surfaces hidden assumptions early.", done: true },
        { id: "2.2", group: "Implementation", text: "Create storage/safe.ts", detail: "The one place that knows localStorage can fail.", done: true },
        { id: "3.1", group: "Verification", text: "bun run build — no SSR or type errors", detail: "Build proves the SSR guard.", done: true },
      ],
    },
    {
      n: 2, name: "Logging", slug: "logging", priority: "high", status: "specced",
      description: "The minimum viable loop: pick a project, log today, see it persist across refresh.",
      spec: {
        overview: "Create-project + log-entry form + a last-7-days list, persisted through the repos from Phase 1.",
        motivation: "This is the first loop the user actually feels — visible effort starts here.",
        userStories: [
          { actor: "returning user", want: "log today's work in two clicks", soThat: "the streak keeps building without friction" },
          { actor: "new user", want: "create my first project from the empty state", soThat: "I have something to log against" },
        ],
        criteria: ["A project can be created with a name", "A log entry persists across refresh", "The last 7 days render newest-first"],
        edges: [
          ["Empty note", "Allow empty note but require a date — a log means 'I showed up'"],
          ["Duplicate same-day log", "Second log same day updates the first, not a duplicate row"],
        ],
        outOfScope: ["Streak math (Phase 3)", "Export (Phase 4)"],
        openQuestions: ["Inline new-project field vs modal? (Lean inline.)"],
      },
      design: {
        overview: "Form writes through logEntriesRepo; the list reads the last 7 days from the same repo.",
        diagram: {
          caption: "Form → repo → store; List ← repo ← store.",
          layers: [
            { label: "UI · client", nodes: ["log-form.tsx", "entry-list.tsx"] },
            { label: "Repositories", nodes: ["log-entries-repo"] },
            { label: "Primitive", nodes: ["safe.ts"] },
          ],
        },
        flow: ["User submits the log form", "repo.add() → safeWrite (JSON + quota guard)", "List re-reads last 7 days", "UI renders newest-first"],
        tradeoffs: [
          { title: "Controlled vs uncontrolled form", chosen: "controlled (useState)", rejected: "uncontrolled + FormData", why: "controlled makes the duplicate-same-day check trivial before write" },
        ],
        components: [
          ["log-form.tsx", "Create-project + log-entry capture", "new", "src/components/log-form.tsx"],
          ["entry-list.tsx", "Last-7-days list, newest first", "new", "src/components/entry-list.tsx"],
          ["log-entries-repo.ts", "Typed CRUD over LogEntry[]", "modified", "src/lib/storage/log-entries-repo.ts"],
        ],
        openQuestions: ["Optimistic insert vs re-read after write? (Lean re-read for v1.)"],
      },
      tasks: [
        { id: "1.1", group: "Setup", text: "Add LogEntry + Project create paths to the repos", detail: "Extend the existing repos; no new storage primitive.", done: true },
        { id: "2.1", group: "Implementation", text: "Build log-form.tsx (project picker, date, note)", detail: "Controlled inputs; disable submit on empty date.", done: false },
        { id: "2.2", group: "Implementation", text: "Build entry-list.tsx (last 7 days)", detail: "Sort newest-first; group by day.", done: false },
        { id: "2.3", group: "Implementation", text: "Wire form → repo.add → list refresh", detail: "", done: false },
        { id: "3.1", group: "Verification", text: "Refresh-survives + duplicate-same-day tests", detail: "Manually verify both edge cases from the spec.", done: false },
      ],
    },
    {
      n: 3, name: "Visualization", slug: "visualization", priority: "medium", status: "roadmap-only",
      description: "Make progress visible — streak heatmap + stalled-projects panel.",
      items: ["Calendar heatmap (last 90 days)", "Streak calculation (current + longest)", "Stalled-projects panel (7+ days)", "Empty-state & edge-case handling"],
    },
    {
      n: 4, name: "Export", slug: "export", priority: "low", status: "roadmap-only",
      description: "Weekly Markdown export + deploy. Closes the final DoD item.",
      items: ["'Export this week' → Markdown", "Browser download (Blob + anchor)", "Deploy to Vercel + verify live"],
    },
  ],
};
