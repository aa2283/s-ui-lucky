#!/bin/sh
set -e

mkdir -p /usr/local/s-ui/db

# 如果数据库不存在，强制初始化 s-ui 端口为你指定的 2095
if [ ! -f "/usr/local/s-ui/db/s-ui.db" ]; then
    echo "=== 正在初始化 s-ui 端口为 2095 ==="
    # 使用 alireza0 的 s-ui 命令初始化
    /usr/local/s-ui/s-ui setting -port 2095 -username admin -password admin || true
fi

echo "=== [1/2] 正在启动 s-ui 面板 (端口: 2095) ==="
/usr/local/s-ui/s-ui run &

echo "=== [2/2] 正在启动 Lucky 面板 (端口: 16601) ==="
exec /usr/local/bin/lucky -cd /goodluck -port 16601
