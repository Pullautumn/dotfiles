#!/usr/bin/env bash

# ==============================================================================
# 脚本功能说明 (Bootstrap Script for Pullautumn Arch Setup - Git Edition)
# 1. 环境防御：严格检测操作系统(仅限Linux)与系统架构(仅限x86_64)。
# 2. 使用 git clone 拉取源码到家目录下。
# 3. 高可用拉取：加入 3 次防抖重试机制，应对极端的网络丢包。
# 4. 一键引导：拉取完成后，无缝切换目录并接管标准输入，提权执行核心安装脚本。
# ==============================================================================

set -euo pipefail

# --- [颜色配置] ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- [环境检测] ---

# 1. 检查是否为 Linux 内核
if [ "$(uname -s)" != "Linux" ]; then
    printf "%bError: This installer only supports Linux systems.%b\n" "$RED" "$NC"
    exit 1
fi

# 2. 检查架构是否匹配 (仅允许 x86_64)
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ]; then
    printf "%bError: Unsupported architecture: %s%b\n" "$RED" "$ARCH" "$NC"
    printf "This installer is strictly designed for x86_64 (amd64) systems only.\n"
    exit 1
fi

# --- [配置区域] ---
TARGET_BRANCH="${BRANCH:-main}"
REPO_URL="https://github.com/Pullautumn/dotfiles.git"

# 获取实际用户家目录（兼容 sudo 执行场景）
if [ -n "${SUDO_USER:-}" ]; then
    REAL_USER="$SUDO_USER"
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_USER="$USER"
    REAL_HOME="$HOME"
fi

TARGET_DIR="$REAL_HOME/dotfiles"

printf "%b>>> Preparing to install from branch: %s%b\n" "$BLUE" "$TARGET_BRANCH" "$NC"
printf ">>> Target directory: %s\n" "$TARGET_DIR"

# --- [执行流程] ---

# 1. 检查必要的依赖
for cmd in git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        printf "Command '%s' not found. Installing...\n" "$cmd"
        pacman -Syu --noconfirm "$cmd"
    fi
done

# 2. 清理旧目录
if [ -d "$TARGET_DIR" ]; then
    printf "Removing existing directory '%s'...\n" "$TARGET_DIR"
    rm -rf "$TARGET_DIR"
fi

# 3. git clone（防抖重试机制）
printf "Cloning repository to %s...\n" "$TARGET_DIR"

for attempt in 1 2 3; do
    if sudo -u "$REAL_USER" git clone \
        --depth 1 \
        --branch "$TARGET_BRANCH" \
        "$REPO_URL" \
        "$TARGET_DIR"; then
        printf "%bClone successful.%b\n" "$GREEN" "$NC"
        break
    fi

    if [ "$attempt" -eq 3 ]; then
        printf "%bError: Failed to clone after 3 attempts. Network issue suspected.%b\n" "$RED" "$NC"
        exit 1
    fi

    printf "%bWarning: Clone failed (attempt %d/3). Retrying in 3 seconds...%b\n" "$RED" "$attempt" "$NC"
    sleep 3
done

# 4. 运行安装
cd "$TARGET_DIR"
printf "Starting installer...\n"
sudo bash "$TARGET_DIR/install.sh" < /dev/tty