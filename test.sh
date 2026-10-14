#!/usr/bin/env bash
# test.sh — every check in one place. Exit 0 = all green. `./run.sh test` runs this script.
#   ./test.sh            deps · secrets · shell · unit (jest, CI mode) · build
#   ./test.sh --quick    skip the production build
set -euo pipefail
cd "$(dirname "$0")"
QUICK=0
case "${1:-}" in
  -h|--help) sed -n '2,4p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  --quick) QUICK=1 ;;
  '') ;;
  *) echo "test.sh: unknown option '$1' (see ./test.sh --help)" >&2; exit 2 ;;
esac

echo "== deps"
[ -d node_modules ] || npm ci --no-fund --no-audit
npm ls --depth=0 >/dev/null

echo "== secrets (no tracked .env)"
tracked="$(git ls-files | grep -E '(^|/)\.env(\..+)?$' | grep -vE '\.env\.(example|template)$' || true)"
[ -z "$tracked" ] || { echo "env files must never be tracked:"; echo "$tracked"; exit 1; }

echo "== shell"
for f in ./*.sh; do bash -n "$f"; /bin/bash -n "$f"; done
if command -v shellcheck >/dev/null 2>&1; then shellcheck -S warning ./*.sh; else echo "shellcheck not installed — syntax only"; fi

echo "== unit (jest)"
CI=true npm test -- --watchAll=false

if [ "$QUICK" -eq 1 ]; then
  echo "== build skipped (--quick)"
else
  echo "== build"
  npm run build
fi
echo "== all green"
