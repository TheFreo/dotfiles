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
