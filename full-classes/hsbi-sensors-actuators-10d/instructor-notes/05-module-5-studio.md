# Module 5 Studio — LEDs & Light as Output

[Module 5](../modules/05-leds-and-light-output.md) · [All instructor notes](./README.md)

## Hardware prep

- One WS2812 strip per pod, a separate 5 V supply, common ground, and a ~330 Ω data resistor.
- **Do not hand out electrolytic capacitors as a required part.** The module treats bulk
  capacitance as optional. If you do provide them, use **10 V or 16 V**, mark the polarity, and
  check every one before power-on.
- A USB power meter per pod; one known-good strip and one known-good supply for triage.
- Decide whether to demonstrate a level shifter. Many 3.3 V boards work on a short strip, so do
  not make the shifter a blocker.

## The capacitor: theory vs classroom

**Theory.** A 100–1000 µF electrolytic across 5 V/GND is **bulk** capacitance. It supplies the
current bursts when many pixels switch and reduces supply droop and ringing. It is a reliability
margin for long strips, long supply leads, or weak supplies. Adafruit's guide recommends it for
exactly that reason.

**Practice.** It is not a functional requirement. A short strip on a good, short-wired supply often
runs without it. In a classroom, the failure modes are ugly and common:

- **reverse polarity** — a reverse-connected electrolytic can vent or explode;
- **6.3 V rating on a 5 V rail** — too little margin; use 10 V or 16 V;
- **inrush** — charging a large capacitor can trip a USB supply or make a spark;
- **live wiring** — a charged capacitor can discharge into the strip or the bench.

That is why this class **does not require** the capacitor. If a pod wants to test one, use a
correctly rated, correctly oriented part, power off while wiring, and treat it as an experiment.
Do not call it a “decoupling capacitor”: a 0.1 µF ceramic at an IC is decoupling; the 1000 µF
electrolytic is bulk.

**What to say if asked.** “The capacitor is not there to make the data work. It is a reservoir for
current bursts. On a short strip with a good supply you may not need it; if you use one, the
polarity and voltage rating matter more than the capacitance.”

## The other two parts

| Part | Job | Classroom rule |
|---|---|---|
| ~330 Ω series resistor in the data line | damps ringing, limits current into the first pixel | use it; cheap insurance, no drama |
| Level shifter (3.3 V → 5 V) | meets the WS2812 input spec (~0.7 × VDD ≈ 3.5 V) | 3.3 V often works on a short strip; do not make the shifter a blocker. If a strip is flaky, try a shifter before blaming the library |
| Bulk electrolytic | supply transient reservoir | optional; 10–16 V, correct polarity; omit if unsure |

## 1000 LEDs on one data line

The data line is not the limiting factor: each pixel regenerates the signal for the next one, so one
GPIO can address a long strip (1000 LEDs ≈ 30 ms per frame, ~33 fps). The limits are **power** and
**refresh time**:

- 1000 LEDs × 60 mA = **60 A** at full white — that needs multiple injection points and thick
  wires, not a bigger capacitor;
- voltage droop along the strip causes color shifts and resets; inject 5 V at both ends and, for
  long strips, the middle;
- the first pixel still needs a valid logic level; after that, the signal is regenerated.

If your room runs 1000 LEDs reliably without bulk capacitors, that is a valid result for that
supply and wiring. Teach it as “measure your supply and wiring”, not as “capacitors are useless”.

## Why the divergence exists

Theory describes worst-case reliability for a production installation: long cables, high current,
EMC, unknown supply. Practice is a classroom with short strips, a bench supply, and cheap parts.
The recommendation is **conditional**, and the conditions are what the AI answer omitted. The fix is
to teach the conditions and the failure modes — not to turn a margin into a mandatory part, or to
ban it outright.
