# Portfolio Prompts Bank – Networking and IoT Solutions

*Use these prompts to guide your reflections. You may choose any 5 prompts per moodule (mix technical, project, and process).
Write 1–2 paragraphs per answer; include screenshots, logs, or code snippets where relevant.*

[↩ Back to Resources Bank](./Z-resources-bank.md)  [↩ Back to Module Index](./00-index.md)

---

## 📌 Module 1 – What’s Your IoT Story?
*Focus: OSI critical exercise, system storytelling, teamwork*


1. **Technical:** *How did the OSI trace exercise change your view of networking layers?* Focus on where the real-world packet didn’t fit the 7-layer box. Share your best OSI mapping screenshot.

2. **Project Context:** *If your IoT project were a movie, what genre would it be?* (Horror vs Rom-Com vs Documentary) Explain with stakeholders and ecosystem fit.

3. **Process:** *What was 1 communication win or conflict in your team during the OSI exercise?* Was reciting RFC 3439 a team hero moment or a snooze-fest?


4. **Technical:** *Calculate the overhead tax* (headers size / payload) from your MQTT/TLS trace. What’s the surprise ratio?

5. **Project Context:** *Describe your IoT project story: Who uses it, what problem does it solve?* Keep it to one paragraph; target “grandma-level” clarity.

6. **Hybrid:** *Plot RTT (cold start):* Capture your ESP32 wake-to-first-pub using **millis() timestamps**. How did deep sleep affect cold-start time compared to Module 2 active loop?



---

## 📌 Module 2 – MQTT Up-Front: Mocking Devices
*Focus: Mocking, abstraction, swapping components, workflow*


1. **Technical:** *What’s the most surprising snippet of MQTT client code you wrote in 10 lines?* Include the line in a fenced block and one-sentence “why it shocked you” note.

2. **Project Context:** *Where would you deploy your mock system in the real world?* (smart office, vertical farm, city bike-shed). Sketch one bullet per environmental factor.

3. **Process:** *What’s 1 workflow hack (e.g., `git pull --all`, squash commits) that improved your repo hygiene?* Explain with before/after.
4. **Hybrid:** *Swap virtual sensor → ESP32:* Share a **side-by-side code diff** of your Python mock and final Arduino. What stayed the same?
5. **Technical:** *How does MQTT’s pub/sub reduce integration friction compared to REST?* Cite one specific pain avoided (e.g., authentication, retries).
6. **Project Context:** *What would break in your mock system if tomorrow’s WiFi password rotated?*



---

## 📌 Module 3 – Wireless IoT: Fat vs. Fit
*Focus: Power profiling, latency tests, range, tradeoffs*


1. **Technical:** *Which protocol wins (WiFi or LoRaWAN) for your prototype—and why?* Back it with your power vs latency data table.
2. **Project Context:** *Who is your project’s primary stakeholder?* Sketch their needs in two bullet points (cow-farmer? city traffic admin?)
3. **Process:** *Did pair debugging the power profile clarify or fuzz the results?*
4. **Hybrid:** *Plot RTT vs supply current:* Display a scatter of WiFi (average 50 mA) vs LoRaWAN (average 23 mA). Circle the “acceptable cold start” threshold you set for the stakeholder.
5. **Technical:** *How did RSSI jump or drop in your on-site test?* Screenshot Wireshark showing ±15 dBm swing; add one sentence on possible cause.
6. **Project Context:** *What happens if your stakeholder tomorrow needs 10 km line-of-sight and sub-second latency?*



---

## 📌 Module 4 – Gateways & Routing
*Focus: Pi as gateway, NAT/firewall, zero-conf, routing*


1. **Technical:** *Why did NAT or firewall fail silently in your testbed?* Include router screenshot or `iptables` scrolled log zone.
2. **Project Context:** *How does your Raspberry Pi gateway improve system reliability for the stakeholder?* Contrast LAN-only vs. WAN-exposed.
3. **Process:** *What’s 1 terminal trick (e.g., `netstat -tulnp`) you taught a teammate this week?*
4. **Hybrid:** *Plot RTT (Pi gateway) vs Module 3 base:* Run identical latency test through Pi. Subtract endpoint-to-pi time; what’s the gateway overhead?
5. **Technical:** *What’s zero-conf discovery saving in your lab?* (`raspberrypi.local` names) vs static IPs.
6. **Project Context:** *What happens if indoor site loses WAN fallback tomorrow?* Design one phone-tree escalation step.



