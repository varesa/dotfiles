set -euo pipefail

outputs=$(swaymsg -t get_outputs -p | grep Output | wc -l)
active_display=$(~/.config/sway/get_active_display.sh)
new_workspace=$(echo -n '' | dmenu -m $active_display)
swaymsg rename workspace to $new_workspace

new_prefix=$(echo $new_workspace | cut -c 1)

if [[ "$new_prefix" =~ ^[0-$(($outputs-1))] ]]; then
    if [[ "$new_prefix" != $active_display ]]; then
        new_output=$(swaymsg -t get_outputs -p | grep Output | sed -n $((${new_prefix}+1))p | cut -d ' ' -f 2)
        swaymsg "move workspace to output $new_output"
    fi
fi
