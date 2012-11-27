#!/bin/sh
#if [ ! `uname` = 'Minix' ]
#then
#	echo "This script should be copied to your minix installation and run in there. (exiting)"
#	exit 1
#fi
export PATH=/usr/bin:/bin:/usr/pkg/bin:/usr/local/bin:/sbin:/usr/sbin

VERSION=master
case "$1" in
  -version) VERSION="$2";;
   *)  break;;	# terminate while loop
esac

set -x
cd /usr/src

env
type git

echo "VERSION: $VERSION"
if [ $VERSION = "master" ]
then
	git checkout master
else
	git config --global --add gitreview.username "jenkins3"
	git review -s
	git review -d $VERSION
fi
make build 2>&1
