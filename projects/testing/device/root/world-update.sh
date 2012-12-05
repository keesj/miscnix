#!/bin/sh
#if [ ! `uname` = 'Minix' ]
#then
#	echo "This script should be copied to your minix installation and run in there. (exiting)"
#	exit 1
#fi
export PATH=/usr/bin:/bin:/usr/pkg/bin:/usr/local/bin:/sbin:/usr/sbin

VERSION=""
GITVERSION=""
case "$1" in
  -version) VERSION="$2";;
  -gitversion) GITVERSION="$2";;
   *)  break;;	# terminate while loop
esac

set -x
cd /usr/src

git clean -f -x -d  -e .gitreview
git reset --hard
if [ -n  "$GITVERSION" ]
then
	
	echo DOING GIT CHECKOUT
	git pull
	git checkout $GITVERSION
fi

if [ -n "$VERSION"  ]
then
	echo DOING GERRIT CHECKOUT
	export USERNAME=jenkins3
	git config --global --add gitreview.username "jenkins3"
	git review -s
	git review -d $VERSION
fi
make build 2>&1
