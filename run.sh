#!/usr/bin/env bash
# run.sh — tacky, a Create React App. Run ./init.sh once first.
#   ./run.sh [start]     dev server on http://localhost:3000 (default)
#   ./run.sh build       production build into build/
#   ./run.sh test        every check (delegates to ./test.sh)
#   ./run.sh help
set -euo pipefail
cd "$(dirname "$0")"

cmd="${1:-start}"
[ $# -gt 0 ] && shift
case "$cmd" in
  help|-h|--help) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  test) exec ./test.sh "$@" ;;
  start|build) ;;
  *) echo "run.sh: unknown command '$cmd' (see ./run.sh help)" >&2; exit 2 ;;
esac
[ -d node_modules ] || { echo "node_modules missing: run ./init.sh first" >&2; exit 1; }
case "$cmd" in
  start) exec npm start ;;
  build) exec npm run build ;;
esac
