#!/usr/bin/env bash

# ==============================================================================
# Matugen 系统全方位还原脚本 (包含图标缓存深度清理)
# ==============================================================================

CUSTOM_DIR="$HOME/.config/matugen/custom"

# [1] 配置文件还原列表
RESTORE_LIST=(
    "btop/catppuccin_mocha.theme"
    "Code/User/settings.json"
    "fastfetch/config.jsonc"
    "fuzzel/colors.ini"
    "kitty/current-theme.conf"
    "niri/conf.d/colors.kdl"
    "obs-studio/matugen.obt"
    "swayosd/colors.css"
    "yazi/theme.toml"
)

# 检测语言环境
if env | grep -q "zh_CN"; then IS_CN=true; else IS_CN=false; fi

function notify() {
    if [ "$IS_CN" = true ]; then
        notify-send "Matugen 还原" "$1"
    else
        notify-send "Matugen Restore" "$2"
    fi
}

notify "正在启动深度还原程序..." "Starting deep restoration..."

# ------------------------------------------------------------------------------
# [一] 还原物理配置文件
# ------------------------------------------------------------------------------
echo "Step 1: Restoring configuration files..."
for rel_path in "${RESTORE_LIST[@]}"; do
    src_file="$CUSTOM_DIR/$rel_path"
    [ -f "$src_file" ] || continue

    first_dir=$(echo "$rel_path" | cut -d'/' -f1)
    rest_path=$(echo "$rel_path" | cut -d'/' -f2-)
    dest="$HOME/.config/$first_dir/$rest_path"

    mkdir -p "$(dirname "$dest")"
    cp "$src_file" "$dest"
    echo "  - Restored: $dest"
done

# ------------------------------------------------------------------------------
# [二] 深度清理图标主题 (解决 Rofi/GTK 顽固样式问题)
# ------------------------------------------------------------------------------
echo "Step 2: Cleaning up icon themes and caches..."

# 1. 物理删除生成的图标文件夹
rm -rf "$HOME/.local/share/icons/Adwaita-Matugen-A"
rm -rf "$HOME/.local/share/icons/Adwaita-Matugen-B"

# 2. 强制修改 GTK 配置文件 (Rofi 在 Wayland 下通常读取 settings.ini 而非 GSettings)
for ver in "3.0" "4.0"; do
    GTK_INI="$HOME/.config/gtk-$ver/settings.ini"
    if [ -f "$GTK_INI" ]; then
        sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=Adwaita/' "$GTK_INI"
        sed -i 's/gtk-theme-name=.*/gtk-theme-name=Adwaita/' "$GTK_INI"
        echo "  - Updated: $GTK_INI"
    fi
done

# 3. 撤销 Flatpak 的图标环境变量覆盖
flatpak override --user --unset-env=ICON_THEME 2>/dev/null || true

# 4. 刷新图标缓存
if command -v gtk-update-icon-cache >/dev/null; then
    gtk-update-icon-cache -f -q "$HOME/.local/share/icons" 2>/dev/null
fi

# 5. 清理可能存在的缩略图缓存 (防止 Rofi 显示旧的预览)
rm -rf "$HOME/.cache/thumbnails"

# ------------------------------------------------------------------------------
# [三] 还原系统全局 GSettings
# ------------------------------------------------------------------------------
echo "Step 3: Resetting GSettings..."
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
gsettings set org.gnome.desktop.interface color-scheme "default"
gsettings set org.gnome.desktop.interface icon-theme "Adwaita"

# ------------------------------------------------------------------------------
# [四] 还原 Fcitx5 主题
# ------------------------------------------------------------------------------
FCITX_CONF="$HOME/.config/fcitx5/conf/classicui.conf"
if [ -f "$FCITX_CONF" ]; then
    sed -i 's/^Theme=.*/Theme=default/' "$FCITX_CONF"
    sed -i 's/^DarkTheme=.*/DarkTheme=default-dark/' "$FCITX_CONF"
    fcitx5 -r 2>/dev/null &
fi

# ------------------------------------------------------------------------------
# [五] 刷新应用进程
# ------------------------------------------------------------------------------
echo "Step 5: Reloading services..."
pkill -SIGUSR2 waybar 2>/dev/null
niri msg action reload-config 2>/dev/null
kill -SIGUSR1 $(pgrep -x kitty) 2>/dev/null
killall -SIGUSR1 btop 2>/dev/null
makoctl reload 2>/dev/null
swaync-client -rs 2>/dev/null &
pkill swayosd 2>/dev/null && swayosd-server &

notify "还原完成！图标与配置已重置。" "Restore complete! Icons and configs reset."
echo "Done! If Rofi icons still look wrong, try logging out and back in."