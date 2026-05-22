# Module 3 – Infrastructure and Gateway Setup

[← Previous: Module 2](./02-hardware-and-basic-electronics.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-embedded-programming-and-deploying.md)

In this module, you will set up the infrastructure needed for your IoT projects, including a network, a gateway, and system management. We will set up a router and install IoTempower on your computer. All the activities for the first part of the module were gamified. We used a real-world earthquake scenario to create the game's steps. By playing the game, each team will learn hands-on how to set up and configure a router for an IoT network. It is an ad hoc local area network that uses IPv4, 2.4 GHz WiFi, and the MQTT protocol for communication. This network will be used for all modules going forward, including the final project for this course. Get acquainted with it. Have fun!

**Block placement:** This module starts on **Day 1** and continues into **Day 2** of the condensed four-day HSBI/GT workshop.

Slide: [Network setup - wifi/mqtt](https://docs.google.com/presentation/d/1nZmo6BYIS8HC2pnfGSesTfHjYayNzHuSUgl4YLhbYP4/edit?slide=id.g31c039e65c1_0_0#slide=id.g31c039e65c1_0_0)

## Portable DIY Ad Hoc IoT Network

Research and take notes.

## Game: “MQTT to the Rescue”

Read through this game as inspiration, but we will only do the actual tasks (router setup, mqtt communcation, and sensor/actor setup mentioned in it)

### Story

In April 2015, there was a critical earthquake in Nepal that killed 8,962 people and injured 21,952 across the countries of Nepal, India, China, and Bangladesh. After this devastating earthquake, the rescue forces had to mobilize quickly to save lives. This was challenging as the infrastructure was damaged. Close to the village of Langtang, an independent volunteer rescue team set up a first-aid station in the affected area to treat the wounded. However, they soon discover that all communication systems are down because the infrastructure has been damaged. They knew that communication could help save lives in time-critical situations, such as getting essential supplies to where they were needed and calling in personnel (doctors and nurses) to attend to an emergency. That’s where your group comes in. With your IT knowledge and limited hardware, the team counts on you to deploy a DIY network for the First-Aid Station. Maria, a traveler, carried a travel router (Mango) that she willingly donated to the station. She also learned from other travelers that in the nearby village, there is one Ethernet cable with internet access, so you can download the necessary applications and dependencies to deploy your network. She was willing to take your team there and back ASAP. The network will help workers communicate and monitor critical hospital machine sensors, such as oxygen tanks. Keep in mind that since there is no internet connection, your network must work only locally and be fully stand-alone.

![][image2]

### Objective

Your team should set up a Local Area Network (LAN) with a Wi-Fi access point and an MQTT broker to establish a simple communication system within the station. You must accomplish this using the router.

**Players:** Each group is an IT team and should create its own network.

### Challenges

Your team will receive a router with OpenWRT 24.10 already installed (an open-source Linux-based router OS), but it needs to be configured correctly for the station's needs:

- You must create a 2.4 GHz Wi-Fi access point with a visible SSID and password, using WPA2 encryption.
- You must find a way to download the dependencies and applications required to deploy the network.
- You must get an MQTT Broker running also on the router.
- You must test the network with a few MQTT clients. This can be on your smartphones and/or computers.

## How to play and find help in the game

Attention. The game has 2 networks. One Maria, our character's network, where you get instructions for each phase using the corresponding MQTT topics described on each phase below. Maria is played by us.

On Maria’s network, each team has a hostname and must subscribe and publish messages using MQTT with the correct messages and topics for each challenge to move ahead in the game.

The game will help you set up your router.

There is help if needed. GAME CHEAT: If you get stuck in one of the tasks and you really need in-depth description, send an MQTT Message card subscribing to a topic **help/phaseX** (x is the number of the phase you are stuck on) to get a detailed and useful tips cheatsheet. Maria will send you help for that phase.

Before the game starts, download the MQTT client apps on your phone so you can use them later in the game to test the network.

- **Download an MQTT client application.** Maria suggests **MyMQTT** by *instant:solutions OG* as it is easy to use. [https://mymqtt.app/en](https://mymqtt.app/en). Turn off the consents and all the cookies to make it less intrusive.
- Install **MQTT-Explorer** on one of your computers. [https://mqtt-explorer.com/](https://mqtt-explorer.com/)

## Connect to Maria’s Network

1. Create a **hostname** for your team. Write it on a **name tag** and make sure it is visible.
2. In one of the team members’ phones, connect to Maria’s WiFi. **SSID** is *Maria*. The **password** is *iotempire*.
3. On **MyMQTT** app on the same phone, connect to the **MQTT broker**: host `192.168.14.1`, port `1883`; no SSL or credentials needed.
4. Under the subscribe tab, subscribe to the topic `instructions/#`.
5. Publish a message on the topic `mqtt/rescue` with your team’s hostname.
6. Maria will publish instructions for each phase on `instructions/#`.

## Phase 1: Set up and configure your LAN

In this phase, Maria had a travel router with OpenWRT installed on it (the Mango), which she will give to you now. She is giving it to your team for this challenge, but you now need to configure your own WiFi network for the First Aid station.

Follow the instructions sent via MQTT to complete this phase.

**Phase 1 Tasks:**

1. The router has OpenWRT installed. Research what OpenWRT is. Take some notes in your portfolio.
2. Research the difference between LAN and WAN. Do we always need an internet connection for networks? Take some notes in your portfolio.
3. Connect your computer to the router using the Ethernet cable. This will create your **Local Area Network (LAN)**. If you cannot connect via Ethernet cable, find a way to log in to the router via the open WiFi.
4. Find the router’s IP on this network. Remember, you are creating a Local Area Network (LAN) between your computer and the router. Each device that connects to the network gets an IPv4 address from the DHCP server running on the router.
5. Research what DHCP/DNS servers are. Take notes in your portfolio.
6. Open the router’s LuCI interface on a browser on your computer that is connected to the router by typing the router’s IP address as the URL.
7. No need to set up a password for now.
8. Search for the LAN interface settings and edit them. Change LAN IPv4 address to **192.168.14.1**. This will be your gateway’s IP from now on. Click save and apply.
9. Since your router’s IP has changed, you must **disconnect** and **reconnect** so your computer receives a new IP.
10. To log in to the router now, you have to use the new IP address.

Once you have completed phase 1, publish a message on **phase1/verification/yourhostname** including the original OpenWRT IP address.

## Phase 2: Set up and configure your WiFi Access Point

Next, set up a WiFi network on the LAN you just created. Log in to the router and follow the instructions for Phase 2.

**Phase 2 Tasks:**

1. Research about 2.4 GHz Wi-Fi band and the European (ETSI) standards. Research what WiFi channels are and understand why it is important to choose a less busy one.
2. Find a less-busy WiFi channel. There is a tool in OpenWRT that helps you with that.
3. Set up a new WiFi access point with the SSID **IOTxx** (where `xx` is a unique name or number of your router).
4. Set the WiFi password to **iotempire** and ensure the network is secure with WPA2-PSK encryption.
5. Change the channel to the previously found less-busy channel.
6. Disable the existing OpenWrt WiFi access point.

Once you have completed phase 2, publish the following message on **phase2/verification/yourhostname**: `My Team’s WiFi is ...`

## Phase 3: MQTT Broker setup

Okay, with the WiFi infrastructure working, we now need to set up the MQTT broker for communication. Maria knows that you can run an MQTT broker on the Mango router as well. The catch is that you need a bit of internet connection to download the software and dependencies.

**Phase 3 Tasks:**

1. Find the internet point. It is a switch full of cables in the room. Connect the router via Ethernet to WAN. You can connect the computer to the LAN via your new WiFi now.
2. Test if you have internet connection on the router under **Network -> Diagnostics**. Ping `openwrt.org`.
3. On the router’s menu, find a way to **install Mosquitto** using OpenWRT's package manager in LuCI (`System -> Software`). First update the list of packages.
4. Install:
   - `mosquitto-ssl`
   - `luci-app-mosquitto`
   - `luci-app-commands`
5. If successfully installed, there should be a new **Services** tab where you can find the **Mosquitto** menu.
6. Configure your Mosquitto broker under the Mosquitto tab:
   - check **Use this LuCI configuration**
   - enable **Allow anonymous connections**
   - add a new listener with port **1883**
   - under protocol, listen to **MQTT**
7. If `luci-app-commands` was correctly installed, check running services on the dashboard:
   - go to **System -> Custom Commands -> Configure**
   - add a command called Running Services with `netstat -tulpn`
   - save and apply
   - run it on the dashboard

**Verification:** Publish an MQTT message on Maria’s network on topic **phase3/verification/hostname**. Is Mosquitto running on TCP or UDP layer? Name two other services running on the Mango router.

## Phase 4: Test MQTT messaging using devices

Now that you have your network set up and your MQTT broker running, it is time to test the communication system. Use the MQTT clients on your phone and MQTT Explorer on your computer to send messages across your network.

**Objective:** Send MQTT messages between devices using MQTT clients on **three** different topics.

**Phase 4 Tasks:**

1. Connect all your team’s phones to your WiFi network.
2. Open your MQTT client app.
3. Connect to your MQTT broker.
4. Research how topics and **publish/subscribe** communication work in MQTT.
5. Create 2 topics with a subtopic for testing, for example `team5/mqtt/test`.
6. Each team member must subscribe to at least one topic.
7. Test all topics by sending messages back and forth between your phones. Everyone must publish at least one message.

Then continue:

1. Research **wildcards** in MQTT and how they work.
2. On one computer connected to the router, open **MQTT-Explorer** and connect to the MQTT broker.
3. Subscribe to all topics using the wildcard.
4. Send messages using your phones and check if the computer can see all of them.

**Verification:** Ensure that all messages are successfully being received on the computer. Show this to the instructor.

Please upload screenshots and evidence to your portfolio. Also create a small tutorial to explain to someone how they can set up their IoT network on a router.

## Phase Extra (Optional): USB Tethering for Internet access

Set up USB tethering to use the phone as an alternative internet connection to the router.

**Attention:** USB tethering does not work when the Mango is connected to a weak power supply (like the little yellow one). It needs at least 2A.

1. On router configuration, install the dependency **kmod-usb-net-rndis**.
2. Connect your phone via USB cable to the Mango router USB port.
3. Activate USB tethering on your phone.
4. Go to the router config interface.
5. Go to **Network -> Interfaces** and add a new interface.
6. Name it `usb1` and set the device to the new USB interface.
7. Under firewall settings, assign the firewall-zone to **wan wan6**.
8. Save and apply.
9. Check if you have an internet connection on the laptop and in your WiFi network.

If you SSH into the Mango and check `dmesg` and see problems with device enumeration, you most likely have a power problem.

In the portfolio, write a few lines on how to start USB tethering for your network.

## First Aid Station Scenario Play

In the portfolio, we want to see proof of all parts of the tasks below. Keep the habit of screenshots and comments. Short and sweet.

Now that you have a network and MQTT system up and running, it's time to test in the real world. Team up with another pair (4 people) and play out the following scenario using one of your networks and the MQTT broker set up before.

### Character 1: Dr. Anya, The Medical Lead

- **Location:** ER Triage Center (smartphone client)
- **Responsibility:** monitors the overall status of critical patients and resources
- **Need:** must receive immediate emergency alerts and monitor the environment of the blood supply
- **MQTT Setup:**
  - subscribes to `station/alert/#`
  - subscribes to `station/supplies/blood/temp`
  - publishes to `station/announcements`

### Character 2: David, The Logistics Manager

- **Location:** Supply Room (laptop)
- **Responsibility:** manages medical supplies and ensures workers receive what they need in time
- **Need:** needs to know when oxygen tanks are running low or supplies need moving
- **MQTT Setup:**
  - subscribes to `station/announcements`
  - subscribes to `station/supplies/request`
  - publishes to `station/supplies/status`

### Character 3: Nurse Sunita, The Patient Ward Medic

- **Location:** General Recovery Ward (smartphone client + ESP emergency button)
- **Responsibility:** direct patient care
- **Need:** an easy way to signal a code blue and get logistics updates
- **MQTT Setup:**
  - subscribes to `station/announcements`
  - subscribes to `station/supplies/status`
  - publishes to `station/supplies/request`
  - ESP emergency button publishes to `station/alert/emergency/wardB`

### Character 4: Maria (The Monitoring Volunteer)

- **Location:** Storage Area (smartphone client + ESP temperature sensor)
- **Responsibility:** monitors blood plasma cooler temperature
- **Need:** verify that the sensor is talking to the network and request more ice if needed
- **MQTT Setup:**
  - subscribes to `station/announcements`
  - Dallas temp ESP publishes to `station/supplies/blood/temp`
  - phone publishes to `station/supplies/request`

Let’s deploy the hardware first. We need a button and a temperature sensor for the station.

## First Aid Station Emergency Button

Create a real button for Ward B using a D1 Mini and a button shield.

1. Use Arduino IDE to merge the code from the ESP8266 example in the MQTT library with the `InputPullupSerial` example.
2. Research how to install new libraries in the Arduino IDE.

MQTT library:
[https://github.com/bertmelis/espMqttClient](https://github.com/bertmelis/espMqttClient)

Button example:
[https://docs.arduino.cc/built-in-examples/digital/InputPullupSerial/](https://docs.arduino.cc/built-in-examples/digital/InputPullupSerial/)

- Set up proper WiFi and MQTT credentials
- Under `void loop()`, modify the code to send a message only if the button is pressed
- The message should say `Code Blue`
- Compile and flash from Arduino IDE
- Verify that the message appears on `station/alert/emergency/wardB`

Document proof in the portfolio.

## First Aid Station Temperature Sensor

Now we need a temperature sensor for the cooler that keeps the blood plasma at a constant temperature. Use a D1 Mini and a Dallas Temperature shield.

1. Use Arduino IDE to merge the ESP8266 example in the MQTT library with the Arduino Temperature Control Library example.
2. Install the DallasTemperature library.

Temperature library:
[https://github.com/milesburton/Arduino-Temperature-Control-Library](https://github.com/milesburton/Arduino-Temperature-Control-Library)

- Set up proper WiFi and MQTT credentials
- Under `void loop()`, modify the code to send temperature values
- Compile and flash
- Verify that the message appears on `station/supplies/blood/temp`

Document proof in the portfolio.

## Role-Playing the First-Aid Scenes

1. Before starting, ensure all 4 character devices and the 2 ESP nodes are connected to the WiFi and the Mosquitto broker.
2. Students should ideally be spaced apart to simulate physical distance.
3. Remind Dr. Anya that `station/alert/#` includes all subtopics below it.

### Scene 1: Blood Plasma Temperature Check

**The Play:** Dr. Anya is worried about the salvaged Fresh Frozen Plasma (FFP). If it gets too warm, it becomes useless, and she cannot treat trauma patients. She needs to see a live temperature reading.

1. **The Action:**
   - Maria powers the ESP temperature sensor and warms it with her hand.
   - Dr. Anya watches `station/supplies/blood/temp`.
   - Maria publishes `More ice for the plasma cooler asap.` to `station/supplies/request`.
2. **The Reaction:**
   - David receives the message and publishes `Ice is on the way, ETA 5 min.` to `station/supplies/status`.
3. **The Test:**
   - Dr. Anya must show the incoming rising temperature data stream.

### Scene 2: The Gauze Request ![][image3]

**The Play:** Nurse Sunita has run out of sterile gauze while dressing a wound.

1. **The Action:**
   - Sunita publishes `Need gauze Ward B. Urgent.` to `station/supplies/request`.
2. **The Reaction:**
   - David publishes `Gauze request dispatching now.` to `station/supplies/status`.
3. **The Test:**
   - David shows he received the request and Sunita shows she received the confirmation.

### Scene 3: Code Blue Alert ![][image4]

**The Play:** A patient in Ward B has gone into cardiac arrest.

1. **The Action:**
   - Sunita presses the hardware emergency button.
   - The ESP node publishes `code blue` to `station/alert/emergency/wardB`.
   - Dr. Anya watches `station/alert/#`.
2. **The Test:**
   - Anya must show that the wildcard subscription caught the specific emergency message.

### Scene 4: General Medical Directive ![][image5]

**The Play:** A minor aftershock of the earthquake has just occurred.

1. **The Action:**
   - Dr. Anya publishes `Aftershock felt. Check patients and oxygen tanks.` to `station/announcements`.
2. **The Reaction:**
   - David, Sunita, and Maria all watch their clients and confirm receipt.
   - Sunita and David publish follow-up status messages.
3. **The Test:**
   - All three show that the broadcast was received successfully across the LAN.

![][image6]

## IoTempower Installation on Laptop

Explore what IoTempower is.

Follow the instructions on the IoTempower GitHub page:
[https://github.com/iotempire/iotempower/blob/master/doc/installation.rst](https://github.com/iotempire/iotempower/blob/master/doc/installation.rst)

## Explore IoTempower Services

Check out `iot_service` and other commands in the IoTempower `bin` directory:
[https://github.com/iotempire/iotempower/tree/master/bin](https://github.com/iotempire/iotempower/tree/master/bin)

There is also a bit more documentation here, but critically hunt for new information together and prepare an update of this page:
[https://github.com/iotempire/iotempower/blob/master/doc/tool-support.rst](https://github.com/iotempire/iotempower/blob/master/doc/tool-support.rst)

### Mosquitto on CLI

If you installed IoTempower, you should have a Mosquitto client on your computer as a command-line tool.

Tasks:

- use `mosquitto_sub` and listen to all messages using wildcards `#` and `+`
- try listening to the MQTT button messages in the terminal
- listen to the temperature sensor messages in the terminal
- understand how `mosquitto_pub` works and publish to `station/announcements`

### MQTT on Node-RED

Node-RED was also installed with IoTempower. Please start it with:
`iot service start --web`

You can now reach it on `http://localhost:40080`

User: `admin`
Password: `iotempire`

Tasks:

- listen to the MQTT messages inside Node-RED using MQTT IN and DEBUG nodes
- extend the button to send messages on your topics
- create a dashboard on Node-RED that displays the temperature on a gauge
- send a warning message if the temperature exceeds a threshold
- deploy an RGB LED on another D1 mini node that reacts to code blue button messages

### Optional – More dashboards

Feel free to explore and create new dashboards with Node-RED. Dashboard 2.0 is pre-installed.

As an alternative, you can explore the IoT MQTT panel app on one phone.

[image2]: ../images/image2.png
[image3]: ../images/image3.png
[image4]: ../images/image4.png
[image5]: ../images/image5.png
[image6]: ../images/image6.png
