# Interview options

**Audience: AI agents running [`GENERATOR.md`](../GENERATOR.md).** These are the choices to offer during the interview. **Defaults** are marked. Always allow "Other" and "Not sure yet" (record "Not sure yet" as `TBD`).

When a user picks something, use Blues Expert `docs_search` to fill in details they shouldn't have to know, such as exact pinouts, compatible Notecards, or the default Notecard interface. The lists here aren't exhaustive. Check the Blues docs for current models.

## Notecard

| Family | Notes |
| --- | --- |
| Notecard Cell+WiFi | Cellular with WiFi fallback. SKUs like `NOTE-MBGLW`, `NOTE-MBNAW`, `NOTE-NBGLW`, `NOTE-NBNAW`. |
| Notecard Cellular | Cellular only. |
| Notecard WiFi | WiFi only. |
| Notecard for LoRa | Requires a LoRaWAN gateway. No GPS or web requests. |
| Notecard for Skylo | Cellular, satellite (NTN), and WiFi. |
| Starnote | Satellite add-on paired with another Notecard. |

Always ask for the exact SKU printed on the Notecard. SKU decoding: `WB`/`MB`/`NB` = band (Cat-1 / Cat-1 bis / LTE-M+NB-IoT); `GL`/`NA`/`EX` = region; trailing `W` = includes WiFi; `X` = includes satellite. Reference: https://dev.blues.io/notecard/notecard-product-family/

## Notecarrier

- Notecarrier A (AL / AE / AF)
- Notecarrier B
- Notecarrier F: Feather-compatible host socket; common for Swan, Cygnet, ESP32 Feathers
- Notecarrier CX: built-in STM32 host, so skip the host question
- Notecarrier X / XM / XS / XI / XP
- Notecarrier Pi Hat: for Raspberry Pi hosts
- Custom carrier / Notecard on the user's own PCB: ask for a schematic and save it to `docs/`

Record the board version (e.g. "Notecarrier F v1.5"). Pinouts differ between versions.

## Host MCU

- Blues Swan (STM32L4)
- Blues Cygnet (STM32L4)
- Notecarrier CX built-in host
- ESP32 (ask which board)
- Raspberry Pi or other Linux SBC (ask which model)
- Arduino-compatible board (ask which)
- Other

## Notecard ↔ host interface

- **I2C (default)**: address `0x17`
- Serial / UART: ask for the baud rate and which host UART

Also ask about the Notecard `ATTN` pin (often used to power or wake the host on a schedule) and `AUX` pins.

## Power

| Source | Suggested `card.voltage` mode |
| --- | --- |
| USB / always plugged in | `usb` |
| LiPo battery | `lipo` |
| Solar + LiPo | `lipo` |
| LiCap / outdoor lithium | `lic` |
| Energizer L91 lithium AA | `l91` |
| Alkaline | `alkaline` |
| Mains adapter | `default` (or omit) |

Confirm the mode with Blues Expert `api_docs` for `card.voltage`.

Sleep strategy options: **always on (default for USB)**; host sleeps and wakes on a timer; Notecard `ATTN` cuts host power between readings (`card.attn` sleep mode, common for battery devices).

## Firmware platform

| Platform | Library | Build tools |
| --- | --- | --- |
| **Arduino (default)** | [note-arduino](https://github.com/blues/note-arduino) | **Arduino CLI (default)**, Arduino IDE, PlatformIO |
| Zephyr | [note-zephyr](https://github.com/blues/note-zephyr) | west |
| ESP-IDF | [note-c](https://github.com/blues/note-c) | idf.py |
| STM32Cube / bare-metal C | [note-c](https://github.com/blues/note-c) | STM32CubeIDE, CMake |
| Python on Linux (e.g. Raspberry Pi) | [note-python](https://github.com/blues/note-python) | pip / venv |
| CircuitPython / MicroPython | [note-python](https://github.com/blues/note-python) | copy to device |

Ask for the board identifier the toolchain needs, such as the Arduino FQBN (e.g. `STMicroelectronics:stm32:Blues:pnum=SWAN_R5` for Swan) or the PlatformIO `board`. Look it up if the user doesn't know.

## Sync mode

- **`periodic` (default)**: outbound every 60 min, inbound every 1440 min (adjust to the product)
- `continuous`: always connected; higher power; for low-latency inbound commands
- `minimum`: sync only when the firmware explicitly calls `hub.sync`

## Dashboard

- **Next.js (default)**
- Other framework (ask)
- Later / never
