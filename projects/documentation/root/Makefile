SRC=DdeKitUsb.txt
DST=$(SRC:%.txt=%.html)
IMGSRC=picsrc/minix3_mass_storage_init.png
IMGDST=$(IMGSRC:picsrc/%.png=img/%.png)

website:${DST} ${IMGDST} Makefile

${IMGDST}:${IMGSRC}
	mkdir -p img
	cp $< $@

%.html:%.txt 
	asciidoc $<
