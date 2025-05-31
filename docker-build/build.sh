#!/bin/bash

# 配置文件路径
CONFIG_FILE="build-config.env"

# 检查配置文件是否存在
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "Error: 配置文件 ${CONFIG_FILE} 不存在"
  exit 1
fi

# 加载配置文件
source "${CONFIG_FILE}" || {
  echo "Error: 无法加载配置文件 ${CONFIG_FILE}"
  exit 1
}

# 检查必需参数
if [ -z "${SQLYNX_VERSION}" ]; then
  echo "Error: SQLYNX_VERSION 未在配置文件中定义"
  exit 1
fi

# 输出参数值
echo "SQLYNX_VERSION: ${SQLYNX_VERSION}"
echo "SQLYNX_START_SHELL: ${SQLYNX_START_SHELL:-未设置}"

# 构建命令的基础部分
BUILD_COMMAND="docker buildx build --build-arg SQLYNX_VERSION=${SQLYNX_VERSION}"

# 如果设置了 SQLYNX_START_SHELL，则添加到构建命令
if [ -n "${SQLYNX_START_SHELL}" ]; then
  BUILD_COMMAND="${BUILD_COMMAND} --build-arg SQLYNX_START_SHELL=${SQLYNX_START_SHELL}"
fi

# 添加其他参数
BUILD_COMMAND="${BUILD_COMMAND} --tag sqlynx:${SQLYNX_VERSION} --platform=linux/amd64 ."

# 执行构建命令
echo "Executing command: ${BUILD_COMMAND}"
eval "${BUILD_COMMAND}"

# 配置标签
docker tag sqlynx:${SQLYNX_VERSION} sqlynx:latest