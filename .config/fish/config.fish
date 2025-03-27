#To start hyprland after logging in from tty
if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec hyprland
end

if status is-interactive
    neofetch
end

function fish_greeting
    echo ""
end
