# Firmware

<!-- Generator: fill from the "Firmware" interview topic. After generating firmware (step 5), replace the placeholders with the real layout and commands. -->

Host firmware for {{PROJECT_NAME}}.

- **Platform:** {{Arduino with note-arduino}}
- **Build tool:** {{Arduino CLI}}
- **Board:** {{e.g. Blues Swan}} (`{{FQBN or PlatformIO env, e.g. STMicroelectronics:stm32:Blues:pnum=SWAN_R5}}`)

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
