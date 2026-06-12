#!/bin/sh
set -e

# 1. 确保 s-ui 数据库目录存在
mkdir -p /usr/local/s-ui/db

# 2. 在后台启动 Tailscale 守护进程
echo "=== [1/4] 正在启动 tailscaled 守护进程 ==="
tailscaled --tun=userspace-networking --socks5-server=127.0.0.1:1055 --outbound-http-proxy-override=127.0.0.1:1055 &

# 3. 等待 tailscaled 启动完毕
sleep 2

# 4. 将容器连接到你的 Tailscale 网络
echo "=== [2/4] 正在连接到 Tailscale 网络 ==="
if [ -z "$TS_AUTHKEY" ]; then
    echo "❌ 错误: 未检测到 TS_AUTHKEY 环境变量，Tailscale 无法登录！"
    exit 1
fi
# 使用用户态网络模式（userspace），完美兼容 PaaS 平台无 TUN 权限的环境
tailscale up --authkey="${TS_AUTHKEY}" --hostname=s-ui-northflank --accept-dns=false

# 5. 初始化 s-ui 配置（如果是第一次启动）
cd /usr/local/s-ui/s-ui
if [ ! -f "/usr/local/s-ui/db/s-ui.db" ]; then
    echo "=== [3/4] 正在初始化 s-ui 端口及账号 ==="
    ./sui setting -port 2095 || true
    ./sui admin -username admin -password admin || true
fi

echo "=== [4/4] 正在前台启动 s-ui 面板 (端口: 2095) ==="
# 让 s-ui 作为前台主进程，保持容器不退出
exec ./sui
