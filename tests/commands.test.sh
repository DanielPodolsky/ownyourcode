#!/bin/bash
# ════════════════════════════════════════════════════════════════════
# Command-contract test — static checks across the /own:* command prose
# and the templates. Catches the regressions that matter for an agentic
# codebase: a command still pointing at a dead path, a missing tool in
# frontmatter, the schema/contract drifting from what commands reference.
#
# These are STATIC checks (grep over .md). They can't verify the agent
# follows the prose — that's the manual test's job — but they pin the
# contract the prose must honor.
# ════════════════════════════════════════════════════════════════════
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CMD="$ROOT/.claude/commands/own"
TPL="$ROOT/core/templates"
PASS=0; FAIL=0
ok()  { echo "  ✓ $1"; PASS=$((PASS+1)); }
bad() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

# grep helpers: assert a pattern is ABSENT / PRESENT in a file
absent_in() { # <pattern> <file> <label>
  if grep -qE "$1" "$2" 2>/dev/null; then bad "$3 ($(basename "$2") still matches /$1/)"; else ok "$3"; fi
}
present_in() { # <pattern> <file> <label>
  if grep -qE "$1" "$2" 2>/dev/null; then ok "$3"; else bad "$3 ($(basename "$2") missing /$1/)"; fi
}

echo "— dead-path references (v2.4 per-page model must be gone as live paths) —"
# product/ should not be referenced anywhere in commands
if grep -rnE 'ownyourcode/product/' "$CMD" >/dev/null 2>&1; then bad "no command references product/"; else ok "no command references product/"; fi
# specs/active|completed should not be a live read/write path
if grep -rnE 'specs/(active|completed)' "$CMD" >/dev/null 2>&1; then bad "no command references specs/active|completed"; else ok "no command references specs/active|completed"; fi
# templates/html (v2.4 per-page templates) gone from commands + installers
if grep -rnE 'templates/html' "$CMD" "$ROOT/scripts" >/dev/null 2>&1; then bad "no templates/html refs in commands/scripts"; else ok "no templates/html refs in commands/scripts"; fi
# theme.css is a v2.4 concept (dashboard is self-styled) — allow only the
# explanatory "no .theme/theme.css" line in init.md
THEMECSS=$(grep -rnE 'theme\.css' "$CMD" | grep -vE 'no .*theme\.css|NO .*theme\.css' || true)
[ -z "$THEMECSS" ] && ok "no live theme.css references" || { bad "stray theme.css reference"; echo "$THEMECSS"; }

echo "— frontmatter tool grants (commands that run node --check need Bash) —"
for c in init feature done; do
  present_in '^allowed-tools:.*\bBash\b' "$CMD/$c.md" "/own:$c frontmatter allows Bash"
done

echo "— the dashboard data file is the single SDD source —"
present_in 'dashboard-data\.js' "$CMD/init.md"    "/own:init writes dashboard-data.js"
present_in 'dashboard-data\.js' "$CMD/feature.md" "/own:feature targets dashboard-data.js"
present_in 'dashboard-data\.js' "$CMD/done.md"    "/own:done mutates dashboard-data.js"
present_in 'window\.PROJECT'    "$CMD/status.md"  "/own:status reads window.PROJECT"
# /own:theme restyles the shell, never the data
present_in 'dashboard\.html'    "$CMD/theme.md"   "/own:theme targets dashboard.html"
absent_in  'edit.*dashboard-data|dashboard-data.*regenerat' "$CMD/theme.md" "/own:theme never edits dashboard-data.js"

echo "— schema field names the writing commands must use (vs the contract) —"
present_in 'data-task|tasks\[' "$CMD/done.md" "/own:done references the tasks structure"
present_in 'roadmap-only'      "$CMD/feature.md" "/own:feature keys off status roadmap-only"
present_in 'status.*specced|specced'  "$CMD/feature.md" "/own:feature sets status specced"
present_in 'audience'          "$CMD/init.md" "/own:init captures meta.audience"

echo "— Terminal-Futurism default is in the shipped template —"
present_in 'Terminal-Futurism' "$TPL/dashboard.html.template" "template names Terminal-Futurism"
present_in '#22c55e'           "$TPL/dashboard.html.template" "template uses the green accent"
present_in 'JetBrains\+Mono'   "$TPL/dashboard.html.template" "template loads JetBrains Mono"
present_in 'phase-numeral'     "$TPL/dashboard.html.template" "template has the ghost-numeral motif"
present_in 'Terminal-Futurism' "$TPL/theme-prompt.md.template" "default theme brief describes Terminal-Futurism"

echo ""
echo "commands: ${PASS}/$((PASS+FAIL)) passed"
[ "$FAIL" -eq 0 ]
