# Module 5 — Student Email Draft

> **Instructor-facing draft.** Copy the email below, replace the placeholders, and send it at least **two days before Day 5**. The student-facing module is [Module 5](../modules/05-leds-and-light-output.md); assessment rules stay in the [syllabus](../syllabus.md).

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## Email

```text
Subject: Module 5 prep — have "pio" and your AI assistant ready

Hi everyone,

Before Day 5, please install the PlatformIO CLI and sign in to your AI
assistant in your editor. Day 5 is as usual two 90-minute blocks, and we want
that time for building, not for installs.

1) PlatformIO CLI in your editor terminal

If PlatformIO is already installed and "pio --version" works in your
terminal, skip to 2). Otherwise install it once with uv:

    uv tool install --with pip platformio
    uv tool update-shell
    pio --version

- No uv yet? Install it first:
  https://docs.astral.sh/uv/getting-started/installation/
- "uv tool update-shell" adds the tool directory to your PATH, but only
  for new shells: restart the terminal, then check "pio --version". If it
  still fails, the tool is at ~/.local/bin/pio (Linux/macOS) or
  %USERPROFILE%\.local\bin\pio.exe (Windows).
- No serial port? Linux: add yourself to "dialout" (or "uucp") and
  install the PlatformIO udev rules. Windows: install the CP210x or
  CH340 driver. macOS: install the driver; if the port stays invisible,
  your user also needs the "admin" and "wheel" groups (exact commands
  are in the module). Verify that "pio device list" shows a connected
  board.

2) Your AI assistant, signed in and ready

Use whatever you already have (Claude, DeepSeek, ChatGPT, Copilot) in
Zed or VS Code. If you want Copilot with education credits:
https://education.github.com/
Terminal people can use opencode: https://opencode.ai/ .

What we build: one LED, then an RGB LED, then an 8-LED WS2812B strip,
described in the module:
https://github.com/iotempire/iotempire-teaching/blob/main/full-classes/hsbi-sensors-actuators-10d/modules/05-leds-and-light-output.md

If an install fights you, let us know on Discord in advance.

See you on Day 5,
[Instructor names]
```

## Sending notes

- **At least two days before Day 5**; replace `[Instructor names]` and add date or room if the LMS needs it.
- **Do not paste the reference.** The full commands, editor snippets, and serial-port fixes stay in the [resource bank](../modules/Z-resources-bank.md#platformio-cli--zedvscode-setup); the module link is enough for the content.
- **No vendor lock-in.** Claude, DeepSeek, ChatGPT, Copilot, or `opencode` is fine; GitHub Education is optional. Check the board ID once: `pio project init --board mhetesp32minikit`.
- **If the lab network blocks installs**, ask for a hotspot or prepare the lab laptops with `uv`/`pio` and the ESP32 platform cached; keep one known-good `task2-rgb` project and one pre-flashed board.
- **Reminder to self:** check before every module whether a prep email is needed; Module 4 (materials) and Module 5 (toolchain, AI access) need one.

## If a student gets stuck

| Symptom | What to tell them |
|---|---|
| `uv: command not found` | Install `uv` from the link above, then reopen the terminal. |
| `pio: command not found` after install | Run `uv tool update-shell`, restart the terminal, or call the full path: `~/.local/bin/pio` (Linux/macOS) or `%USERPROFILE%\.local\bin\pio.exe` (Windows). |
| `pio device list` is empty | Linux: `dialout`/`uucp` + udev rules; Windows: CP210x/CH340 driver; macOS: driver + `admin`/`wheel` groups (resource bank); try another USB cable. |
| PlatformIO wants a second core in VS Code | Set `"platformio-ide.useBuiltinPIOCore": false`. |

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)
