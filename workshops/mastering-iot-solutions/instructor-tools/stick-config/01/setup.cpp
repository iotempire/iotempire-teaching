// IoTempower Workshop Node: Stick 01
const char* id="01";

out(led, ONBOARDLED).inverted().off();
button(home, BUTTON_HOME, "pressed", "released").inverted().debounce(10);
button(buttom, BUTTON_RIGHT, "pressed", "released").inverted().debounce(10);
m5stickc_display(console, 2, 270);
m5stickc_imu(imu, true, true, false, false);

// Grove protoboard (pre-soldered, sensor on GPIO32):
//ds18b20(temp, 32);
// Bare sensor wired to the top HAT header (G26):
//ds18b20(temp, 26);
//scd4x(gas).i2c(26,0);

void start() {
    do_later(100, [] () {
        IN(console).print("This is stick: ")
                   .print(id);
    });
}
