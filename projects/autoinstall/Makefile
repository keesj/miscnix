default:minix.base.8g.img

minix_R3.2.0-116fcea.iso.bz2:
	wget http://www.minix3.org/iso/minix_R3.2.0-116fcea.iso.bz2

#
# unzip the bz2
#
%.iso:%.iso.bz2
	bunzip2 -k $< 


#
#
# @TODO make the script more configurable
minix.base.8g.img:script/02_qemu_minix_base.install.expect minix_R3.2.0-116fcea.iso
	script/02_qemu_minix_base.install.expect
	mv minix.tmp.img minix.base.8g.img

minix.postinst.8g.img:minix.base.8g.img
	rm -f minix.postinst.8g.tmp.img minix.postinst.8g.img
	cp minix.base.8g.img minix.postinst.8g.tmp.img
	post-install/01-reconfigure-net.expect
	post-install/02-setup.expect
	post-install/03-keesj.expect
	mv minix.postinst.8g.tmp.img minix.postinst.8g.img
	
