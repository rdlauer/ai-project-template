# Data

<!-- Generator: fill from the "Notehub & data" interview topic. This is the most important doc for Notehub IQ: without it, an LLM sees only field names and numbers, not what they mean. -->

## Notehub

- **Project:** {{NOTEHUB_PROJECT_NAME}}
- **ProductUID:** `{{com.your-company.your-name:your_product}}`
- **Sync:** `{{periodic}}` mode, outbound every {{60}} min, inbound every {{1440}} min

## Notefiles

| Notefile | Direction | Purpose | When it's written |
| --- | --- | --- | --- |
| `{{sensors.qo}}` | Device → cloud | {{PURPOSE}} | {{e.g. every 15 minutes}} |

<!-- Generator: one table per Notefile, copying the pattern below. -->

### `{{sensors.qo}}`

| Field | Type | Units | Normal range | Description |
| --- | --- | --- | --- | --- |
| `{{field}}` | {{number / int / bool / string}} | {{UNITS}} | {{RANGE}} | {{DESCRIPTION}} |

## Expected behavior

- **Healthy device:** {{e.g. "one sensors.qo note every 15 minutes; voltage above 3.6 V"}}
- **Offline:** {{e.g. "no events for 2 hours"}}
