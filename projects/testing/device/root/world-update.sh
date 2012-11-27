#!/bin/sh
#if [ ! `uname` = 'Minix' ]
#then
#	echo "This script should be copied to your minix installation and run in there. (exiting)"
#	exit 1
#fi
export PATH=/usr/bin:/bin:/usr/pkg/bin:/usr/local/bin:/sbin:/usr/sbin

VERSION=master
GITVERSION=""
case "$1" in
  -version) VERSION="$2";;
   *)  break;;	# terminate while loop
esac
case "$2" in
  -gitversion) GITVERSION="$3";;
   *)  break;;	# terminate while loop
esac

set -x
cd /usr/src

env
type git

if [ -n  "$GITVERSION" ]
then
	git checkout $GITVERSION
fi
if [ -n "$VERSION"  ]
	git config --global --add gitreview.username "jenkins3"
	git review -s
	git review -d $VERSION
fi
make build 2>&1
