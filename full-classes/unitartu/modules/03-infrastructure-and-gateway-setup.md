# Module 3 – Infrastructure and Gateway Setup

[← Previous: Module 2](./02-hardware-and-basic-electronics.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-embedded-programming-and-deploying.md)

In this module, you set up the infrastructure needed for your IoT projects: network, gateway, MQTT broker, and first integrations.

**Placement:** This module belongs in the early-to-middle part of the semester and can naturally span multiple weekly sessions.

Slide: [Network setup - wifi/mqtt](https://docs.google.com/presentation/d/1nZmo6BYIS8HC2pnfGSesTfHjYayNzHuSUgl4YLhbYP4)

## Portable DIY Ad Hoc IoT Network

Research and take notes.

## Game: “MQTT to the Rescue”

This module contains a gamified setup sequence for deploying a local emergency communication network using OpenWRT and MQTT.

![][image2]

### How to play and find help in the game

- Each team creates a hostname.
- Maria’s network provides instructions via MQTT.
- Help can be requested on topics such as `help/phaseX`.
- Install an MQTT phone client and MQTT Explorer.

### Connect to Maria’s Network

- connect one phone to SSID `Maria`
- password: `iotempire`
- connect to broker at `192.168.14.1:1883`
- subscribe to `instructions/#`
- publish hostname on `mqtt/rescue`

### Phase 1: Set up and configure your LAN

Tasks include:

- research OpenWRT
- research LAN vs WAN
- connect computer by Ethernet
- find router IP
- research DHCP and DNS
- open LuCI
- change LAN IPv4 address to `192.168.14.1`
- reconnect after the IP change

### Phase 2: Set up and configure your WiFi access point

Tasks include:

- research 2.4 GHz Wi-Fi and European channel use
- choose a less busy channel
- configure SSID `IOTxx`
- set WPA2-PSK password `iotempire`
- disable the original OpenWrt AP

> [!NOTE]
> Keep the original local-regulation discussion here, including the question about which Wi-Fi channels may be used in Estonia.

### Phase 3: MQTT Broker setup

- connect router WAN to available internet
- test internet under diagnostics
- install `mosquitto-ssl`, `luci-app-mosquitto`, and `luci-app-commands`
- configure Mosquitto in LuCI
- inspect running services with `netstat -tulpn`

### Phase 4: Test MQTT messaging using devices

- connect all team devices to your own WiFi
- connect clients to the broker
- create topics and subtopics
- publish and subscribe from several devices
- test wildcard subscriptions in MQTT Explorer

### Optional Phase Extra: USB tethering for internet access

Use your phone as an alternative WAN connection via USB tethering.


## Week 2 – First Aid Station Scenario Play

Students role-play a first-aid scenario over the network they built.

Characters:

- Dr. Anya
- David
- Nurse Sunita
- Maria

Hardware tasks:

- First Aid Station Emergency Button
- First Aid Station Temperature Sensor

Role-play scenes:

- Scene 1: Blood Plasma Temperature Check
- Scene 2: The Gauze Request ![][image3]
- Scene 3: Code Blue Alert ![][image4]
- Scene 4: General Medical Directive ![][image5]

![][image6]

## IoTempower Installation on Laptop

Explore what IoTempower is and follow the installation instructions on GitHub.

## Explore IoTempower Services

Topics in this section:

- Mosquitto on CLI
- MQTT in Node-RED
- optional additional dashboards
- config file notes


[image2]: ../images/image2.png
[image3]: ../images/image3.png
[image4]: ../images/image4.png
[image5]: ../images/image5.png
[image6]: ../images/image6.png
