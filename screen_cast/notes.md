# Creating an animated SVG from terminal recording

1. Copy or symlink to Alice vignette in vert-ramp-affirmations
    - performance.csv
    - annotations.r
    - spek.json
1. Create pseudoterminal window (gnome terminal)
2. Rename terminal to "Casting"
3. Navigate to bitstomach/demo directory
4. Create a new terminal
5. Navigate to bitstomach/demo directory
6. Record terminal activity, Run `./custom_docast.sh` from new terminal
    This will focus and type into Casting terminal.
7. Allow to run to completion.  DO NOT CHANGE WINDOW FOCUS.
8. Convert asciicast to svg: `termtosvg render demo.cast demo.svg`  
