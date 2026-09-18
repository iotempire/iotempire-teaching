#!/usr/bin/env bash
# Thin wrapper: delegates to the unified generator in tools/.
#
# The class directory and output filename prefix are preset here; every argument
# (release label, --engine, ...) is forwarded unchanged.
#
# Usage: ./generate-lms-pdfs.sh [release-label] [--engine <name>] [--prefix <prefix>]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec "$SCRIPT_DIR/../../tools/generate-lms-pdfs.sh" \
    --class-dir "$SCRIPT_DIR" \
    --prefix "hsbi-networking-iot-" \
    "$@"
