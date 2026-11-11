#!/usr/bin/env bash
# Checks a project generated from this template for leftovers, broken config, and firmware that doesn't build.
set -u

require_firmware=0
if [ "${1:-}" = "--require-firmware" ]; then require_firmware=1; shift; fi
dir=${1:?usage: test/check.sh [--require-firmware] <generated-project-dir>}
failures=0
fail() { echo "FAIL: $*"; failures=$((failures + 1)); }

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

for f in .mcp.json .cursor/mcp.json .vscode/mcp.json; do
  python3 -c 'import json, sys; json.load(open(sys.argv[1]))' "$dir/$f" 2>/dev/null || fail "$f isn't valid JSON"
done

md_grep() { grep -rnF --include='*.md' --exclude-dir=.git --exclude-dir=node_modules "$1" "$dir"; }
md_grep '{{' && fail "placeholders left in Markdown (above)"
md_grep '<!-- Generator' && fail "generator comments left in Markdown (above)"

if [ -f "$dir/SETUP.md" ]; then
  grep -qF '<commit>' "$dir/SETUP.md" && fail "SETUP.md doesn't name the generator commit"
  grep -qE '[0-9a-f]{40}|GENERATOR\.md' "$dir/SETUP.md" || fail "SETUP.md doesn't link the generator"
fi

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
