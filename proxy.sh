#!/usr/bin/env bash
if [ "$1" == 's' ]; then
  PS3='选择代理模式: '
  options=(
  '部分代理 8118'
  '全局代理 8119'
  '关闭代理'
  )
  select opt in "${options[@]}";do
  read -r name port <<< "${opt}"
  break
  done
  echo "执行-> $name"
  if [ -n "$port" ]; then
      networksetup -setwebproxy "Wi-Fi" 127.0.0.1 "$port"
      networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 "$port"
  fi
  if [ -z "$port" ]; then
     networksetup -setwebproxystate "Wi-Fi" off
     networksetup -setsecurewebproxystate "Wi-Fi" off
  fi
  exit 0
fi
if [ "$1" == 'ss' ]; then
    conf=$(grep -r '"server"' ~/Documents/ss.d|awk -F: '{print $1" "$3}'|column -t|fzf|awk '{print $1}')
    if [ -n "$conf" ]; then
      echo "切换配置: -> $conf"
      ln -sf "$conf" ~/Documents/ss-local.json
      pkill -F ~/.ss-local.pid
      ss-local -c ~/Documents/ss-local.json -f ~/.ss-local.pid
    fi
    exit 0
fi
privoxy ~/Documents/privoxy.config
privoxy ~/Documents/privoxy-all.config
pkill -F ~/.ss-local.pid
ss-local -c ~/Documents/ss-local.json -f ~/.ss-local.pid
networksetup -setwebproxy "Wi-Fi" 127.0.0.1 8118
networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 8118

