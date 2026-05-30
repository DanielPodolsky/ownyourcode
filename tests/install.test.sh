#!/bin/bash
# ════════════════════════════════════════════════════════════════════
# Install test — runs project-install.sh into a throwaway project and
# asserts the v2.5 dashboard is seeded correctly with no dead v2.4 artifacts.
# No network, no side effects outside a temp dir (cleaned up at the end).
# ════════════════════════════════════════════════════════════════════
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0
ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
bad()  { echo "  ✗ $1"; FAIL=$((FAIL+1)); }
exists(){ [ -e "$1" ] && ok "$2" || bad "$2 (missing: $1)"; }
absent(){ [ ! -e "$1" ] && ok "$2" || bad "$2 (unexpectedly present: $1)"; }

# Syntax checks on the installers themselves
bash -n "$ROOT/scripts/project-install.sh" && ok "project-install.sh syntax" || bad "project-install.sh syntax"

# Run the installer into a fresh fixture
FIX="$(mktemp -d -t oyc-install-test-XXXXX)"
trap 'rm -rf "$FIX"' EXIT
touch "$FIX/CLAUDE.md"
( cd "$FIX" && bash "$ROOT/scripts/project-install.sh" >/dev/null 2>&1 )
[ $? -eq 0 ] && ok "installer ran (exit 0)" || bad "installer exit code"

OYC="$FIX/ownyourcode"

# v2.5 dashboard artifacts seeded
exists "$OYC/dashboard/dashboard.html"               "dashboard.html seeded"
exists "$OYC/dashboard/dashboard-data.js"            "dashboard-data.js seeded"
exists "$OYC/DASHBOARD_CONTRACT.md"        "DASHBOARD_CONTRACT.md seeded"
exists "$OYC/.theme/theme-prompt.md"       ".theme/theme-prompt.md seeded"
exists "$OYC/.theme/.history"              ".theme/.history created"
exists "$OYC/templates/dashboard.html.template" "in-project template kept (fallback regen)"

# dashboard files live under dashboard/, NOT at the ownyourcode/ root
exists "$OYC/dashboard"                      "dashboard/ folder created"
absent "$OYC/dashboard.html"                 "no flat dashboard.html at root (moved to dashboard/)"
absent "$OYC/dashboard-data.js"              "no flat dashboard-data.js at root (moved to dashboard/)"

# dead v2.4 artifacts must NOT appear
absent "$OYC/product"                       "no product/ dir (v2.4 removed)"
absent "$OYC/templates/html"                "no templates/html/ dir (v2.4 removed)"
absent "$OYC/.theme/theme.css"              "no theme.css (dashboard self-styled)"

# generated JS is valid
cp "$OYC/dashboard/dashboard-data.js" "$FIX/_data.js" && node --check "$FIX/_data.js" \
  && ok "seeded dashboard-data.js is valid JS" || bad "seeded dashboard-data.js invalid JS"
node -e 'const fs=require("fs");const h=fs.readFileSync(process.argv[1],"utf8");const j=[...h.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m=>m[1]).join("\n;\n");fs.writeFileSync(process.argv[2],j);' "$OYC/dashboard/dashboard.html" "$FIX/_inline.js" \
  && node --check "$FIX/_inline.js" && ok "seeded dashboard.html inline JS is valid" || bad "seeded dashboard.html inline JS invalid"

# render-contract integrity (what /own:theme checks before/after a restyle)
[ "$(grep -c 'window.PROJECT' "$OYC/dashboard/dashboard.html")" -ge 1 ] && ok "dashboard.html keeps window.PROJECT load" || bad "dashboard.html missing window.PROJECT"
[ "$(grep -c 'function renderViews' "$OYC/dashboard/dashboard.html")" -eq 1 ] && ok "dashboard.html keeps render logic" || bad "dashboard.html missing render logic"

echo ""
echo "install: ${PASS}/$((PASS+FAIL)) passed"
[ "$FAIL" -eq 0 ]
