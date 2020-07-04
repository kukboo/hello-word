#!/bin/bash
# author:yituge.cn
echo 'CentOS部署halo博客系统一键脚本'
echo '更新yum'
yum update -y
echo '安装最新版无头openjdk'
yum install java-latest-openjdk-headless -y
echo '添加halo用户到/home'
cd /home
useradd -m halo
echo '登录halo用户'
su halo
echo '安装halo-jar文件并重命名'
if [ -e /halo-latest.jar ];then
echo 'halo-jar文件已存在'
else
wget https://dl.halo.run/release/halo-1.3.2.jar -O halo-latest.jar
fi
echo '下载配置文件到 ~/.halo 目录'
curl -o ~/.halo/application.yaml --create-dirs https://dl.halo.run/config/application-template.yaml
echo '退出halo用户'
sudo root
echo '下载 Halo 官方的 halo.service 模板'
curl -o /etc/systemd/system/halo.service --create-dirs https://dl.halo.run/config/halo.service
echo '修改 /etc/systemd/system/halo.service'
sed -i "s/JAR_PATH/\/home\/halo\/halo-latest.jar/g" /etc/systemd/system/halo.service
echo '刷新 Systemd'
systemctl daemon-reload
echo '使 Halo 开机自启'
systemctl enable halo
echo '启动 Halo'
service halo start
echo '----END----'
