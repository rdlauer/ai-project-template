# Testing the generator

`test/run.sh` generates a complete project from this checkout, including uncommitted changes, without a user present. Claude Code plays the user from [`persona.md`](./persona.md): a Feather Kit greenhouse monitor that skips the Notehub, flashing, and dashboard steps. Then [`check.sh`](./check.sh) checks the result.

```sh
test/run.sh                  # generate into a new temp folder
test/run.sh /tmp/greenhouse  # or into a folder you choose
test/check.sh <project-dir>  # check any generated project
```

`check.sh` fails on:

- missing files, or unexpected files at the project root
- MCP config that doesn't define both Blues servers in the shape each client expects
- leftover `{{` placeholders or `<!-- Generator` comments
- a `SETUP.md` that doesn't link a generator to resume from: a raw URL pinned to a commit (checked over the network), or a local copy that exists
- Arduino firmware that doesn't build

With `--require-firmware`, which `run.sh` passes because the persona asks for firmware, it also fails when there's no sketch or no `arduino-cli` to build it.

`run.sh` saves the full transcript, every tool call and result, as JSON Lines in `<project-dir>.log`. [`check_api_validate.py`](./check_api_validate.py) then reads it and fails the run unless the agent called `api_validate` and the last attempt for each request (by its `req` or `cmd` name) passed. A rejected request that the agent later fixes is fine; one that errored or never got a result isn't. The agent's closing summary is in the last line: `tail -1 <project-dir>.log | jq -r .result`.

Requirements: [Claude Code](https://claude.com/claude-code) and, to build the firmware, `arduino-cli` with the STM32 core. A run takes several minutes and uses Claude Code with permission checks off, so the agent can install Arduino libraries without asking.
