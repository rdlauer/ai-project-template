# Project generator instructions

**Audience: AI agents.** The user has asked you to create a new Blues IoT project from this generator. Follow these steps in order. The steps are a conversation with the user, not a batch job: keep them informed, ask before anything irreversible, and never invent hardware details.

Generator source: `https://github.com/tjvantoll/ai-project-template` (branch `main`).

## Ground rules

- **Ask, don't guess.** Pins, part numbers, Notefile names, units, and thresholds come from the user or from documentation you looked up. If neither is available, write `TBD` and move on.
- **Look things up instead of asking** when the answer is in Blues documentation, e.g. a Notecarrier's default Notecard interface, Feather pin mappings, or the right `card.voltage` mode. Use the Blues Expert MCP `docs_search` tool if available. Tell the user what you looked up.
- **Ask a few questions at a time** (2–4), grouped by topic. Offer choices from [`generator/options.md`](./generator/options.md) and mark the defaults. Use your tool's multiple-choice question UI if it has one.
- **Keep `SETUP.md` up to date** in the new project (see step 1) so that setup can resume in a later session.
- **Ask before** creating anything in Notehub, flashing hardware, or running commands that touch a connected device.

## Step 0: Prepare

1. **Find the target folder.** Default to the current working directory. If it isn't empty (ignoring `.git`), ask whether to use it anyway or create a subfolder.
2. **Get the generator files.** Clone into a temporary folder outside the target, e.g.
   ```sh
   git clone --depth 1 https://github.com/tjvantoll/ai-project-template <temp-dir>
   ```
   If `git` is unavailable, fetch each file listed in [File manifest](#file-manifest) from `https://raw.githubusercontent.com/tjvantoll/ai-project-template/main/<path>`.
3. Read `generator/options.md` from the generator source.

## Step 1: Scaffold

1. Copy everything in `template/` (including dotfiles) into the target folder. Don't copy anything outside `template/`.
2. Create `CLAUDE.md` in the target folder containing exactly `@AGENTS.md`.
3. Create `SETUP.md` in the target folder from [SETUP.md contents](#setupmd-contents). Check off "Scaffold."
4. If the folder isn't a git repository, run `git init`.
5. Tell the user what you created, and that the project includes MCP config for Blues Expert and Notehub MCP. They may need to approve those servers or restart their agent in this folder before the servers work. That's fine: the interview doesn't need them.

## Step 2: Interview

Work through these topics in order. Record answers as you go: fill in the matching `{{PLACEHOLDER}}` values in the target project's files after each topic, not all at the end. This keeps progress safe if the session ends.

| Topic | Ask about | Writes to |
| --- | --- | --- |
| Product | Project name; one-sentence summary; what problem it solves and for whom; where it's deployed and how many units; what "working correctly" looks like. | `README.md`, `docs/product.md` |
| Notecard | Model family and exact SKU. | `docs/hardware.md` |
| Notecarrier | Model and version, or custom carrier. | `docs/hardware.md` |
| Host | Host MCU or SBC. Skip if the Notecarrier has a built-in host (e.g. Notecarrier CX). | `docs/hardware.md` |
| Components | Every sensor, actuator, display, battery, antenna, and enclosure, with part numbers and datasheet links. Offer to save datasheets to `docs/datasheets/`. | `docs/hardware.md` |
| Wiring | Notecard ↔ host interface (I2C default, or serial); ATTN/AUX pin usage; one row per component connection (pin → pin, bus, address, voltage). | `docs/hardware.md` |
| Power | Power source; `card.voltage` mode; sleep strategy; battery-life target. | `docs/hardware.md`, `docs/configuration.md` |
| Firmware | Platform and build tool (default: Arduino + Arduino CLI); board identifier (FQBN / PlatformIO env); what the firmware should do. | `firmware/README.md` |
| Notehub & data | Notehub project name and ProductUID (or "not created yet"); sync mode and cadence; Notefiles with fields, types, units, and normal ranges; what healthy and offline look like. | `docs/data.md`, `docs/configuration.md` |
| Configuration | Runtime settings that should be changeable from Notehub (env vars with defaults). Whether to use note templates (default: yes, for each outbound Notefile). | `docs/configuration.md` |
| Dashboard | Whether they want one now, later, or never; preferred framework (default: Next.js). | `dashboard/README.md` |

Tips:

- If Notehub MCP is available and the user already has a Notehub project, offer to read the ProductUID, existing Notefiles, and environment variables from Notehub instead of asking.
- If the user doesn't know their Notefiles yet, propose a design based on the components and product goals (e.g. one `.qo` for periodic readings) and confirm it with them.
- Suggest environment variables for any value they might want to tune after deployment, such as the sample interval.

When the interview is done, check off "Interview" in `SETUP.md`.

## Step 3: Finalize docs

1. Make sure `docs/*.md` and `README.md` agree with each other (Notefile names, ProductUID, env vars, voltage mode, sync settings).
2. Remove every template guidance comment (`<!-- ... -->`) from the generated Markdown files.
3. Search the project for `{{`. Any remaining placeholder should be replaced with `TBD`, and listed in `SETUP.md` under "Open questions."
4. Check off "Docs" in `SETUP.md` and offer to make the first git commit.

## Step 4: Check the MCP servers

Confirm that the Blues Expert and Notehub MCP tools are available.

- If they aren't, tell the user how to enable them: approve the servers in `.mcp.json` (Claude Code), `.cursor/mcp.json` (Cursor), or `.vscode/mcp.json` (VS Code), or for other tools add HTTP MCP servers named "Blues Expert" (`https://mcp.blues.io/expert/mcp`) and "Notehub MCP" (`https://mcp.notehub.io/mcp`). Usually they then need to restart the agent in the project folder and say "continue the project setup." Stop here until they do.
- Blues Expert is required for step 6. Notehub MCP is required for step 7 and helpful for steps 5 and 6.

## Step 5: Notehub project

The firmware needs a ProductUID, so the Notehub project comes first.

1. If the user doesn't have a Notehub project yet, ask them to create one at https://notehub.io (or create it with Notehub MCP if they ask you to).
2. Record the ProductUID in `docs/data.md` and `docs/configuration.md`.
3. If the user wants project-level values for the environment variables in `docs/configuration.md` now, set them with Notehub MCP (with their approval). Otherwise the firmware's defaults apply.
4. Check off "Notehub project" in `SETUP.md`.

## Step 6: Firmware

Ask whether to generate firmware now. If yes:

1. Call Blues Expert `firmware_entrypoint` and follow its guidance for the chosen platform.
2. Read `docs/hardware.md`, `docs/data.md`, and `docs/configuration.md`. Write firmware in `firmware/` that matches them exactly: same pins, Notefiles, field names, env vars, and defaults.
3. The firmware applies the Notecard configuration from `docs/configuration.md` at startup (`hub.set` with the ProductUID and sync settings, `card.voltage`, `note.template`, and so on), so that flashing the host is all it takes to set up a device. No Notecard CLI step is needed.
4. Validate every Notecard request with Blues Expert `api_validate`.
5. Build the firmware. Fix errors until it compiles. If the toolchain isn't installed, give the user install commands and ask before running them.
6. Update `firmware/README.md` with the real layout and build, flash, and monitor commands.
7. Ask whether the device is connected and whether to flash it. If yes, flash it and watch the serial output for Notecard errors.
8. Using Notehub MCP, confirm that the device appears in the project and that its events match `docs/data.md`. Fix any differences in the firmware or the docs.
9. Check off "Firmware" in `SETUP.md`.

## Step 7: Notehub IQ

Once the device has sent events:

1. With the user's approval, onboard the Notehub project with Notehub MCP.
2. Create datasets for each Notefile in `docs/data.md`, plus `_session.qo` and `_health.qo`. Follow Notehub MCP's dataset guidance first: dataset columns are permanent.
3. Try a first question with the user, e.g. "Are my devices behaving as described in docs/data.md?"
4. Check off "Notehub IQ" in `SETUP.md`.

## Step 8: Dashboard (optional)

If the user wants a dashboard now:

1. Build it in `dashboard/` with the chosen framework. Call the Notehub API from server-side code only, using the variables in `dashboard/.env.example`. Never expose the personal access token to the browser.
2. Use the Notefile names, fields, and units in `docs/data.md`.
3. Add new environment variables to `dashboard/.env.example` and the table in `dashboard/README.md`.
4. Update `dashboard/README.md` with how to run and deploy it.
5. Check off "Dashboard" in `SETUP.md` (or mark it skipped).

## Step 9: Finish

1. Make sure `README.md` is still short: name, description, and links. Details belong in `docs/`, `firmware/README.md`, and `dashboard/README.md`.
2. If "Open questions" in `SETUP.md` is empty and every step is checked or skipped, delete `SETUP.md`. Otherwise keep it and tell the user what's left.
3. Offer to commit.

## SETUP.md contents

```markdown
# Project setup

This project was generated from https://github.com/tjvantoll/ai-project-template.
Setup isn't finished yet. To continue, tell your AI agent: "continue the project setup."

Agents: follow https://github.com/tjvantoll/ai-project-template/blob/main/GENERATOR.md,
starting at the first unchecked step. Delete this file when setup is complete.

- [ ] Scaffold
- [ ] Interview
- [ ] Docs
- [ ] Notehub project
- [ ] Firmware
- [ ] Notehub IQ
- [ ] Dashboard

## Open questions

<!-- Placeholders still marked TBD, things to validate later, decisions deferred. -->
```

## File manifest

Files to fetch if `git` is unavailable (paths relative to the repository root):

```
GENERATOR.md
generator/options.md
template/README.md
template/AGENTS.md
template/.gitignore
template/.mcp.json
template/.cursor/mcp.json
template/.vscode/mcp.json
template/docs/product.md
template/docs/hardware.md
template/docs/data.md
template/docs/configuration.md
template/docs/datasheets/.gitkeep
template/firmware/README.md
template/dashboard/README.md
template/dashboard/.env.example
```
