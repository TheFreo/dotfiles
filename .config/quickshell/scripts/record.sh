#!/bin/bash
notify-send "Start Recording"

wf-recorder -g "0,0 2016x1260" -f "$HOME/$(date +%Y-%m-%d_%H-%M-%S).mp4"
