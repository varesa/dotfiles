#!/bin/bash
set -euo pipefail

workspaces=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.type == "workspace").name' | grep -E '^[0-9]')

for workspace in $workspaces; do
    swaymsg "workspace $workspace; exec ~/.config/sway/switch_workspace.sh 1"
    sleep 0.1
done
