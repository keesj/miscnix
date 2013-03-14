#!/bin/sh
set -x
set -e


MYSCP="sshpass -p dev scp  -P 8888  -o NoHostAuthenticationForLocalhost=yes -o PubkeyAuthentication=no"
MYSSH="sshpass -p dev ssh -p 8888 root@127.0.0.1 -o NoHostAuthenticationForLocalhost=yes -o PubkeyAuthentication=no "

$MYSSH rm -rf packages
$MYSCP -r device/* root@127.0.0.1:/
$MYSSH pkgin -y install git-review unittest-xml-reporting fuse-ntfs-3g-1.1120 ntfsprogs
$MYSSH git config --global --add gitreview.username "jenkins3" 

#echo haha
