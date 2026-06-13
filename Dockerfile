FROM alpine:latest

# 1. 安装基础依赖
RUN apk add --no-cache ca-certificates wget curl tzdata bash
ENV TZ=Asia/Shanghai

# 2. 下载并安装 FRP 客户端 (v0.60.0 稳定版)
RUN wget https://github.com/fatedier/frp/releases/download/v0.60.0/frp_0.60.0_linux_amd64.tar.gz \
    && tar -xzf frp_0.60.0_linux_amd64.tar.gz \
    && mkdir -p /usr/local/bin /etc/frp \
    && mv frp_0.60.0_linux_amd64/frpc /usr/local/bin/frpc \
    && chmod +x /usr/local/bin/frpc \
    && rm -rf frp_0.60.0_linux_amd64*

# 3. 下载并解压 s-ui (alireza0 官方版)
RUN wget https://github.com/alireza0/s-ui/releases/latest/download/s-ui-linux-amd64.tar.gz \
    && mkdir -p /usr/local/s-ui \
    && tar -xzf s-ui-linux-amd64.tar.gz -C /usr/local/s-ui \
    && chmod +x /usr/local/s-ui/s-ui/sui \
    && rm -f s-ui-linux-amd64.tar.gz

# 4. 创建持久化数据目录
# /etc/frp 目录留给你挂载或放 frpc.toml
RUN mkdir -p /etc/frp /usr/local/s-ui/db

# 5. 复制并配置启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 6. 启动指挥棒
ENTRYPOINT ["/entrypoint.sh"]
