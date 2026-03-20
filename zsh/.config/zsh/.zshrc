# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/zsh/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions extract copyfile copypath colored-man-pages colorize sudo)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

####  proxy 配置  ####
# 检查端口是否处于 LISTEN 状态
is_port_listening() {
    ss -tuln | grep -q ":${1}\b"
}

# 开启代理（自动测试）
proxy_on() {
    # 先检查代理端口是否监听
    # if ! is_port_listening 7897; then
    #     echo "❌ 代理端口 7897 未监听，请先启动代理服务 (如 Clash/V2Ray)"
    #     return 1
    # fi

    # 设置代理变量（大小写兼容）
    export http_proxy="http://127.0.0.1:7897"
    export HTTP_PROXY="$http_proxy"
    export https_proxy="http://127.0.0.1:7897"
    export HTTPS_PROXY="$https_proxy"
    export all_proxy="socks5://127.0.0.1:7897"
    export ALL_PROXY="$all_proxy"

    echo "✅ 代理已开启: 127.0.0.1:7897"

    # 测试 Google 连通性
    if curl -Is https://www.google.com --connect-timeout 3 >/dev/null 2>&1; then
        echo "✅ 代理测试通过 (Google 可达)"
    else
        echo "❌ 代理不可用 (Google 不可达)"
        return 1
    fi
}

# 关闭代理（保持不变）
proxy_off() {
    unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY all_proxy ALL_PROXY
    echo "❌ 代理已关闭"
}

# 代理状态检测（增加端口检查）
proxy_status() {
    local active_proxy="${http_proxy:-${HTTP_PROXY:-未设置}}"

    if [ "$active_proxy" != "未设置" ]; then
        echo "✅ 代理已启用: $active_proxy"
        if is_port_listening 7897; then
            if curl -Is https://www.google.com --connect-timeout 3 >/dev/null 2>&1; then
                echo "✅ 代理服务运行中 (Google 可达)"
            else
                echo "❌ 代理端口正常但代理不可用 (Google 不可达)"
            fi
        else
            echo "❌ 代理端口未监听 (服务未运行)"
        fi
    else
        echo "❌ 代理未启用"
    fi
}

# 代理连通性测试（保持不变）
proxy_test() {
    if [ -z "$http_proxy" ] && [ -z "$HTTP_PROXY" ]; then
        echo "❌ 代理未开启"
        return 1
    fi

    echo "🔍 测试代理连通性..."
    if curl -Is https://www.google.com --connect-timeout 3 >/dev/null 2>&1; then
        echo "✅ 代理可用 (Google 可达)"
    else
        echo "❌ 代理不可用 (Google 不可达)"
        return 1
    fi
}
export PATH="$HOME/.cargo/bin:$PATH"

# Created by `pipx` on 2025-09-10 10:22:11
export PATH="$PATH:~/.local/bin"
export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/.config/rofi/scripts:$PATH"

####  nvm 配置  ####
# source /usr/share/nvm/init-nvm.sh

####  snapper配置(一键双子卷备份 + 更新 grub 菜单)  ####
alias snap-all='sudo snapper -c root create --description "Manual_ALL_$(date +%R)" && sudo snapper -c home create --description "Manual_ALL_$(date +%R)" && sudo grub-mkconfig -o /boot/grub/grub.cfg'

####  claude-code-router 配置  ####
alias ccr='~/Code/NodeJs/node_modules/.bin/ccr'

####  Maven  ####
export MAVEN_HOME="/opt/JetBrains/idea/plugins/maven/lib/maven3/"
export PATH=$MAVEN_HOME/bin:$PATH

####  Maven Daemon  ####
export MVND_HOME="/opt/maven-mvnd"
export MAVEN_HOME=$MVND_HOME/mvn
export PATH=$MVND_HOME/bin:$MAVEN_HOME/bin:$PATH

#### JDK  ####
export JAVA_HOME="/opt/java/zulu8.92.0.19-ca-jdk8.0.482"
# export JAVA_HOME="/opt/java/zulu21.48.15-ca-jdk21.0.10"
export PATH=$JAVA_HOME/bin:$PATH


