#!/bin/bash

song_info=$(playerctl metadata --format '  {{title}} - {{artist}}  |')

if [[ -z "$song_info" ]]; then
    echo ""
else
    echo "$song_info"
fi
