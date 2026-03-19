#!/bin/bash
# 生成悬浮提示文本
CAP=$(cat /sys/class/power_supply/BAT0/capacity)
STATE=$(cat /sys/class/power_supply/BAT0/status)
PERF=$(powerprofilesctl get)
echo "电池: $CAP% ($STATE)
性能模式: $PERF"
