FROM alpine:latest

# 1. 安装基础依赖
RUN apk add --no-cache ca-certificates wget curl tzdata
ENV TZ=Asia/Shanghai

# 2. 下载并安装完全正确的官方 2.27.2 版本
RUN wget https://github.com/gdy666/lucky/releases/download/v2.27.2/lucky_2.27.2_Linux_x86_64.tar.gz \
    && tar -xzf lucky_2.27.2_Linux_x86_64.tar.gz \
    && mv lucky /usr/local/bin/lucky \
    && chmod +x /usr/local/bin/lucky \
    && rm -f lucky_2.27.2_Linux_x86_64.tar.gz

# 3. 创建配置持久化目录
RUN mkdir -p /goodluck

# 4. 修正启动参数：
# -cd 指定配置文件夹路径
# -port 指定管理面板监听端口
ENTRYPOINT ["/usr/local/bin/lucky", "-cd", "/goodluck", "-port", "16601"]
