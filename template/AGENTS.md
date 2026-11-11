# AGENTS.md

Instructions for AI coding agents working on {{PROJECT_NAME}}. Claude Code reads this through `CLAUDE.md`.

## Start here

- **If `SETUP.md` exists, project setup isn't finished.** When the user asks to continue setup (or a task depends on an unfinished step), follow the generator instructions linked in `SETUP.md`, starting at the first unchecked step.
- **Read the docs before writing code.** They're the source of truth about this device. Don't guess at pins, part numbers, Notefile names, units, or thresholds.

| File | Read it when |
| --- | --- |
| `docs/product.md` | You need to know what the device is for and what "working" means. |
| `docs/hardware.md` | Choosing pins, buses, libraries, or power behavior; debugging hardware. |
| `docs/data.md` | Writing or reading notes, interpreting Notehub data. |
| `docs/configuration.md` | Adding device settings or Notehub environment variables. |
| `docs/datasheets/` | You need component details. Check here before searching the web. |
| `firmware/README.md` | Building, flashing, or changing firmware. |
| `dashboard/README.md` | Running or changing the dashboard. |

- **Keep the docs in sync with the code, in the same change.** Update the matching doc when you add or rename a Notefile or field, add a setting, change wiring, add a component, or change sync cadence. Out-of-date docs mislead future agents and Notehub IQ.
- **Keep `README.md` short:** name, description, and links. Details go in `docs/`.

## MCP servers

This project is configured with two Blues MCP servers (`.mcp.json`, `.cursor/mcp.json`, `.vscode/mcp.json`). Use them instead of answering from memory. Blues APIs change, and training data goes stale.

If an MCP server isn't connected, read the Blues docs as Markdown instead: https://dev.blues.io/llms-agent.txt covers the core concepts and every Notecard request, and appending `.md` to any https://dev.blues.io page URL returns that page as Markdown.

### Blues Expert MCP: firmware and Notecard APIs

`https://mcp.blues.io/expert/mcp` (no auth). Use it for **writing or reviewing firmware and Notecard requests**.

- **Before writing or substantially changing firmware, call `firmware_entrypoint`.**
- Use `firmware_best_practices` for power, sync strategy, templates, and error handling.
- Use `api_docs` for the exact arguments of a Notecard request.
- **Run `api_validate` on every Notecard JSON request you write**, before adding it to the firmware.
- Use `docs_search` for general Blues questions: pinouts, SKUs, Notehub features, troubleshooting.

### Notehub MCP: live device data

`https://mcp.notehub.io/mcp` (browser sign-in). Use it for **anything involving real devices, events, or fleets**: checking that new firmware sends what it should, answering questions about device health and sensor trends with Notehub IQ, reading environment variables, and checking which host firmware version each device reports.

- Follow the server's own instructions: load its skill first, find this project's repository, and check the schema before querying.
- For longer Notehub work, such as monitoring a fleet or rolling out firmware, Blues publishes agent skills at https://notehub.md (`npx skills add https://notehub.md`).
- Use the Notehub project named in `docs/data.md`.
- **Ask before making any change in Notehub**, such as setting env vars, creating fleets, or sending notes to devices. These affect real hardware.
- Interpret data using the field descriptions, units, and normal ranges in `docs/data.md`, and the firmware source.

### Using both

Cross-reference them. For example, when debugging "device X stopped reporting," read the firmware's sync and sleep logic and `docs/hardware.md` → *Power*, then query `_session.qo` and `_health.qo` for that device through Notehub MCP.

## Firmware

- Use the platform, toolchain, and board in `firmware/README.md`.
- Pin assignments must match `docs/hardware.md` → *Wiring*.
- Prefer Notecard features over hand-rolled ones: note templates, `env.get` for remote configuration, `card.attn` / `card.voltage` for power, `hub.sync` only when necessary.
- Read tunable values from Notehub environment variables, with in-code defaults that match `docs/configuration.md`.
- The firmware applies the Notecard configuration in `docs/configuration.md` at startup (`hub.set`, `card.voltage`, `card.location.mode`, note templates, `card.dfu`, ...). Flashing the host is all it takes to set up a device, so keep the firmware and that doc in sync.
- The firmware reports its version to Notehub on every boot with the `version` argument of `hub.set`, which works on every Notecard (Notecard for LoRa has no `dfu` requests). Bump the version in the source with every release, and in `firmware/README.md`.
- Before saying a firmware change works, build it. If a device is connected, flash it, check serial output, and confirm the expected events through Notehub MCP.

## Dashboard

- Call the Notehub API from server-side code only. Never expose `NOTEHUB_PERSONAL_ACCESS_TOKEN` to the browser.
- The token is scoped to this one project (see `dashboard/README.md`). If a feature needs more access than the token has, tell the user. Never suggest a token that reaches all of their projects.
- Use the Notefile names, fields, and units in `docs/data.md`.
- Dashboard secrets and settings live in `dashboard/.env` (never committed). Add new variables to both `dashboard/.env.example` and the table in `dashboard/README.md`.
