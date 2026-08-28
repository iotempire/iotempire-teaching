# Module 7 – Final Project

[← Previous: Module 6](./06-iot-systems.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md)


The final project is an opportunity to synthesize knowledge and skills from all modules. Students design, build, document, and present an IoT system of their choice, demonstrating integration of hardware, embedded programming, networking, and orchestration. The project must be completed as a team and includes a **portfolio entry**, a **public presentation**, and a **project showcase**. Projects will be assessed on technical and documentation quality and novelty.


The project builds upon the hardware and software toolchain used throughout the course. Teams are encouraged to leverage IoTempower for device management, Node-RED for integration, MQTT for communication, and open repositories for libraries and examples.


## Stories/Scenarios

The final project can be inspired by real-world scenarios or your own creative vision. Use the provided scenarios for inspiration:

- **Emergency Room (ER) monitoring system**: monitor patient vital signs, alert medical staff on anomalies, integrate RFID and temperature sensors with Node-RED alerts
- **Smart greenhouse automation**: control humidity, temperature, and lighting via sensors, automate watering based on soil moisture, collect historical trends
- **Warehouse intrusion detection**: combined PIR + LIDAR presence detection, real-time alerts via Node-RED dashboard to security team, log timestamps
- **IoT classroom presence tracker**: deploy RFID readers at multiple stations to track student attendance, aggregate presence data in InfluxDB

- **Patient monitoring in home care**: collect metrics from BME280 health sensors, push alerts on abnormal thresholds to caretaker’s phone via Telegram/Discord



Use your creativity, but align your proposal with available resources and feasibility.


## Final Project


### Project Proposal (Week ___)
Each team must prepare a one-page project proposal including:
- **Motivation** and problem statement
- **Key user stories** and functional requirements
- **Hardware inventory** (which boards, sensors, actors)
- **Software stack** (Arduino IDE, ESPHome, PlatformIO, Node-RED, IoTempower, etc.)
- **Timeline** with intermediate milestones and presentation dates
- **Risk assessment** and fallback plans

Approvals and feedback must be completed before project execution. Capture your milestones in a shared Git repository — reflections are expected at each step.


### Development Phase


- **Design and Planning**
  - Collect hardware and prototype sensor-node circuits
  - Sketch Node-RED flows and dashboard layouts
  - Define MQTT topics and schemas
  - Select libraries and firmware platforms

- **Iterative Prototyping and Testing**
  - Build and test individual nodes
  - Implement OTA propagation for deployed devices using IoTempower or PlatformIO
  - Instrument logging and metrics; visualize evolving datasets in Grafana/Node-RED

- **Integration and Documentations**
  - Integrate nodes into a cohesive system
  - Build system-level dashboard and documentation
  - Record videos or photographs that demonstrate use cases
  - Write end-user guide or troubleshooting section

Review with instructors; revise design and improve robustness.


- **Testing and Validation**
  - Test edge cases (sensor failure, network latency)
  - Refine thresholds and alert logic
  - Perform live demos and collect feedback
  - Add robustness (watchdog timers, MQTT QoS 1, buffering on disconnect)



### Project Documentation - Portfolio Entry (Week ___)

Each team member must create a **portfolio entry** in your **personal GitHub repository** and link to the **team repository**. Include:

- **Project Description** with problem statement and solution overview
- **Installation Guide** with step-by-step instructions to reproduce the system
- **Architecture Diagram** (hand-drawn and photographed or rendered) showing:
  - MQTT topics schema
  - Node roles and sensors/actors
  - Network roles (gateway and clients)
  - Data flow diagram
- **Hardware BOM** with photos
- **Code Repositories** (firmware and Node-RED flows exports)
- **Dashboard Screenshots** showing real readings and alerts
- **Reflection** summarizing lessons learned, challenges, and improvements (per-person)
- **Video Demo** (or set of GIFs) showing each use case and user interaction
- **User Guide** for day-to-day operation and troubleshooting


Highlight key design decisions and creative solutions. Include links to repository and live dashboard.




### Final Project Presentation (Week ___)

Teams present a **10 minute live demonstration** focusing on impact and technical substance:
- **Problem and Context** (2 min)
- **System Architecture** (3 min)
  - Node roles, protocols, topics
  - Security and robustness choices
- **Live Demo** (3 min)
  - Show the system in action with real-time interaction; include all stakeholders’ personas if applicable
- **Reflection and Future Work** (2 min)

Presentations are assessed on clarity, technical depth, and delivery. Record a backup video in case of technical failure.



## Extra Content

Materials outside the core modules, kept for historical or elective use.


## Final Project Presentation

Guidelines and templates for preparing and delivering final project presentations as week 15 or 16 depending on syllabus schedule.


----

**Assessment weight and rubric:**
- Proposal quality and instructor feedback incorporation (10%)
- Technical execution and integration (40%)
- Documentation and reproducibility (30%)
- Presentation and communication (20%)

Adapt requirements to local course constraints and deliver as scheduled.