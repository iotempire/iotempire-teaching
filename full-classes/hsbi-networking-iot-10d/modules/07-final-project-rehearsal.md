# Module 7 – Final Project Rehearsal: Peer Feedback & Dry Runs

[← Back to Module 6](./06-power-latency.md) | [Quick module index](./00-index.md)

---

## 📌 Module Outcomes
By the end of this module, you will:
1. **Present** your IoT project progress to peers and instructors.
2. Provide and receive **constructive feedback** using a structured rubric.
3. **Course-correct** your project based on peer input.
4. Run **regression tests** to ensure system stability.

---

## 📚 Preparation (Homework – 30 min)

### 🛠 **Individually (Before Class)**
1. **Portfolio & Code**:
   - Push your **latest code**, **README**, and **2-page project report** to your GitHub portfolio.
   - Include:
     - Project title/tagline.
     - Block diagram (e.g., `sensor → ESP32 → MQTT broker → Dashboard`).
     - Challenges faced and how you overcame them.
     - Demo script (bullet points for your 5-minute presentation).
2. **Peer Review Preparation**:
   - Review **two peers’ projects** using the [Peer Review Rubric](#peer-review-rubric) below.
   - Write **3 questions** you want answered by your peers (e.g., "Does this software architecture scale?").


---

## 🛠 In-Class Lab: Project Presentations & Feedback

*Format:* **Lightning round presentations (5 min + 5 min feedback/critique)**

---

### **Step 1: Quick Setup (5 min)**
- Teams of 5–7 students reassemble.
- Each student sets up their **ESP32 + sensors/actors + MQTT broker** demo.
- Push **hourly check-in screenshots** to a shared drive (if instructor requests).

---

### **Step 2: Lightning Presentations (25 min total)**
*Order:* ABC rotates (1 = present first, recuse = skip to next round).

**Prompt for Presenters:**
"Convince your teammates this project could work in the real world. Focus on:*
- Who would use this? *Name a persona.*
- What’s the **core innovation**? (Doesn’t have to be tech—design, cost, simplicity.)
- What’s the **riskiest assumption**?
- Demo 1 thing—be it a sensor, UI, gateway report."

*Helpful time block:* (5 min per person)
1. **Title** (10 sec).
2. **Problem/solution** (60 sec).
3. **Demo** (120 sec—make it snappy!).
4. **Hurdles** (30 sec—what’s broke and how are you fixing it?).


---

### **Step 3: Peer Feedback Round (20 min)**
*Each listener fills out feedback forms for 2–3 teams (use the rubric below).*

**Peer Review Rubric** *(Score 1–5: 1 = poor, 5 = excellent. Midpoint = ‘needs work’)*

| Criterion                          | Score  | Notes                                                                                 |
|------------------------------------|--------|---------------------------------------------------------------------------------------|
| **Clarity of Value Prop**           |  1–5  | Is it easy to understand *why* this project matters? *Example: "This saves farmers 2 hrs/day."* |
| **Technical Feasibility**           |  1–5  | Can it be built in 2–3 weeks? Considered power, range, component costs.                |
| **Communication & Demo**            |  1–5  | Code runs? Prototype works? Visuals/aids (dashboard, video snippet) made sense.            |
| **Risk Management**                |  1–5  | Did they identify 1–2 risks and propose solutions? (Relates to Module 8 follow-up.)       |
| **Documentation**                   |  1–5  | Portfolio complete? Code readable? Tradeoffs documented?                              |

**Peer Comments:**
- What’s **1 strength** you’d build on?
- What’s **1 critical weakness** to address before demo day?
- What **1 resource/person** would help?

---

### **Step 4: Synthesis & Next Steps (10 min)**
*Instructor-led wrap-up.*

- **Tally up rubric scores**. Highlight **common themes**: e.g., "80% of projects lack power estimates!".
- **Crowdsource fixes:**
  - Example: "Team A, you need to mock your gateway’s power draw—borrow the USB power meter setup from Module 3."
- **Action Items:**
  - Each student writes 3 bullet points in their portfolio:
    - *What I’ll keep doing.*
    - *What I’ll change.*
    - *Who I’ll ask for help.*

---

## 📝 Portfolio Update This Week
Your **expanded reflection** (1–2 pages) should answer:

### **Project Synthesis**
1. **Value & Persona:**
   - Describe the **persona** who would benefit from your project (e.g., "urban gardener Lisa, 30s").
   - How does your system provide more **time/money/safety** than their status quo?
2. **Feedback Analysis:**
   - What **1 piece of feedback** from peers surprised you? Why?
   - What **1 strength** did 3+ peers highlight?
3. **Troubleshooting Reflect:**
   - What’s the **weirdest bug** you debugged this week? How did you isolate it?


---

### **Teamwork & Process**
4. **Collaboration Wins:**
   - How did **dividing up tasks** (e.g., sensor code vs gateway vs dashboard) affect your sprint?
   - What’s **1 workflow hack** that speeded things up? (e.g., `git pull --all`, `mosquitto_sub -t "#"`)
5. **Future Stewardship:**
   - What’s **1 module concept** you’ll review tonight to prep for final demo?
   - Who’s the **#1 person** on your team you’ll ping with last-minute questions, and how?


---

## 🔧 Regression Testing Checklist *(Save for Module 8)*
Before the final presentation, **re-run these tests** to ensure consistency across environments:

| Test                          | Check                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------|
| **Power Stability**           | Sensor broadcasts data after 24h idle at room temperature. Measures: <1% packet loss.          |
| **MQTT Broker Reliability**    | All subscribers reconnect and receive data w/ 0 errors on reboot.                          |
| **Gateway Latency**           | Median RTT under 2 sec (cold) to 0.5 sec (warm).                                       |
| **Range Stress**               | Low RSSI (-80 dBm), messages arrive.                                                     |
| **Backup Comm**               | If LoRa fails, WiFi fallback tested. Log results in `regression_test.log`.                  |

*Store scripts in your repo:* e.g., `regression_power.py`, `regression_mqtt.sh`.

---

## 📌 Resources & References
- **Peer Review Template:** Use this markdown block (copy/paste into your feedback doc).
- **Regression Script Ideas:** [ESP32 Power Saver Sketch](https://github.com/espressif/arduino-esp32/blob/master/libraries/ESP32/examples/ResetReason/ResetReason.ino)

---

## 📌 Next Steps
1. **Revise project** based on peer feedback (+ add regression test plan to portfolio).
2. **Prepare for Module 8**—final touches before presentation:
   - *Review:* [Final Project Demo Guide](https://docs.google.com/document/d/1ExampleDraft/edit) *(link to be added).*
3. **Final meetup:** Bring **hardware**, **portfolios**, and **regression test logs**.

---

*
Peer Review Rubric Template (Copy/Paste):*
```markdown
| Criterion | Score 1–5 | Notes |
|-----------|------------|------|
| Value Prop | _____ | ___ |
| Technical... | _____ | ___ |
| Communication... | _____ | ___ |
| Risk Mgmt... | _____ | ___ |
| Documentation... | _____ | ___ |

**Strengths:** _____

**Critical Weakness:** _____

**Who Can Help:** _____
```

*[Portfolio Template for Reflections](https://portfolio.iotempower.us)* (Use this template for your submission.)