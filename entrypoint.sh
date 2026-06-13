#!/bin/bash

echo "=== [1/2] 正在后台初始化并启动 s-ui 面板... ==="
cd /usr/local/s-ui/s-ui

# 💡 核心修正：带上 export，确保读取环境变量，并使用更稳妥的运行方式
export SUI_PORT=2095
./sui > /dev/null 2>&1 &

# 延迟 3 秒，给 s-ui 充足的时间去创建数据库和向系统申请 2095 端口
sleep 3

# 检查 2095 端口到底有没有开，如果没开说明刚才命令行不行，需要换带参数的强启
if ! netstat -tuln | grep -q ":2095 "; then
    echo "警告: 默认启动未成功监听 2095 端口，尝试使用命令行参数强启..."
    ./sui -port 2095 > /dev/null 2>&1 &
    sleep 2
fi

echo "=== [2/2] 正在前台启动 frpc 穿透... ==="
# frpc 会在最前台死守，只要它不倒，容器就不会重启
exec /usr/local/bin/frpc -c /etc/frp/frpc.toml
