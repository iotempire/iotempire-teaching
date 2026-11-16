#!/usr/bin/env bash
# Verify that rendered slide decks match their Markdown sources.
#
# For every full-classes/*/slides/*.md the script counts the `---`
# separators (one page per separator plus the first slide). When a sibling
# PDF exists it compares that count with pdfinfo's page count. A stale PDF
# is a warning; a page-count mismatch is a failure.
#
#   ./tools/check-slides.sh
#
# Exit status: 0 when clean, 1 on a page-count mismatch.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
status=0
decks=0

shopt -s nullglob
for md in "$REPO_DIR"/full-classes/*/slides/*.md; do
    decks=$((decks + 1))
    base="${md%.md}"
    separators=$(grep -c '^---$' "$md" || true)
    expected=$((separators + 1))
    relative="${md#"$REPO_DIR"/}"

    if [ ! -f "$base.pdf" ]; then
        printf 'skip   %s: no PDF yet (%s separators -> %s pages)\n' \
            "$relative" "$separators" "$expected"
        continue
    fi

    if ! command -v pdfinfo >/dev/null 2>&1; then
        printf 'skip   %s: pdfinfo not installed\n' "$relative"
        continue
    fi

    pages=$(pdfinfo "$base.pdf" | awk '/^Pages:/ {print $2}')
    if [ "$pages" != "$expected" ]; then
        printf 'FAIL   %s: PDF has %s pages, source implies %s\n' \
            "$relative" "$pages" "$expected"
        status=1
    else
        printf 'ok     %s: %s pages\n' "$relative" "$pages"
    fi

    if [ "$md" -nt "$base.pdf" ]; then
        printf 'warn   %s: source is newer than the PDF (re-render before publishing)\n' \
            "$relative"
    fi
done

if [ "$decks" -eq 0 ]; then
    echo "check-slides: no decks found"
    exit 0
fi

echo
if [ "$status" -eq 0 ]; then
    echo "check-slides: $decks decks, no page-count mismatches"
else
    echo "check-slides: $decks decks, mismatches found"
fi
exit "$status"
