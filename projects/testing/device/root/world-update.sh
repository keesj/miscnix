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
make clean world  2>&1
