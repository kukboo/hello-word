#!/bin/bash
# author:yituge.cn
echo 'CentOS部署halo博客系统一键脚本'
echo '更新yum'
sudo yum update -y
echo '安装最新版无头openjdk'
sudo yum install java-latest-openjdk-headless -y
echo '添加halo用户到/home'
sudo cd /home
sudo useradd -m halo
su halo <<!
echo '安装halo-jar文件并重命名'
if [ -e halo/halo-latest.jar ];then
echo 'halo-jar文件已存在'
else
cd /home
echo '备用jar下载网址https://dl.halo.run/release/halo-1.3.2.jar'
wget https://halo.cary.tech/release/halo-1.3.2.jar -O halo/halo-latest.jar
fi
echo '下载配置文件到 ~/.halo 目录'
curl -o ~/.halo/application.yaml --create-dirs https://dl.halo.run/config/application-template.yaml
exit
!
echo '下载 Halo 官方的 halo.service 模板'
sudo curl -o /etc/systemd/system/halo.service --create-dirs https://dl.halo.run/config/halo.service
echo '修改 /etc/systemd/system/halo.service'
sudo sed -i "s/JAR_PATH/\/home\/halo\/halo-latest.jar/g" /etc/systemd/system/halo.service
echo '刷新 Systemd'
sudo systemctl daemon-reload
echo '使 Halo 开机自启'
sudo systemctl enable halo
echo '启动 Halo'
su halo -c "service halo start"
echo '查看 Halo 状态'
su halo -c service halo status
echo '----END----'
