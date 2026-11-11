# Test persona

**Audience: an AI agent running [`GENERATOR.md`](../GENERATOR.md) as an automated test.** No user is present. Answer each interview question the way this user would, without waiting for input, and follow the rules below wherever the generator says to ask the user first.

## The user

- **Project:** Greenhouse Monitor. Reports temperature and humidity from a small hobby greenhouse so the owner can tell when it's too hot or too cold.
- **Deployment:** one prototype, indoors in the greenhouse, fixed in place.
- **Kit:** Blues Feather Kit for Cell+WiFi. The Notecard is labeled `NOTE-MBGLW`, and the Notecarrier is a Notecarrier F v1.5.
- **Components:** Adafruit BME280 breakout (Adafruit product 2652) on the Notecarrier's Qwiic port, I2C address `0x77`.
- **Firmware updates:** Notecard Outboard Firmware Update, since the Notecarrier F is pre-wired for it.
- **Power:** USB, always on. No battery-life target.
- **Location:** not needed.
- **Firmware:** Arduino with Arduino CLI, on the Cygnet. Read the sensor, add a note, wait for the next sample. Start at version 1.0.0.
- **Data:** one outbound Notefile, `greenhouse.qo`, with `temp` (°C, normally 5–35) and `humidity` (%, normally 30–90), written every 15 minutes. Default sync settings. Healthy means a note every 15 minutes; offline means no events for an hour.
- **Configuration:** a `sample_interval_min` environment variable, default 15. Use note templates.
- **Data routing:** none yet.
- **Dashboard:** later.
- **Notehub project:** not created yet.

## Steps that need hardware or accounts

- **Scaffold:** carry on without restarting.
- **Check the MCP servers:** Blues Expert is connected for this test; Notehub MCP isn't. Note that and carry on.
- **Notehub project:** skip. Leave the ProductUID as `TBD` and list it under Open questions.
- **Firmware:** generate the firmware and build it with `arduino-cli`. Don't flash it: no device is connected. Skip the Notehub check.
- **Notehub IQ** and **Dashboard:** mark them skipped.
- **Finish:** don't commit.
