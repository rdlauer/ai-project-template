# Data

<!-- Generator: fill from the "Notehub & data" and "Data routing" interview topics. This is the most important doc for Notehub IQ: without it, an LLM sees only field names and numbers, not what they mean. -->

## Notehub

- **Project:** {{NOTEHUB_PROJECT_NAME}}
- **ProductUID:** `{{PRODUCT_UID, e.g. com.your-company.your-name:your_product}}`
- **Sync:** `{{default: periodic}}` mode, outbound every {{default: 60}} min, inbound every {{default: 1440}} min

## Notefiles

| Notefile | Direction | Purpose | When it's written |
| --- | --- | --- | --- |
| `{{e.g. sensors.qo}}` | Device → cloud | {{PURPOSE}} | {{e.g. every 15 minutes}} |

<!-- Generator: one table per Notefile, copying the pattern below. If the device records a track, list _track.qo above. -->

### `{{e.g. sensors.qo}}`

| Field | Type | Units | Normal range | Description |
| --- | --- | --- | --- | --- |
| `{{FIELD}}` | {{number / int / bool / string}} | {{UNITS}} | {{RANGE}} | {{DESCRIPTION}} |

## Routes

Where Notehub sends events after they arrive. Credentials live in Notehub, never in this repository.

| Route | Destination | Notefiles | Purpose |
| --- | --- | --- | --- |
| {{ROUTE_NAME, or "None yet"}} | {{e.g. HTTPS endpoint, AWS Lambda, MQTT broker}} | {{e.g. sensors.qo}} | {{PURPOSE}} |

## Expected behavior

- **Healthy device:** {{e.g. "one sensors.qo note every 15 minutes; voltage above 3.6 V"}}
- **Offline:** {{e.g. "no events for 2 hours"}}
