#!/bin/sh

if [ ! -f minix.postinst.8g.img ]
then
	minix.postinst.8g.img
fi
DISK_IMAGE=minix.postinst.8g.img

if [ ! -f usbdisk.img ] 
then
	#create a "usb disk"
	echo "creating usb disk image"
	dd if=/dev/zero of=usbdisk.img bs=1M seek=1000 count=1
	
fi
USB_DISK_PARAMS="-drive id=my_usb_disk,file=usbdisk.img,if=none  -device usb-storage,drive=my_usb_disk "


QEMU_PARAMS=$USB_DISK_PARAMS
INSTANCE_NUMBER=1


for i in `seq 1 1 10`
do
	if  ! netstat -na  | grep "tcp[^6].*LISTEN"  | awk '{print $4}' | sed "s,.*:,,g" | grep $((4444 + $i)) 1>/dev/null
	then
		echo "Free instance found: $i"
		INSTANCE_NUMBER=$i
		break
	fi
done


SSH_PORT=$((2222 + $INSTANCE_NUMBER))
MONITOR_PORT=$((4444 + $INSTANCE_NUMBER))
#
# Currently 512 MB is needed to start with networking
# 1024 is needed to compile clang....
#
# start qemu with port redirection so sshing to localhost 2222 will ssh into the qemu instance
# also start the monitor on port 4444 so we can telnet to it.
echo "starting qemu instance ${INSTANCE_NUMBER} with ssh port ${SSH_PORT} and monitor on port ${MONITOR_PORT}"
sleep 2
exit
qemu-system-i386 -localtime -redir tcp:$SSH_PORT::22 -m 1024 -hda $DISK_IMAGE -curses \
	-monitor telnet::$MONITOR_PORT,server,nowait \
	-enable-kvm -usb  $QEMU_PARAMS

