# Module 6 – IoT Systems

[← Previous: Module 5](./05-integration-and-simulations.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-final-project.md)

**Block placement:** This module is scheduled for **Day 3**, together with Module 5. Try to reach the team (test) project today, we can use a bit of time on the fourth day to finish it.

## Scaling IoT Systems

Slides: [Scaling IoT Systems](https://docs.google.com/presentation/d/1Jqvox8ba1FuM9QS67BS8BsGoHe7STENVnbn3vzxJ2fU)

- Add your notes for building blocks and pain points here
- Add your notes for scaling up here
- Add your notes for Device Management and Integration for IoT Systems here

## IoTempower as Device Management Framework

Remark: Only one deploy command can run at a time on one IoTempower gateway. Coordinate with your peer(s). Also, this is a long lab. Use your time wisely and consider dividing tasks after you and your peers grasp the basics.

Start the services as discussed and tested in previous modules.

Tool support in IoTempower:
[https://github.com/iotempire/iotempower/blob/master/doc/tool-support.rst](https://github.com/iotempire/iotempower/blob/master/doc/tool-support.rst)

### Task 1 (pre task): Creating Your First IoT System with IoTempower

This is meant to get you set up with IoTempower and configure, deploy, and manage IoT nodes.

Follow the [quickstart](https://github.com/iotempire/iotempower/blob/master/doc/quickstart.rst) all the way to the second node as well as the linked tutorial video ([https://youtu.be/fTWNYXfet9E](https://youtu.be/fTWNYXfet9E)) and do all subtasks.

Be aware that some things might not be updated. Ask the instructor and file issues if you spot potential improvements in the documentation — or even PRs.

The videos and some resources might still mention `gw.iotempower.net`. For HSBI, replace this with the address of your actual gateway computer and port `40080`, for example `http://192.168.14.xxx:40080` or `http://localhost:40080`.

For the step “Next deployments”, connect the node to external USB power as suggested and show that the deploy step still works over OTA.

TIPS: using [WSL USB GUI](https://gitlab.com/alelec/wsl-usb-gui/-/releases) can help with attaching the device for easy flashing.

### Task 2: Second Node

Follow the [manual here](https://github.com/iotempire/iotempower/blob/master/doc/second-node.rst) and do all the subtasks, also using the toggle node.

### Task 3: Rebuild access control system with IoTempower (4+ nodes)

Create a new IoT system and configure the config file.
Rebuild a minimal version of your access control system with IoTempower nodes. You can re-use your Node-RED code and adjust the topics. Remember to create a **new node folder** inside your new IoT system for each separate node you are going to deploy. Use the `iot menu` if needed.

Pick at least 4 sensors from the last module and implement them in an IoTempower system. You can take the examples of Module 5 task 2 and choose sensors and actuators such as OLED, RFID, lock-relay, etc.

For the portfolio in this task, be very brief with the steps and focus on code, photos, screenshots, and explain only the important changes in your Node-RED flow as it should stay mainly the same as before.

## Hostel HostmeWell Automation

TODO: consider bringing back water measurement task

### Team finding

Spend some minutes finding potential teammates for this project. Team up with another pair if you didn't yet.

### Story

Andres and Liis have received a hostel in Tartu from her parents, HostmeWell. The hostel is a good business but it is still run in the old-fashioned way, everything done manually by the workers.

Andres and Liis want to automate some parts of the hostel to help the user experience and also the workers. They want your team to create some prototypes to brainstorm and test out ideas that could help them.

### Your job

Come up with 3 challenges that are part of HostmeWell, either from the guests or the workers, that could be solved using the sensors, actuators, and services from IoTempower.

You can use the sensors from the previous access control system tasks to guide your ideas for the hostel that is trying to implement some automation in a home-automation style.

Take your time to imagine and create. The important thing is to practice and exercise prototyping and story modeling as ways to brainstorm solutions.

- Create a little story for each of the 3 challenges.
  - Your story must have characters with names, a description of the problem, and how the problem is being solved with the technology.
  - Name the hardware and software needed to solve the problem and the potential difficulties in implementing the solution.

You have to prototype one solution during this lab class.

### Rules

- Create a **new system** for your project in IoTempower. You must think of a system and not standalone solutions.
- Prototype at least **1 of the 3 challenges**. Pick a challenge that is doable in class. Groups that are fast can implement them all.
- Write a nice **story** for the scenario about the challenge.
- Research the filters in IoTempower. Use at least one filter.
- Nodes must talk to each other, use at least 3 nodes, create some creative **Node-RED integration** and a nice **dashboard**.
- Implement your fast **prototype**. Research about dirty prototyping. The point is to test your solutions, visualize the challenge, and brainstorm ideas.
- You can use the sensors from the last tasks but pick **one new sensor or actuator** from the IoTempower list to implement as well, if available.
- **Optional:** If your group is fast, try to implement a **database** using LiteSQL or InfluxDB. Install and run InfluxDB locally and connect it to Node-RED. Gather data from two different nodes and visualize it.

OBS: The challenges can be weird, absurd, and creative. They do not have to fully work as long as they explore creative solutions.

### Portfolio report

In the portfolio report your build system:

1. Take photos and screenshots of the prototype and the dashboards to prove you did the experiment.
2. Upload your code with comments.
3. List the buses used for the sensors (I2C, etc).
4. Make sure your story is also there.
5. Report on difficulties you found with certain sensors.
6. Report on how to use the filter you have chosen.
