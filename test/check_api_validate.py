"""Checks a stream-json transcript for Notecard requests that api_validate never accepted.

Every request the agent validates must end with a successful validation. A rejected attempt is
fine if a later validation of the same request (by its "req" or "cmd" name) succeeds. An error
or a missing result counts as a failed attempt.
"""

import json
import re
import sys


def request_name(arguments):
    request = arguments.get("request") if isinstance(arguments, dict) else None
    if isinstance(request, str):
        try:
            request = json.loads(request)
        except ValueError:
            match = re.search(r'"(?:req|cmd)"\s*:\s*"([^"]+)"', request)
            return match.group(1) if match else request
    if isinstance(request, dict):
        name = request.get("req") or request.get("cmd")
        if isinstance(name, str):
            return name
    return json.dumps(request)


calls = {}  # tool_use id -> [order, request name, succeeded]
with open(sys.argv[1], encoding="utf-8") as f:
    for line in f:
        try:
            event = json.loads(line)
        except ValueError:
            continue
        message = event.get("message") if isinstance(event, dict) else None
        content = message.get("content") if isinstance(message, dict) else None
        for block in content if isinstance(content, list) else []:
            if not isinstance(block, dict):
                continue
            name = block.get("name")
            if block.get("type") == "tool_use" and isinstance(name, str) and name.endswith("__api_validate"):
                calls[block.get("id")] = [len(calls), request_name(block.get("input")), False]
            elif block.get("type") == "tool_result" and block.get("tool_use_id") in calls:
                accepted = "validation successful" in json.dumps(block.get("content")).lower()
                calls[block["tool_use_id"]][2] = accepted and not block.get("is_error")

last_attempt = {}
for order, name, succeeded in sorted(calls.values()):
    last_attempt[name] = succeeded
passed = sum(succeeded for _, _, succeeded in calls.values())
print(f"api_validate: {len(calls)} call(s), {passed} passed, {len(last_attempt)} distinct request(s)")

problems = []
if not calls:
    problems.append("the agent never called api_validate")
problems += [f"the last api_validate attempt for {name} didn't pass" for name, ok in sorted(last_attempt.items()) if not ok]
for problem in problems:
    print(f"FAIL: {problem}")
sys.exit(1 if problems else 0)
