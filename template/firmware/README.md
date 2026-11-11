# Firmware

<!-- Generator: fill from the "Firmware" interview topic. After the Firmware step generates firmware, replace the placeholders with the real layout and commands. -->

Host firmware for {{PROJECT_NAME}}.

- **Platform:** {{default: Arduino with note-arduino}}
- **Build tool:** {{default: Arduino CLI}}
- **Board:** {{e.g. Blues Cygnet}} (`{{FQBN or PlatformIO env, e.g. STMicroelectronics:stm32:Blues:pnum=CYGNET}}`)
- **Version:** {{default: 1.0.0}}, reported to Notehub on every boot. Bump it with every release.
- **Field updates:** {{Notecard Outboard Firmware Update / IAP / none}} (see [hardware](../docs/hardware.md#host-firmware-updates))

## What it does

{{Short description of the main loop, e.g. "On boot, apply hub.set and read env vars. Every sample_interval_min, read the sensor, add a note to sensors.qo, and sleep."}}

## Build, flash, and monitor

```sh
{{BUILD_COMMAND}}
{{FLASH_COMMAND}}
{{SERIAL_MONITOR_COMMAND}}
```

## Layout

```
{{FILE_TREE}}
```
