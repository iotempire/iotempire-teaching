#!/usr/bin/env bash
# Unified LMS PDF generator for the IoTempire teaching repository.
#
# Renders a class's Markdown sources into dated, upload-ready PDFs inside that
# class's lms-announcements/ directory.
#
# Preferred engine: LibreOffice (soffice) — it also leaves an editable .odt
# fallback next to the PDF. Fallbacks, in order: Pandoc -> styled HTML ->
# headless Chromium, then Pandoc with XeLaTeX or pdfLaTeX.
#
# Usage:
#   tools/generate-lms-pdfs.sh --class-dir <dir> [options] [release-label]
#
# Required:
#   --class-dir <dir>   Class directory containing syllabus.md and pre-study.md
#
# Options:
#   --prefix <prefix>   Output filename prefix (default: "<class-dir-name>-", with any
#                       trailing duration suffix such as "-10d" removed)
#   --style <file>      CSS used by the Chromium engine
#                       (default: <class-dir>/lms-pdf.css, else tools/lms-pdf.css)
#   --engine <name>     Force an engine: soffice | chromium | pandoc-latex
#   -h, --help          Show this help
#
# Positional:
#   release-label       Optional label embedded in the output filenames
#                       (default: current year)
#
# Examples:
#   tools/generate-lms-pdfs.sh --class-dir full-classes/hsbi-sensors-actuators-10d 2026-27
#   full-classes/hsbi-sensors-actuators-10d/generate-lms-pdfs.sh 2026-27   # thin wrapper

set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$TOOLS_DIR/.." && pwd)"

# Documents rendered by default, as "<source-file>:<document-name>".
DOCUMENTS=(
    "syllabus.md:syllabus"
    "pre-study.md:pre-study-guide"
)

CLASS_DIR=""
PREFIX=""
STYLE_FILE=""
RELEASE_LABEL=""
ENGINE=""
BROWSER_BIN=""
HELP_REQUESTED=false

usage() {
    cat <<'EOF'
Usage: tools/generate-lms-pdfs.sh --class-dir <dir> [options] [release-label]

Render a class's syllabus.md and pre-study.md into dated PDFs.

Required:
  --class-dir <dir>   Class directory containing the Markdown sources

Options:
  --prefix <prefix>   Output filename prefix (default: "<class-dir-name>-", with any
                      trailing duration suffix such as "-10d" removed)
  --style <file>      CSS used by the Chromium engine
  --engine <name>     Force an engine: soffice, chromium, or pandoc-latex
  -h, --help          Show this help message

Engines (auto-selected by preference by default):
  soffice       LibreOffice (default) — creates PDF + editable .odt fallback
  chromium      Pandoc -> styled HTML -> headless Chromium
  pandoc-latex  Pandoc with XeLaTeX/pdfLaTeX

Examples:
  tools/generate-lms-pdfs.sh --class-dir full-classes/hsbi-sensors-actuators-10d
  tools/generate-lms-pdfs.sh --class-dir full-classes/hsbi-networking-iot-10d 2026-27
  tools/generate-lms-pdfs.sh --class-dir . --engine soffice 2026-27

Convenience wrappers live next to each class (for example
full-classes/hsbi-sensors-actuators-10d/generate-lms-pdfs.sh) and call this script
with the class directory and filename prefix already set.

Outputs are written to <class-dir>/lms-announcements/, which is ignored by Git.
With LibreOffice, an editable .odt is generated alongside each PDF. The Markdown
sources are never modified. Each PDF receives temporary release metadata: label,
generation date, and source revision.
EOF
}

# Detect help before consuming arguments, so that it works in any position.
for arg in "$@"; do
    case "$arg" in
        -h|--help) HELP_REQUESTED=true ;;
    esac
