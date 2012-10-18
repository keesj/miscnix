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
git review -s
git fetch gerrit
git reset --hard
git checkout $VERSION
export PATH=/usr/bin:/bin:/usr/pkg/bin:/usr/local/bin:/sbin:/usr/sbin
#/root/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/pkg/bin:/usr/pkg/sbin:/usr/pkg/X11R6/bin
make clean world 2>&1
