#!/bin/bash
set -euo pipefail

workspaces=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.type == "workspace").name' | grep -E '[0-9]{2}')

for workspace in $workspaces; do
    output_num=$(echo $workspace | cut -c 1)
    output=$(swaymsg -t get_outputs -p | grep Output | awk '{print NR-1 $s}' | grep "^$output_num" | cut -d ' ' -f 2)
    swaymsg workspace $workspace
    swaymsg move workspace to output $output
done
