# 使用 Alpine Linux 3.20.1 作为基础镜像
FROM alpine:3.21.3

# 设置 SQLynx 的版本号，默认为 2.0.0
ARG SQLYNX_VERSION="3.6.0"
ARG SQLYNX_START_SHELL="sqlynx-ide"

# 将 ARG 变量转换为 ENV 变量，以便在运行阶段使用
ENV SQLYNX_VERSION=${SQLYNX_VERSION}
ENV SQLYNX_START_SHELL=${SQLYNX_START_SHELL}

# 设置工作目录为 /apps
WORKDIR /apps

# 替换默认的 Alpine 镜像源为中国科技大学的镜像源
RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

# 更新并安装必要的软件包，包括 bash、OpenJDK 8 JRE、wget、curl 等
RUN set -x \
    && apk update -v \
    && apk add --no-cache bash openjdk8-jre openjdk8-jre-lib wget curl iputils unzip zip \
    && apk cache clean \
    && rm -rf /var/cache/apk/*

# 下载并解压 SQLynx 应用程序，并创建符号链接
RUN set -x \
    && wget http://maicong-software-1302946156.cos.ap-beijing.myqcloud.com/software/sqlynx_linux_no_jdk_${SQLYNX_VERSION}.zip \
    && unzip sqlynx_linux_no_jdk_${SQLYNX_VERSION}.zip \
    && ln -s `unzip -l sqlynx_linux_no_jdk_${SQLYNX_VERSION}.zip | awk 'NR==4 {split($4, arr, "/"); print arr[1]; exit}'` sqlynx \
    && rm -rf sqlynx_linux_no_jdk_${SQLYNX_VERSION}.zip

# 创建启动脚本 start.sh，包含启动 SQLynx、处理信号和输出日志
RUN echo -e '#!/bin/bash\n bash /apps/sqlynx/${SQLYNX_START_SHELL}.sh start \n trap "echo Stopping SQLynx...;bash /apps/sqlynx/${SQLYNX_START_SHELL}.sh stop; exit 0" SIGINT SIGTERM \n tail -f /apps/sqlynx/log/${SQLYNX_START_SHELL}-console.log & \n wait $!' > /apps/sqlynx/start.sh && chmod a+x /apps/sqlynx/start.sh

# 暴露端口 18888
EXPOSE 18888

# 定义容器启动时运行的命令
CMD ["/bin/bash", "/apps/sqlynx/start.sh"]
