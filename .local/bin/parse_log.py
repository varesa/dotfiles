#!/bin/env python3

import sys
import math
import datetime


def get_date(time):
    return datetime.datetime.fromtimestamp(time).isoformat()


def format_time(time):
    if time < 60:
        return f"{time} seconds"
    if time < 15*60:
        minutes = math.floor(time / 60)
        seconds = time - minutes * 60
        return f"{minutes} minutes, {seconds} seconds"
    if time < 60*60:
        minutes = round(time / 60)
        return f"{minutes} minutes"
    return str(time)


last_time = None

while True:
    line = sys.stdin.readline().strip()
    if not line:
        break

    time, message = line.split(' ', maxsplit=1)
    time = int(time)

    if last_time:
        delta = time - last_time
        print(f"{get_date(time)} - {message} [{format_time(delta)}]")
    else:
        print(f"{get_date(time)} - {message}")

    last_time = time

