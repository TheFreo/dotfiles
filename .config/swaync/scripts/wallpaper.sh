#!/bin/bash

WALL_DIR="$HOME/Wall"
CACHE_DIR="$HOME/.cache/wall-thumbs"

mkdir -p "$CACHE_DIR"

for img in "$WALL_DIR"/*; do
    name=$(basename "$img")
    thumb="$CACHE_DIR/$name.png"

    if [ ! -f "$thumb" ]; then
        magick "$img" -thumbnail 300x200^ -gravity center -extent 300x200 "$thumb"
    fi
done

choice=$(for img in "$WALL_DIR"/*; do
    name=$(basename "$img")
    printf "%s\0icon\x1f%s\n" "$name" "$CACHE_DIR/$name.png"
done | rofi -dmenu -show-icons -p "Wallpaper")

if [ -n "$choice" ]; then
    awww img "$WALL_DIR/$choice" \
        --transition-type wipe \
        --transition-duration 1 \
        --transition-fps 60
fi
