#!/bin/bash
# ════════════════════════════════════════════════════════════════════
# OwnYourCode v2.5 test runner — runs all deterministic test layers.
#
#   bash tests/run.sh
#
# Layers:
#   1. install   — project-install.sh seeds the dashboard, no dead v2.4 dirs
#   2. render    — the dashboard's real render JS handles every schema state
#   3. commands  — static contract checks over the /own:* command prose
#
# Requires: bash, node. No network, no other dependencies.
# What this does NOT test: whether the agent FOLLOWS the command prose at
# runtime — that's tests/MANUAL_TEST.md (run OwnYourCode for real).
# ════════════════════════════════════════════════════════════════════
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
FAILED=""

run() { # <label> <command...>
  echo ""
  echo "━━━ $1 ━━━"
  if "${@:2}"; then :; else FAILED="$FAILED $1"; fi
}

run "install"  bash    "$HERE/install.test.sh"
run "render"   node    "$HERE/dashboard-render.test.js"
run "commands" bash    "$HERE/commands.test.sh"

echo ""
echo "════════════════════════════════════════════"
if [ -z "$FAILED" ]; then
  echo "✅ ALL TEST LAYERS PASSED"
  exit 0
else
  echo "❌ FAILED LAYERS:$FAILED"
  exit 1
fi
