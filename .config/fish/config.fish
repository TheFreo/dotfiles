if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    #Autostart hyprland after login in tty1
    exec start-hyprland
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

function fish_greeting
    echo ""
end

alias po='loginctl poweroff'
alias re='loginctl reboot'
alias nv='nvim'
alias taildown='sudo systemctl stop tailscaled'
alias y='yazi'
alias sudo='doas'
