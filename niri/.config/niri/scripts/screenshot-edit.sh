#!/bin/bash

# 截图并保存到临时文件
temp_file="/tmp/screenshot-$(date +%s).png"
grim -g "$(slurp)" "$temp_file"

# 如果截图成功
if [ -f "$temp_file" ]; then
    # 用你想用的编辑器打开它。例如 GIMP。
    gimp "$temp_file"

    # 待编辑完成后，可以选择是否自动删除临时文件
    # rm "$temp_file"
fi
