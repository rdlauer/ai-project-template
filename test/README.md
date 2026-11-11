# Testing the generator

`test/run.sh` generates a complete project from this checkout, including uncommitted changes, without a user present. Claude Code plays the user from [`persona.md`](./persona.md): a Feather Kit greenhouse monitor that skips the Notehub, flashing, and dashboard steps. Then [`check.sh`](./check.sh) checks the result.

```sh
test/run.sh                  # generate into a new temp folder
test/run.sh /tmp/greenhouse  # or into a folder you choose
test/check.sh <project-dir>  # check any generated project
```

`check.sh` fails on missing files, invalid MCP config, leftover `{{` placeholders or `<!-- Generator` comments, a `SETUP.md` that doesn't point back to the generator, and Arduino firmware that doesn't build. It doesn't call `api_validate`, so read the run's log (`<project-dir>.log`) to confirm the agent validated its Notecard requests.

Requirements: [Claude Code](https://claude.com/claude-code) and, to build the firmware, `arduino-cli` with the STM32 core. A run takes several minutes and uses Claude Code with permission checks off, so the agent can install Arduino libraries without asking.
