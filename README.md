# Teaching Internet of Things (IoT) the IoTempower Way

> **Development note:** This top-level document is actively maintained. If you spot an error or want to add your class/workbook, open a pull request!



## Welcome

Welcome to teaching and learning the IoTempower way. The IoTempower framework has been developed to support educators and students alike in exploring the world
of connected devices, systems, and the challenges they address. Here you find all our teaching
material and learning resources in a central point.

Our course, “The Internet of Things,” is an engaging, hands-on course that bridges the virtual and physical to impact positive change. The course caters to different learning needs with flexible formats: Express (4h) Workshop, Intensive (16h) Workshop, and Full Course (60h guided, 20-40h unsupervised). Starting from the 16h version, we cover core topics of storytelling, basic electronics, IoT architecture, machine-to-machine communication, and exploring open-source IoT integration using Node-RED, all within our fully open-source and in-house developed IoT teaching framework - IoTempower (<https://github.com/iotempire/iotempower>).

We advocate that challenge-based education (CBE) allows students to work with the technology themselves and apply it to real-world problems. Our students have a chance to truly understand IoT’s strengths and weaknesses and its potential to help us deal with today’s challenges in creative, innovative, collaborative, and communicative ways. We foster an inclusive course mindset, promoting storytelling, exploration, and working with failure (which we will frame positively as exploration) as part of the learning process. We emphasize collaborative team and group work and encourage critical reflection, with no differentiation between labs and lectures. From the start, students experiment with hardware, programming, and networking aspects of IoT, bridging the gap between the virtual and physical worlds through prototyping.

## Course Elements

The core sessions include storytelling and story-driven development, basic electronics, networking, communication protocols, IoT architecture, and exploring open-stack integrations using Node-RED, all seamlessly enabled within the umbrella IoTempower framework. All the software used in our course (including the IoTempower framework itself) is open-source and relies only on libraries with permissive licenses, making it a solution that is affordable and easy to replicate. Our students can even turn their projects into commercial products without any license restrictions.

**Available Workbooks/Courses**

We provide several comprehensive workbooks that serve as the foundation for our IoT courses, each tailored to different formats and contexts:

- [University of Tartu (UT) IoT Introduction Workbook (15-16 weeks)](full-classes/unitartu-IoT-intro-15d/README.md): A modular, 16-week class designed for in-depth exploration of IoT concepts. This workbook is split into per-module files for easier maintenance and covers a structured progression from introduction to final projects. It is ideal for semester-long courses.

- [HSBI/GT Lab Tutorials Workbook (4 days)](full-classes/hsbi-MCU-programming-blocked-4d/README.md): A condensed four-day block format designed for intensive workshops. This workbook adapts material from the UT version to fit a shorter timeframe, with a stronger emphasis on MCU programming and embedded systems while maintaining IoT as an application context.

- [HSBI/GT Microcontroller Programming (10-day extended edition)](full-classes/hsbi-MCU-programming-10d/README.md): A local-first MCU and IoT course delivered over ten weeks, from basic electronics through multi-node final projects.

- [HSBI/GT Networking and IoT Solutions (10 weeks)](full-classes/hsbi-networking-iot-10d/README.md): A local-first networking and integration course: TCP/IP and OpenWrt edge gateways, mesh and overlay networks (B.A.T.M.A.N., Nebula, Yggdrasil), MQTT, ESP-NOW, industrial bridging (OPC-UA/Modbus), and IoTempower fleet management, culminating in a multi-node final project.

- [HSBI/GT Sensors and Actuators (10 days)](full-classes/hsbi-sensors-actuators-10d/README.md): A hands-on sensors and actuators course: measurement technique and uncertainty, I²C and sensor addressing, sensor characterization and calibration, distance/motion/environment sensors, LEDs and LED animation, servos and other motors, and IoTempower-based sensor/actuator systems with a characterized final project.

- [Mastering IoT Solutions – Hands-On Workshop (2–3 h)](workshops/mastering-iot-solutions/README.md): The hands-on Day 1 master class (M5StickC, Node-RED, and the local IoTempower stack) exploring IoT solutions from a business and implementation perspective.

- [Magic Wands – Edge & Voice Computing Workshop (4–16 h, draft)](workshops/magic-wands-edge-computing/README.md): Voice- and gesture-driven IoT using an M5StickC, a local Whisper speech-to-text server, and Node-RED. Note: This is currently in **draft stage** - content may be incomplete.


We introduce the IoTempower framework early in the class to allow rapid prototyping and quick success, which keeps students motivated to learn more. Once the students have experienced key IoT development tools (after about 50 to 70% of the class), they start designing and then implementing their final project. Starting from stories, students describe a challenge inspired by a real-world problem and work towards constructing a feasible solution. Guest speakers from industry and academia highlight different problem domains to help guide the students in picking and describing challenges for their final projects.

We also provide modular workshops that can be slotted into a program: the **Mastering IoT Solutions** master class and the **Magic Wands** edge/voice-computing AI-lab. See the subfolders in `/workshops` for details.

## Learning Tools & Classroom Environment

We provide a community channel that allows all students studying IoT to profit from each other across university and country boundaries. After several tries and discussions with students, we use Discord in the Tartu, Linz, and Regensburg case and open that for any teacher else approaching us. However, other chat environments should work as well but will lose the networking effect with other students and teachers being involved in IoTempower.

We also provide slides and resources to help with technical challenges or supporting discussions. We are continually creating new video material to support upcoming technical challenges. Chatbots of large language models (LLMs) like ChatGPT, Copilot, or Gemini also enhance our class learning experience by speeding up individual and team in-class research tasks. They also enrich our discussions by allowing us to critically reflect on their answers and suggestions.

In our course, we embrace the idea that hands-on experiences are crucial for the learning process. We provide a kit with sensors, actuators, cables, power supplies, a gateway, and microcontrollers to each student team. We paid special attention to selecting each kit component, prioritizing affordability and ease of sourcing in most regions worldwide. This approach equips each team with a truly practical experience as they can control every aspect of their network and do not have to depend on resources and services (from the university or the cloud) outside of the scope of their group.

I offer several classes in the area of the Internet of Things (IoT).
Teaching material is generally publicly available.
If you want to teach a class, feel free to use the published material, but give attribution to IoTempower and Ulrich Norbisrath.

Initially, I taught these classes based on different sets of material, but we are now using a more unified material base. We also depend more and more strongly on my IoTempower teaching framework.

## For Instructors

Each class folder ships a `generate-lms-pdfs.sh` wrapper that renders its `syllabus.md` and `pre-study.md` into dated, upload-ready LMS PDFs via the shared generator [`tools/generate-lms-pdfs.sh`](tools/generate-lms-pdfs.sh). LibreOffice is used by default (it also leaves an editable `.odt`); Pandoc, headless Chromium, and LaTeX are fallbacks. Run it from a class folder, or point the tool at any class with `--class-dir`. To add the exports to a new class, see [`tools/README.md`](tools/README.md).

---

## References & Resources

References and resources include IoTempower, IoT stories, hardware details, and external references.

- [IoTempower](https://github.com/iotempire/iotempower)
- [YouTube playlist](https://www.youtube.com/@ut-teaching-ulno)
- [Discord](https://discord.com/channels/1064132619735928932/1064132620398637148)
