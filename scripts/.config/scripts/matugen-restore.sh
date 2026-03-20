#!/bin/bash

CUSTOM_DIR="$HOME/.config/matugen/custom"

# 还原列表（只还原这些文件）
RESTORE_LIST=(
    "btop/catppuccin_mocha.theme"
    "Code/User/settings.json"
    "fastfetch/config.jsonc"
    # "fcitx5/conf/classicui.conf"
    "fuzzel/colors.ini"
    "kitty/themes/theme.conf"
    # "mako/colors.conf"
    "niri/conf.d/colors.kdl"
    "obs-studio/matugen.obt"
    # "swaync/colors.css"
    "swayosd/colors.css"
    # "waybar/colors.css"
    # "wlogout/colors.css"
    "yazi/theme.toml"
    # "vscode/settings.json"
)

if env | grep -q "zh_CN"; then IS_CN=true; else IS_CN=false; fi

if [ "$IS_CN" = true ]; then
    notify-send "Matugen" "正在还原自定义配色..."
else
    notify-send "Matugen" "Restoring custom colors..."
fi

# 按列表还原文件
for rel_path in "${RESTORE_LIST[@]}"; do
    src_file="$CUSTOM_DIR/$rel_path"
    [ -f "$src_file" ] || continue

    first_dir=$(echo "$rel_path" | cut -d'/' -f1)
    rest_path=$(echo "$rel_path" | cut -d'/' -f2-)

    case "$first_dir" in
        # vscode)
        #     dest="$HOME/.config/Code/User/$rest_path"
        #     ;;
        *)
            dest="$HOME/.config/$first_dir/$rest_path"
            ;;
    esac

    mkdir -p "$(dirname "$dest")"
    cp "$src_file" "$dest"
    echo "Restored: $dest"
done

# 刷新各应用
pkill -SIGUSR2 waybar 2>/dev/null
niri msg action reload-config 2>/dev/null
kill -SIGUSR1 $(pgrep -x kitty) 2>/dev/null
killall -SIGUSR1 btop 2>/dev/null
makoctl reload 2>/dev/null
swaync-client -rs 2>/dev/null &
pkill swayosd 2>/dev/null && swayosd-server &

# 还原 fcitx5 主题为默认
sed -i 's/^Theme=.*/Theme=default/' "$HOME/.config/fcitx5/conf/classicui.conf"
sed -i 's/^DarkTheme=.*/DarkTheme=default-dark/' "$HOME/.config/fcitx5/conf/classicui.conf"

# 重启 fcitx5
fcitx5 -r 2>/dev/null &

# 刷新 GTK 主题
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus" gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus" gsettings set org.gnome.desktop.interface color-scheme "default"
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus" gsettings set org.gnome.desktop.interface icon-theme "Adwaita"

if [ "$IS_CN" = true ]; then
    notify-send "Matugen" "自定义配色已还原!"
else
    notify-send "Matugen" "Custom colors restored!"
fi