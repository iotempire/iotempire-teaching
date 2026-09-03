# Module 6 – IoT Systems

[← Previous: Module 5](./05-integration-and-simulations.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-final-project.md)


## Scaling IoT Systems

IoT Systems are more than assembling sensors, nodes, and networks. As your projects grow from single-node prototypes to multi-node, multi-user systems, key challenges surface: manageability, resilience, security, and visualization. In this module, you explore the "why" and "how" of scaling: how to compose multiple node types, integrate loosely-coupled services, and maintain operational visibility.

**Topics addressed:**
- User Management and Authentication (basic)
- Metrics collection, retention, anomaly detection
- Distributed state and failover patterns
- Service Discovery and Health monitoring
- Multi-node coordination and cluster management (intro)
- Interoperability with third-party services/APIs


Learn about monitoring tools like InfluxDB for time-series data and Grafana for dashboards.


## IoTempower as Device Management Framework

IoTempower provides server-side tooling to ease managing fleets of IoT nodes. Learn its patterns:
- Environment setup and management
- Config file templates and per-node customization
- OTA updates across nodes
- Firmware signing and rollback
- Node discovery via discovery service topic (`iotempower/discovery`)
- Multiple gateways and redundant routes
- Service orchestration and failure recovery

**Pre-Task:**
Install IoTempower on your development machine and create a folder `~/iotempower/systems/workgroupX` following the [GetStarted guide](https://github.com/iotempire/iotempower#getstarted). Familiarize yourself with commands `iot env`, `iot service start`, and `iot conf help`.


### Task 1: Creating Your First IoT System

Using your existing gateway/router and Node-RED install, create a new system folder using the IoTempower scaffold.

- Initialize a system folder with `iot init workgroupX`
- Add one ESP8266 node (with button and LED) and one ESP32 node (with temperature sensor).
- Configure device settings in `devices/` and `nodes/` configuration files
- Apply initial firmware image via OTA using `iot node flash` or serial for the first firmware
- Verify device appears on the discovery topic
- Gather node metrics (`heap`, `rssi`, `uptime`) and visualize in Node-RED dashboard or Grafana

Reflect on what discovery and metrics mean for maintainability.


### Task 2: Second Node

Replicate your setup with a second identical node. Update system configuration so both nodes share GPIO pins and topics but adapt behavior via environment variables in `device.conf` files. For instance:
- Node A publishes to `env/workgroupX/room1/temperature`
- Node B subscribes to `env/workgroupX/room1/#` to blink LED when temperature ≥ threshold

- Use `iot service health` to visualize heartbeat and warn if a node stops communicating


Document how you compartmentalized configuration per environment.


### Task 3: Rebuild access control system with IoTempower (4+ nodes)
Pick an earlier solution and refactor it to run under IoTempower:
- Refactor Node-RED flows to use environment variables (`$WORKGROUP`, `$NODEID`)
- Add RFID node, motion node, OLED node, and LED-status node
- Put system under OTA update control, with each orchestrated deployment using `iot node deploy`
- Add logging metrics to InfluxDB via MQTT listener `iotempower/metrics/#`; visualize with Grafana
- Set thresholds and alerts (e.g., motion detected outside business hours → alert via broadcast topic)


This task emphasizes "live at scale" maintenance: swap out a misbehaving device or push an emergency rollback build without classroom disruption.


----

**Notes:** In a university context, this module may be optional or adapted based on time and hardware availability.