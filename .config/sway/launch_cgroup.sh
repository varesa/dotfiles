#!/bin/bash

# MemTotal in KB -> *1000 to bytes -> /100 to percents
# *1000/100 = *10
mem_percent="$(($(awk '/MemTotal/ {print $2}' /proc/meminfo) * 10))"

mem_high="$(($mem_percent * 50))"
mem_max="$(($mem_percent * 75))"

app_cleaned="$(echo $1 | sed 's/[^a-zA-Z]\+/_/g')"

exec systemd-run \
    --user --scope \
    --slice=app.slice --unit="app-sway-${app_cleaned}-$$-${RANDOM}" \
    -p MemoryHigh="$mem_high" -p MemoryMax="$mem_max" \
    "$@"
