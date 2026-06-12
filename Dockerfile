FROM alpine:latest

# 1. 安装基础依赖
RUN apk add --no-cache ca-certificates wget curl tzdata
ENV TZ=Asia/Shanghai

# 2. 直接指定稳定的最新版本号（当前最新为 2.14.3）
ENV LUCKY_VERSION=2.14.3

# 3. 直接下载并安装 Lucky，不再依赖任何 API 解析
RUN wget https://github.com/gacjie/lucky/releases/download/v${LUCKY_VERSION}/lucky_${LUCKY_VERSION}_Linux_x86_64.tar.gz \
    && tar -xzf lucky_${LUCKY_VERSION}_Linux_x86_64.tar.gz \
    && mv lucky /usr/local/bin/lucky \
    && chmod +x /usr/local/bin/lucky \
    && rm -f lucky_${LUCKY_VERSION}_Linux_x86_64.tar.gz

# 4. 创建配置持久化目录
RUN mkdir -p /goodluck

# 5. 启动面板
ENTRYPOINT ["/usr/local/bin/lucky", "-c", "/goodluck", "-p", "16601"]
