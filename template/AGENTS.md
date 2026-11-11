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

This project is configured with two Blues MCP servers (`.mcp.json`, `.cursor/mcp.json`, `.vscode/mcp.json`). Use them instead of answering from memory, and follow each server's own instructions. If a server isn't connected, start at https://dev.blues.io/llms.txt.

- **Blues Expert** (`https://mcp.blues.io/expert/mcp`): writing or reviewing firmware and Notecard requests, and general Blues questions. **Run its `api_validate` tool on every Notecard request you write**, before it goes into the firmware.
- **Notehub MCP** (`https://mcp.notehub.io/mcp`, browser sign-in): anything involving real devices, events, or fleets, including Notehub IQ questions about this project's data. For longer Notehub work, Blues also publishes agent skills at https://notehub.md.

When working in Notehub:

- Use the Notehub project named in `docs/data.md`.
- **Ask before making any change in Notehub**, such as setting env vars, creating fleets, or sending notes to devices. These affect real hardware.
- Interpret data using the field descriptions, units, and normal ranges in `docs/data.md`, and the firmware source.

Cross-reference the two. For example, when debugging "device X stopped reporting," read the firmware's sync and sleep logic and `docs/hardware.md` → *Power*, then look at that device's recent sessions and health events in Notehub.

## Firmware

- Use the platform, toolchain, and board in `firmware/README.md`.
- Pin assignments must match `docs/hardware.md` → *Wiring*.
- Follow Blues Expert's firmware guidance on how to use the Notecard, rather than hand-rolling what it already does.
- Read tunable values from Notehub environment variables, with in-code defaults that match `docs/configuration.md`.
- The firmware applies the Notecard configuration in `docs/configuration.md` at startup (`hub.set`, `card.voltage`, `card.location.mode`, note templates, `card.dfu`, ...). Flashing the host is all it takes to set up a device, so keep the firmware and that doc in sync.
- The firmware reports its version to Notehub on every boot with the `version` argument of `hub.set`. Bump the version in the source with every release, and in `firmware/README.md`.
- Before saying a firmware change works, build it. If a device is connected, flash it, check serial output, and confirm the expected events through Notehub MCP.

## Dashboard

- Call the Notehub API from server-side code only. Never expose `NOTEHUB_PERSONAL_ACCESS_TOKEN` to the browser.
- The token carries the user's privileges in this one project only (see `dashboard/README.md`). Never suggest a token that reaches all of their projects.
- Use the Notefile names, fields, and units in `docs/data.md`.
- Dashboard secrets and settings live in `dashboard/.env` (never committed). Add new variables to both `dashboard/.env.example` and the table in `dashboard/README.md`.
