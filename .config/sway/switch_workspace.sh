#!/bin/sh

display=$(~/.config/sway/get_active_display.sh)

swaymsg workspace ${display}${1}
