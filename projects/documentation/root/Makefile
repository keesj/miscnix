SRC=DdeKitUsb.txt
DST=$(SRC:%.txt=%.html)

website:${DST}

%.html:%.txt Makefile
	asciidoc $<
