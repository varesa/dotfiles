#!/bin/sh

display=$(~/.config/sway/get_active_display.sh)

swaymsg move container to workspace ${display}${1}
