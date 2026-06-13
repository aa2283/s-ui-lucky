#!/bin/bash

echo "=== [1/2] 正在后台启动 s-ui 面板... ==="
# 默认配置初始化（保留你镜像原有的逻辑，假设是通过 sui 程序直接拉起）
cd /usr/local/s-ui/s-ui
./sui > /dev/null 2>&1 &

# 稍微等 2 秒让 s-ui 的端口和网络就绪
sleep 2

echo "=== [2/2] 正在前台启动 frpc 穿透... ==="
# 检查配置文件是否存在，如果不存在就生成一个默认的模板防止报错崩溃
if [ ! -f "/etc/frp/frpc.toml" ]; then
    echo "警告: 未检测到 /etc/frp/frpc.toml，正在生成默认模板..."
    cat <<EOF > /etc/frp/frpc.toml
serverAddr = "litao.dns.army"
serverPort = 7000
auth.token = "myfrp123"

[[proxies]]
name = "s-ui-udp"
type = "udp"
localIP = "127.0.0.1"
localPort = 32539
remotePort = 32668
EOF
fi

# 在前台阻塞运行 frpc，死守容器寿命
exec /usr/local/bin/frpc -c /etc/frp/frpc.toml
