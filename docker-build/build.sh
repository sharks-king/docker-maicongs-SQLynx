#!/bin/bash

# 检查 \$1 是否为空
if [ -z "\$1" ]; then
  echo "Error: \\$1 (SQLYNX_VERSION) is required."
  exit 1
fi

# 输出 \$1 和 \$2 的值
echo "SQLYNX_VERSION: ${1}"
echo "SQLYNX_START_SHELL: ${2}"

# 构建命令的基础部分
BUILD_COMMAND="docker buildx build --build-arg SQLYNX_VERSION=${1}"

# 如果 \$2 不为空，则添加到构建命令中
if [ -n "\$2" ]; then
  BUILD_COMMAND="${BUILD_COMMAND} --build-arg SQLYNX_START_SHELL=${2}"
fi

# 添加其他参数
BUILD_COMMAND="${BUILD_COMMAND} --tag registry.cn-hangzhou.aliyuncs.com/sql_studio/sqlynx:${1} --platform=linux/amd64 . --push"

# 执行构建命令
echo "Executing command: ${BUILD_COMMAND}"
eval ${BUILD_COMMAND}