#!/bin/sh

# load x config
xrdb merge ~/.Xresources
# wallpaper
feh --bg-fill ~/Pictures/Wallpapers/1.png
# rebind caps to escape
setxkbmap -option caps:escape
# mouse speed and touchpad click
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Accel Speed' 1
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1
# redshift
redshift -l 40.7128:-74.0060 &
# compton compositor to reduce tearing
compton &
