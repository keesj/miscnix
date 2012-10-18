#!/bin/sh
if [ ! `uname` = 'Minix' ]
then
	echo "This script should be copied to your minix installation and run in there. (exiting)"
	exit 1
fi

VERSION=master
while [ $# -gt 0 ]
do
    case "$1" in
	-version) VERSION="$2"; shift;;
	*)  break;;	# terminate while loop
    esac
    shift
done

set -x
cd /usr/src
#git config --global user.name jenkins3
#git config --global user.email jenkins@keesj.dds.nl
git config --global --add gitreview.username "jenkins3"
git review -s
git review -d $VERSION
export PATH=/usr/bin:/bin:/usr/pkg/bin:/usr/local/bin:/sbin:/usr/sbin
#/root/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/pkg/bin:/usr/pkg/sbin:/usr/pkg/X11R6/bin
make clean world 2>&1
