#!/bin/sh
cat <<EOM
Things this script will do 

* checkout the pkgsrc
* checkout the HEAD version of the MINIX source
* build and install a new clang compiler to support shared libraries
* make world using shared libary support
* tweak the stty settings and copy the indent files to the root users' 
  directory


Things that still need doing by hand:
* ssh-keygen
* copy ssh shared key
* Create .ssh/config
Host gitsrv
HosstName oeeo.few.vu.nl
User git
IdentityFile ~/.ssh/shared
* git config --global user.name "Kees Jongenburger"
* git config --global user.email "kees.jongenburger@gmail.com"
* create dot git config and addremote git@gitsrv:minix-usb
* setup pkgsrc cd /usr ; make pkgsrc-create
* add pkgsrc remote
* PKG development 
* install url2pkg and pkglint

STARTING
EOM



if [ ! `uname` = 'Minix' ]
then
	echo "This script should be copied to your minix installation and run in there. (exiting)"
	exit 1
fi

set -x
(
#exit
	# update git 
	cd /usr/src
	# Unstaged changes after reset:
	#M       include/minix/sys_config.h
	#
	#
	git reset --hard
	git pull
	git checkout -t origin/master
)
(
#exit
	cd /usr/
	make pkgsrc-create 
)
(
#exit
	cd /usr/pkgsrc/minix/clang29/
	bmake && pkgin -y remove clang-2.9nb5 && bmake install
)
(
#exit
	cd /usr/src
	git pull
	#see docs updating 20120402 
	make -C usr.bin/genassym install
	make clean world
)

#
# change stty behaviour and copy indent.pro
#
(
	if grep erase /root/.ashrc 
	then
		echo ".bashrc already patched"
	else 
		echo 'stty erase ^?' >> /root/.ashrc
	fi

	if [ -f /root/.indent.pro ]
	then
		echo "indent configuration already copied"
	else 
		cp /usr/share/misc/indent.pro /root/.indent.pro
	fi
)
