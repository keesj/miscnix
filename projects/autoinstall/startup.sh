#!/bin/sh

DISK_IMAGE=minix.postinst.8g.img
INSTANCE_NUMBER=1


if [ -f .settings ]
then
	#allow to override the above settings using a .settings file
	#with DISK_IMAGE=minix-usb.img for example
	. ./.settings
fi

if [ ! -f usbdisk.img ] 
then
	#create a "usb disk"
	#this part is really optional usbdisk.img is added to qemu as a usb base disk
	#and is added here to allow testing of the dde usb stack 
	echo "creating usb disk image"
	dd if=/dev/zero of=usbdisk.img bs=1M seek=1000 count=1
	
fi
USB_DISK_PARAMS="-drive id=my_usb_disk,file=usbdisk.img,if=none  -device usb-storage,drive=my_usb_disk "


QEMU_PARAMS=$USB_DISK_PARAMS


#
# Try and find free tcp ports to run a qemu instance. This part is most probably not 
# portable as it assumes output from netstat
#tcp        0      0 0.0.0.0:9418            0.0.0.0:*               LISTEN     
#
for i in `seq 0 1 10`
do
	if  ! netstat -na  | grep "tcp[^6].*LISTEN"  | awk '{print $4}' | sed "s,.*:,,g" | grep $((4444 + $i)) 1>/dev/null
	then
		INSTANCE_NUMBER=$i
		break
	fi
done

if [ ! -f $DISK_IMAGE ]
then
	echo "Did not find '${DISK_IMAGE}' to start"
	exit 1
fi

SSH_PORT=$((2222 + $INSTANCE_NUMBER))
MONITOR_PORT=$((4444 + $INSTANCE_NUMBER))
#
# Currently 512 MB is needed to start with networking
# 1024 is needed to compile clang....
#
# start qemu with port redirection so sshing to localhost 2222 will ssh into the qemu instance
# also start the monitor on port 4444 so we can telnet to it.
echo "starting ${DISK_IMAGE} qemu instance ${INSTANCE_NUMBER} with ssh port ${SSH_PORT} and monitor on port ${MONITOR_PORT}"
sleep 2
qemu-system-i386 -localtime -redir tcp:$SSH_PORT::22 -m 1024 -hda $DISK_IMAGE -curses \
	-monitor telnet::$MONITOR_PORT,server,nowait \
	-enable-kvm -usb  $QEMU_PARAMS

