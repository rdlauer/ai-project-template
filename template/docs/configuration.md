# Configuration

How the device is configured. Every device setting must be documented here. (Dashboard settings are documented in [`dashboard/README.md`](../dashboard/README.md).)

## 1. Notecard configuration (applied by the firmware)

The firmware sends these settings to the Notecard at startup, so flashing the host is all it takes to set up a device. Change them here and in the firmware together.

<!-- Generator: fill from the Power, Location, Firmware updates, Notehub & data, and Configuration interview topics. Remove rows that don't apply, such as card.dfu when the device doesn't use Outboard Firmware Update. -->

| Setting | Value | Notecard request |
| --- | --- | --- |
| ProductUID | `{{PRODUCT_UID, e.g. com.your-company.your-name:your_product}}` | `hub.set` `product` |
| Sync mode | `{{default: periodic}}` | `hub.set` `mode` |
| Outbound interval | {{default: 60}} min | `hub.set` `outbound` |
| Inbound interval | {{default: 1440}} min | `hub.set` `inbound` |
| Voltage mode | `{{e.g. lipo}}` | `card.voltage` `mode` |
| Location mode | `{{default: off}}` | `card.location.mode` `mode` |
| Location tracking | {{off / on, writing _track.qo (requires periodic location mode)}} | `card.location.track` |
| Note templates | {{e.g. "sensors.qo"}} | `note.template` |
| Outboard Firmware Update | {{e.g. "stm32", mode altdfu}} | `card.dfu` |
| Host firmware version | Reported on every boot from the version in the firmware source | `hub.set` `version` |

## 2. Notehub environment variables

Runtime settings that the firmware reads with [`env.get`](https://dev.blues.io/api-reference/notecard-api/env-requests/latest/#env-get). Change them in Notehub at the project, fleet, or device level without reflashing. Device values override fleet values, which override project values. The firmware falls back to the defaults below when a variable isn't set. See [Understanding Environment Variables](https://dev.blues.io/guides-and-tutorials/notecard-guides/understanding-environment-variables/).

<!-- Generator: suggest a variable for anything the user may want to tune after deployment. -->

| Variable | Default | Units | Set at | Description |
| --- | --- | --- | --- | --- |
| `{{e.g. sample_interval_min}}` | `{{e.g. 15}}` | {{e.g. minutes}} | {{project / fleet / device}} | {{e.g. How often the host takes a reading.}} |
