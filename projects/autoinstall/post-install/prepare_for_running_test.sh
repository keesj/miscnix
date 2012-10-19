#!/bin/sh
set -x
set -e


MYSCP="sshpass -p dev scp  -P 8888  -o NoHostAuthenticationForLocalhost=yes"
MYSSH="sshpass -p dev ssh -p 8888 root@127.0.0.1 -o NoHostAuthenticationForLocalhost=yes"

$MYSSH rm -rf packages
$MYSCP -r device/* root@127.0.0.1:/
$MYSSH pwd
$MYSSH /usr/pkg/sbin/pkg_add packages/unittest-xml-reporting-1.3.2.tgz
$MYSSH /usr/pkg/sbin/pkg_add packages/git-review-1.19.tgz
$MYSSH git config --global --add gitreview.username "jenkins3" 

#echo haha
