#!/bin/bash

WALLPAPER=""

while [[ $# -gt 0 ]]; do
  case $1 in
  *)
    WALLPAPER="$1"
    shift
    ;;
  esac
done

# 自动获取壁纸路径
if [ -z "$WALLPAPER" ]; then
  if command -v swww &>/dev/null && pgrep -x "swww-daemon" >/dev/null; then
    DETECTED_WALL=$(swww query | head -n 1 | awk -F ': ' '{print $2}' | awk '{print $1}')
    if [ -n "$DETECTED_WALL" ] && [ -f "$DETECTED_WALL" ]; then
      WALLPAPER="$DETECTED_WALL"
    fi
  fi
  if [ -z "$WALLPAPER" ] && [ -f "$HOME/.config/waypaper/config.ini" ]; then
    WP_PATH=$(sed -n 's/^wallpaper[[:space:]]*=[[:space:]]*//p' "$HOME/.config/waypaper/config.ini")
    WP_PATH="${WP_PATH/#\~/$HOME}"
    if [ -n "$WP_PATH" ] && [ -f "$WP_PATH" ]; then
      WALLPAPER="$WP_PATH"
    fi
  fi
fi

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
  notify-send "Error" "无法找到壁纸路径。"
  exit 1
fi

ln -sf "$WALLPAPER" "$HOME/.cache/.current_wallpaper"
