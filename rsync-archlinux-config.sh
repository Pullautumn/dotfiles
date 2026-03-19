#!/usr/bin/env bash
set -euo pipefail

########################
# 配置区域
########################

# 备份根目录
DOTFILES_ROOT="$HOME/dotfiles"

# 定义需要同步的项目
# 格式: "源根目录:相对路径"
SYNC_ITEMS=(
  # .config 下的目录
  ".config:btop"
  ".config:environment.d"
  ".config:fastfetch"
  ".config:fcitx5"
  ".config:fontconfig"
  ".config:fuzzel"
  ".config:gtklock"
  ".config:gtk-3.0"
  ".config:kitty"
  ".config:mako"
  ".config:mpv"
  ".config:niri"
  ".config:nvim"
  ".config:rofi"
  ".config:satty"
  ".config:scripts"
  ".config:swaylock"
  ".config:swaync"
  ".config:systemd"
  ".config:Thunar"
  ".config:tlpui"
  ".config:waybar"
  ".config:waybar-niri-Win11Like"
  ".config:waypaper"
  ".config:wlogout"
  ".config:xdg-desktop-portal"
  ".config:yazi"

  # .local 下的目录
  ".local:bin"
  ".local:share/applications"
  ".local:share/bin"
  ".local:share/fcitx5/rime/default.yaml"
  ".local:share/fcitx5/rime/default.custom.yaml"

  # ~ 下的文件
  ":.zshrc"
  ":.oh-my-zsh"

  # 可以添加更多，格式: "源根:相对路径"
  # ".config:nvim/init.lua"  # 单个文件也可以
)

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

########################
# 工具函数
########################

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# 解析项目字符串
parse_item() {
  local item="$1"
  local source_root="${item%%:*}"
  local relative_path="${item#*:}"

  local source_path="$HOME/$source_root/$relative_path"
  local backup_path="$DOTFILES_ROOT/$source_root/$relative_path"

  echo "$source_path|$backup_path|$source_root/$relative_path"
}

# 检查目录
check_directories() {
  if [[ ! -d "$DOTFILES_ROOT" ]]; then
    log_warning "备份目录不存在，正在创建: $DOTFILES_ROOT"
    mkdir -p "$DOTFILES_ROOT"
  fi
}

# 比较差异
check_diff() {
  local item="$1"
  local paths
  paths=$(parse_item "$item")

  local source_path="${paths%%|*}"
  local rest="${paths#*|}"
  local backup_path="${rest%%|*}"

  if [[ ! -e "$source_path" ]]; then
    return 2
  fi

  if [[ ! -e "$backup_path" ]]; then
    return 1
  fi

  local diff_output
  if [[ -d "$source_path" ]]; then
    diff_output=$(rsync -avcn --delete "$source_path/" "$backup_path/" 2>/dev/null | grep -Ev '^(sending|sent|total|$)' || true)
  else
    if ! cmp -s "$source_path" "$backup_path"; then
      return 1
    fi
    diff_output=""
  fi

  if [[ -n "$diff_output" ]]; then
    return 1
  else
    return 0
  fi
}

# 同步项目
sync_item() {
  local item="$1"
  local paths
  paths=$(parse_item "$item")

  local source_path="${paths%%|*}"
  local rest="${paths#*|}"
  local backup_path="${rest%%|*}"
  local display_name="${rest#*|}"

  if [[ ! -e "$source_path" ]]; then
    log_error "无法同步，源不存在: $display_name"
    return 1
  fi

  local backup_parent
  backup_parent="$(dirname "$backup_path")"
  mkdir -p "$backup_parent"

  if [[ -f "$source_path" ]]; then
    cp -f "$source_path" "$backup_path"
    log_success "✓ 已同步文件: $display_name"
  elif [[ -d "$source_path" ]]; then
    rsync -av --delete "$source_path/" "$backup_path/"
    log_success "✓ 已同步目录: $display_name"
  fi
}

# 显示差异
show_diff() {
  local item="$1"
  local paths
  paths=$(parse_item "$item")

  local source_path="${paths%%|*}"
  local rest="${paths#*|}"
  local backup_path="${rest%%|*}"
  local display_name="${rest#*|}"

  if [[ ! -e "$source_path" ]] || [[ ! -e "$backup_path" ]]; then
    return
  fi

  echo -e "\n${YELLOW}=== 差异详情: $display_name ===${NC}"

  if [[ -d "$source_path" ]]; then
    rsync -avcn --delete --itemize-changes "$source_path/" "$backup_path/" 2>/dev/null | grep -Ev '^(sending|sent|total|$|.*/$)' || true
  else
    diff -u "$backup_path" "$source_path" || true
  fi
}

########################
# 主要功能
########################

