if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    #Autostart hyprland after login in tty1
    exec hyprland
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

function fish_greeting
    echo ""
end

alias con="~/.config/swaync/scripts/wifi.sh" #script for connecting to a wifi network

fish_add_path /home/thefreo/.spicetify
