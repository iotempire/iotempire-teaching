#!/usr/bin/env sh
# Render a Markdown slide deck to PDF with pandoc + Typst, then open it in
# Okular's presentation mode (fullscreen, one slide per page).
#
#   render-slides.sh <deck.md> [output.pdf] [--no-open]
#
# Slides are separated by a `---` line in the Markdown (turned into a page
# break by pagebreak.lua); the 16:9 look lives in slides.typ.
set -eu

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

input=${1:?usage: render-slides.sh <deck.md> [output.pdf] [--no-open]}
shift

output=""
open=1
for arg in "$@"; do
  case "$arg" in
    --no-open) open=0 ;;
    *) output=$arg ;;
  esac
done
[ -n "$output" ] || output=${input%.md}.pdf

pandoc "$input" \
  --from=gfm \
  --pdf-engine=typst \
  --template="$dir/slides.typ" \
  --lua-filter="$dir/pagebreak.lua" \
  --output="$output"

printf 'rendered %s\n' "$output"

if [ "$open" = 1 ] && command -v okular >/dev/null 2>&1; then
  okular --presentation "$output" >/dev/null 2>&1 &
fi
