#!/bin/env python3

import subprocess
import json

tree = json.loads(subprocess.check_output(['swaymsg', '-t', 'get_tree']))

def handle_container(con):

    windows = []

    if 'app_id' in con.keys():
        app_id = con['id']
        app_name = con['app_id'] if con['app_id'] else con['window_properties']['class']
        app_title = con['name']

        windows.append((app_id, app_name, app_title,))

    for child in con['nodes']:
        windows = windows + handle_container(child)

    return windows

windows = []

for output in tree['nodes']:
    for workspace in output['nodes']:
        if 'nodes' not in workspace.keys():
            continue

        for container in workspace['nodes']:
            windows = windows + handle_container(container)

windows_string = '\n'.join([f"<{app_id}> {app_name} --- {app_title}" for app_id, app_name, app_title in windows])


selection = subprocess.check_output(['rofi', '-dmenu', '-i'], input=windows_string, universal_newlines=True)
window_id = selection.split(' ')[0][1:-1]
subprocess.check_output(['swaymsg', f"[con_id=\"{window_id}\"]", 'focus'])
