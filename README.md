#vagex-setup
===========

vagex setup script for debian

vagex vision:1.5.7

#功能：
	vncserver挂vagex
	采用vncserver+iceweasel+vagex1.5
#备注：
	尽量在screen下运行以防中途断线
	测试问题提交：http://www.tillage.net/vagex-debian-install-script/
 
#用法： 
	方法一：先安装git后下载安装脚本

	apt-get update
	apt-get install git
	git clone git://github.com/tillage/vagex-setup.git
	cd vagex-setup
	bash vagex_debian.sh
	
	方法二：不安装git直接下载压缩包后安装脚本
	
	wget -O vagex-setup.tar.gz https://github.com/tillage/vagex-setup/tarball/iceweasel
	tar xfz vagex-setup.tar.gz
	cd tillage-vagex*
	bash vagex_debian.sh
	
	安装完成后用vnc连接后进行相应firefox优化后, File > Open File ，选择 Video Quality Manager 安装文件，安装后再安装 vagex_firefox_add_on*.xpi firefox优化无非就是关掉更新，关历史记录，更改首页为空白页面……
