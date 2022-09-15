#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

# 检查系统类型
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

# 检查root
[[ $EUID -ne 0 ]] && echo -e "${RED}Error:${PLAIN} This script must be run as root!" && exit 1

# Install some dependencies
if [ "${release}" == "centos" ]; then
	yum -y install wget ca-certificates locales localedef 
else
	apt-get update 
	apt-get -y install wget ca-certificates locales 
fi

# Get Word dir
dir=$(pwd)

# 更改语言环境
if [ "${release}" == "centos" ]; then
	localedef -v -c -i zh_CN -f UTF-8 zh_CN.UTF-8 > /dev/null 2>&1
	cd /etc
	rm -rf locale.conf
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.conf > /dev/null 2>&1
	cp locale.conf locale
	cat locale.conf >> /etc/environment

elif [ "${release}" == "debian" ]; then
	rm -rf /etc/locale.gen
	rm -rf /etc/default/locale
	rm -rf /etc/default/locale.conf
	cd /etc/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.gen > /dev/null 2>&1
	locale-gen
	cd /etc/default/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.conf > /dev/null 2>&1
	cp locale.conf locale
elif [ "${release}" == "ubuntu" ]; then
		rm -rf /etc/locale.gen
	rm -rf /etc/default/locale
	rm -rf /etc/default/locale.conf
	cd /etc/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.gen > /dev/null 2>&1
	locale-gen
	cd /etc/default/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.conf > /dev/null 2>&1
	cp locale.conf locale
fi

# 返回成功信息
clear
echo "您的服务器语言设置已被改为中文（简体）"
echo "重新连接到您的服务器以检查它"
echo ""
echo "脚本来自 zhujiboke.com "

# 删除脚本
cd ${dir}
rm -rf LocaleCN.sh
