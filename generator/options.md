# Interview options

**Audience: AI agents running [`GENERATOR.md`](../GENERATOR.md).** For each interview topic, the default to suggest and the Blues docs page to read before asking. Always allow "Other" and "Not sure yet" (record "Not sure yet" as `TBD`).

The docs are the source of truth for Blues products, what they support, and how Notecard requests behave, so take the choices you offer and their details from the linked pages, not from this file or from memory. Every link below is the page's Markdown version. If Blues Expert is connected, `docs_search` covers the same ground.

## Hardware

- If the user hasn't bought hardware yet, suggest a Blues kit. The [quickstarts](https://dev.blues.io/quickstart.md) cover each kit, and the [Blues Shop](https://shop.blues.com/) lists what's in it and what Blues currently sells.
- If they already have hardware, ask what's printed on each board, including the Notecard's SKU and the Notecarrier's version. Read its datasheet from the [datasheets](https://dev.blues.io/datasheets.md). If the datasheet says the product is no longer available for purchase, tell the user: it's still supported, but don't suggest it for new units.

| Topic | Default | Read |
| --- | --- | --- |
| Notecard | none | [Notecard Product Family](https://dev.blues.io/notecard/notecard-product-family.md), [Notecard datasheet](https://dev.blues.io/datasheets/notecard-datasheet.md) |
| Notecarrier | none | [Notecarrier datasheet](https://dev.blues.io/datasheets/notecarrier-datasheet.md) |
| Host and Notecard ↔ host interface | I2C | [Host Wiring Guide](https://dev.blues.io/guides-and-tutorials/host-wiring-guide.md) |
| Firmware updates | Notecard Outboard Firmware Update if the Notecarrier is pre-wired for it, otherwise none | [Host DFU Overview](https://dev.blues.io/notehub/host-firmware-updates/host-dfu-overview.md) |
| Power and sleep | `card.voltage` mode to match the power source; always on for USB power | [`card.voltage`](https://dev.blues.io/api-reference/notecard-api/card-requests/latest.md), [Low-Power Firmware Design](https://dev.blues.io/notecard/notecard-walkthrough/low-power-firmware-design.md) |
| Location | off | [Time & Location Requests](https://dev.blues.io/notecard/notecard-walkthrough/time-and-location-requests.md) |

## Firmware and data

| Topic | Default | Read |
| --- | --- | --- |
| Firmware platform | Arduino with note-arduino, built with Arduino CLI | [Firmware Libraries](https://dev.blues.io/tools-and-sdks/firmware-libraries.md); Blues Expert `firmware_entrypoint` |
| Sync mode | `periodic`: outbound every 60 min, inbound every 1440 min (adjust to the product) | [`hub.set`](https://dev.blues.io/api-reference/notecard-api/hub-requests/latest.md) |
| Data routing | none yet: data stays in Notehub | [Routing Data to Cloud](https://dev.blues.io/guides-and-tutorials/routing-data-to-cloud.md) |
| Environment variables | one for anything the user may want to tune after deployment | [Understanding Environment Variables](https://dev.blues.io/guides-and-tutorials/notecard-guides/understanding-environment-variables.md) |
| Dashboard | Next.js | [Notehub API](https://dev.blues.io/api-reference/notehub-api.md) |