done

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            shift
            ;;
        --class-dir)
            CLASS_DIR="${2:-}"
            shift 2
            ;;
        --class-dir=*)
            CLASS_DIR="${1#--class-dir=}"
            shift
            ;;
        --prefix)
            PREFIX="${2:-}"
            shift 2
            ;;
        --prefix=*)
            PREFIX="${1#--prefix=}"
            shift
            ;;
        --style)
            STYLE_FILE="${2:-}"
            shift 2
            ;;
        --style=*)
            STYLE_FILE="${1#--style=}"
            shift
            ;;
        --engine)
            ENGINE="${2:-}"
            shift 2
            ;;
        --engine=*)
            ENGINE="${1#--engine=}"
            shift
            ;;
        --*)
            echo "Error: unknown option '$1'." >&2
            exit 2
            ;;
        *)
            RELEASE_LABEL="$1"
            shift
            ;;
    esac
done

if [[ "$HELP_REQUESTED" == true ]]; then
    usage
    exit 0
fi

if [[ -z "$CLASS_DIR" ]]; then
    echo "Error: --class-dir is required." >&2
    echo >&2
    usage >&2
    exit 2
fi

if [[ ! -d "$CLASS_DIR" ]]; then
    echo "Error: class directory not found: $CLASS_DIR" >&2
    exit 1
fi
CLASS_DIR="$(cd "$CLASS_DIR" && pwd)"
OUTPUT_DIR="$CLASS_DIR/lms-announcements"

if [[ -z "$PREFIX" ]]; then
    # Derive a clean default prefix from the class directory name, dropping a
    # trailing duration suffix such as "-10d", "-15d", or "-10weeks".
    derived_prefix="$(basename "$CLASS_DIR")"
    if [[ "$derived_prefix" =~ ^(.*)-([0-9]+)(d|days|w|weeks|h|hs)$ ]]; then
        derived_prefix="${BASH_REMATCH[1]}"
    fi
    PREFIX="${derived_prefix}-"
fi

RELEASE_LABEL="${RELEASE_LABEL:-$(date +%Y)}"
ENGINE="${ENGINE:-auto}"

case "$ENGINE" in
    auto|soffice|chromium|pandoc-latex) ;;
    *)
        echo "Error: invalid engine '$ENGINE'. Must be one of: soffice, chromium, pandoc-latex." >&2
        exit 2
        ;;
esac

if [[ -z "$STYLE_FILE" ]]; then
    if [[ -f "$CLASS_DIR/lms-pdf.css" ]]; then
        STYLE_FILE="$CLASS_DIR/lms-pdf.css"
    else
        STYLE_FILE="$TOOLS_DIR/lms-pdf.css"
    fi
fi

for candidate in chromium chromium-browser google-chrome google-chrome-stable; do
    if command -v "$candidate" >/dev/null 2>&1; then
        BROWSER_BIN="$candidate"
        break
    fi
done

