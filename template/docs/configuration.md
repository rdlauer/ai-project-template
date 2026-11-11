# Configuration

How the device is configured. Every device setting must be documented here. (Dashboard settings are documented in [`dashboard/README.md`](../dashboard/README.md).)

## 1. Notecard configuration (applied by the firmware)

The firmware sends these settings to the Notecard at startup, so flashing the host is all it takes to set up a device. Change them here and in the firmware together.

<!-- Generator: fill from the Power, Notehub & data, and Configuration interview topics. -->

| Setting | Value | Notecard request |
| --- | --- | --- |
| ProductUID | `{{com.your-company.your-name:your_product}}` | `hub.set` `product` |
| Sync mode | `{{periodic}}` | `hub.set` `mode` |
| Outbound interval | {{60}} min | `hub.set` `outbound` |
| Inbound interval | {{1440}} min | `hub.set` `inbound` |
| Voltage mode | `{{lipo}}` | `card.voltage` `mode` |
| Note templates | {{e.g. "sensors.qo"}} | `note.template` |

## 2. Notehub environment variables

Runtime settings that the firmware reads with [`env.get`](https://dev.blues.io/api-reference/notecard-api/env-requests/latest/#env-get). Change them in Notehub at the project, fleet, or device level without reflashing. Device values override fleet values, which override project values. The firmware falls back to the defaults below when a variable isn't set. See [Understanding Environment Variables](https://dev.blues.io/guides-and-tutorials/notecard-guides/understanding-environment-variables/).

<!-- Generator: suggest a variable for anything the user may want to tune after deployment. -->

| Variable | Default | Units | Set at | Description |
| --- | --- | --- | --- | --- |
| `{{sample_interval_min}}` | `{{15}}` | {{minutes}} | {{project}} | {{How often the host takes a reading.}} |
