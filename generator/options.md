# Interview options

**Audience: AI agents running [`GENERATOR.md`](../GENERATOR.md).** These are the choices to offer during the interview. **Defaults** are marked. Always allow "Other" and "Not sure yet" (record "Not sure yet" as `TBD`).

When a user picks something, look up the details they shouldn't have to know, such as exact pinouts, compatible Notecards, or the default Notecard interface. See [Looking things up](../GENERATOR.md#looking-things-up).

These lists include only products Blues currently sells. A user may own older hardware that Blues still supports. Accept it as "Other" and work from its datasheet at https://dev.blues.io/datasheets/.

## Blues kits

Ask about kits first. A kit answers the Notecard, Notecarrier, and host questions, so confirm the kit and move on to the topics it doesn't cover.

| Kit | Notecard | Notecarrier | Host |
| --- | --- | --- | --- |
| Blues Solution Kit for Cell+WiFi | Notecard Cell+WiFi (`NOTE-MBGLW`) | Notecarrier CX | Built into Notecarrier CX |
| Blues Feather Kit for Cell+WiFi | Notecard Cell+WiFi (`NOTE-MBGLW`) | Notecarrier F | Blues Cygnet |
| Blues Starter Kit for Cell+WiFi | Notecard Cell+WiFi (`NOTE-MBGLW`) | Notecarrier X | Bring your own (ask which). It connects over Qwiic, or over jumper wires once headers are soldered on. |

Each kit also includes a flexible dual cellular and GPS antenna. Kit contents can change, so still confirm the SKU printed on the Notecard. For any other kit, look up its contents.

## Notecard

| Family | SKUs | Notes |
| --- | --- | --- |
| Notecard Cell+WiFi | `NOTE-MBGLW`, `NOTE-MBNAW`, `NOTE-WBGLWT`, `NOTE-WBNAW`, `NOTE-WBNAWT`, `NOTE-WBEXW`, `NOTE-WBEXWT` | Cellular and WiFi. |
| Notecard Cellular | `NOTE-MBGLN`, `NOTE-MBNAN`, `NOTE-WBNAN`, `NOTE-WBEXN` | Cellular only. |
| Notecard for Skylo | `NOTE-NBGLWX` | Cellular (LTE-M / NB-IoT), Skylo satellite (NTN), and WiFi in one module. |
| Notecard for LoRa | | Requires a LoRaWAN gateway. No GPS (`fixed` location only) and no web requests. |
| Notecard XP | | Low-cost variant of the Notecard Cellular SKUs for volume orders. Needs Notecarrier XP to prototype. |
| Starnote for Skylo | | Satellite add-on that gives a Notecard NTN fallback. Prototype on Notecarrier XS. |
| Starnote for Iridium | | Satellite add-on that gives a Notecard Iridium fallback. Prototype on Notecarrier XI. |

Always ask for the exact SKU printed on the Notecard. Cellular SKUs read left to right as `NOTE-`, then band (`WB` = Cat-1, `MB` = Cat-1 bis, `NB` = LTE-M/NB-IoT), region (`GL` = global, `NA` = North America, `EX` = EMEA), WiFi (`W` = yes; `N` or nothing = no), modem (`T` = Telit), and satellite (`X`). For example, `NOTE-WBGLWT` is a global Cat-1 Notecard with WiFi and a Telit modem. Reference: https://dev.blues.io/notecard/notecard-product-family/#decoding-notecard-cellular-skus

## Notecarrier

- Notecarrier A: for battery-powered builds; onboard cellular/WiFi and GPS antennas, LiPo and solar connectors, Qwiic ports
- Notecarrier CX: built-in STM32L433 host (the same MCU as Cygnet), so skip the host question
- Notecarrier F: Feather socket for Swan, Cygnet, and other Feather hosts
- Notecarrier Pi: HAT for Raspberry Pi and compatible SBCs
- Notecarrier X: small; Qwiic and ESLOV ports to connect a host over I2C; LiPo charging
- Notecarrier XM: the most minimal Notecarrier (USB-C, no external SIM slot); a low-cost companion for Notecard for LoRa
- Notecarrier XS: for Notecard plus Starnote for Skylo
- Notecarrier XI: for Notecard plus Starnote for Iridium
- Notecarrier XP: required companion for Notecard XP
- Wireless for OPTA: adds Notecard to a Finder or Arduino Opta PLC (not a Notecarrier, but it fills the same role)
- Custom carrier / Notecard on the user's own PCB: ask for a schematic and save it to `docs/`

Record the board version printed on the silkscreen (e.g. "Notecarrier F v1.5"). Pinouts and Outboard Firmware Update wiring differ between versions.

## Host MCU

- Blues Swan (STM32L4R5)
- Blues Cygnet (STM32L433)
- Notecarrier CX built-in host (STM32L433)
- ESP32 (ask which board)
- Raspberry Pi or other Linux SBC (ask which model)
- Arduino Opta, with Wireless for OPTA
- Other Arduino-compatible board (ask which)
- Other

