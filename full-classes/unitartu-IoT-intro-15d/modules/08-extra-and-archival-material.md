# Module 8 – Extra and Archival Material


[← Previous: Module 7](./07-final-project.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md)



This module consolidates extra content that supplements previous modules, including historical material, optional extensions, and reference guides intended for advanced or curious students. The content may be removed or migrated in future editions; consult the original HSBI workbook for authoritative versions.




## IoTempower Gateway on Raspberry PI



For users preferring a Raspberry Pi gateway, setup IoTempower on Raspberry Pi OS instead of a travel router:


- Install dependencies (Mosquitto, Node.js, Python if needed)
- Clone iotempower repository and run `iot install`
- Adapt configuration files for Raspberry Pi GPIO pinouts and network services
- Integrate with Wi-Fi access point or wired LAN as preferred
- Use `iot service start` to manage local services (Node-RED, Mosquitto, etc.)


*Notes: ESPHome or Tasmota alternatives exist for lightweight gateways; choose based on hardware constraints.*



## Hostel HostmeWell Automation (Historical/Legacy)


This scenario was used in HSBI to introduce automation concepts. Although the hotel-brand name is playful, the underlying concepts of room automation (lighting, HVAC, occupancy sensing) remain educational. It primarily served to illustrate multi-room systems orchestrated via Node-RED and summarized here for context.


- **Use Case**: Automate hotel room with smart lighting and HVAC control
- **Hardware**: ESP32 or ESP8266 nodes per room, relay modules, motion sensors, temperature/humidity sensors
- **Integration**: Node-RED flows for presence-based conditioning; database storage for occupancy analytics; MQTT topics scoped by room (e.g., `hostel/room1/lightset`)
- **Dashboard**: Room-by-room controls and real-time metrics via Node-RED dashboard; energy dashboards per floor
- **Reflection Prompt**: How would you extend this to water leak detection and alerting for maintenance teams?




Legacy material retained for educational value and inspiration.



----

**Contents migrated or summarized from obsolete sections below. Material may be outdated or platform-specific.**


# Obsolete


Section title retained for migration clarity. Original material moved to respective archived modules or superceded by updated guides as above.



## MQTT on microcontroller (legacy reference)



*This content described legacy MQTT libraries and client configurations for ESP-class devices. Modern use should employ ArduinoMqttClient or PubSubClient; consult current documentation.*



## Additional Temperature Sensors (superceded)


*Use Adafruit unified sensor libraries; OneWire and DHT libraries are standard for Arduino ecosystem.*



## Resources (maintained externally)


- [https://iotempower.us/docs](https://iotempower.us/docs)
- [https://github.com/iotempire/iotempower](https://github.com/iotempire/iotempower)
- [https://play.google.com/store/apps/details?id=snr.lab.iotmqttpanel.prod](https://play.google.com/store/apps/details?id=snr.lab.iotmqttpanel.prod)

- [https://apps.apple.com/us/app/iot-mqtt-panel](https://apps.apple.com/us/app/iot-mqtt-panel)




## More Sensors



### Analog Touch Sensor
- Use capacitive touch library to convert GPIO to touch input
- Publish events on touch detection; debounce and hysteresis suggested



### Moisture Sensor
- Monitor soil moisture via ADC on ESP32; implement oversampling and median filtering
- Calibrate in moisture classes (dry/wet) and publish numeric values on MQTT topic `env/soil`
- Add hysteresis to avoid chatter when near threshold



### Other sensors (partly optional)
- Sound: KY-037 microphone module
- Vibration: SW-420 sensor module
- Hall effect: magnetic field detection with KY-003
- PIR motion: HC-SR501 alternative; adjust sensitivity and delay potentiometer
- Sound buzzer: active or passive; PWM-controlled tones




----

Your instructor may choose to include or omit any of these sections based on course pace and student interest.