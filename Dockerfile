FROM alpine:latest

# 1. 安装基础依赖
RUN apk add --no-cache ca-certificates wget curl tzdata
ENV TZ=Asia/Shanghai

# 2. 下载并安装 Lucky (Go语言编写，开箱即用)
# 2. 自动获取最新版本号并下载安装 Lucky
RUN LATEST_VERSION=$(curl -s https://api.github.com/櫥b/gacjie/lucky/releases/latest | grep -oP '"tag_name": "\K[^"]*') \
    && echo "Latest version is ${LATEST_VERSION}" \
    # 去掉版本号前面的 v (例如将 v2.14.3 转为 2.14.3)
    && VERSION_NUM=$(echo ${LATEST_VERSION} | sed 's/^v//') \
    # 动态拼接正确的下载链接
    && wget https://github.com/gacjie/lucky/releases/download/${LATEST_VERSION}/lucky_${VERSION_NUM}_Linux_x86_64.tar.gz \
    && tar -xzf lucky_${VERSION_NUM}_Linux_x86_64.tar.gz \
    && mv lucky /usr/local/bin/lucky \
    && chmod +x /usr/local/bin/lucky \
    && rm -f lucky_${VERSION_NUM}_Linux_x86_64.tar.gz

# 3. 创建配置持久化目录
RUN mkdir -p /goodluck

# 4. 直接启动命令（连启动脚本 entrypoint.sh 都省了）
# -c 指定数据目录，-p 指定面板监听端口 16601
ENTRYPOINT ["/usr/local/bin/lucky", "-c", "/goodluck", "-p", "16601"]
