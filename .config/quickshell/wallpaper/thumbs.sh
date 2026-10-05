#!/usr/bin/env bash

DIR="$1"
CACHE="$2"

mkdir -p "$CACHE"
shopt -s nullglob nocaseglob

for img in "$DIR"/*.{jpg,jpeg,png,webp,bmp,gif}; do
  name=$(basename "$img")
  thumb="$CACHE/$name.png"

  [ "$thumb" -nt "$img" ] && continue

  magick "${img}[0]" -thumbnail 300x200^ -gravity center -extent 300x200 "$thumb" &
  while [ "$(jobs -rp | wc -l)" -ge 4 ]; do wait -n; done
done
wait
