
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


export_from_file() {
    local var_name="$1"
    local file_path="$2"
    local fallback_value="${3:-""}"
    local content="$fallback_value"

    if [ -r "$file_path" ]; then
        content=$(< "$file_path")
    fi

    declare -x "$var_name=$content"
}


# 清除文件内容并用编辑器打开
cv() {
  if [[ -z "$1" ]]; then
    echo "Usage: cv "
    return 1
  fi

  # 检查文件是否存在，如果不存在则创建
  if [[ ! -f "$1" ]]; then
    touch "$1"
  fi

  # 清空文件内容
  echo '' > "$1"

  # 使用 $EDITOR 打开文件
  ${EDITOR:-vim} "$1"
}


function y() {
 local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
 yazi "$@" --cwd-file="$tmp"
 if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
  builtin cd -- "$cwd"
 fi
 rm -f -- "$tmp"
}


#Function to manage proxy settings
proxy() {
  if [ "$1" = "on" ]; then
    # Set lowercase and uppercase variables for maximum compatibility
    export http_proxy="http://127.0.0.1:7897"
    export https_proxy="http://127.0.0.1:7897"
    export all_proxy="socks5://127.0.0.1:7897"
    export HTTP_PROXY="${http_proxy}"
    export HTTPS_PROXY="${https_proxy}"
    export ALL_PROXY="${all_proxy}"
    echo "Proxy is ON"
    echo "http_proxy: $http_proxy"
    echo "https_proxy: $https_proxy"
    echo "all_proxy: $all_proxy"
  elif [ "$1" = "off" ]; then
    # Unset all related proxy variables
    unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
    echo "Proxy is OFF"
  elif [ "$1" = "status" ]; then
    if [ -n "$http_proxy" ] || [ -n "$HTTP_PROXY" ]; then
      echo "Proxy is ON"
      echo "--------------------"
      echo "http_proxy: ${http_proxy:-"Not set"}"
      echo "https_proxy: ${https_proxy:-"Not set"}"
      echo "all_proxy: ${all_proxy:-"Not set"}"
      echo "--------------------"
      echo "HTTP_PROXY: ${HTTP_PROXY:-"Not set"}"
      echo "HTTPS_PROXY: ${HTTPS_PROXY:-"Not set"}"
      echo "ALL_PROXY: ${ALL_PROXY:-"Not set"}"
    else
      echo "Proxy is OFF"
    fi
  else
    echo "Usage: proxy [on|off|status]"
  fi
}

# alias trans=/usr/bin/trans -e google

# function trans(){
#     if [ -n "$http_proxy" ] || [ -n "$HTTP_PROXY" ]; then
#         _trans -e google "$@"
#     else
#         _trans -e bing "$@"
#     fi
# }
#

