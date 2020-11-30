#!/usr/bin/env bash

# Content and casting typing commands combined.
# THE TARGET WINDOW MUST BE IN THE CORRECT DIRECTORY TO RUN & RECORD THE DEMO!!
# The geometry of the target window is recorded.

CASTING=$(xdotool search --name 'Casting')
CAST_WINDOW_ID=${CAST_WINDOW_ID:-$CASTING}
FAST_DELAY=55
NORM_DELAY=120
CAST_FILE='demo.cast'


function fast_content {
  xdotool type --window ${CAST_WINDOW_ID} --delay $FAST_DELAY "${1}"
  sleep .1
  xdotool key Return
}

function norm_content {
  xdotool type --window ${CAST_WINDOW_ID} --delay $NORM_DELAY "${1}"
  sleep .2
  xdotool key Return
}

##################
# Setup Casting  #
##################
echo "typing to ${CAST_WINDOW_ID}"
xdotool windowfocus --sync ${CAST_WINDOW_ID}
# Use aciinema
xdotool type --window ${CAST_WINDOW_ID} "asciinema rec --overwrite ${CAST_FILE}"

# ALTERNATE CASTING RECORDING OPTIONS:

# Use termtosvg directly
# xdotool type --window ${CAST_WINDOW_ID} "termtosvg out.svg"

# Use ttygif
#xdotool type --window ${CAST_WINDOW_ID} "export WINDOWID=${CAST_WINDOW_ID}"
#xdotool key Return
#xdotool type --window ${CAST_WINDOW_ID} "ttyrec demo.rec"

# Sends return to start recording
xdotool key Return
sleep 2.0

##############################
# Begin Casting Instructions #
##############################

read -r -d '' TITLE <<'HEREDOC'
#    ____  _ _       _                             _
#   |  _ \(_) |     | |                           | |
#   | |_) |_| |_ ___| |_ ___  _ __ ___   __ _  ___| |__
#   |  _ <| | __/ __| __/ _ \| '_ ` _ \ / _` |/ __| '_ \
#   | |_) | | |_\__ \ || (_) | | | | | | (_| | (__| | | |
#   |____/|_|\__|___/\__\___/|_| |_| |_|\__,_|\___|_| |_|
#
HEREDOC
xdotool type --window ${CAST_WINDOW_ID} --delay 2 "${TITLE}"
xdotool key Return

read -r -d '' CHUNK <<'HEREDOC'
# Let's examine performance data about Alice
cat performance.csv
HEREDOC
norm_content "${CHUNK}"
sleep 2
norm_content "# The data has Alice and three other performers."
sleep 4

xdotool key Return
read -r -d '' CHUNK <<'HEREDOC'
# Let's look at the measure description in spek
jq '."slowmo:IsAboutMeasure"' spek.json
HEREDOC
norm_content "${CHUNK}"
sleep 2
norm_content "# The psdo_0000095 type indicates the comparator is a social comparator."
norm_content "# That indicates the mean performance of the performers will be used for comparison." 
sleep 4

xdotool key Return
read -r -d '' CHUNK <<'HEREDOC'
# Let's look at the performance data description in spek.json
jq '."slowmo:InputTable"."csvw:tableSchema"' spek.json
HEREDOC
norm_content "${CHUNK}"
sleep 3
norm_content "# This gives the names of columns and their uses."
norm_content "# This information will be used when running the annotations."
sleep 3

xdotool key Return
read -r -d '' CHUNK <<'HEREDOC'
# Examine the math behind an assertion in annotations.r
head -n 72 annotations.r | tail -n 14
HEREDOC
norm_content "${CHUNK}"
sleep 3
fast_content "# The double bang !! is what allows us to use the names of columns from the spek."
fast_content "#   It is an rlang feature to evaluate part of an expression before the entire thing."
fast_content "#   In this case, it's allowing variable symbol injection."
norm_content "#   That makes re-using annotations between clients MUCH easier."
sleep 5

xdotool key Return Return
read -r -d '' CHUNK <<'HEREDOC'
# Let's create annotations of the performers based on performance data and configuration.
bitstomach.sh -h
HEREDOC
fast_content "${CHUNK}"
sleep 4
norm_content "bitstomach.sh -s spek.json -a annotations.r -d performance.csv > output.json"
sleep 2
norm_content "# It is done and has written content to output.json"

xdotool key Return
read -r -d '' CHUNK <<'HEREDOC'
# Examine the updated spek output for performcer, Alice.
jq '."http://example.com/slowmo#IsAboutPerformer"[] | select(."@id" == "_:pAlice")' output.json
HEREDOC
norm_content "${CHUNK}"
sleep 4
norm_content "# There are two annotations made about Alice: psdo_0000095 and psdo_0000104."
sleep 3

read -r -d '' CHUNK <<'HEREDOC'
# psdo_0000095 means social comparator content.
#  This was given by the spek.json measure description.
HEREDOC
fast_content "${CHUNK}"
sleep 2

read -r -d '' CHUNK <<'HEREDOC'
# psdo_0000104 means positive performance gap.
#  This was determined from the performance data.
HEREDOC
fast_content "${CHUNK}"
sleep 3

xdotool key Return Return
read -r -d '' CHUNK <<'HEREDOC'
# That's it. 
# The output.json is a copy of spek.json with annotations about performers added in.
# It is suitable input for the next program in the pipeline.
HEREDOC
norm_content "${CHUNK}"
sleep 4

##################
# END Casting  #
##################

xdotool type --window ${CAST_WINDOW_ID} "exit"
xdotool key Return
