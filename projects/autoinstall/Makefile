default:minix.dev.8g.img

#
# Download the isp
#
minix-dev.iso:
	wget http://www.minix3.org/iso/minix3_2_1_ide_20120621_f8c6b27.iso.bz2
	bunzip2 minix3_2_1_ide_20120621_f8c6b27.iso.bz2
	mv  minix3_2_1_ide_20120621_f8c6b27.iso minix-dev.iso

#
# Perform installation to harddisk
#
minix.dev.8g.img:script/02_qemu_minix_base.install.expect minix-dev.iso
	time script/02_qemu_minix_base.install.expect -- --image $@ --cdrom minix-dev.iso 2>&1 | tee  $@.log

#
# Perform generic post installation
#
minix.dev-postinst.8g.img:minix.dev.8g.img
	cp $< $@
	time post-install/02-setup.expect -- --image $@ 2>&1 | tee  $@.log
	post-install/03-password.expect -- --image $@ 2>&1 | tee -a $@.log
	#echo "now start the image using the startup.sh script"
	#echo "and scp and run post-install.sh to finish installation"
	
