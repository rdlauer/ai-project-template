#!/usr/bin/env bash
# Checks a project generated from this template for leftovers, broken config, and firmware that doesn't build.
set -u

require_firmware=0
if [ "${1:-}" = "--require-firmware" ]; then require_firmware=1; shift; fi
dir=${1:?usage: test/check.sh [--require-firmware] <generated-project-dir>}
here=$(cd "$(dirname "$0")" && pwd)
failures=0
fail() { echo "FAIL: $*"; failures=$((failures + 1)); }

# Runs a helper that prints one problem per line. A helper that crashes fails the check too.
check_with() {
  local output status
  output=$(python3 -I "$here/$1" "$dir")
  status=$?
  while IFS= read -r line; do [ -n "$line" ] && fail "$line"; done <<<"$output"
  [ "$status" -eq 0 ] || fail "$1 exited with status $status (see above)"
}

for f in README.md AGENTS.md CLAUDE.md .gitignore .mcp.json .cursor/mcp.json .vscode/mcp.json \
  docs/product.md docs/hardware.md docs/data.md docs/configuration.md \
  firmware/README.md dashboard/README.md dashboard/.env.example; do
  [ -e "$dir/$f" ] || fail "missing $f"
done

[ "$(cat "$dir/CLAUDE.md" 2>/dev/null)" = "@AGENTS.md" ] || fail "CLAUDE.md must contain exactly @AGENTS.md"

for entry in "$dir"/* "$dir"/.[!.]*; do
  [ -e "$entry" ] || continue
  case $(basename "$entry") in
    README.md | AGENTS.md | CLAUDE.md | SETUP.md | LICENSE | .gitignore | .git | .mcp.json | .cursor | .vscode | docs | firmware | dashboard) ;;
    *) fail "unexpected file at the project root: $(basename "$entry")" ;;
  esac
done

check_with check_mcp.py

md_grep() { grep -rnF --include='*.md' --exclude-dir=.git --exclude-dir=node_modules "$1" "$dir"; }
md_grep '{{' && fail "placeholders left in Markdown (above)"
md_grep '<!-- Generator' && fail "generator comments left in Markdown (above)"

check_with check_setup.py

sketch=$(find "$dir/firmware" -name '*.ino' -not -path '*/build/*' 2>/dev/null | head -1)
fqbn=$(grep -oE '[A-Za-z0-9_-]+:[A-Za-z0-9_-]+:[A-Za-z0-9_-]+(:[A-Za-z0-9_=,-]+)?' "$dir/firmware/README.md" 2>/dev/null | head -1)
if [ -z "$sketch" ]; then
  [ "$require_firmware" = 1 ] && fail "firmware/ has no Arduino sketch"
elif ! command -v arduino-cli >/dev/null; then
  if [ "$require_firmware" = 1 ]; then
    fail "arduino-cli isn't installed, so the firmware can't be built"
  else
    echo "SKIP: arduino-cli isn't installed, so the firmware wasn't built"
  fi
elif [ -z "$fqbn" ]; then
  fail "firmware/README.md doesn't name an FQBN"
else
  arduino-cli compile --fqbn "$fqbn" "$(dirname "$sketch")" >/dev/null 2>&1 \
    || fail "firmware doesn't build with $fqbn (run arduino-cli compile to see why)"
fi

if [ "$failures" -eq 0 ]; then echo "PASS: $dir"; else echo "$failures check(s) failed"; exit 1; fi
