# Repository Tools

Shared helper scripts for maintaining the teaching material.

## `generate-lms-pdfs.sh` — LMS exports

Renders a class's `syllabus.md` and `pre-study.md` into dated, upload-ready PDFs
inside that class's `lms-announcements/` directory (which is gitignored).

**Preferred engine: LibreOffice**, because it also leaves an editable `.odt`
next to each PDF. If LibreOffice is unavailable, the script falls back to
Pandoc → styled HTML → headless Chromium, then to Pandoc with XeLaTeX/pdfLaTeX.

### From a class folder (recommended)

Each class ships a thin wrapper with the class directory and filename prefix
preset, so the per-class command is unchanged:

```sh
cd full-classes/hsbi-sensors-actuators-10d
./generate-lms-pdfs.sh 2026-27
```

### Directly, for any class

```sh
tools/generate-lms-pdfs.sh --class-dir full-classes/hsbi-networking-iot-10d 2026-27
```

### Options

| Option | Meaning |
|---|---|
| `--class-dir <dir>` | **Required.** Directory containing `syllabus.md` and `pre-study.md`. |
| `--prefix <prefix>` | Output filename prefix. Default: class folder name minus a trailing duration suffix (e.g. `hsbi-sensors-actuators-`). |
| `--style <css>` | Stylesheet for the Chromium engine. Default: the class's own `lms-pdf.css` if present, otherwise `tools/lms-pdf.css`. |
| `--engine <name>` | Force `soffice`, `chromium`, or `pandoc-latex`. Default: auto (LibreOffice first). |
| `-h`, `--help` | Show usage. |
| `<release-label>` | Positional. Embedded in the filenames; defaults to the current year. |

Example output: `hsbi-sensors-actuators-2026-27-syllabus.pdf` and
`hsbi-sensors-actuators-2026-27-pre-study-guide.pdf`. Each PDF carries temporary
release metadata (label, generation date, source revision). The Markdown sources
are never modified.

### Adding a new class

The class needs `syllabus.md` and `pre-study.md`, and each of its files should
start with a level-1 title. Then either call the tool directly (see above) or add
a wrapper next to the class, mirroring an existing one:

```bash
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/../../tools/generate-lms-pdfs.sh" \
    --class-dir "$SCRIPT_DIR" --prefix "my-class-" "$@"
```

Finally, add `/<class-dir>/lms-announcements/` to the repository `.gitignore`.

## `lms-pdf.css`

Shared default stylesheet for the Chromium rendering path. Identical copies
still live in each class folder for historical reasons; a class-local
`lms-pdf.css` takes precedence, so an individual class can diverge if needed.