---

## 📌 Module 5 – Industrial Protocols (Optional)
*Focus: OPC-UA vs. Modbus, translation layers, legacy systems*


1. **Technical:** *How would you explain an OPC-UA “node” to a Modbus veteran?* Use analogies.
2. **Project Context:** *Where does your system break if factory IT bans MQTT entirely next week?* How would you pivot?
3. **Process:** *If you had another 30 min, what would you add to your translation layer?* (e.g., caching, security)
4. **Hybrid:** *Plot bridge latency:* Measure Node-RED translating OPC-UA → MQTT. What’s the translation overhead in ms?
5. **Technical:** *What’s 1 pain point translating JSON fields into 32-bit Modbus registers? Confess.*
6. **Project Context:** *What’s the fallback interface if OPC-UA server/discovery fails?*



---

## 📌 Module 6 – Power & Latency Optimization
*Focus: Deep sleep, duty cycle, battery life, stability*


1. **Technical:** *What single line of code or hardware trick saved ≥30 mAh in your project?* Include diff and screenshot before/after.
2. **Project Context:** *How would you redesign your project if the battery quadrupled to 2000 mAh?* Footprint, sensors, cost trade-off sketch (one paragraph)
3. **Process:** *What unexpected power bug (e.g., `Serial.begin()` sleeping 50 µA drain) did you discover?*
4. **Hybrid:** *Plot threshold tolerance:* Compare your RTT **cold-start** with trigger every 60 s vs 300 s. Where does the stakeholder feel their latency threshold is smashed?
5. **Technical:** *Why is frequency scaling (changing MCU clock 240 MHz → 80 MHz) often unused in IoT?* Your informed opinion plus microamp numbers.
6. **Project Context:** *What’s 1 nightmare deployment scenario for your project?* (e.g., 200 m underground, -20°C weather) add power mitigation.



---

## 📌 Module 7 – Final Project Rehearsal
*Focus: Peer feedback, dry-runs, regression tests*


1. **Technical:** *What’s 1 strength in your project your peers praised?* Back it with 1 line of code or diagram.
2. **Project Context:** *What’s 1 risk you’ll address before final demo?* How did peer feedback surface it?
3. **Process:** *What’s 1 hack or refactor (e.g., clean Makefile) that polished your repo for presentation?*
4. **Hybrid:** *Plot regression test pass:* Re-run RTT test and power consumption. Compare logs to Module 3 baseline. Any regression?
5. **Technical:** *What’s your final threshold benchmark for acceptance?* (RTT <2 s, battery ≥180 days, etc.)
6. **Project Context:** *What would you drop from your project if time runs out?* (Be emotionally honest)
7. **End-to-End Lesson:** *Across Modules 1–7, what’s the single most important insight you’ll take into your final project demo?*  Share the “aha” moment and what you changed because of it.


1. **Technical:** *What’s 1 strength in your project your peers praised?* Back it with 1 line of code or diagram.
2. **Project Context:** *What’s 1 risk you’ll address before final demo?* How did peer feedback surface it?
3. **Process:** *What’s 1 hack or refactor (e.g., clean Makefile) that polished your repo for presentation?*
4. **Hybrid:** *Plot regression test pass:* Re-run RTT test and power consumption. Compare logs to Module 3 baseline. Any regression?
5. **Technical:** *What’s your final threshold benchmark for acceptance?* (RTT <2 s, battery ≥180 days, etc.)
6. **Project Context:** *What would you drop from your project if time runs out?* (Be emotionally honest.)



---

### 🧩 Using This Bank (Quick Guide)
- Pick **any 5 prompts per module** (mix technical, project context, process).
- Aim for **1–2 paragraphs each**; include screenshots/csv/code snippets where relevant.
- Autogenerate **title headers** like
  `## Module 4 – Prompt 1 + Prompt 5: NAT Fail, H-W Diag`

- Reuse prompts across modules to **build a narrative** (e.g., “grandma-level clarity” appears in Module 1, refined in Module 7).

- Add **personal voice**: make it yours.

---

*Your reflections are your story—tell it, critique it, and grow from it.*

[↩ Back to Resources Bank](./Z-resources-bank.md)