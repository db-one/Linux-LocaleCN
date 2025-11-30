#!/bin/bash

# 检查root权限
[ $(id -u) != "0" ] && { echo "${CFAILURE}错误: 你必须是ROOT权限才能运行此脚本${CEND}"; exit 1; }

# 安装必要组件（包含locales和基础中文字体）
apt-get update
apt-get install -y wget ca-certificates locales
# apt-get install -y wget ca-certificates locales fonts-wqy-microhei

# 启用中文区域
sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen zh_CN.UTF-8

# 设置默认语言
tee /etc/default/locale >/dev/null <<EOF
LANG="zh_CN.UTF-8"
LC_ALL="zh_CN.UTF-8"
LANGUAGE="zh_CN.UTF-8"
EOF

# 配置设置生效
echo "应用当前环境设置..."
source /etc/default/locale

# 验证输出
echo -e "\n配置完成！验证信息："
echo "当前语言：$(locale | grep LANG)"
echo "配置已完成！当前终端已支持中文显示。"

# 删除临时文件
rm -rf LocaleCN.sh
