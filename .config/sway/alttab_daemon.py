#!/usr/bin/python3

import asyncio
import json
import os
import signal
import sys
import swayipc


async def shutdown(s, loop):
    if "connection" in state:
        await state["connection"].close()
    for task in [t for t in asyncio.all_tasks() if t is not asyncio.current_task()]:
        task.cancel()
    loop.stop()


async def main():

    # Open subscribe IPC connection
    state["connection"] = await swayipc.subscribe(["workspace"])
    connection = state["connection"]
    response = await connection.receive_json()
    if not response["success"]:
        print("Could not open IPC connection to Sway", file=sys.stderr)
        sys.exit(1)

    # Loop forever
    try:
        while True:

            # Get events from connection
            event = await connection.receive_json()

            # Skip events that aren't focus events
            if event["change"] != "focus":
                continue

            outputs = await swayipc.get_outputs()
            current_workspaces = []
            for output in outputs:
                current_workspaces.append(output['current_workspace'])

            filename = os.path.join(os.environ['XDG_RUNTIME_DIR'], 'sway_workspaces')
            if os.path.isfile(filename):
                with open(filename, 'r') as f:
                    old = json.load(f)

                old_workspaces = old['workspaces']
                for old_workspace in old_workspaces:
                    if old_workspace not in current_workspaces:
                        last_filename = os.path.join(os.environ['XDG_RUNTIME_DIR'], 'sway_last_workspace')
                        with open(last_filename, 'w') as f:
                            f.write(old_workspace)

            with open(filename, 'w') as f:
                json.dump({
                    "workspaces": current_workspaces
                }, f)

    except json.decoder.JSONDecodeError:
        pass


state = {}
loop = asyncio.get_event_loop()
signals = (signal.SIGHUP, signal.SIGTERM, signal.SIGINT)
for s in signals:
    loop.add_signal_handler(s, lambda s=s: asyncio.create_task(shutdown(s, loop)))

try:
    loop.run_until_complete(main())
finally:
    loop.close()
