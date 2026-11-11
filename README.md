# Blues AI Project Template

A starting point for building [Blues](https://blues.com) IoT projects.

Humans: Tell your agents to:

> Create a new Blues IoT project in this folder using the template at https://github.com/tjvantoll/ai-project-template.

Agents: Follow the steps in [`GENERATOR.md`](./GENERATOR.md).

## What the agent does

1. **Scaffold:** copies [`template/`](./template/) into your folder and adds MCP config for Blues Expert and Notehub MCP.
2. **Interview:** asks about your product, then your hardware (if you have a Blues kit, that covers most of it): Notecard, Notecarrier, host MCU, components, firmware updates, wiring, power, and location. Then your firmware platform, Notefiles, data routing, and configuration. Where it can, it looks up answers in the Blues docs instead of asking you.
3. **Document:** writes your answers into `docs/`.
4. **Notehub project:** helps you create or pick the Notehub project the device will report to, and set up routes.
5. **Firmware:** generates host firmware in `firmware/` using Blues Expert, builds it, and flashes it. The firmware configures the Notecard itself, so no extra setup tools are needed.
6. **Notehub IQ:** onboards your project with Notehub MCP and creates datasets so you can ask questions about your device data.
7. **Dashboard (optional):** generates a web dashboard in `dashboard/`.

## What you get

```plaintext
my-project/
├── README.md            # name, short description, links
├── AGENTS.md            # instructions for AI agents
├── .mcp.json            # Blues Expert + Notehub MCP (also .cursor/ and .vscode/)
├── docs/
│   ├── product.md       # what it does, who it's for, expected behavior
│   ├── hardware.md      # Notecard, Notecarrier, host, components, wiring, power
│   ├── data.md          # Notehub project, Notefiles, fields, expected behavior
│   └── configuration.md # Notecard settings, Notehub env vars
├── firmware/            # host firmware
└── dashboard/           # web dashboard (+ .env.example for its secrets)
```

## Requirements

- An AI coding agent that supports MCP servers.
- Blues hardware: a Notecard, a Notecarrier (or custom carrier), and a host MCU.
- A [Notehub](https://notehub.io) account.

## License

[MIT](./LICENSE)
