#!/bin/sh
if [ ! `uname` = 'Minix' ]
then
	echo "This script should be copied to your minix installation and run in there. (exiting)"
	exit 1
fi

set -x
#set -e
cd /usr/src
git reset --hard
git pull
#if we don't have a local checkout create one
if ! git branch | grep master 2>&1 > /dev/null
then
	git checkout -t origin/master
else 
	git checkout master
fi
#echo  "PATH=$PATH"
export PATH=/usr/bin:/bin:/usr/pkg/bin:/usr/local/bin:/sbin:/usr/sbin
#/root/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/pkg/bin:/usr/pkg/sbin:/usr/pkg/X11R6/bin
make clean world 2>&1
