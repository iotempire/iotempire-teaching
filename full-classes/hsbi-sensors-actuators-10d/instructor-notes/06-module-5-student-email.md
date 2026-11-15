# Module 5 — Student Email Draft

> **Instructor-facing draft.** Copy the email below, replace the placeholders, and send it through the LMS at least **two days before Day 5**. The student-facing module is [Module 5](../modules/05-leds-and-light-output.md); the schedule and assessment rules stay in the [syllabus](../syllabus.md).

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## Email

```text
Subject: Module 5 prep — have "pio" and your AI assistant ready

Hi everyone,

Before Day 5 (LEDs) we have two 90-minute blocks, and we want the first
minutes for first light, not for installs. Please prepare two things on
your laptop before the session.

1) A working PlatformIO CLI in your editor terminal (about 10–15 minutes)

We use the "pio" command from the integrated terminal in Zed or VS Code,
not the PlatformIO IDE extension. Install it once with uv:

    uv tool install --with pip platformio
    uv tool update-shell
    pio --version

- No uv yet? Install it first:
  https://docs.astral.sh/uv/getting-started/installation/
- Already have a working "pio" on your PATH, or prefer another install?
  That is fine. The check is the same: open the integrated terminal in
  Zed or VS Code and run "pio --version" there.
- If you use the VS Code PlatformIO extension anyway, set
  "platformio-ide.useBuiltinPIOCore": false so it reuses the CLI instead
  of downloading a second Python environment.
- The board is the MH-ET LIVE ESP32 MiniKit (PlatformIO board
  "mhetesp32minikit"). You do not need to create the project yet; we do
  that together.
- No serial port? Linux: add yourself to "dialout" (or "uucp") and
  install the PlatformIO udev rules. Windows/macOS: install the CP210x or
  CH340 USB-to-UART driver. "pio device list" should show the board.

2) An AI assistant in your editor (GitHub Education is optional)

- If you already use Claude, DeepSeek, ChatGPT, Copilot, or another
  assistant, sign it in and have it ready in Zed or VS Code. If it is
  only a web page, bring it anyway; we will connect an editor agent or
  opencode. You do not need GitHub Education for this session.
- If you want Copilot with the education credits, apply for GitHub
  Education / the Student Developer Pack here:
  https://education.github.com/
  It is optional and can be added later.
- If your approval is still pending, use the assistant you already have;
  we will connect it in the editor during the session.
- If you live in the terminal: opencode (https://opencode.ai/) is a good
  command-line agent and a fine alternative. It is optional.

What we will do

Two sessions: Stage A is a discrete RGB LED (forward voltage, 220 ohm
resistors, PWM, a serial "R G B" REPL). Stage B is an 8-LED WS2812B strip
(NeoPixelBus, "index R G B" and "clear", the USB power budget). We scaffold
the project with an AI agent, verify it on the hardware, and commit a
shareable repo.

We provide the LEDs, strips, resistors, and boards. If you already have
your MiniKit, bring it; either way, bring your laptop, a USB cable, and
your GitHub account.

If an install fights you, come 10 minutes early or post in the Discord; we
will fix it together.

See you on Day 5,
[Instructor names]
```

## Sending notes

- Send this **at least two days before Day 5**; the first session opens with the install check.
  Replace `[Instructor names]` and add the date or room if your LMS needs it.
- The exact commands, the Zed/VS Code snippets, the serial-port fixes, and the scaffold prompt are
  in the [resource bank](../modules/Z-resources-bank.md#platformio-cli--zedvscode-setup). Do not
  paste the whole reference into the email.
- **Do not block on GitHub Education.** Claude, DeepSeek, ChatGPT, Copilot, or another assistant in
  the editor is enough. GitHub Education is an optional route to Copilot credits, not a requirement;
  the prompt → draft → verify → commit loop is the point, not a specific vendor.
- **If the lab network blocks installs**, ask students to bring a hotspot, or prepare the lab laptops
  with `uv`/`pio` and the ESP32 platform cached. Have one known-good `led-lab` project and one
  pre-flashed board.
- **Check the board ID once:** `pio project init --board mhetesp32minikit`. If the PlatformIO
  registry disagrees, fix the email and the module before sending.
- **opencode is optional.** It is a recommendation for command-line users, not a course
  requirement.
- **Reminder to self:** before every module, check whether a prep email is needed. Some modules need
  nothing; Module 4 (materials) and Module 5 (toolchain, GitHub Education, AI access) do. The TODO
  carries the general check.

## If a student gets stuck

| Symptom | What to tell them |
|---|---|
| `uv: command not found` | Install `uv` from the link above, then reopen the terminal. |
| `pio: command not found` after install | Run `uv tool update-shell`, restart the terminal, or call the full path (`~/.local/bin/pio`). |
| `pio device list` is empty | Linux: `dialout`/`uucp` + udev rules; Windows/macOS: CP210x/CH340 driver; try another USB cable. |
| Copilot/GitHub Education is still pending | Use Claude, DeepSeek, or another assistant; GitHub Education is optional. opencode is a CLI alternative. |
| No GitHub account yet | Create one; the Education application can follow after the session. |
| PlatformIO wants to download a second core in VS Code | Set `"platformio-ide.useBuiltinPIOCore": false`. |

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)
