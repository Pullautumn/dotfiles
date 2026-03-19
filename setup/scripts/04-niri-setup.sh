#!/bin/bash

# ==============================================================================
# 04-niri-setup.sh - Niri Desktop (Restored FZF & Robust AUR)
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/00-utils.sh"
VERIFY_LIST="/tmp/pullautumn_install_verify.list"
rm -f "$VERIFY_LIST"
DEBUG=${DEBUG:-0}
CN_MIRROR=${CN_MIRROR:-0}
UNDO_SCRIPT="$SCRIPT_DIR/de-undochange.sh"

check_root

# --- [HELPER FUNCTIONS] ---


# 2. Critical Failure Handler (The "Big Red Box")
# 2. Critical Failure Handler (The "Big Red Box")
critical_failure_handler() {
  local failed_reason="$1"
  trap - ERR

  echo ""
  echo -e "\033[0;31m################################################################\033[0m"
  echo -e "\033[0;31m#                                                              #\033[0m"
  echo -e "\033[0;31m#   CRITICAL INSTALLATION FAILURE DETECTED                     #\033[0m"
  echo -e "\033[0;31m#                                                              #\033[0m"
  echo -e "\033[0;31m#   Reason: $failed_reason\033[0m"
  echo -e "\033[0;31m#                                                              #\033[0m"
  echo -e "\033[0;31m#   OPTIONS:                                                   #\033[0m"
  echo -e "\033[0;31m#   1. Restore snapshot (Undo changes & Exit)                  #\033[0m"
  echo -e "\033[0;31m#   2. Retry / Re-run script                                   #\033[0m"
  echo -e "\033[0;31m#   3. Abort (Exit immediately)                                #\033[0m"
  echo -e "\033[0;31m#                                                              #\033[0m"
  echo -e "\033[0;31m################################################################\033[0m"
  echo ""

  while true; do
    read -p "Select an option [1-3]: " -r choice
    case "$choice" in
    1)
      # Option 1: Restore Snapshot
      if [ -f "$UNDO_SCRIPT" ]; then
        warn "Executing recovery script..."
        bash "$UNDO_SCRIPT"
        exit 1
      else
        error "Recovery script missing! You are on your own."
        exit 1
      fi
      ;;
    2)
      # Option 2: Re-run Script
      warn "Restarting installation script..."
      echo "-----------------------------------------------------"
      sleep 1
      exec "$0" "$@"
      ;;
    3)
      # Option 3: Exit
      warn "User chose to abort."
      warn "Please fix the issue manually before re-running."
      error "Installation aborted."
      exit 1
      ;;
    *) 
      echo "Invalid input. Please enter 1, 2, or 3." 
      ;;
    esac
  done
}

# 3. Robust Package Installation with Retry Loop
ensure_package_installed() {
  local pkg="$1"
  local context="$2" # e.g., "Repo" or "AUR"
  local max_attempts=3
  local attempt=1
  local install_success=false

  # 1. Check if already installed
  if pacman -Q "$pkg" &>/dev/null; then
    return 0
  fi

  # 2. Retry Loop
  while [ $attempt -le $max_attempts ]; do
    if [ $attempt -gt 1 ]; then
      warn "Retrying '$pkg' ($context)... (Attempt $attempt/$max_attempts)"
      sleep 3 # Cooldown
    else
      log "Installing '$pkg' ($context)..."
    fi

    # Try installation
    if as_user yay -S --noconfirm --needed --answerdiff=None --answerclean=None "$pkg"; then
      install_success=true
      break
    else
      warn "Attempt $attempt/$max_attempts failed for '$pkg'."
    fi

    ((attempt++))
  done

  # 3. Final Verification
  if [ "$install_success" = true ] && pacman -Q "$pkg" &>/dev/null; then
    success "Installed '$pkg'."
  else
    critical_failure_handler "Failed to install '$pkg' after $max_attempts attempts."
  fi
}

section "Phase 4" "Niri Desktop Environment"

# ==============================================================================
# STEP 0: Safety Checkpoint
# ==============================================================================

# Enable Trap
trap 'critical_failure_handler "Script Error at Line $LINENO"' ERR

# ==============================================================================
# STEP 1: Identify User & DM Check
# ==============================================================================
detect_target_user
info_kv "Target" "$TARGET_USER"

