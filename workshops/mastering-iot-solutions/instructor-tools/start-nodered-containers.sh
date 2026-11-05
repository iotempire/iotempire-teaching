#!/usr/bin/env bash
# ============================================================================
# DEPRECATED (2026-11): replaced by the LAN-only classroom orchestrator
# `classroom-nodered.sh` (see ../INSTRUCTOR-GUIDE.md).
#
# The old helper did not install Dashboard 2.0 into fresh containers and mapped
# broker.internal to the container bridge instead of the classroom router.
# The implementation is in the repository history if it is ever needed.
# ============================================================================
echo "ERROR: start-nodered-containers.sh is deprecated. Use classroom-nodered.sh (see INSTRUCTOR-GUIDE.md)." >&2
exit 1
