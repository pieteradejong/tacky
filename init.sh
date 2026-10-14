#!/usr/bin/env bash
# init.sh — everything needed to work on this Create React App project. Idempotent; exit 0 = ready.
#   ./init.sh            node check, npm ci (reused when node_modules exists)
#   ./init.sh --clean    remove node_modules first
set -euo pipefail
cd "$(dirname "$0")"
case "${1:-}" in
  -h|--help) sed -n '2,4p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  --clean) rm -rf node_modules ;;
  '') ;;
  *) echo "init.sh: unknown option '$1' (see ./init.sh --help)" >&2; exit 2 ;;
esac

command -v npm >/dev/null 2>&1 || { echo "npm (Node 18+) is required" >&2; exit 1; }
echo "node $(node -v), npm $(npm -v)"
if [ -d node_modules ]; then
  echo "reusing node_modules (./init.sh --clean to rebuild)"
else
  npm ci --no-fund --no-audit
fi
echo "ready: ./run.sh (dev server) · ./test.sh (every check)"
