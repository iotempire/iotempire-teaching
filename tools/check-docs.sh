#!/usr/bin/env bash
# Markdown link, anchor, and code-fence checker.
#
# Thin wrapper around check-docs.py so the repository has one stable
# command that can be pre-approved in the editor.
#
#   ./tools/check-docs.sh [PATH ...]      # default: the whole repository
#
# Exit status: 0 when clean, 1 when issues are found, 2 on usage error.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$SCRIPT_DIR/check-docs.py" "$@"
