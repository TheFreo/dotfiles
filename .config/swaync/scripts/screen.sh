#!/bin/sh

sh_menu () {
 rofi -dmenu -l 0 -p "enter ip"
}

[ -n "$*" ] && query="$*" || query=$( sh_menu )
[ -z "$query" ] && exit 1
query=$(printf '%s' "$query" | tr ' ' '+' )

adb connect 100.98.44.84:5555

scrcpy --turn-screen-off --require-audio
