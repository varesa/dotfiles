#!/bin/bash

# If operating on a single ws fails for whatever reason, do our best to fix the rest
# instead of leaving everything in middle of two states
#set -euo pipefail

workspaces=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.type == "workspace").name' | grep -E '[0-9]{2}')

for workspace in $workspaces; do
    workspace_num=$(echo $workspace | cut -c 2)
    swaymsg workspace $workspace
    sleep 0.1

    output_num="$(./get_active_display.sh)"
    swaymsg rename workspace to tmp_$output_num$workspace_num
done

workspaces=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.type == "workspace").name' | grep -E '[0-9]{2}')
for workspace in $workspaces; do
    swaymsg workspace $workspace
    sleep 0.1
    swaymsg rename workspace to "$(echo $workspace | sed 's/tmp_//')"
done
