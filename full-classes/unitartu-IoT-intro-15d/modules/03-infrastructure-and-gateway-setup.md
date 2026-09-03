# Module 3 – Infrastructure and Gateway Setup

[← Previous: Module 2](./02-hardware-and-basic-electronics.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-embedded-programming-and-deploying.md)

Module 3 focuses on establishing the foundational infrastructure for IoT projects, including network setup, gateway and router configuration, installing an MQTT broker, and safety protocols. The module uses a gamified emergency network setup scenario to help students understand network roles and communication protocols using OpenWRT routers and MQTT.

Slide: [Network setup - wifi/mqtt](https://docs.google.com/presentation/d/1nZmo6BYIS8HC2pnfGSesTfHjYayNzHuSUgl4YLhbYP4)


# Portable DIY Ad Hoc IoT Network


Research and take notes.

# Game: “MQTT to the Rescue”


* **Story:**


  In April 2015, there was a critical earthquake in Nepal that killed 8,962 people and injured 21,952 across the countries of Nepal, India, China, and Bangladesh. After this devastating earthquake, the rescue forces had to mobilize quickly to save lives. This was challenging as the infrastructure was damaged. Close to the village of Langtang, an independent volunteer rescue team set up a first-aid station in the affected area to treat the wounded. However, they soon discover that all communication systems are down because the infrastructure has been damaged. They knew that communication could help save lives in time-critical situations, such as getting essential supplies to where they were needed and calling in personnel (doctors and nurses) to attend to an emergency. That’s where your group comes in. With your IT knowledge and limited hardware, the team counts on you to deploy a DIY network for the First-Aid Station. Maria, a traveler, carried a travel router (Mango) that she willingly donated to the station. She also learned from other travelers that in the nearby village, there is one Ethernet cable with internet access, so you can download the necessary applications and dependencies to deploy your network. She was willing to take your team there and back ASAP. The network will help workers communicate and monitor critical hospital machine sensors, such as oxygen tanks. Keep in mind that since there is no internet connection, your network must work only locally and be fully stand-alone.
  

* **Objective:**  
  Your team should set up a Local Area Network (LAN) with a Wi-Fi access point and an MQTT broker to establish a simple communication system within the station. You must accomplish this using the router.

  **Players:**
  Each group is an IT team and should create its own network.


* **Challenges :**
  Your team will receive a router with OpenWRT 24.10 already installed (an open-source Linux-based router OS), but it needs to be configured correctly for the station's needs:
  You must create a 2.4 GHz Wi-Fi access point with a visible SSID and password, using WPA2 encryption.

  You must find a way to download the dependencies and applications required to deploy the network.

  You must get an MQTT Broker running also on the router.

  You must test the network with a few MQTT clients. This can be on your smartphones and/or computers.


## How to play and find help in the Game


Attention. The game has 2 networks. One Maria, our character's network, where you get instructions for each phase using the corresponding MQTT topics described on each phase below.  Maria is played by us.

On Maria’s network. Each team has a hostname and must subscribe and publish messages using MQTT with the correct messages and topics for each challenge to move ahead in the game.

The game will help you set up your router.

There is help if needed. GAME CHEAT: If you get stuck in one of the tasks and you really need in-depth description, send an MQTT Message card subscribing to a topic **help/phaseX** (x is the number of the phase you are stuck on) to get a detailed and useful TIPS cheatsheet. Maria will send you help for that phase.

Before the game starts, download the MQTT client apps on your phone so you can use them later in the game to test the network.

* **Download an MQTT client application.** Maria suggests **MyMQTT** by *instant:solutions OG* as it is easy to use. [https://mymqtt.app/en](https://mymqtt.app/en) . Turn off the consents and all the cookies to make it less intrusive.
  * Install **MQTT-Explorer** on one of your computers. [https://mqtt-explorer.com/](https://mqtt-explorer.com/)


##  


## **Connect to Maria's Network** 

1. Create a **hostname** for your team. Write it on a **name tag** and make sure it is visible.
2. In one of the team members’ phones, connect to Maria’s WiFi **SSID** is *Maria*. The **password** is *iotempire*.
3. On **MyMQTT** app on the same phone, connect to the **MQTT broker :** Host 192.168.14.1, port 1883; no SSL or credentials needed.
4. Under the subscribe tab, subscribe to the topic  **-instructions/#** (# is to get all instructions that come under the topic instructions).
5. Publish a message on the topic **mqtt/rescue** with your team’s **hostname.**
6. Maria will publish instructions for each phase on **instructions/#.** You can see the instructions on the dashboard for phase 1. Once you complete it and submit the verification, you will get the instructions for phase 2.

## **Phase 1: Set up and configure your LAN**


In this Phase, Maria had a travel router with OpenWRT installed on it (the Mango), which she will give to you now. She is giving it to your team for this challenge, but you now need to configure your own WiFi network for the First Aid station.

Follow the instructions sent via MQTT to complete this phase.
**Phase 1 Tasks:**

1\. The router has OpenWRT installed. Research what OpenWRT is. Take some notes in your portfolio. 

2\. Research the difference between LAN and WAN.  Do we always need an internet connection for networks? Take some notes in your portfolio.

3\. Connect your computer to the router using the Ethernet cable. This will create your **Local Area Network (LAN)**. If you can not connect via Ethernet cable, find a way to log in to the router via the open WiFi.

4\. Find the router’s IP on this Network. Remember, you are creating a Local Area Network (LAN) between your computer and the router. Each device that connects to the network gets an IPv4 address from the DHCP server running on the router.

5\. Research what DHCP/DNS servers are. Take notes on your portfolio.

6\. Open the router’s LUCI interface on a browser on your computer that is connected to the router by typing the router’s IP address as the URL.

7\. No need to set up a password for now.

8\. Search for the LAN interface settings and edit them. Change LAN IPv4 address to **192.168.14.1.** This will be your gateway’s IP from now on. Click save and apply. Apply unchecked. 

9\. Since your router’s IP has changed now you must **disconnect** and **reconnect** for your computer to be part of the new network and receive a new IP. You can do this on your network manager or just by unplugging the Ethernet cable and replugging it into the computer.

10\. To log in to the router now, you have to use the new IP address that we just created.

Once you have completed phase 1, publish a message on **phase1/verification/*yourhostname* *the original OpenWRT IP address (write the IP)***. 


## **Phase 2: Set up and configure your WiFi Accesspoint**


Next, let’s set up a WiFi network on the LAN we just created**. Log in to the router and follow the instructions for Phase 2 that have been sent to your phone.

**Phase 2 Tasks:**

1\. Research about 2.4 GHz Wi-Fi band and the European (ETSI) standards. Research what WiFi channels are and understand why it is important to choose a less busy one. Can all channels be used in Estonia? 

2\. Find a less-busy WiFi channel. There is a tool in OpenWRT that helps you with that.

3\. Set up a new WiFi Access point with the SSID **IOTxx** (Where xx is a unique name or number of your router).

4\. Set the WiFi password to ***iotempire***. Ensure the network is secure with WPA2-PSK encryption.

5\. Change the channel to the previously found less-busy channel.

6\. Disable the existing OpenWrt WiFi access point. You only need one WiFi network from now on.


> [!NOTE]
> Keep the original local-regulation discussion here, including the question about which Wi-Fi channels may be used in Estonia.


Once you have completed phase 2, publish the following message on **phase2/verification/*yourhostname* **:** *My Team’s WiFi is ****____(write your SSID)****. Once Maria verifies that your WiFi is up, she will send you new instructions for the next phase. Again, please subscribe to this topic to receive new instructions.


## **Phase 3: MQTT Broker setup**


Okay, with the WiFi infrastructure working, we now need to set up the MQTT broker for the communication. Maria knows that you can run an MQTT broker on the Mango Router as well. The catch here is that you need a bit of internet connection to download the software and dependencies.
If you subscribed to the topic **instructions/#**, you will receive information on where to find the point with internet access.

**Phase 3 Tasks:**

1\. Find the internet point. It is a switch full of cables in the room. Connect the router via Ethernet to WAN. You can connect the computer to the LAN via your new WiFi now.
2\. Test if you have internet connection on the router under **network -> diagnostic**. Ping openwrt.org. If you see that packages are transmitted, it means that you have internet on the router.

3\. On the router’s menu, find a way to **install Mosquitto** (an MQTT broker) using OpenWRT's package manager in LUCI (System-> Software). First update the List of Packages available.
Then install the following packages:
**mosquitto-ssl,  luci-app-mosquitto** and **luci-app-commands** 
4\. If you successfully installed the additional software above, there should be a new **Services** tab where you can find the **Mosquitto** menu. You might have to refresh the webpage to see it.

5\. Configure your Mosquitto Broker under the Mosquitto tab:
- **Check** the box **Use this LuCI configuration.**  
- Set to Enable **Allow anonymous connections** field.
- Add a new **Listener,** and configure it by setting the **Port** to **1883** 
-  Under **Protocol dropdown set it to listening** to **MQTT**.

6\. If luci-app-commands was correctly installed, you could check if the services that are running on the dashboard.
- Go to **System -> Custom Commands -> Configure**.   
- Add new services, name it Running Services **and type** "netstat -tulpn" on the command box.   
- Save and apply.   
- Go back to the dashboard and run the command.   
- Under PID/Program name, you can see Mosquitto running. 

!!!
Remember, if you get stuck in one of the tasks and you can get more help by publishing an MQTT message on the topic **help/phaseX** (x is the number of the phase you are stuck on)
Maria will send you help.

**Verification:** Publish an MQTT message on Maria’s network on topic **phase3/verification/hostname.** Is Mosquitto running on TCP or UDP layer? Name two other services running on the Mango router.

Once Maria verifies your answer, she will publish instructions for phase 4 on your phone. 


## **Phase 4: Test MQTT messaging using devices**


Now that you have your network set up and your MQTT broker running, it is time to test the communication system. Use the MQTT clients on your phone and the MQTT explorer on your computer to send messages across your network. 

Maria explained that the way MQTT works is that everyone who is subscribed to a topic and subtopic gets a message when a Publisher publishes on that topic.

**Objective:** Send MQTT messages between devices using MQTT clients on **three** different topics.

Follow the instructions from **phase 4.**

**Phase 4 Task:**

1\. Connect all your team's phones, including this one your network's WiFi now. You can disconnect from Maria’s Network now.

2\. Open your MQTT client app.

3\. Connect to your MQTT broker. Remember that your broker’s IP is the same as your Gateway/Router.
4\. Research how topics and **publish/subscribe** communication work in MQTT. 
5\. Create 2 topics with a subtopic for testing. For example: team5/mqtt/test.
6\. Each team member must subscribe to at least one topic. After subscribing, messages can be seen on the **dashboard** page.
7\. Test all 2 topics by sending messages back and forth between your phones. Everyone must publish a message on at least one topic. Ensure messages are successfully sent and received across different devices.

If this is working, congratulations! Your ad-hoc communication network is up and running


Once more, if you need more help, publish on Maria’s network **help/phaseX** (x is the number of the phase you are stuck on). Remember that you must reconnect to Maria’s network to publish there now.

Great job! Your system is up and running. But the system needs a little upgrade. The first aid station manager told the team it would be nice to have a computer where you can see all the messages that have been published. To finish this part of the phase, follow the instructions below:
1. Research about **wildcards** in MQTT and how they work. What does the **#** listen to. How do the topic and subtopic work and their hierarchy? Take notes in your portfolio.   
2. On one computer connected to the router via Ethernet, open **MQTT-Explorer** (the one you have installed earlier) and connect to the MQTT broker.   
3. Subscribe to all topics using the **wildcard**.  
4. Send messages using your phone and check if the computer can see all of them.

**Verification:** Ensure that all messages are successfully being received on the computer. Use your phones and send different messages on different topics. Show them to us that you have accomplished this phase by showing the computer.

**CONGRATULATIONS! YOU HAVE HELPED THE HELPERS HELP OTHERS IN THIS CRITICAL MOMENT, AND NOW YOU HAVE YOUR OWN AD-HOC IOT NETWORK AS WELL. THE FIRST AID STATION IS VERY HAPPY WITH YOUR TEAM.**


**!!! PLEASE printscreen and upload the images to your portfolio. This game is part of your project for this module of this module.**


**Also, in the portfolio, create a small tutorial to explain to someone how they can set up their IoT network on a router.  This can be simple step-by-step instructions or a whole video if you want. Be creative, have fun.** 

## **Phase Extra (Optional): USB Tethering for Internet access**


Set up the USB tethering to use the phone as an alternative WAN connection to the router.

ATTENTION!!
USB tethering does not work when the mango is connected to a weak power supply (like the little yellow one), it needs to get power from at least 2A (like the 12V -> 4x5V USB charger) - keep that in mind if you want to tether your phone's internet into the mango.

1. On routers’ configuration, install the dependency **kmod-usb-net-rndis.**
2. Connect your phone via USB cable to the mango router USB port  
3. Activate USB tethering on your phone  
4. Go on the router’s Config Interface (remember to connect to your router via Ethernet)
5. Go to network -> interfaces and say Add new interface.
6. Name it usb1 and set the device to **eth1 or eth0.2** (depending on the name of the new usb interface)**.** Create interface.
7. Under firewall settings, assign the firewall-zone to **wan wan6**
8. Save and apply.   
9. Check if you have an internet connection on the laptop and in your WiFi network. If your phone has internet access on GSM or another WiFi, it should tether it to the router.

If you ssh into the mango and check kernel messages with dmesg and see something about problems with device enumeration, you most likely have a power problem as described above.

In the portfolio, write a few lines on how to start USB tethering for your network.


# Week 2 – First Aid Station Scenario Play


Students role-play a first-aid scenario over the network they built.

Characters:

- **Dr. Anya**, The Medical Lead
- **David**, The Logistics Manager
- **Nurse Sunita**, The Patient Ward Medic 
- **Maria** (The Monitoring Volunteer)



Hardware tasks:

- First Aid Station Emergency Button
- First Aid Station Temperature Sensor

Role-play scenes:

- Scene 1: Blood Plasma Temperature Check
- Scene 2: The Gauze Request 
- Scene 3: Code Blue Alert 
- Scene 4: General Medical Directive


Additional material:

[image2]: ../images/image2.png
[image3]: ../images/image3.png
[image4]: ../images/image4.png
[image5]: ../images/image5.png
[image6]: ../images/image6.png