#!/usr/bin/env bash
# ============================================================================
# DEPRECATED (2026-11): the MQTT broker runs on the classroom router.
# The sticks use _gateway / 192.168.114.1. Starting mosquitto on the instructor
# PC does not help them. Verify the router broker with:
#     nc -zv 192.168.114.1 1883
# Use classroom-nodered.sh for the containers (see INSTRUCTOR-GUIDE.md).
# ============================================================================
echo "ERROR: start-infra.sh is deprecated. The broker runs on the classroom router (192.168.114.1); see INSTRUCTOR-GUIDE.md." >&2
exit 1
