# AGENTS.md

This repository is a **project generator** for Blues IoT projects.

- **If the user wants to create a new project,** follow [`GENERATOR.md`](./GENERATOR.md). Create the project in a different folder from this repository unless the user says otherwise.
- **If the user is editing the generator:**
  - `GENERATOR.md` is the step-by-step script agents follow.
  - `generator/options.md` holds each interview topic's default and the docs page its choices come from.
  - Don't copy Blues facts into the generator or the template: product lists, SKUs, request arguments, modes, or which settings work together. Link the dev.blues.io page that owns the fact, and if the docs don't cover it, fix the docs. Copied facts go stale, and every project generated from the template keeps its own stale copy. What belongs here is what the docs don't do: the interview, the project layout, the setup steps, and the defaults.
  - `template/` holds the files copied into every new project. `<!-- Generator: ... -->` comments are guidance for the generating agent, which removes them. Placeholders follow the conventions in [Placeholders](./GENERATOR.md#placeholders).
  - Files in `template/` are instructions for *generated* projects, not for this repository.
  - Refer to generator steps by name (e.g. "the Firmware step"), not number, so that adding a step doesn't break references.
  - Projects resume setup from the generator commit they were created from (see `SETUP.md` in `GENERATOR.md`), so a change only reaches projects created after it.
  - To try a change end to end, see [`test/README.md`](./test/README.md).
