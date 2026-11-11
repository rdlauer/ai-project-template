# AGENTS.md

This repository is a **project generator** for Blues IoT projects.

- **If the user wants to create a new project,** follow [`GENERATOR.md`](./GENERATOR.md). Create the project in a different folder from this repository unless the user says otherwise.
- **If the user is editing the generator:**
  - `GENERATOR.md` is the step-by-step script agents follow.
  - `generator/options.md` holds the interview choices and defaults.
  - `template/` holds the files copied into every new project. Placeholders use `{{LIKE_THIS}}`, and `<!-- Generator: ... -->` comments are guidance for the generating agent, which removes them.
  - Keep the [File manifest](./GENERATOR.md#file-manifest) in `GENERATOR.md` in sync with the files in `template/` and `generator/`.
  - Files in `template/` are instructions for *generated* projects, not for this repository.
