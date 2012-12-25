#!/bin/bash
#功能：
#	基于debian的vagex挂机一键包
#作者：耕耘
#修改：
#  12.25 vagex 1.5.6
#  12.18 vagex 1.5.5
#  11.30 vagex 1.5.1
#  11.20 vagex插件更新为1.4.5
#  不再依赖googlecode仓库 http://code.google.com/p/vagex-debian/
#  修改部分代码，并加入注释
#备注：
#	尽量在screen下运行以防中途断线
#	第一次重启后无法输入 vagex ID ，点击 cancel ，依次按 ctrl + w 和 ctrl + q 关掉浏览器后，转向终端执行以下命令重启后 VNC 登陆，正常输入 vagex ID 。 
#用法： 安装完成后用vnc连接后进行相应firefox优化后, File > Open File ，选择 Video Quality Manager 安装文件，安装后再安装 vagex_firefox_add_on*.xpi
#       firefox优化无非就是关掉更新，关历史记录，更改首页为空白页面……

vagex_addr="http://vagex.com/vagex_add_on-1.5.6.xpi"
#vagex_addr="https://addons.mozilla.org/firefox/downloads/file/168846/vagex_firefox_add_on-1.4.4-fn+an+fx+sm.xpi"

apt-get update 
#使用iceweasel
apt-get -q -y --force-yes install jwm vnc4server xterm iceweasel zip wget 
# 安装中文字库，设置locales，非必需
apt-get install ttf-wqy-zenhei
dpkg-reconfigure locales
#激活粘贴板，可以在vnc桌面环境下，vps和本机自由粘贴复制。
#vncconfig -nowin &
vncserver && vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartupbak
mv xstartup ~/.vnc/ && chmod a+x ~/.vnc/xstartup

cp vncserverd /etc/init.d && chmod a+x /etc/init.d/vncserverd
if [ -f /etc/rc.local ]; then
	sed -i '/exit\ 0/d' /etc/rc.local
	cat <<- EOF >> /etc/rc.local
/etc/init.d/vncserverd start
exit 0
EOF
else
	update-rc.d vncserverd defaults
fi

cp vncreboot.sh /etc/cron.hourly/vncreboot && chmod a+x /etc/cron.hourly/vncreboot
/etc/init.d/cron restart

if [`getconf LONG_BIT` = 32] 
then
	wget http://f.tillage.net/flash/libflashplayer-32bit.so.zip
else
	wget http://f.tillage.net/flash/libflashplayer-64bit.so.zip
fi

unzip libflashplayer*.zip
mkdir -p /usr/lib/iceweasel/plugins
cp libflashplayer.so /usr/lib/iceweasel/plugins


#下载vagex及youtube优化插件。
wget $vagex_addr 
wget https://addons.mozilla.org/firefox/downloads/file/134971/youtube_video_quality_manager-1.2-fx.xpi

/etc/init.d/vncserverd start 
