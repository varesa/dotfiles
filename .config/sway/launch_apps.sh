#!/bin/sh

active_display=$(~/.config/sway/get_active_display.sh)

rofi -i -modi drun -show drun -m $active_display
