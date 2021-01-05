#!/bin/bash

DIR="$HOME/.config/sway"

cmd="$(wofi -i --show drun --conf ${DIR}/wofi-drun-nolaunch.conf | sed 's/ \?%.//g' | tr -d '\n')"
swaymsg exec ${DIR}/launch_cgroup.sh "${cmd}"

# Legacy:
#active_display=$(~/.config/sway/get_active_display.sh)
#rofi -i -modi drun -show drun -m XWAYLAND$active_display
#wofi -i --show drun
