#!/usr/bin/env bash
# Generates a project from this checkout with Claude Code, answering the interview from
# test/persona.md, then checks the result.
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
out=${1:-$(mktemp -d)}
mkdir -p "$out"
out=$(cd "$out" && pwd)
log="$out.log"
echo "Generating into $out"

# Notehub MCP needs a browser sign-in, so the test connects only Blues Expert.
mcp='{"mcpServers":{"blues-expert":{"type":"http","url":"https://mcp.blues.io/expert/mcp"}}}'

# The prompt goes first: --mcp-config takes several values and would swallow it.
# stream-json (which needs --verbose with -p) logs every tool call and result, not just the final reply.
(cd "$out" && claude -p \
  "Create a new Blues IoT project in this folder using the generator at $repo. It's a local copy: use it as is, including uncommitted changes. This is an automated test with no user present, so follow $repo/test/persona.md." \
  --output-format stream-json --verbose \
  --dangerously-skip-permissions \
  --strict-mcp-config --mcp-config "$mcp" \
  > "$log")
echo "Transcript: $log"

status=0

# The Firmware step validates every Notecard request with api_validate.
python3 -I "$repo/test/check_api_validate.py" "$log" || status=1

# The persona asks for firmware, so a run that skips it fails.
"$repo/test/check.sh" --require-firmware "$out" || status=1
exit "$status"
