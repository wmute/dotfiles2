#!/bin/sh

# replace caps key with escape 
setxkbmap -option caps:escape
# touchpad settings
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Accel Speed' 1
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1
# wallpaper
feh --bg-fill /home/wintermute/Pictures/anisotropy.png
# dwm status bar
dwmstatus 2>&1 >/dev/null &
