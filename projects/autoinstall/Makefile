default:minix.dev.8g.img

#
# Download the isp
#
minix-dev.iso:
	wget http://www.minix3.org/iso/minix3_2_1_ide_20120620_ace9a62.iso.bz2
	bunzip2 minix3_2_1_ide_20120620_ace9a62.iso.bz2
	mv  minix3_2_1_ide_20120620_ace9a62.iso minix-dev.iso

#
# Perform installation to harddisk
#
minix.dev.8g.img:script/02_qemu_minix_base.install.expect minix-dev.iso
	script/02_qemu_minix_base.install.expect -- --image $@ --cdrom minix-dev.iso

#
# Perform generic post installation
#
minix.dev-postinst.8g.img:minix.dev.8g.img
	cp $< $@
	post-install/02-setup.expect -- --image $@
	post-install/03-password.expect -- --image $@
	#echo "now start the image using the startup.sh script"
	#echo "and scp and run post-install.sh to finish installation"
	