## Notecard ↔ host interface

- **I2C (default)**: address `0x17`
- Serial / UART: ask for the baud rate and which host UART

Also ask about the Notecard `ATTN` pin (often used to power or wake the host on a schedule) and `AUX` pins.

## Power

| Source | `card.voltage` mode |
| --- | --- |
| USB or mains adapter (always powered) | `default` (or omit) |
| LiPo battery | `lipo` |
| Solar + LiPo | `lipo` |
| Lithium-ion capacitor (LiC), e.g. Blues Scoop | `lic` |
| Tadiran HLC lithium battery | `tad` |
| Energizer L91 lithium AA | `l91` |
| Alkaline | `alkaline` |

Confirm the mode against the `card.voltage` docs. Notecard XP doesn't support voltage thresholds, so skip `card.voltage` there. To check a battery-life target against real hardware, Blues Mojo measures the device's current draw.

Sleep strategy options: **always on (default for USB)**; host sleeps and wakes on a timer; Notecard `ATTN` cuts host power between readings (`card.attn` sleep mode, common for battery devices).

## Location

| Need | `card.location.mode` | Notes |
| --- | --- | --- |
| **None (default)** | `off` | Notehub still estimates an approximate location from cell towers or WiFi. |
| Fixed installation | `fixed`, with `lat` and `lon` | The only mode on Notecard for LoRa. |
| Occasional position | `periodic` | Takes a GPS fix at an interval, only if the device has moved. |
| Live position | `continuous` | GPS stays on. High power. |

For a tracker, add `card.location.track` to record each fix in `_track.qo`. GPS needs a GPS antenna: the kits include one, and Notecarrier A has one onboard.

## Host firmware updates

| Option | How it works | Needs |
| --- | --- | --- |
| **Notecard Outboard Firmware Update (default when the carrier is pre-wired)** | The Notecard downloads host firmware from Notehub and flashes the host through its ROM bootloader, with no help from the host firmware. | An STM32 or ESP32 host. Notecarrier CX and Notecarrier F are pre-wired. On other boards, wire the Notecard's `ALT_DFU` (or `AUX`) pins to the host's `BOOT`, `RESET`, and UART pins. Enabled with `card.dfu`. |
| In-application programming (IAP) | The host firmware downloads the update from the Notecard with `dfu.get` and flashes itself. | Update code in the host firmware. No extra wiring. |
| None | Update over USB or a debugger only. | |

The `card.dfu` arguments depend on the carrier and its version (Notecarrier CX and Notecarrier F v1.5 use `"mode":"altdfu"`), so look them up. Reference: https://dev.blues.io/notehub/host-firmware-updates/notecard-outboard-firmware-update/

## Firmware platform

| Platform | Library | Build tools |
| --- | --- | --- |
| **Arduino (default)** | [note-arduino](https://github.com/blues/note-arduino) | **Arduino CLI (default)**, Arduino IDE, PlatformIO |
| Zephyr | [note-zephyr](https://github.com/blues/note-zephyr) | west |
| ESP-IDF | [note-espidf](https://github.com/blues/note-espidf) | idf.py |
| STM32Cube / bare-metal C | [note-c](https://github.com/blues/note-c) | STM32CubeIDE, CMake |
| Python on Linux (e.g. Raspberry Pi) | [note-python](https://github.com/blues/note-python) | pip / venv |
| CircuitPython / MicroPython | [note-python](https://github.com/blues/note-python) | copy to device |

Ask for the board identifier the toolchain needs, such as the Arduino FQBN or the PlatformIO `board`. Swan is `STMicroelectronics:stm32:Blues:pnum=SWAN_R5`; Cygnet and the Notecarrier CX host are `STMicroelectronics:stm32:Blues:pnum=CYGNET`. Look it up if the user doesn't know.

## Sync mode

- **`periodic` (default)**: outbound every 60 min, inbound every 1440 min (adjust to the product)
- `continuous`: always connected; higher power; for low-latency inbound commands
- `minimum`: sync only when the firmware explicitly calls `hub.sync`

## Data routing

Where events go after they reach Notehub. More than one is fine.

- **None yet (default)**: data stays in Notehub, where the dashboard and Notehub IQ read it
- General HTTP/HTTPS endpoint
- AWS (Lambda, SQS, IoT Analytics), Azure (Functions, Service Bus), or Google Cloud Functions
- MQTT broker
- Snowflake or an S3 archive
- Hosted dashboards: Datacake, Qubitro
- Alerts: Slack, Twilio

Reference: https://dev.blues.io/notehub/notehub-walkthrough/#routing-data-with-notehub

## Dashboard

- **Next.js (default)**
- Other framework (ask)
- Later / never
