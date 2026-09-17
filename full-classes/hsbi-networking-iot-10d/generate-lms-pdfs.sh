#!/usr/bin/env bash
# Generate dated, upload-ready LMS PDFs from the syllabus and pre-study guide.
# Preferred path: LibreOffice (creates PDF + editable ODT fallback).
# Fallbacks: Pandoc -> styled HTML -> headless Chromium, then Pandoc with XeLaTeX/pdfLaTeX.
# Usage: ./generate-lms-pdfs.sh [release-label]
#        ./generate-lms-pdfs.sh --engine chromium [release-label]
#        ./generate-lms-pdfs.sh --engine pandoc-latex [release-label]
#        ./generate-lms-pdfs.sh --engine soffice [release-label]
# Example: ./generate-lms-pdfs.sh 2026-27

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/lms-announcements"
STYLE_FILE="$SCRIPT_DIR/lms-pdf.css"
RELEASE_LABEL=""
ENGINE=""
BROWSER_BIN=""

for arg in "$@"; do
    case "$arg" in
        --engine)
            ENGINE="${2:-}"
            shift 2
            ;;
        --engine=*)
            ENGINE="${arg#--engine=}"
            shift
            ;;
        *)
            RELEASE_LABEL="$arg"
            shift
            ;;
    esac
done
RELEASE_LABEL="${RELEASE_LABEL:-$(date +%Y)}"

# Validate --engine value
if [[ -n "$ENGINE" ]]; then
    case "$ENGINE" in
        chromium|pandoc-latex|soffice) ;;
        *)
            echo "Error: invalid engine '$ENGINE'. Must be one of: chromium, pandoc-latex, soffice" >&2
            exit 2
            ;;
    esac
fi

for candidate in chromium chromium-browser google-chrome google-chrome-stable; do
    if command -v "$candidate" >/dev/null 2>&1; then
        BROWSER_BIN="$candidate"
        break
    fi
done

usage() {
    cat <<'EOF'
Usage: ./generate-lms-pdfs.sh [release-label]
       ./generate-lms-pdfs.sh --engine <engine> [release-label]

Generate dated, upload-ready PDFs for the syllabus and pre-study guide.

Engines (auto-selected by preference by default):
  soffice      LibreOffice (default) — creates PDF + untracked .odt fallback
  chromium     Pandoc -> styled HTML -> headless Chromium
  pandoc-latex Pandoc with XeLaTeX/pdfLaTeX

Options:
  --engine <name>   Hard-select a conversion engine (soffice, chromium, or pandoc-latex)
  -h, --help        Show this help message

Examples:
  ./generate-lms-pdfs.sh
  ./generate-lms-pdfs.sh 2026-27
  ./generate-lms-pdfs.sh --engine soffice 2026-27

Outputs are written to `lms-announcements/`, which is ignored by Git.
When using LibreOffice, an additional `.odt` file is generated alongside each
PDF. This ODT is untracked by Git and can be marginally edited as a fallback
if the PDF needs minor adjustments. The Markdown sources are never modified.

Each exported PDF receives temporary release metadata: label, generation date,
and source revision.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
fi

if [[ ! "$RELEASE_LABEL" =~ ^[A-Za-z0-9._-]+$ ]]; then
    echo "Error: release label may contain only letters, numbers, dots, underscores, and hyphens." >&2
    exit 2
fi

if [[ -z "$ENGINE" ]]; then
    ENGINE="auto"
fi

if ! command -v pandoc >/dev/null 2>&1 && ! command -v soffice >/dev/null 2>&1; then
    echo "Error: neither 'pandoc' nor LibreOffice's 'soffice' is available in PATH." >&2
    exit 127
fi

for source in "$SCRIPT_DIR/syllabus.md" "$SCRIPT_DIR/pre-study.md"; do
    if [[ ! -f "$source" ]]; then
        echo "Error: expected source file is missing: $source" >&2
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
STAGED_FILES=()
TEMP_DIRECTORIES=()

cleanup() {
    rm -f "${STAGED_FILES[@]}"
    rm -rf "${TEMP_DIRECTORIES[@]}"
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

    STAGED_FILES+=("$staged_html")
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
    local staged_basename="${staged_source##*/}"
    local base_name="${staged_basename%.md}"
    local staged_odt="$OUTPUT_DIR/${base_name}.odt"
    local staged_pdf="$OUTPUT_DIR/${base_name}.pdf"
    local final_pdf="$2"

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
    local output_name="hsbi-networking-iot-${RELEASE_LABEL}-${document_name}.pdf"
    local staged_source
    local final_pdf="$OUTPUT_DIR/$output_name"
    local pdf_engine

    staged_source="$(mktemp "$SCRIPT_DIR/lms-pdf-XXXXXX")"
    mv "$staged_source" "${staged_source}.md"
    staged_source+=".md"
    STAGED_FILES+=("$staged_source")
    stage_document "$source" "$staged_source"
    rm -f "$final_pdf"

    case "$ENGINE" in
        soffice)
            echo "Rendering $document_name with LibreOffice..."
            if convert_with_soffice "$staged_source" "$final_pdf" && [[ -s "$final_pdf" ]]; then
                echo "Created with LibreOffice: $final_pdf"
                return
            fi
            echo "Error: LibreOffice could not create $output_name." >&2
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
            echo "Error: Pandoc + $BROWSER_BIN could not create $output_name." >&2
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

            echo "Error: no available renderer could create $output_name." >&2
            echo "For Pandoc, install Chromium or a complete LaTeX installation (for example, xcolor.sty)." >&2
            exit 1
            ;;
    esac
}

render_pdf "$SCRIPT_DIR/syllabus.md" "syllabus"
render_pdf "$SCRIPT_DIR/pre-study.md" "pre-study-guide"

echo
printf 'Upload these files to your LMS from: %s\n' "$OUTPUT_DIR"
