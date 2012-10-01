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

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ff_addr="http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/3.6.26/linux-i686/en-US/firefox-3.6.26.tar.bz2"
flash_addr="http://fpdownload.macromedia.com/get/flashplayer/pdc/11.1.102.55/install_flash_player_11_linux.i386.tar.gz"
vagex_addr="https://addons.mozilla.org/firefox/downloads/file/168846/vagex_firefox_add_on-1.4.4-fn+an+fx+sm.xpi"
yvqm_addr="https://addons.mozilla.org/firefox/downloads/file/134971/youtube_video_quality_manager-1.2-fx.xpi"

func_vncpwd() {
	echo "-----------"
	echo "Plese input the VNC password below!"
	echo "-----------"
}


func_in_flash() {
	wget $flash_addr &&
	mkdir ~/.mozilla
	mkdir ~/.mozilla/plugins
	tar xzf install*.tar.gz
	mv libflashplayer.so ~/.mozilla/plugins
	rm install*.tar.gz
}

func_in_ff() {
	wget $ff_addr
	tar xjf firefox*.tar.bz2
	mv  firefox ~/
	rm firefox*.tar.bz2
}

func_in_vnc() {
	aptitude -y install vnc4server &&
	func_vncpwd
	vncserver && vncserver -kill :1 &&
	mv ~/.vnc/xstartup ~/.vnc/xstartupbak &&
	mv xstartup ~/.vnc/ && chmod a+x ~/.vnc/xstartup &&

	mv vncserverd /etc/init.d && chmod a+x /etc/init.d/vncserverd &&
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

}

apt-get update &&
#apt-get -y --force-yes install aptitude wget &&    #非必须，除非是安装最精简的debian无aptitude和wget
#安装必要依赖
apt-get -y install mercurial libasound2-dev libcurl4-openssl-dev libnotify-dev libxt-dev libiw-dev mesa-common-dev autoconf2.13 yasm bzip2 zip libidl-dev 
#安装vnc
func_in_vnc
#安装firefox
func_in_ff
#安装flash
func_in_flash

#下载vagex及youtube优化插件。
wget $vagex_addr 
wget $yvqm_addr 

/etc/init.d/vncserverd start 