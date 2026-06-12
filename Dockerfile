FROM alpine:latest

# 1. 安装基础依赖
RUN apk add --no-cache ca-certificates wget curl tzdata
ENV TZ=Asia/Shanghai

# 2. 直接使用你提供的完全正确的官方 2.27.2 下载链接
RUN wget https://github.com/gdy666/lucky/releases/download/v2.27.2/lucky_2.27.2_Linux_x86_64.tar.gz \
    && tar -xzf lucky_2.27.2_Linux_x86_64.tar.gz \
    && mv lucky /usr/local/bin/lucky \
    && chmod +x /usr/local/bin/lucky \
    && rm -f lucky_2.27.2_Linux_x86_64.tar.gz

# 3. 创建配置持久化目录
RUN mkdir -p /goodluck

# 4. 启动面板（使用容器内 16601 端口）
ENTRYPOINT ["/usr/local/bin/lucky", "-c", "/goodluck", "-p", "16601"]
