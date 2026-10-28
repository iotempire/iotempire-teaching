# ===========================================================================
# FEEDBACK ROUND — <date> · <session / modules>
# ===========================================================================
#
# Nothing is decided today. Say it in the first minute:
#   "Nothing is decided today. I want one artefact and one sentence per
#    module. If it is not there yet, say 'not yet' and we move on."
#
# THE 12-MINUTE SLOT
#   0:00  NAMES: the pod writes its members' first names in "members" (30 s).
#   0-2   "Show me the one artefact you are proudest of, and name the goal."
#   2-4   "Now the other module: show it, or say 'not yet'."
#   4-7   One question, then one strength and one next step.
#   7-9   Write the line below. Call the next pod.
#   9-12  Transition. Move on the timer, not on the sentence.
#
# THE PEER ROUND BEFORE YOU (35 min)
#   12 min  Pod A presents   |  3 min switch + notes
#   12 min  Pod B presents   |  3 min reflections
#
# PORTFOLIO GATE (checked in the peer round, ~15 seconds per member)
#   [ ] own repository — from "Use this template", not a fork
#   [ ] can edit and commit — show the commit
#   [ ] can link — a relative link opens the right page
#   [ ] one entry per module, or a visible "not yet"
#
# QUESTIONS TO ASK (pick two or three; do not interview)
#   Portfolio   Which module entry is the weakest? What would you add?
#               Show me a commit you made yourself.
#   Artefacts   Which plan line told you the index was used?
#               Show me a defect you PROVED with a query.
#               Which constraint did you watch reject something?
#               What happens if you load the same file twice?
#               Why is this a database and not a spreadsheet?
#   Reflection  Which entry would you show an employer, and why that one?
#               What did you believe at the start that you no longer do?
#
# END WITH: two strengths, one gap, and one question you could not answer.
#           The last one goes to #sql-questions.
#
# NOT READY? 4 minutes: "not yet", one next step, move on. No rescue.
#
# FIELDS:  pod | members | gate | shown | not yet | next step
#   members         : FIRST NAMES ONLY — the pod writes them, in the first 30 s
#   gate            : ok / fix   (repo missing, cannot edit, cannot link)
#   shown / not yet : module numbers only ("M1, M2"), or "—"
#   next step       : ONE imperative sentence
#
# Examples:
# P03 | Ada, Ben, Chi | ok  | M1, M2 | M4 | bring the M2 orphan query and its plan
# P04 | Ada, Ben, Chi (abs: Dee) | fix | M1, M2 | M3 | Dee puts her notes in her own repo and links one entry
# ===========================================================================

P01 |  |  | M1, M2 |  | 
P02 |  |  | M1, M2 |  | 
P03 |  |  | M1, M2 |  | 
P04 |  |  | M1, M2 |  | 
P05 |  |  | M1, M2 |  | 
P06 |  |  | M1, M2 |  | 
P07 |  |  | M1, M2 |  | 
P08 |  |  | M1, M2 |  | 
P09 |  |  | M1, M2 |  | 
P10 |  |  | M1, M2 |  | 
P11 |  |  | M1, M2 |  | 
P12 |  |  | M1, M2 |  | 

# Add or delete lines to match the number of pods.
# Keep the peer-practice order, so the instructor can move front to back.

# ---------------------------------------------------------------------------
# Turn this file into a Markdown table later (bash/zsh):
#
#   { printf '| pod | members | gate | shown | not yet | next step |\n|---|---|---|---|---|---|\n'
#     grep -v '^#' feedback.txt | grep -v '^$' | sed -e 's/ *| */ | /g' -e 's/^/| /' -e 's/$/ |/'
#   } > feedback-table.md
#
# Or paste the lines into any spreadsheet and split on "|".
# ---------------------------------------------------------------------------
