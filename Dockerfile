FROM alpine:latest

# 1. 安装基础依赖
RUN apk add --no-cache ca-certificates wget curl tzdata bash
ENV TZ=Asia/Shanghai

# 2. 下载并安装 Lucky (gdy666 官方稳定版 v2.27.2)
RUN wget https://github.com/gdy666/lucky/releases/download/v2.27.2/lucky_2.27.2_Linux_x86_64.tar.gz \
    && tar -xzf lucky_2.27.2_Linux_x86_64.tar.gz \
    && mv lucky /usr/local/bin/lucky \
    && chmod +x /usr/local/bin/lucky \
    && rm -f lucky_2.27.2_Linux_x86_64.tar.gz

# 3. 下载并安装你的 s-ui (alireza0 官方最新版)
RUN wget https://github.com/alireza0/s-ui/releases/latest/download/s-ui-linux-amd64.tar.gz \
    && mkdir -p /usr/local/s-ui \
    && tar -xzf s-ui-linux-amd64.tar.gz -C /usr/local/s-ui \
    # alireza0 编译出来的名字是 s-ui，我们统一将其赋予执行权限
    && chmod +x /usr/local/s-ui/s-ui \
    && rm -f s-ui-linux-amd64.tar.gz

# 4. 创建各自的数据持久化目录
RUN mkdir -p /goodluck /usr/local/s-ui/db

# 5. 复制并配置启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 6. 启动双服务
ENTRYPOINT ["/entrypoint.sh"]
