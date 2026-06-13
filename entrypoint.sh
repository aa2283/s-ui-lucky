#!/bin/bash

echo "=== [1/2] 正在后台启动 s-ui 面板... ==="
cd /usr/local/s-ui/s-ui
./sui -port 2095 > /dev/null 2>&1 &

# 稍微等 2 秒让 s-ui 的端口和网络就绪
sleep 2

echo "=== [2/2] 正在前台启动 frpc 穿透... ==="
# 直接用 exec 顶上去，读取你在环境中处理好的配置文件
exec /usr/local/bin/frpc -c /etc/frp/frpc.toml
