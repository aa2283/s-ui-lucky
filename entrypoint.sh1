#!/bin/sh
set -e

# 创建数据库目录
mkdir -p /usr/local/s-ui/db

# 必须切换到程序所在目录，否则 s-ui 会找不到静态网页资源
cd /usr/local/s-ui/s-ui

# 如果是第一次启动（数据库不存在），自动完成端口和账号初始化
if [ ! -f "/usr/local/s-ui/db/s-ui.db" ]; then
    echo "=== [初始化] 正在配置 s-ui 端口及账号 ==="
    ./sui setting -port 2095 || true
    ./sui admin -username admin -password admin || true
fi

echo "=== [1/2] 正在后台启动 s-ui 面板 (端口: 2095, 路径: /app/) ==="
./sui &

echo "=== [2/2] 正在启动 Lucky 面板 (端口: 16601) ==="
exec /usr/local/bin/lucky -cd /goodluck -port 16601
