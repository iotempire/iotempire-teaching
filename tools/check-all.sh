#!/usr/bin/env bash
# One read-only validation entry point for the repository.
#
# Runs the Markdown checker, the slide-deck check, and `git diff --check`.
# Nothing here writes to the working tree.
#
#   ./tools/check-all.sh
#
# Exit status: 0 when every check passes, 1 otherwise.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
status=0

echo "== Markdown: links, anchors, fences =="
"$SCRIPT_DIR/check-docs.sh" || status=1

echo
echo "== Slides: separators vs PDF pages =="
"$SCRIPT_DIR/check-slides.sh" || status=1

echo
echo "== Whitespace: git diff --check =="
if git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git -C "$REPO_DIR" --no-pager diff --check; then
        echo "ok: no whitespace errors in tracked changes"
    else
        status=1
    fi
else
    echo "skip: not a git work tree"
fi

echo
if [ "$status" -eq 0 ]; then
    echo "check-all: PASS"
else
    echo "check-all: FAIL"
fi
exit "$status"
