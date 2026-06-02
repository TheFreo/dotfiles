# Dotfiles
My Hyprland config for Arch Linux

## Details
- **OS**: [Artix Linux](https://artixlinux.org/)
- **Laptop**: [MacBook Pro 13 2014](https://support.apple.com/en-us/111942)
- **Compositor**: [Hyprland](https://github.com/hyprwm/Hyprland)
- **Panel**: [waybar](https://github.com/Alexays/Waybar)
- **Lock screen**: [swaylock](https://github.com/swaywm/swaylock)
- **Notifications**: [swaync](https://github.com/ErikReider/SwayNotificationCenter)
- **Wallpaper loader**: [awww](https://codeberg.org/LGFae/awww)
- **Wallpaper picker**: [rofi](https://github.com/davatorium/rofi)
- **Terminal**: [kitty](https://github.com/kovidgoyal/kitty)
- **Shell**: [fish](https://fishshell.com/)
- **Search menu**: [wofi](https://github.com/SimplyCEO/wofi)
- **Browser**: [Waterfox](https://github.com/BrowserWorks/Waterfox)
- **File manager**: [yazi](https://yazi-rs.github.io/)

## Screenshots

![](assets/1.png)

![](assets/2.png)

![](assets/3.png)

<br>

<details>
<summary><b>Install</b></summary>

### Default

```sh
git clone https://github.com/TheFreo/dotfiles
cd dotfiles
cp -r .config ~/
cp -r Wall ~/
awww img ~/Wall/6.jpg
```

### Fonts

```sh
ttf-font-awesome
otf-font-awesome
ttf-jetbrains-mono
ttf-ubuntu-mono-nerd
ttf-dejavu
powerline-fonts
adobe-source-han-sans-jp-fonts
```

### GTK Theme

```sh
git clone https://github.com/linuxmobile/Colloid-gtk-theme
cd Colloid-gtk-theme
./install.sh --tweaks black
```

### GTK Icons

```sh
git clone https://github.com/vinceliuice/WhiteSur-icon-theme
cd WhiteSur-icon-theme
./install.sh
```

</details>

<details>
<summary><b>Other</b></summary>

### Packages for MacBook

```sh
brightnessctl
broadcom-wl
playerctl
tlp
```

</details>
