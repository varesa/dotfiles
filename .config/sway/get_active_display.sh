#swaymsg -t get_outputs -p | grep Output | awk '{print NR-1 $s}' | grep focused | cut -c 1
swaymsg -t get_outputs -p | grep Output | cut -d ' ' -f 3- | sort | awk '{print NR-1 $s}' | grep focused | cut -c 1
