# Feedback round — <date> · <session / modules>

# One line per pod. Fill during the round, not afterwards.
# Fields:  pod | members | gate | shown | not yet | next step
#   gate            : ok / fix   (portfolio missing, cannot edit, cannot link)
#   shown / not yet : module numbers only ("M1, M2"), or "—"
#   next step       : ONE imperative sentence
#
# Examples:
# P03 | Ada, Ben, Chi | ok  | M1, M2 | M4 | bring the M2 orphan query and its plan
# P04 | Ada, Ben, Chi (abs: Dee) | fix | M1, M2 | M3 | Dee puts her notes in her own repo and links one entry
#
# `gate` comes from the peer practice round: every member opens their own
# portfolio, edits a line, commits, and shows a working relative link.

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

# ---------------------------------------------------------------------------
# Turn this file into a Markdown table later (bash/zsh):
#
#   { printf '| pod | members | gate | shown | not yet | next step |\n|---|---|---|---|---|---|\n'
#     grep -v '^#' feedback.txt | grep -v '^$' | sed -e 's/ *| */ | /g' -e 's/^/| /' -e 's/$/ |/'
#   } > feedback-table.md
#
# Or paste the lines into any spreadsheet and split on "|".
# ---------------------------------------------------------------------------
