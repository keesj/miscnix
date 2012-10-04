#!/bin/sh

DISK_IMAGE=minix.dev-postinst.8g.img
INSTANCE_NUMBER=1
MULTIBOOT_SOURCE_DIR=""

if [ -f .settings ]
then
	#allow to override the above settings using a .settings file
	#with DISK_IMAGE=minix-usb.img for example
	. ./.settings
fi

#
# If you want to test the usb stack for mass storage you can do this
# by uncommenting the following QEMU_PARAMS line.
# Make sure you create a dist image either with qemu-img or from the command
# line using
#
#  dd if=/dev/zero of=usbdisk.img bs=1M seek=1000 count=1
USB_DISK_PARAMS="-drive id=my_usb_disk,file=usbdisk.img,if=none  -device usb-storage,drive=my_usb_disk "
#QEMU_PARAMS="-usb $USB_DISK_PARAMS"


port_bound(){
	if netstat -na  | grep "tcp[^6].*LISTEN"  | awk '{print $4}' | sed "s,.*:,,g" | grep "$1\$" 1>/dev/null
	then
		return 1
	fi
	return 0	
}
#
# Try and find free tcp ports to run a qemu instance. This part is most probably not 
# portable as it assumes output from netstat
#tcp        0      0 0.0.0.0:9418            0.0.0.0:*               LISTEN     
#
for i in `seq 0 1 10`
do
	if port_bound $((4444 + $i))
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


#
# if the MULTIBOOT_SOURCE_DIR is given (and is a directory) copy the files to a
# new directory called multiboot.
#
# Setup the qemu parameters to emable multiboot
#

if [ -n "$MULTIBOOT_SOURCE_DIR" -a -d "$MULTIBOOT_SOURCE_DIR" ]
then
	echo "Using multiboot (found directory)"

	# For multiboot in qemu we need to give the modules as parameter to
	# qemu in the initrd argument. We need a comma separated list of items
	# but also need to pass the kernel command line arguments to the
	# modules.

	MULTIBOOT_DEST_DIR=multiboot
	rm -rf $MULTIBOOT_DEST_DIR
	mkdir -p $MULTIBOOT_DEST_DIR
	cp $MULTIBOOT_SOURCE_DIR/* $MULTIBOOT_DEST_DIR
	for i in $MULTIBOOT_DEST_DIR/mod*.gz ; do gunzip $i ; done

	#
	# The modules initially don't have access to the kernel command line so
	# we are forced to pass the kernel command line to all the modules.
	# Failing to do so will for example result in the file system not being
	# mounted because the root device name is unknown.
	#

	MULTIBOOT_KERNEL_CMD_LINE="rootdevname=c0d0p0s0"
	MULTIBOOT_MODULE_NAMES="
		mod01_ds \
		mod02_rs \
		mod03_pm \
		mod04_sched \
		mod05_vfs \
		mod06_memory \
		mod07_log \
		mod08_tty \
		mod09_mfs \
		mod10_vm \
		mod11_pfs \
		mod12_init \
		"
	MULTIBOOT_MODULES=""
	for i in ${MULTIBOOT_MODULE_NAMES}
	do
		MULTIBOOT_MODULES="$MULTIBOOT_MODULES,$MULTIBOOT_DEST_DIR/${i} arg=$MULTIBOOT_KERNEL_CMD_LINE"
	done
	MULTIBOOT_MODULES=${MULTIBOOT_MODULES:1}
	MULTIBOOT_PARAMS="-kernel $MULTIBOOT_DEST_DIR/kernel -initrd \"$MULTIBOOT_MODULES\""

	QEMU_PARAMS="$QEMU_PARAMS -append \"$MULTIBOOT_KERNEL_CMD_LINE\""
	QEMU_PARAMS="$QEMU_PARAMS $MULTIBOOT_PARAMS"
fi


SSH_PORT=$((2222 + $INSTANCE_NUMBER))
MONITOR_PORT=$((4444 + $INSTANCE_NUMBER))

if ! port_bound $SSH_PORT
then
	echo "SSH port $SSH_PORT already bound"
	exit 1
fi
if ! port_bound $MONITOR_PORT
then
	echo "Monitor port $MONITOR_PORT already bound"
	exit 1
fi

# Test if we can use kvm 
if [ -x /usr/sbin/kvm-ok ]
then
	if /usr/sbin/kvm-ok 2>&1 > /dev/null
	then
		QEMU_PARAMS="$QEMU_PARAMS -enable-kvm"
	else
		QEMU_PARAMS="$QEMU_PARAMS -disable-kvm"
	fi
fi

# Currently 512 MB is needed to start with networking 1024 is needed to compile
# clang....
#
# start qemu with port redirection so sshing to localhost 2222 will ssh into
# the qemu instance also start the monitor on port 4444 so we can telnet to it.

echo "starting ${DISK_IMAGE} qemu instance ${INSTANCE_NUMBER} with ssh port ${SSH_PORT} and monitor on port ${MONITOR_PORT}"
sleep 2

# The default network driver for qemu changed over time. At first The used
# device was a Realtek 8139(rtl8139). Later they changed the default to e1000. To try
# and use the previous driver uncomment the following line
#
#QEMU_PARAMS="$QEMU_PARAMS -net nic,model=e1000"

cmd="qemu-system-i386 -curses -localtime -redir tcp:$SSH_PORT::22 -m 2048  $QEMU_PARAMS -monitor telnet::$MONITOR_PORT,server,nowait -hda $DISK_IMAGE"
#
# I don't actually know why I need the eval here ..
echo $cmd
eval $cmd
