#!/bin/sh

WALLPAPER_DIR="$HOME/Wall"
INDEX_FILE="$HOME/.wallpaper_index.txt"

if [ ! -f "$INDEX_FILE" ]; then
    echo 0 > "$INDEX_FILE"
fi

CURRENT_INDEX=$(cat "$INDEX_FILE")

WALLPAPERS=("$WALLPAPER_DIR"/*.{jpg,png,jpeg})

WALLPAPER_COUNT=${#WALLPAPERS[@]}

if [ $CURRENT_INDEX -ge $WALLPAPER_COUNT ]; then
    CURRENT_INDEX=0
fi

swww img ${WALLPAPERS[$CURRENT_INDEX]} --transition-type simple --transition-step 80

NEW_INDEX=$((CURRENT_INDEX + 1))
echo $NEW_INDEX > "$INDEX_FILE"
