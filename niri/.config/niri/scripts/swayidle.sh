#!/usr/bin/env bash

# 5分钟锁屏，10分钟熄屏，20分钟休眠
exec swayidle -w \
# 5分钟无操作 → 锁屏（加 pgrep 防重复启动，这是最重要的一行！）
timeout 300 'pgrep -x gtklock || gtklock &' \
# 锁屏后 30秒 → 熄屏（可改成 310/360 等，根据喜好调整）
timeout 330 'niri msg action power-off-monitors' \
# 按键/鼠标 → 先点亮屏幕（必须放 resume 里）
resume 'niri msg action power-on-monitors' \
# 合盖/休眠前 → 强制锁屏
before-sleep 'pgrep -x gtklock || gtklock'