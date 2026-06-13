#!/bin/sh
set -e

# 1. 确保 s-ui 数据库目录存在
mkdir -p /usr/local/s-ui/db

# 2. 在后台启动 tailscaled（去掉那个报错的参数）
echo "=== [1/4] 正在启动 tailscaled 守护进程 ==="
tailscaled --tun=userspace-networking --socks5-server=127.0.0.1:1055 &

# 3. 等待守护进程完全就绪
sleep 3

# 4. 连接 Tailscale
echo "=== [2/4] 正在连接到 Tailscale 网络 ==="
if [ -z "$TS_AUTHKEY" ]; then
    echo "❌ 错误: 未检测到 TS_AUTHKEY 环境变量，Tailscale 无法登录！"
    # 为了防止网络抖动误判导致容器闪退，你可以选择报错但不退出，或者直接退出
    exit 1
fi

tailscale up --authkey="${TS_AUTHKEY}" --hostname=s-ui-northflank --accept-dns=false

# 5. 初始化 s-ui 配置
cd /usr/local/s-ui/s-ui
if [ ! -f "/usr/local/s-ui/db/s-ui.db" ]; then
    echo "=== [3/4] 正在初始化 s-ui 端口及账号 ==="
    ./sui setting -port 2095 || true
    ./sui admin -username admin -password admin || true
fi

echo "=== [4/4] 正在前台启动 s-ui 面板 (端口: 2095) ==="
exec ./sui
