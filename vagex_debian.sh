#!/bin/bash
#功能：
#	基于debian的vagex挂机一键包
#原作者：主机控
#修改：
#  vagex插件更新为1.4
#  不再依赖googlecode仓库 http://code.google.com/p/vagex-debian/
#  修改部分代码，并加入注释
#备注：
#	尽量在screen下运行以防中途断线
#	第一次重启后无法输入 vagex ID ，点击 cancel ，依次按 ctrl + w 和 ctrl + q 关掉浏览器后，转向终端执行以下命令重启后 VNC 登陆，正常输入 vagex ID 。 
#用法： 安装完成后用vnc连接后进行相应firefox优化后, File > Open File ，选择 Video Quality Manager 安装文件，安装后再安装 vagex_firefox_add_on*.xpi
#       firefox优化无非就是关掉更新，关历史记录，更改首页为空白页面……

apt-get update 
#使用iceweasel
apt-get -q -y --force-yes install jwm vnc4server xterm iceweasel
#激活粘贴板，可以在vnc桌面环境下，vps和本机自由粘贴复制。
#vncconfig -nowin &
vncserver && vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartupbak
mv xstartup ~/.vnc/ && chmod a+x ~/.vnc/xstartup

mv vncserverd /etc/init.d && chmod a+x /etc/init.d/vncserverd
if [ -f /etc/rc.local ]; then
	sed -i '/exit\ 0/d' /etc/rc.local
	cat <<- EOF >> /etc/rc.local
/etc/init.d/vncserverd start
exit 0
EOF
else
	update-rc.d vncserverd defaults
fi

mv vncreboot.sh /etc/cron.daily && chmod a+x /etc/cron.daily/vncreboot.sh

if [`getconf LONG_BIT` = 32] 
then
	wget http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.236/install_flash_player_11_linux.x86_64.tar.gz
else
	wget http://fpdownload.macromedia.com/get/flashplayer/pdc/11.1.102.55/install_flash_player_11_linux.i386.tar.gz
fi

tar zxvf install*.tar.gz
mkdir -p /usr/lib/iceweasel/plugins
cp libflashplayer.so /usr/lib/iceweasel/plugins


#下载vagex及youtube优化插件。
wget https://addons.mozilla.org/firefox/downloads/file/168846/vagex_firefox_add_on-1.4.4-fn+an+fx+sm.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/134971/youtube_video_quality_manager-1.2-fx.xpi

/etc/init.d/vncserverd start 
