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
