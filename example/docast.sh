#!/usr/bin/env bash

# Use xdotool to type commands to window doing screen cast
# ./docast.sh path/to/script

# search for window titled "Casting"
CASTING=$(xdotool search --name 'Casting')

# Die if CAST_WINDOW_ID not defined and Window title 'Casting' not found.
if [ -z ${CAST_WINDOW_ID} ] && [ -z ${CASTING} ]; then
  echo "CAST_WINDOW_ID is unset or empty, and window title "Casting" not found."
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "No arguments supplied. Expected path the script for casting."
  exit 1
fi

CAST_WINDOW_ID=${CAST_WINDOW_ID:-$CASTING}
# Default delay in milliseconds bewteeen keystrokes
TYPE_DELAY=${TYPE_DELAY:-100}
# Default delay in seconds before entering next line
LINE_DELAY=${LINE_DELAY:-3}

echo "typing to ${CAST_WINDOW_ID}"
xdotool windowfocus --sync ${CAST_WINDOW_ID}

while IFS= read -r LINE
do
  xdotool type --window ${CAST_WINDOW_ID} --delay $TYPE_DELAY "${LINE}"
  xdotool key Return
  sleep ${LINE_DELAY}
done < "$1"
