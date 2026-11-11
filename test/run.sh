#!/usr/bin/env bash
# Generates a project from this checkout with Claude Code, answering the interview from
# test/persona.md, then runs test/check.sh on the result.
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
out=${1:-$(mktemp -d)}
mkdir -p "$out"
echo "Generating into $out"

# Notehub MCP needs a browser sign-in, so the test connects only Blues Expert.
mcp='{"mcpServers":{"blues-expert":{"type":"http","url":"https://mcp.blues.io/expert/mcp"}}}'

# The prompt goes first: --mcp-config takes several values and would swallow it.
(cd "$out" && claude -p \
  "Create a new Blues IoT project in this folder using the generator at $repo. It's a local copy: use it as is, including uncommitted changes. This is an automated test with no user present, so follow $repo/test/persona.md." \
  --dangerously-skip-permissions \
  --strict-mcp-config --mcp-config "$mcp" \
  > "$out.log")

"$repo/test/check.sh" "$out"
