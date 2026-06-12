FROM alpine:latest

# 1. 安装基础依赖
RUN apk add --no-cache ca-certificates wget curl tzdata bash
ENV TZ=Asia/Shanghai

# 2. 下载并安装 Lucky (v2.27.2)
RUN wget https://github.com/gdy666/lucky/releases/download/v2.27.2/lucky_2.27.2_Linux_x86_64.tar.gz \
    && tar -xzf lucky_2.27.2_Linux_x86_64.tar.gz \
    && mv lucky /usr/local/bin/lucky \
    && chmod +x /usr/local/bin/lucky \
    && rm -f lucky_2.27.2_Linux_x86_64.tar.gz

# 3. 下载并安装 s-ui (使用标准 64 位版本)
RUN wget https://github.com/alireza0/s-ui/releases/latest/download/s-ui-linux-amd64.tar.gz \
    && tar -xzf s-ui-linux-amd64.tar.gz \
    && mkdir -p /usr/local/s-ui \
    && mv sui /usr/local/s-ui/sui \
    && chmod +x /usr/local/s-ui/sui \
    && rm -f s-ui-linux-amd64.tar.gz

# 4. 创建各自的数据持久化目录
RUN mkdir -p /goodluck /usr/local/s-ui/db

# 5. 复制并配置启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 6. 通过脚本启动双服务
ENTRYPOINT ["/entrypoint.sh"]
