"""Prints one line per problem with a generated project's MCP config files."""

import json
import os
import sys

SERVER_URLS = {"https://mcp.blues.io/expert/mcp", "https://mcp.notehub.io/mcp"}

# Each client's file, the key that holds its servers, and the "type" it needs
# for an HTTP server (Cursor infers the transport from "url").
CLIENTS = {
    ".mcp.json": ("mcpServers", "http"),
    ".cursor/mcp.json": ("mcpServers", None),
    ".vscode/mcp.json": ("servers", "http"),
}

project = sys.argv[1]
for path, (key, server_type) in CLIENTS.items():
    try:
        with open(os.path.join(project, path)) as f:
            config = json.load(f)
    except (OSError, ValueError):
        print(f"{path} is missing or isn't valid JSON")
        continue
    servers = config.get(key) if isinstance(config, dict) else None
    if not isinstance(servers, dict):
        print(f'{path} has no "{key}" object')
        continue
    by_url = {}
    for name, server in servers.items():
        url = server.get("url") if isinstance(server, dict) else None
        if isinstance(url, str):
            by_url[url] = server
        else:
            print(f'{path}: the "{name}" server has no "url" string')
    for url in sorted(SERVER_URLS):
        server = by_url.get(url)
        if server is None:
            print(f"{path} has no server for {url}")
        elif server_type and server.get("type") != server_type:
            print(f'{path}: the {url} server needs "type": "{server_type}"')