# DM Check
check_dm_conflict
# ==============================================================================
# STEP 2: Core Components
# ==============================================================================
section "Step 1/9" "Core Components"
PKGS="niri xdg-desktop-portal-gnome fuzzel kitty firefox libnotify mako polkit-gnome"
# 記錄到清單
echo "$PKGS" >> "$VERIFY_LIST"
exe pacman -S --noconfirm --needed $PKGS

log "Configuring Firefox Policies..."
POL_DIR="/etc/firefox/policies"
exe mkdir -p "$POL_DIR"
echo '{ "policies": { "Extensions": { "Install": ["https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi"] } } }' >"$POL_DIR/policies.json"
exe chmod 755 "$POL_DIR" && exe chmod 644 "$POL_DIR/policies.json"

# ==============================================================================
# STEP 3: File Manager
# ==============================================================================
section "Step 2/9" "File Manager"
FM_PKGS1="ffmpegthumbnailer gvfs-smb nautilus-open-any-terminal file-roller gnome-keyring gst-plugins-base gst-plugins-good gst-libav nautilus"
FM_PKGS2="xdg-desktop-portal-gtk thunar tumbler ffmpegthumbnailer poppler-glib gvfs-smb file-roller thunar-archive-plugin gnome-keyring thunar-volman gvfs-mtp gvfs-gphoto2 webp-pixbuf-loader libgsf"

# 記錄到清單
echo "$FM_PKGS1" >> "$VERIFY_LIST"
echo "$FM_PKGS2" >> "$VERIFY_LIST"

exe pacman -S --noconfirm --needed $FM_PKGS1
exe pacman -S --noconfirm --needed $FM_PKGS2


# 默认终端处理
echo "xdg-terminal-exec" >> "$VERIFY_LIST"
exe as_user paru -S --noconfirm --needed xdg-terminal-exec
if ! grep -q "kitty" "$HOME_DIR/.config/xdg-terminals.list"; then
  echo 'kitty.desktop' >> "$HOME_DIR/.config/xdg-terminals.list"
fi

# if [ ! -f /usr/local/bin/gnome-terminal ] || [ -L /usr/local/bin/gnome-terminal ]; then
#   exe ln -sf /usr/bin/kitty /usr/local/bin/gnome-terminal
# fi
sudo -u "$TARGET_USER" dbus-run-session gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty

# Nautilus Nvidia/Input Fix
configure_nautilus_user

section "Step 3/9" "Temp sudo file"

SUDO_TEMP_FILE="/etc/sudoers.d/99_pullautumn_installer_temp"
echo "$TARGET_USER ALL=(ALL) NOPASSWD: ALL" >"$SUDO_TEMP_FILE"
chmod 440 "$SUDO_TEMP_FILE"
log "Temp sudo file created..."
# ==============================================================================
# STEP 5: Dependencies (RESTORED FZF)
# ==============================================================================
section "Step 4/9" "Dependencies"
LIST_FILE="$PARENT_DIR/niri-applist.txt"

# Ensure tools
command -v fzf &>/dev/null || pacman -S --noconfirm fzf >/dev/null 2>&1

