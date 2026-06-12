FROM alpine:latest

# 1. 安装基础依赖，直接引入 tailscale
RUN apk add --no-cache ca-certificates wget curl tzdata bash tailscale
ENV TZ=Asia/Shanghai

# 2. 下载并解压 s-ui (alireza0 官方版)
RUN wget https://github.com/alireza0/s-ui/releases/latest/download/s-ui-linux-amd64.tar.gz \
    && mkdir -p /usr/local/s-ui \
    && tar -xzf s-ui-linux-amd64.tar.gz -C /usr/local/s-ui \
    && chmod +x /usr/local/s-ui/s-ui/sui \
    && rm -f s-ui-linux-amd64.tar.gz

# 3. 创建数据持久化目录
RUN mkdir -p /usr/local/s-ui/db

# 4. 复制并配置启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