if [[ ! "$RELEASE_LABEL" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
    echo "Error: release label may contain only letters, numbers, dots, underscores, and hyphens." >&2
    exit 2
fi

if ! command -v pandoc >/dev/null 2>&1 && ! command -v soffice >/dev/null 2>&1; then
    echo "Error: neither 'pandoc' nor LibreOffice's 'soffice' is available in PATH." >&2
    exit 127
fi

for document in "${DOCUMENTS[@]}"; do
    source_file="$CLASS_DIR/${document%%:*}"
    if [[ ! -f "$source_file" ]]; then
        echo "Error: expected source file is missing: $source_file" >&2
        exit 1
    fi
done

if [[ -n "$BROWSER_BIN" && ! -f "$STYLE_FILE" ]]; then
    echo "Error: expected stylesheet is missing: $STYLE_FILE" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

SOURCE_REVISION="$(git -C "$REPO_DIR" rev-parse --short HEAD 2>/dev/null || printf 'not-a-git-checkout')"
if ! git -C "$REPO_DIR" diff --quiet 2>/dev/null; then
    SOURCE_REVISION+=" + local changes"
fi

GENERATED_ON="$(date +%F)"
STAGE_DIR="$(mktemp -d)"
TEMP_DIRECTORIES=()

cleanup() {
    rm -rf "$STAGE_DIR" "${TEMP_DIRECTORIES[@]:-}"
}
trap cleanup EXIT

stage_document() {
    local source="$1"
    local staged_source="$2"
    local first_line

    IFS= read -r first_line < "$source"

    {
        printf '%s\n\n' "$first_line"
        printf '> **LMS release:** %s  \n' "$RELEASE_LABEL"
        printf '> **Generated:** %s  \n' "$GENERATED_ON"
        printf '> **Source revision:** `%s`\n\n' "$SOURCE_REVISION"
        tail -n +2 "$source"
    } | sed \
        -e 's/^> \[!NOTE\]/> **Note**/' \
        -e 's/^> \[!IMPORTANT\]/> **Important**/' \
        -e 's/^> \[!TIP\]/> **Tip**/' \
        -e 's/^> \[!WARNING\]/> **Warning**/' \
        -e 's/^> \[!CAUTION\]/> **Caution**/' \
        > "$staged_source"
}

convert_with_chromium() {
    local staged_source="$1"
    local final_pdf="$2"
    local staged_html="${staged_source%.md}.html"
    local browser_profile

    browser_profile="$(mktemp -d)"
    TEMP_DIRECTORIES+=("$browser_profile")

    pandoc \
        --from=gfm \
        --to=html5 \
        --standalone \
        --embed-resources \
        --css="$STYLE_FILE" \
        --output "$staged_html" \
        "$staged_source" && \
    "$BROWSER_BIN" \
        --headless \
        --disable-gpu \
        --no-first-run \
        --no-default-browser-check \
        --user-data-dir="$browser_profile" \
        --print-to-pdf="$final_pdf" \
        --print-to-pdf-no-header \
        "file://$staged_html"
}

convert_with_pandoc_latex() {
    local staged_source="$1"
    local final_pdf="$2"
    local pdf_engine="$3"

    pandoc \
        --from=gfm \
        --to=pdf \
        --pdf-engine="$pdf_engine" \
        --pdf-engine-opt=-interaction=nonstopmode \
        --pdf-engine-opt=-halt-on-error \
        --output "$final_pdf" \
        "$staged_source"
}

convert_with_soffice() {
    local staged_source="$1"
    local final_pdf="$2"
    local staged_basename="${staged_source##*/}"
    local base_name="${staged_basename%.md}"
    local staged_odt="$OUTPUT_DIR/${base_name}.odt"
    local staged_pdf="$OUTPUT_DIR/${base_name}.pdf"

    rm -f "$staged_odt" "$staged_pdf" "$final_pdf"

    # First convert to ODT (editable fallback)
    soffice --headless \
        --convert-to odt \
        --outdir "$OUTPUT_DIR" \
        "$staged_source"

    if [[ ! -f "$staged_odt" ]]; then
        return 1
    fi

    # Then convert the ODT to PDF
    soffice --headless \
        --convert-to pdf \
        --outdir "$OUTPUT_DIR" \
        "$staged_odt"

    if [[ ! -f "$staged_pdf" ]]; then
        return 1
    fi

    mv "$staged_pdf" "$final_pdf"
    # ODT is intentionally kept (untracked) as a marginal-edit fallback
}

render_pdf() {
    local source="$1"
    local document_name="$2"
    local base_name="${PREFIX}${RELEASE_LABEL}-${document_name}"
    local staged_source="$STAGE_DIR/${base_name}.md"
    local final_pdf="$OUTPUT_DIR/${base_name}.pdf"
    local pdf_engine

    stage_document "$source" "$staged_source"
    rm -f "$final_pdf"

    case "$ENGINE" in
        soffice)
            echo "Rendering $document_name with LibreOffice..."
            if convert_with_soffice "$staged_source" "$final_pdf" && [[ -s "$final_pdf" ]]; then
                echo "Created with LibreOffice: $final_pdf"
                return
            fi
            echo "Error: LibreOffice could not create ${base_name}.pdf." >&2
            exit 1
            ;;

        chromium)
            if ! command -v pandoc >/dev/null 2>&1 || [[ -z "$BROWSER_BIN" ]]; then
                echo "Error: engine 'chromium' requested but Pandoc or a Chromium browser is not available." >&2
                exit 1
            fi
            echo "Rendering $document_name with Pandoc and $BROWSER_BIN..."
            if convert_with_chromium "$staged_source" "$final_pdf" && [[ -s "$final_pdf" ]]; then
                echo "Created with Pandoc + $BROWSER_BIN: $final_pdf"
                return
            fi
            rm -f "$final_pdf"
            echo "Error: Pandoc + $BROWSER_BIN could not create ${base_name}.pdf." >&2
            exit 1
            ;;

        pandoc-latex)
            if ! command -v pandoc >/dev/null 2>&1; then
                echo "Error: engine 'pandoc-latex' requested but Pandoc is not available." >&2
                exit 1
            fi
            for pdf_engine in xelatex pdflatex; do
                if ! command -v "$pdf_engine" >/dev/null 2>&1; then
                    continue
                fi
                echo "Rendering $document_name with Pandoc and $pdf_engine..."
                if convert_with_pandoc_latex "$staged_source" "$final_pdf" "$pdf_engine" && [[ -s "$final_pdf" ]]; then
                    echo "Created with Pandoc ($pdf_engine): $final_pdf"
                    return
                fi
                rm -f "$final_pdf"
            done
            echo "Error: no LaTeX engine available for pandoc-latex engine." >&2
            exit 1
            ;;

        auto)
            # Auto-select: try LibreOffice first, then Chromium, then LaTeX
            if command -v soffice >/dev/null 2>&1; then
                echo "Rendering $document_name with LibreOffice..."
                if convert_with_soffice "$staged_source" "$final_pdf" && [[ -s "$final_pdf" ]]; then
                    echo "Created with LibreOffice: $final_pdf"
                    return
                fi
                rm -f "$final_pdf"
                echo "LibreOffice could not create a PDF; trying Pandoc + Chromium." >&2
            fi

            if command -v pandoc >/dev/null 2>&1 && [[ -n "$BROWSER_BIN" ]]; then
                echo "Rendering $document_name with Pandoc and $BROWSER_BIN..."
                if convert_with_chromium "$staged_source" "$final_pdf" && [[ -s "$final_pdf" ]]; then
                    echo "Created with Pandoc + $BROWSER_BIN: $final_pdf"
                    return
                fi
                rm -f "$final_pdf"
                echo "Pandoc + $BROWSER_BIN could not create a PDF; trying LaTeX." >&2
            fi

            if command -v pandoc >/dev/null 2>&1; then
                for pdf_engine in xelatex pdflatex; do
                    if ! command -v "$pdf_engine" >/dev/null 2>&1; then
                        continue
                    fi
                    echo "Rendering $document_name with Pandoc and $pdf_engine..."
                    if convert_with_pandoc_latex "$staged_source" "$final_pdf" "$pdf_engine" && [[ -s "$final_pdf" ]]; then
                        echo "Created with Pandoc ($pdf_engine): $final_pdf"
                        return
                    fi
                    rm -f "$final_pdf"
                done
            fi

            echo "Error: no available renderer could create ${base_name}.pdf." >&2
            echo "For Pandoc, install Chromium or a complete LaTeX installation (for example, xcolor.sty)." >&2
            exit 1
            ;;
    esac
}

for document in "${DOCUMENTS[@]}"; do
    render_pdf "$CLASS_DIR/${document%%:*}" "${document##*:}"
done

echo
printf 'Upload these files to your LMS from: %s\n' "$OUTPUT_DIR"
