#!/bin/sh


systemctl --user is-active alttab.service || (systemctl --user import-environment SWAYSOCK; systemctl --user start alttab.service)
swaymsg workspace $(cat $XDG_RUNTIME_DIR/sway_last_workspace)
