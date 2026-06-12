#!/bin/sh
set -e

# 确保数据目录存在
mkdir -p /usr/local/s-ui/db

# 核心一步：如果数据库是新创建的，强制将 s-ui 的面板监听端口改为 2095
if [ ! -f "/usr/local/s-ui/db/s-ui.db" ]; then
    echo "=== 正在初始化 s-ui 端口为 2095 ==="
    # 借助 s-ui 自带的命令行工具直接修改初始端口
    /usr/local/s-ui/sui setting -port 2095 -username admin -password admin || true
fi

echo "=== [1/2] 正在启动 s-ui 面板 (端口: 2095) ==="
/usr/local/s-ui/sui run &

echo "=== [2/2] 正在启动 Lucky 面板 (端口: 16601) ==="
exec /usr/local/bin/lucky -cd /goodluck -port 16601