if [ -f "$LIST_FILE" ]; then
  mapfile -t DEFAULT_LIST < <(grep -vE "^\s*#|^\s*$" "$LIST_FILE" | sed 's/#.*//; s/AUR://g' | xargs -n1)

  if [ ${#DEFAULT_LIST[@]} -eq 0 ]; then
    warn "App list is empty. Skipping."
    PACKAGE_ARRAY=()
  else
    echo -e "\n   ${H_YELLOW}>>> Default installation in 60s. Press ANY KEY to customize...${NC}"

    if read -t 60 -n 1 -s -r; then
      # --- [RESTORED] Original FZF Selection Logic ---
      clear
      log "Loading package list..."

      SELECTED_LINES=$(grep -vE "^\s*#|^\s*$" "$LIST_FILE" |
        sed -E 's/[[:space:]]+#/\t#/' |
        fzf --multi \
          --layout=reverse \
          --border \
          --margin=1,2 \
          --prompt="Search Pkg > " \
          --pointer=">>" \
          --marker="* " \
          --delimiter=$'\t' \
          --with-nth=1 \
          --bind 'load:select-all' \
          --bind 'ctrl-a:select-all,ctrl-d:deselect-all' \
          --info=inline \
          --header="[TAB] TOGGLE | [ENTER] INSTALL | [CTRL-D] DE-ALL | [CTRL-A] SE-ALL" \
          --preview "echo {} | cut -f2 -d$'\t' | sed 's/^# //'" \
          --preview-window=down:50%:wrap \
          --color=dark \
          --color=fg+:white,bg+:black \
          --color=hl:blue,hl+:blue:bold \
          --color=header:yellow:bold \
          --color=info:magenta \
          --color=prompt:cyan,pointer:cyan:bold,marker:green:bold \
          --color=spinner:yellow)

      clear

      if [ -z "$SELECTED_LINES" ]; then
        warn "User cancelled selection. Installing NOTHING."
        PACKAGE_ARRAY=()
      else
        PACKAGE_ARRAY=()
        while IFS= read -r line; do
          raw_pkg=$(echo "$line" | cut -f1 -d$'\t' | xargs)
          clean_pkg="${raw_pkg#AUR:}"
          [ -n "$clean_pkg" ] && PACKAGE_ARRAY+=("$clean_pkg")
        done <<<"$SELECTED_LINES"
      fi
      # -----------------------------------------------
    else
      log "Auto-confirming ALL packages."
      PACKAGE_ARRAY=("${DEFAULT_LIST[@]}")
    fi
  fi

  # --- Installation Loop ---
  if [ ${#PACKAGE_ARRAY[@]} -gt 0 ]; then
    BATCH_LIST=()
    AUR_LIST=()
    info_kv "Target" "${#PACKAGE_ARRAY[@]} packages scheduled."
    # 記錄到清單 (將陣列展開並寫入)
    echo "${PACKAGE_ARRAY[@]}" >> "$VERIFY_LIST"
    for pkg in "${PACKAGE_ARRAY[@]}"; do
      [ "$pkg" == "imagemagic" ] && pkg="imagemagick"
      [[ "$pkg" == "AUR:"* ]] && AUR_LIST+=("${pkg#AUR:}") || BATCH_LIST+=("$pkg")
    done

    # 1. Batch Install Repo Packages
    if [ ${#BATCH_LIST[@]} -gt 0 ]; then
      log "Phase 1: Batch Installing Repo Packages..."
      as_user yay -Syu --noconfirm --needed --answerdiff=None --answerclean=None "${BATCH_LIST[@]}" || true

      # Verify Each
      for pkg in "${BATCH_LIST[@]}"; do
        ensure_package_installed "$pkg" "Repo"
      done
    fi

    # 2. Sequential AUR Install
    if [ ${#AUR_LIST[@]} -gt 0 ]; then
      log "Phase 2: Installing AUR Packages (Sequential)..."
      for pkg in "${AUR_LIST[@]}"; do
        ensure_package_installed "$pkg" "AUR"
      done
    fi

    # Waybar fallback
    if ! command -v waybar &>/dev/null; then
      warn "Waybar missing. Installing stock..."
      exe pacman -S --noconfirm --needed waybar
    fi
  else
    warn "No packages selected."
  fi
else
  warn "niri-applist.txt not found."
fi

# ==============================================================================
# STEP 6: Dotfiles (Stow)
# ==============================================================================
section "Step 5/9" "Deploying Dotfiles"

REPO_GITHUB="https://github.com/Pullautumn/dotfiles.git"
DOTFILES_REPO="$HOME_DIR/.local/share/pullautumn-niri"

# --- 本地路径优先 ---
LOCAL_DOTFILES=""

# 候选本地路径列表（按优先级排列）
for candidate in \
    "$HOME_DIR/dotfiles" \
    "$HOME_DIR/.dotfiles" \
    "$(dirname "$SCRIPT_DIR")" \
; do
    if [ -d "$candidate" ] && [ -f "$candidate/README.md" ]; then
        LOCAL_DOTFILES="$candidate"
        log "Found local dotfiles at: $LOCAL_DOTFILES"
        break
    fi
done

prepare_repository() {
    # 如果找到本地路径，直接用，不克隆
    if [ -n "$LOCAL_DOTFILES" ]; then
        log "Using local dotfiles: $LOCAL_DOTFILES"
        DOTFILES_REPO="$LOCAL_DOTFILES"
        return 0
    fi

    local BRANCH_NAME="main"

    if [ -d "$DOTFILES_REPO" ]; then
        if ! as_user git -C "$DOTFILES_REPO" rev-parse --is-inside-work-tree &>/dev/null; then
            warn "Found broken repo. Cleaning up..."
            rm -rf "$DOTFILES_REPO"
        else
            log "Repo exists. Pulling updates..."
            if ! as_user git -C "$DOTFILES_REPO" pull origin "$BRANCH_NAME"; then
                warn "Pull failed. Cleaning up..."
                rm -rf "$DOTFILES_REPO"
            fi
        fi
    fi

    if [ ! -d "$DOTFILES_REPO" ]; then
        log "Cloning dotfiles from GitHub..."

        if ! as_user mkdir -p "$DOTFILES_REPO" 2>/dev/null; then
            local parent_dir
            parent_dir=$(dirname "$DOTFILES_REPO")
            [ ! -d "$parent_dir" ] && mkdir -p "$parent_dir"
            chown "$TARGET_USER:" "$parent_dir"
            if ! as_user mkdir -p "$DOTFILES_REPO"; then
                mkdir -p "$DOTFILES_REPO"
                chown -R "$TARGET_USER:" "$DOTFILES_REPO"
            fi
        fi

        as_user git -C "$DOTFILES_REPO" init
        as_user git -C "$DOTFILES_REPO" branch -m "$BRANCH_NAME"
        as_user git -C "$DOTFILES_REPO" remote add origin "$REPO_GITHUB"

        if ! as_user git -C "$DOTFILES_REPO" pull origin "$BRANCH_NAME" --depth 1; then
            rm -rf "$DOTFILES_REPO"
            critical_failure_handler "Failed to clone dotfiles from GitHub."
        fi

        chown -R "$TARGET_USER:" "$DOTFILES_REPO"
        as_user git -C "$DOTFILES_REPO" branch --set-upstream-to=origin/main main
        as_user git config --global --add safe.directory "$DOTFILES_REPO"
        success "Repository cloned."
    fi
}

prepare_repository

# --- stow 部署 ---
deploy_dotfiles_stow() {
    local repo="$DOTFILES_REPO"

    # 确保 stow 已安装
    if ! command -v stow &>/dev/null; then
        log "Installing stow..."
        pacman -S --noconfirm --needed stow
    fi

    # 加载排除列表
    local EXCLUDE_LIST=()
    local EXCLUDE_FILE="$PARENT_DIR/exclude-dotfiles.txt"
    if [ "$TARGET_USER" != "pullautumn" ]; then
        if [ -f "$EXCLUDE_FILE" ]; then
            log "Loading exclusions..."
            while IFS= read -r line; do
                [[ "$line" =~ ^\s*# || -z "$line" ]] && continue
                EXCLUDE_LIST+=("$line")
            done < "$EXCLUDE_FILE"
        fi
    fi

    # 备份现有配置
    log "Backing up existing configs..."
    as_user tar -czf "$HOME_DIR/config_backup_$(date +%s).tar.gz" \
        -C "$HOME_DIR" .config --ignore-failed-read 2>/dev/null || true

    # 获取所有 stow 包（排除非包目录）
    local SKIP_DIRS=("setup" "wallpapers" ".git" "wallpaper")
    local STOW_PKGS=()

    while IFS= read -r -d '' pkg_path; do
        local pkg_name
        pkg_name=$(basename "$pkg_path")

        # 跳过固定排除目录
        local skip=false
        for s in "${SKIP_DIRS[@]}"; do
            [ "$pkg_name" = "$s" ] && skip=true && break
        done
        $skip && continue

        # 跳过用户排除列表
        for ex in "${EXCLUDE_LIST[@]}"; do
            [ "$pkg_name" = "$ex" ] && skip=true && break
        done
        $skip && continue

        # 跳过非目录（README.md、*.sh 等）
        [ ! -d "$pkg_path" ] && continue

        STOW_PKGS+=("$pkg_name")
    done < <(find "$repo" -mindepth 1 -maxdepth 1 -print0)

    if [ ${#STOW_PKGS[@]} -eq 0 ]; then
        warn "No stow packages found in $repo"
        return 1
    fi

    log "Packages to stow: ${STOW_PKGS[*]}"

    # 清理冲突文件（先 dry-run 检测冲突，再删除）
    log "Cleaning up conflicting files..."
    for pkg in "${STOW_PKGS[@]}"; do
        conflict_output=$(as_user stow --dir="$repo" --target="$HOME_DIR" -n -R "$pkg" 2>&1 || true)
        if echo "$conflict_output" | grep -q "cannot stow"; then
            echo "$conflict_output" | grep "cannot stow" | while read -r line; do
                conflict_path=$(echo "$line" | grep -oP 'over existing target \K[^\s]+')
                if [ -n "$conflict_path" ]; then
                    full_path="$HOME_DIR/$conflict_path"
                    log "  Removing conflict: $full_path"
                    as_user rm -rf "$full_path"
                fi
            done
        fi
    done

    # 执行 stow
    for pkg in "${STOW_PKGS[@]}"; do
        log "  Stowing: $pkg"
        if as_user stow --dir="$repo" --target="$HOME_DIR" -R "$pkg" 2>/tmp/stow_err.log; then
            success "  Stowed: $pkg"
        else
            warn "  Stow failed for '$pkg':"
            cat /tmp/stow_err.log
        fi
    done

    # 壁纸软链接（wallpaper 包特殊处理）
    if [ -d "$repo/wallpaper/Pictures/Wallpapers" ]; then
        as_user mkdir -p "$HOME_DIR/Pictures"
        as_user ln -sfn "$repo/wallpaper/Pictures/Wallpapers" "$HOME_DIR/Pictures/Wallpapers"
        success "Wallpapers linked."
    elif [ -d "$repo/wallpapers" ]; then
        as_user mkdir -p "$HOME_DIR/Pictures"
        as_user ln -sfn "$repo/wallpapers" "$HOME_DIR/Pictures/Wallpapers"
        success "Wallpapers linked (from wallpapers/)."
    fi

    # 可执行权限
    [ -d "$HOME_DIR/.local/bin" ] && as_user chmod -R +x "$HOME_DIR/.local/bin"

    # pullautumn 工具链接
    command -v pullautumn &>/dev/null && as_user pullautumn link

    # 用户名和路径替换
    # 无论用户名是什么都执行替换，把 dotfiles 里的 pullautumn 替换成当前实际用户
    log "Replacing paths for user: $TARGET_USER ($HOME_DIR)"
    find "$HOME_DIR/.config" "$HOME_DIR/.local" -type l 2>/dev/null | while read -r link; do
        real_file=$(readlink -f "$link")
        # 只处理指向 dotfiles 仓库的软链接（避免误改系统文件）
        if [[ "$real_file" == "$DOTFILES_REPO"* ]] && [ -f "$real_file" ]; then
            # 检查文件是否包含需要替换的内容
            if grep -qE "pullautumn|file://~|=~/" "$real_file" 2>/dev/null; then
                log "  Patching: $real_file"
                sed -i \
                    -e "s|/home/pullautumn|$HOME_DIR|g" \
                    -e "s|pullautumn|$TARGET_USER|g" \
                    -e "s|file://~/|file://$HOME_DIR/|g" \
                    -e "s|=~/|=$HOME_DIR/|g" \
                    "$real_file"
            fi
        fi
    done

    # niri output.kdl 处理
    local OUTPUT_EXAMPLE="$DOTFILES_REPO/niri/.config/niri/output-example.kdl"
    local OUTPUT_KDL="$HOME_DIR/.config/niri/output.kdl"
    if [ "$TARGET_USER" = "pullautumn" ]; then
        [ -f "$OUTPUT_EXAMPLE" ] && as_user cp "$OUTPUT_EXAMPLE" "$OUTPUT_KDL"
    else
        as_user touch "$OUTPUT_KDL"
    fi

    # GTK4 主题链接
    local GTK4="$HOME_DIR/.config/gtk-4.0"
    local THEME="$HOME_DIR/.local/share/themes/adw-gtk3-dark/gtk-4.0"
    if [ -d "$GTK4" ] && [ -d "$THEME" ]; then
        as_user rm -f "$GTK4/gtk.css" "$GTK4/gtk-dark.css"
        as_user ln -sf "$THEME/gtk-dark.css" "$GTK4/gtk-dark.css"
        as_user ln -sf "$THEME/gtk.css" "$GTK4/gtk.css"
    fi

    # Flatpak overrides
    if command -v flatpak &>/dev/null; then
        as_user flatpak override --user --filesystem=xdg-data/themes
        as_user flatpak override --user --filesystem="$HOME_DIR/.themes"
        as_user flatpak override --user --filesystem=xdg-config/gtk-4.0
        as_user flatpak override --user --filesystem=xdg-config/gtk-3.0
        as_user flatpak override --user --env=GTK_THEME=adw-gtk3-dark
        as_user flatpak override --user --filesystem=xdg-config/fontconfig
    fi

    # 修复 home 目录权限
    chown -R "$TARGET_USER:$TARGET_USER" "$HOME_DIR/.cache" 2>/dev/null || true
    chown -R "$TARGET_USER:$TARGET_USER" "$HOME_DIR/.config" 2>/dev/null || true
    chown -R "$TARGET_USER:$TARGET_USER" "$HOME_DIR/.local" 2>/dev/null || true

    success "Dotfiles deployed via stow."
}

deploy_dotfiles_stow

# ==============================================================================
# STEP 7: Wallpapers
# ==============================================================================
section "Step 6/9" "Wallpapers"
# 更新引用路径
if [ -d "$DOTFILES_REPO/wallpapers" ]; then
  as_user ln -sf "$DOTFILES_REPO/wallpapers" "$HOME_DIR/Pictures/Wallpapers"
  
  as_user mkdir -p "$HOME_DIR/Templates"
  as_user touch "$HOME_DIR/Templates/new"
  echo "#!/bin/bash" | as_user tee "$HOME_DIR/Templates/new.sh" >/dev/null
  as_user chmod +x "$HOME_DIR/Templates/new.sh"
  success "Installed."
fi

# === remove gtk bottom =======
as_user gsettings set org.gnome.desktop.wm.preferences button-layout ":close"
# ==============================================================================
# STEP 8: Hardware Tools
# ==============================================================================
section "Step 7/9" "Hardware"
if pacman -Q ddcutil &>/dev/null; then
  gpasswd -a "$TARGET_USER" i2c
  lsmod | grep -q i2c_dev || echo "i2c-dev" >/etc/modules-load.d/i2c-dev.conf
fi
if pacman -Q swayosd &>/dev/null; then
  systemctl enable --now swayosd-libinput-backend.service >/dev/null 2>&1
fi
success "Tools configured."

section "Config" "Hiding useless .desktop files"
log "Hiding useless .desktop files"
run_hide_desktop_file

rm -f "$SUDO_TEMP_FILE"


# === 教程文件 ===
log "Copying tutorial file on desktop..."
as_user cp "$PARENT_DIR/resources/必看-pullautumn-Niri使用方法.txt" "$HOME_DIR/必看-Pullautumn-Niri使用方法.txt"
# ==============================================================================
# STEP 9: Cleanup & Auto-Login
# ==============================================================================
# section "Final" "Cleanup & Boot"
# SVC_DIR="$HOME_DIR/.config/systemd/user"
# SVC_FILE="$SVC_DIR/niri-autostart.service"
# LINK="$SVC_DIR/default.target.wants/niri-autostart.service"

# if [ "$SKIP_DM" = true ]; then
#   log "Auto-login skipped."
#   as_user rm -f "$LINK" "$SVC_FILE"
# else
#   log "Configuring TTY Auto-login..."
#   mkdir -p "/etc/systemd/system/getty@tty1.service.d"
#   echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --noreset --noclear --autologin $TARGET_USER - \${TERM}" >"/etc/systemd/system/getty@tty1.service.d/autologin.conf"

#   as_user mkdir -p "$(dirname "$LINK")"
#   cat <<EOT >"$SVC_FILE"
# [Unit]
# Description=Niri Session Autostart
# After=graphical-session-pre.target
# [Service]
# ExecStart=/usr/bin/niri-session
# Restart=on-failure
# [Install]
# WantedBy=default.target
# EOT
#   as_user ln -sf "../niri-autostart.service" "$LINK"
#   chown -R "$TARGET_USER" "$SVC_DIR"
#   success "Enabled."
# fi


# ==============================================================================
# STEP 9: Display Manager (greetd + tuigreet) & Cleanup
# ==============================================================================
section "Final" "Cleanup & Boot Configuration"

# 1. 清理旧的 TTY 自动登录残留（无论是否启用 greetd，旧版残留都应清除）
log "Cleaning up legacy TTY autologin configs..."
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf 2>/dev/null

if [ "$SKIP_DM" = true ]; then
  log "Display Manager setup skipped (Conflict found or user opted out)."
  warn "You will need to start your session manually from the TTY."
else

  setup_ly
fi

trap - ERR
log "Module 04 completed."