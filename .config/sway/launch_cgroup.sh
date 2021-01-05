#!/bin/bash

app_cleaned="$(echo $1 | sed 's/[^a-zA-Z]\+/_/g')"
exec systemd-run --user --scope --slice=app.slice --unit="app-sway-${app_cleaned}-${RANDOM}" "$@"
