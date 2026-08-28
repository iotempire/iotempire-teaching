# Module 1 – What’s Your IoT Story? Introduction and Critical OSI Exercise

[← Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-mqtt-abstraction.md)

---

## 📌 Module Outcomes
By the end of this module, you will:
1. Critically assess the **OSI model’s relevance** for modern IoT systems.
2. Design an **IoT project story** (system context, stakeholders, problem/solution).
3. Set up your **portfolio repository** and document your first reflections.
4. Understand the **course workflow**, tools, and team-based learning approach.

---
## 🎯 Node-RED Integration: The Gateway Dashboard (15 min)
Launch Node-RED on your gateway (<http://192.168.8.1:1880>) and:
1. Import [`01-hello-mqtt.json`](./flows/01-hello-mqtt.json) from the resource bank.
2. Change the MQTT broker address to your OpenWRT gateway (`192.168.8.1:1883`).
3. Power on your ESP32 and confirm the **temperature reading** appears on the dashboard.
   *Deliverable:* In your portfolio folder `01-intro/task-02-node-red`, save:
   - 1 screenshot of the Node-RED canvas.
   - 1 screenshot of the ESP32 serial console printing the MQTT publish line.

---
## 📚 Pre-Class Preparation (30 min max)
Complete these **before** the meetup. Take notes in your end-of-week reflection (`portfolio/01-intro.md`) using the [portfolio template](https://github.com/espressif/esp-iot-solution/blob/master/templates/README.md) style.

### 🎥 Watch (10–15 min total)
- **[Practical Networking: How Data Moves Through the Internet – Module 1 videos 1–3](https://www.practicalnetworking.net/index/networking-fundamentals-how-data-moves-through-the-internet/)** *(Ed Harmoush)*
  *Guiding Questions:*
  • Which **two layers of the OSI model** are often debated in real networks and why does Ed say they “glue” everything?
  • After the videos, redraw the **internet-edge cartoon** yourself in your portfolio and add one sentence about the **TCP/IP layer** that Ed skips in the video’s final slide.


- **RFC Readings (timeless):**
  • [RFC 1918](https://tools.ietf.org/html/rfc1918) – private IPv4 space you configure in your gateway
  • [RFC 3439 §3 “Layering Considered Harmful”](https://tools.ietf.org/html/rfc3439#section-3) – why strict OSI boundaries break in IoT loads.

---
### 📖 Read (10 min total)
- **[RFC 3439, Section 3: "Layering Considered Harmful"](https://tools.ietf.org/html/rfc3439#section-3)**
  *Focus:* The "Simplicity" principle—the internet’s builders rejected rigid layer boundaries.
- **[RFC 1958: "Architectural Principles of the Internet"](https://tools.ietf.org/html/rfc1958)**
  *Focus:* The **end-to-end principle**; why engineers value flexibility over strict layering.

---
## 🛠 In-Class Team-Based Learning (TBL) Exercise (45 min)
*Teams of 4–5 students. One recorder, one reporter.*

### **Task 1: The Layering Friction Challenge (20 min)**
**Your team’s goal:** Dissect a **real-world IoT packet trace** and map it to the OSI layers.

**Materials:**
- A **PCAP file** (provided in class) of an ESP32 sending:
  - Sensor data (`{"temp": 22.5, "hum": 45}`) via MQTT.
  - TLS-encrypted transport (WiFi+MQTT).

**Steps:**
1. **Whiteboard/Table Mapping**:
   - List all components of the trace (e.g., WiFi MAC frame, IPv6 header, TCP keep-alive, MQTT publish packet).
   - Assign each component to an **OSI layer (1–7)** on a shared board/digital canvas (e.g., Miro, Google Jamboard).
   - *Observe:* Where do **MQTT**, **TLS**, and **WiFi** clash with rigid layer boundaries?

2. **Overhead Tax Calculation (10 min):**
   - Calculate the **ratio** of:
     *(Headers + TLS overhead) / (Payload size)*
   - *Prompt:* If this sensor runs on a coin cell for 5 years, which layers are draining its battery?

3. **Debate (5 min):**
   - Is OSI a **functional engineering tool** or a **historical dictionary**?
   - *Hint:* Consider tools like Wireshark (does it respect OSI layers in its protocol tree?).

---
### **Task 2: IoT Project Storytelling (15 min)**
**Your team’s goal:** Craft a **2-minute "system story"** for a fictional (but plausible) IoT project.

**Prompt:**
> *"Explain your project to Grandma. Avoid jargon. Focus on:*
> - *Who uses it?*
> - *What problem does it solve?*
> - *How does it fit into a larger system? (e.g., smart home, factory floor)*"

**Example Story:**
> *"Each cow wears a collar with a tiny computer. The computer listens for when the cow is sick and tells the farmer’s phone ‘Call the vet!’ The collars talk to a central Raspberry Pi in the barn, which sends an alert via the internet to an app."*

**Why Storytelling?**
- Forces clarity on **stakeholders** and **user needs**.
- Highlights **interfaces** (e.g., cow collar → Pi → internet → farmer’s phone).

---
**Share + Discuss (10 min):**
- Each team presents their story **and** one OSI friction finding.
- Class votes: **Which story is most compelling? Why?**

---
## 🔧 Labs and Hands-On (Practical Work)
### **Lab 1: Portfolio Repository Setup**
1. **Create your portfolio repo** on GitHub:
   - Use [this template](https://portfolio.iotempower.us) or fork [iotempower-portfolio-template](https://github.com/iotempower/portfolio-template).
   - Share with instructors (add `ulno` as a reader).
   - Add a `README.md` with:
     - Your name/project title.
     - A link to your first reflection (see **Portfolio Reflection** below).

2. **Document your OSI exercise**:
   - Screenshot your team’s OSI trace mapping.
   - Add notes on where friction occurred (e.g., *"MQTT publish packets straddled Layer 5–7"*).

---
## 📝 Portfolio Reflection Prompts
Write **your individual reflection** (1–2 pages) in your portfolio *by the end of the day*. Address:

### **Technical Reflection**
1. **OSI Critique**:
   - What was the **hardest part** of mapping the packet trace to OSI layers? Did modern tools (Wireshark) respect OSI boundaries?
   - After this exercise, do you find OSI **useful** or **overly academic**? Justify your stance with examples from the trace or your project story.

2. **Protocol Discovery**:
   - Based on the pre-class videos, how would you explain **MQTT’s role** in IoT to a beginner?
   - What’s one **unexpected insight** about TCP/IP from the Hussein Nasser video?

---
### **Project Story Reflection**
3. **System Context**:
   - Describe your **fictional IoT project** (or a real one you’re considering).
   - Who are the **stakeholders**? What problem does it solve?
   - How did the storytelling exercise change your view of **interfaces** (e.g., sensor → gateway → user)?

---
### **Process Reflection**
4. **Teamwork**:
   - How did your team **divide labor** in the OSI exercise? Were there conflicts or standout contributions?
   - What’s one **communication win/lesson** from today?

5. **Future Steps**:
   - What’s **one module you’re most excited to explore** next? Why?
   - What **support do you need** from instructors/peers?

---
## 🎯 Why This Matters for IoT
- **OSI** teaches you *what could go wrong* in a system.
- **Storytelling** ensures your project has **clarity** and **user focus**.
- **TBL** leverages peer learning—critical for *Fachhochschule* collaboration.

---
## 📌 Next Steps
1. **Complete your portfolio reflection** (due by EOD).
2. **Prepare for Module 2** by reviewing:
   - [Pre-class video for MQTT mockups](https://www.youtube.com/watch?v=hzJ00SqJYeY) *(guiding Q: How does MQTT simplify device swapping?)*
3. **Next meetup:** Bring your **portfolio repo link** and **project idea** (even if vague)! 