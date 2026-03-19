#!/bin/bash
# 读取电池基础信息
BAT_PATH="/sys/class/power_supply/BAT0"
CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status" | tr '[:upper:]' '[:lower:]')

# 生成电池图标
if [ "$STATUS" = "Full" ] || [ "$STATUS" = "Not charging" ]; then
  ICON=""
elif [ "$STATUS" = "Discharging" ]; then
  case $CAPACITY in
  0..19) ICON="" ;;
  20..39) ICON="" ;;
  40..59) ICON="" ;;
  60..79) ICON="" ;;
  80..100) ICON="" ;;
  esac
fi

# 输出最终显示文本
echo "$ICON $CAPACITY%"
