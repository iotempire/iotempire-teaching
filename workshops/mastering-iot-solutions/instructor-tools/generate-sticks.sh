#!/usr/bin/env bash
# ============================================================================
# Generate Stick Configurations (01 to N)
# ============================================================================
# Usage: ./generate-sticks.sh [count] [board_type]
# Example: ./generate-sticks.sh 15 "m5stickc plus2"
# ============================================================================

set -euo pipefail

COUNT=${1:-15}
BOARD=${2:-"m5stickc plus2"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/stick-config"

echo "Generating $COUNT stick configurations with board='$BOARD' in $CONFIG_DIR..."

for i in $(seq 1 "$COUNT"); do
    id=$(printf "%02d" "$i")
    dir="$CONFIG_DIR/$id"
    mkdir -p "$dir"
    
    # Write node.conf
    cat > "$dir/node.conf" << EOF
board="$BOARD"
EOF

    # Write setup.cpp
    cat > "$dir/setup.cpp" << EOF
// IoTempower Workshop Node: Stick $id
const char* id="$id";

out(led, ONBOARDLED).inverted().off();
button(home, BUTTON_HOME, "pressed", "released").inverted().debounce(10);
button(buttom, BUTTON_RIGHT, "pressed", "released").inverted().debounce(10);
m5stickc_display(console, 2, 270);
m5stickc_imu(imu, true, true, false, false);

//ds18b20(temp, 26);
//scd4x(gas).i2c(26,0);

void start() {
    do_later(100, [] () {
        IN(console).print("This is stick: ")
                   .print(id);
    });
}
EOF
done

echo "✅ Successfully generated sticks 01 through $(printf "%02d" "$COUNT")."
