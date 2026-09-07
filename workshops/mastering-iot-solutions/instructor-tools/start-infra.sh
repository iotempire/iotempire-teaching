#!/usr/bin/env bash
# ============================================================================
# Workshop Infrastructure Starter (Mosquitto MQTT Broker via IoTempower)
# ============================================================================
# Starts the MQTT broker for the workshop.
#
# Recommended Setup:
#   A dedicated portable hardware router (e.g. GL-iNet GL-B1300) broadcasting:
#     - 5 GHz: iotempire-b1300-5g (for participant laptops)
#     - 2.4 GHz: iotempire-b1300   (for M5StickC devices)
#     - Wi-Fi Password: iotempire
#   A dedicated router with strong concurrent client support is highly
#   recommended (running 20+ clients on laptop Wi-Fi requires specialized
#   Atheros or older Realtek USB adapters under Linux).
#
# Usage:
#   ./start-infra.sh start
#   ./start-infra.sh status
#   ./start-infra.sh stop
# ============================================================================

set -euo pipefail

MQTT_PORT=1883

echo "========================================================================="
echo "🛠️  Mastering IoT Solutions - Infrastructure Bring-Up"
echo "========================================================================="

check_mqtt_running() {
    if ss -tln | grep -q ":$MQTT_PORT "; then
        return 0
    else
        return 1
    fi
}

start_mqtt() {
    echo "🔍 Checking for MQTT Broker on port $MQTT_PORT..."
    if check_mqtt_running(); then
        echo "✅ MQTT Broker is already running on port $MQTT_PORT."
    else
        echo "🚀 Starting Mosquitto MQTT broker..."
        if command -v iot >/dev/null 2>&1; then
            echo "Starting MQTT via IoTempower service (iot service start --mqtt)..."
            iot service start --mqtt || true
        elif command -v mosquitto >/dev/null 2>&1; then
            cat > /tmp/workshop-mosquitto.conf << 'EOF'
listener 1883 0.0.0.0
allow_anonymous true
persistence false
log_type error
log_type warning
log_type notice
log_type information
EOF
            sudo mosquitto -c /tmp/workshop-mosquitto.conf -d
            echo "✅ Mosquitto started as daemon."
        elif command -v podman >/dev/null 2>&1 || command -v docker >/dev/null 2>&1; then
            CLI=$(command -v podman || command -v docker)
            $CLI run -d --name workshop-mosquitto -p 1883:1883 \
                eclipse-mosquitto:latest
            echo "✅ Mosquitto started in container."
        else
            echo "❌ Error: Neither iot, mosquitto, nor container engine found." >&2
            exit 1
        fi
    fi
}

show_status() {
    echo ""
    echo "📡 Network Status:"
    ip -br addr show | grep -v "127.0.0.1" || true
    echo ""
    echo "🔌 Listening Ports:"
    ss -tln | grep -E "(:1883|:180[0-9]|:181[0-9]|:4188)" || true
    echo ""
    echo "Tips for Monitoring MQTT traffic:"
    echo "  - Via IoTempower:  iot x mqtt_listen   (from node dir or system dir)"
    echo "  - Via mosquitto:   mosquitto_sub -h localhost -t '#' -v"
    echo "========================================================================="
}

case "${1:-start}" in
    start)
        start_mqtt
        show_status
        ;;
    status)
        show_status
        ;;
    stop)
        echo "Stopping MQTT broker..."
        if command -v iot >/dev/null 2>&1; then
            iot service stop || true
        fi
        sudo pkill -f mosquitto 2>/dev/null || true
        (command -v podman || command -v docker) stop workshop-mosquitto 2>/dev/null || true
        echo "✅ Stopped."
        ;;
    *)
        echo "Usage: $0 [start|status|stop]"
        exit 1
        ;;
esac