check_all() {
  local has_changes=false
  local changed_items=()

  log_info "正在检查差异..."
  echo ""

  for item in "${SYNC_ITEMS[@]}"; do
    local paths
    paths=$(parse_item "$item")
    local display_name="${paths##*|}"

    set +e
    check_diff "$item"
    local diff_status=$?
    set -e

    if [[ $diff_status -eq 0 ]]; then
      echo -e "  ${GREEN}✓${NC} $display_name - 无变化"
    elif [[ $diff_status -eq 1 ]]; then
      echo -e "  ${YELLOW}⚠${NC} $display_name - 有变化"
      has_changes=true
      changed_items+=("$item")
    elif [[ $diff_status -eq 2 ]]; then
      echo -e "  ${RED}✗${NC} $display_name - 源不存在"
    fi
  done

  echo ""

  if [[ "$has_changes" == true ]]; then
    log_warning "发现 ${#changed_items[@]} 个项目有变化"
    return 1
  else
    log_success "所有项目都是最新的"
    return 0
  fi
}

sync_all() {
  local synced_count=0

  log_info "正在同步所有有变化的项目..."
  echo ""

  for item in "${SYNC_ITEMS[@]}"; do
    set +e
    check_diff "$item" 2>/dev/null
    local diff_status=$?
    set -e

    if [[ $diff_status -ne 0 ]]; then
      if sync_item "$item"; then
        synced_count=$((synced_count + 1))
      fi
    fi
  done

  echo ""
  log_success "已同步 $synced_count 个项目"
}

force_sync_all() {
  local synced_count=0

  log_info "正在强制同步所有项目..."
  echo ""

  for item in "${SYNC_ITEMS[@]}"; do
    set +e
    sync_item "$item"
    local sync_status=$?
    set -e

    if [[ $sync_status -eq 0 ]]; then
      synced_count=$((synced_count + 1))
    fi
  done

  echo ""
  log_success "已同步 $synced_count 个项目"
}

diff_all() {
  log_info "显示所有差异..."

  for item in "${SYNC_ITEMS[@]}"; do
    local paths
    paths=$(parse_item "$item")
    local display_name="${paths##*|}"

    set +e
    check_diff "$item" 2>/dev/null
    local diff_status=$?
    set -e
    if [[ $diff_status -eq 0 ]]; then
      echo -e "${GREEN}✓${NC} $display_name - 无变化，跳过"
      continue
    fi
    if [[ $diff_status -eq 1 ]]; then
      show_diff "$item"
    fi
  done
}

interactive_sync() {
  log_info "交互式同步模式"
  echo ""

  for item in "${SYNC_ITEMS[@]}"; do
    local paths
    paths=$(parse_item "$item")
    local display_name="${paths##*|}"

    set +e
    check_diff "$item"
    local diff_status=$?
    set -e

    if [[ $diff_status -eq 0 ]]; then
      echo -e "${GREEN}✓${NC} $display_name - 无变化，跳过"
      continue
    fi

    if [[ $diff_status -eq 2 ]]; then
      echo -e "${RED}✗${NC} $display_name - 源不存在，跳过"
      continue
    fi

    echo -e "\n${YELLOW}⚠${NC} $display_name - 发现变化"

    show_diff "$item" | head -20

    read -p "是否同步此项目? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
      sync_item "$item"
    else
      log_info "已跳过: $display_name"
    fi
  done
}

show_help() {
  cat <<EOF
配置文件同步脚本

用法: $(basename "$0") [选项]

选项:
  check, -c       检查差异（默认）
  sync, -s        同步所有有变化的项目
  force, -f       强制同步所有项目
  diff, -d        显示详细差异
  interactive, -i 交互式同步（逐个确认）
  help, -h        显示此帮助信息

示例:
  $(basename "$0")              # 检查差异
  $(basename "$0") sync         # 同步有变化的项目
  $(basename "$0") -i           # 交互式同步

配置:
  源目录: $HOME/.config, $HOME/.local
  备份目录: $DOTFILES_ROOT
  
  同步项目 (${#SYNC_ITEMS[@]} 个):
EOF

  for item in "${SYNC_ITEMS[@]}"; do
    local paths
    paths=$(parse_item "$item")
    local display_name="${paths##*|}"
    echo "    - $display_name"
  done
}

########################
# 主程序
########################

main() {
  check_directories

  local command="${1:-check}"

  case "$command" in
  check | -c)
    check_all
    ;;
  sync | -s)
    sync_all
    ;;
  force | -f)
    force_sync_all
    ;;
  diff | -d)
    diff_all
    ;;
  interactive | -i)
    interactive_sync
    ;;
  help | -h | --help)
    show_help
    ;;
  *)
    log_error "未知命令: $command"
    echo ""
    show_help
    exit 1
    ;;
  esac
}

main "$@"
