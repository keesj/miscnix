#!/bin/sh
export PATH=/usr/bin:/bin:/usr/pkg/bin:/usr/local/bin:/sbin:/usr/sbin
cd /usr/src/releasetools
touch /lib/dummy.so
./release.sh  -c -p 2>&1
