# Hardware

<!-- Generator: fill from the Notecard, Notecarrier, Host, Components, Wiring, and Power interview topics. Link datasheets in docs/datasheets/ where available. -->

## Bill of materials

| Role | Part | Part number / SKU | Datasheet |
| --- | --- | --- | --- |
| Notecard | {{e.g. Notecard Cell+WiFi}} | `{{NOTE-XXXXX}}` | {{LINK}} |
| Notecarrier | {{e.g. Notecarrier F v1.5}} | {{PART_NUMBER}} | {{LINK}} |
| Host MCU | {{e.g. Blues Swan}} | {{PART_NUMBER}} | {{LINK}} |
| {{Sensor / actuator / display}} | {{NAME}} | {{PART_NUMBER}} | {{LINK}} |
| Battery | {{e.g. 3.7 V 2000 mAh LiPo}} | {{PART_NUMBER}} | {{LINK}} |
| Antenna | {{NAME}} | {{PART_NUMBER}} | {{LINK}} |
| Enclosure | {{NAME}} | {{PART_NUMBER}} | {{LINK}} |

## Wiring

### Notecard ↔ host

- **Interface:** {{I2C (address 0x17) / Serial at N baud on UARTx}}
- **ATTN:** {{unused / wired to host EN to power the host on a schedule / used as an interrupt}}
- **AUX pins:** {{unused / describe}}

### Peripherals

| Component | Component pin | Connects to | Bus | Notes |
| --- | --- | --- | --- | --- |
| {{COMPONENT}} | {{e.g. SDA}} | {{e.g. Host D14 via Qwiic}} | {{I2C / SPI / UART / GPIO / analog}} | {{e.g. address 0x62, 3.3 V}} |

<!-- Generator: if the user has a photo or diagram, save it to docs/ and link it here. -->

## Power

- **Source:** {{USB / LiPo / solar + LiPo / mains / ...}}
- **Notecard voltage mode:** `{{card.voltage mode}}` (applied by the firmware; see [configuration](./configuration.md))
- **Sleep strategy:** {{always on / host sleeps between readings / Notecard ATTN cuts host power}}
- **Battery-life target:** {{e.g. 6 months / N/A}}
