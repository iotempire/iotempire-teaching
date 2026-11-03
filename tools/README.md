# Repository Tools

Shared helper scripts for maintaining the teaching material.

## `generate-lms-pdfs.sh` — LMS exports

Renders a class's `syllabus.md` and `pre-study.md` into dated, upload-ready PDFs
inside that class's `lms-announcements/` directory (which is gitignored).

**Preferred engine: LibreOffice**, because it also leaves an editable `.odt`
next to each PDF. If LibreOffice is unavailable, the script falls back to
Pandoc → styled HTML → headless Chromium, then to Pandoc with XeLaTeX/pdfLaTeX.

Engine notes:

- **Chromium** prints with the browser header/footer suppressed (no date/title
  banner and no `file://…` URL), using the class stylesheet.
- **Pandoc + LaTeX** uses a tuned serif article layout (11 pt, 2.4 cm margins,
  1.15 line spacing, colored links) so announcements do not look sparse. When
  `DejaVu Serif` is installed it is pinned as the main font (XeLaTeX/LuaLaTeX
  only), which also covers glyphs like `≈` that Latin Modern lacks.

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

## `collect-portfolios.sh` — student repositories

Instructor helper for the “create from template + invite” workflow. Students
create their portfolio in *one click* and invite you; this script accepts the
invitations in bulk and clones the repositories for review. It never writes to a
student repository.

```sh
bash tools/collect-portfolios.sh invitations          # who invited you, and what is still pending
bash tools/collect-portfolios.sh accept               # accept every pending invitation
bash tools/collect-portfolios.sh list                 # repos named net-iot-hsbi-20YY-portfolio
bash tools/collect-portfolios.sh clone --dir ~/review  # clone them next to each other
```

| Flag | Meaning |
|---|---|
| `--pattern RE` | Repository-**name** regex (the part after the owner). Default `^net-iot-hsbi-20[0-9]{2}-portfolio$`. |
| `--dir DIR` | Target directory for `clone`. Default: the current directory. |
| `--depth N` | Shallow clone depth (faster for large cohorts). Default: full history. |
| `--dry-run` | Show what would happen (`accept`, `clone`). |

Clones are written to `DIR/<owner>__<repo>` (e.g. `alice__net-iot-hsbi-2026-portfolio`), because every student's repository carries the same name.

Requires an authenticated `gh` (`gh auth login`) and `git`. Notes:

- `gh repo invite` does **not** exist, and `gh repo list` cannot list
  collaborator repositories — the script uses `gh api` for both directions.
- Accepting an invitation requires that the student granted you access; a public
  repository that was never shared will not appear at all. Students who never
  invite are a *missing submission* problem, not a tooling problem.
- Invitations can expire. Run `invitations` before the first checkpoint, not on
  the last day.

## `lms-pdf.css`

Shared default stylesheet for the Chromium rendering path. Identical copies
still live in each class folder for historical reasons; a class-local
`lms-pdf.css` takes precedence, so an individual class can diverge if needed.
