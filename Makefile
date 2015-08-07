BUILDDIR := build
PKGFILES := $(addprefix ${BUILDDIR}/,INFO host.php)

.PHONY: all clean distribute
all: fastsharecz.host

fastsharecz.host: ${PKGFILES}
	rm -f ${BUILDDIR}/.tmpfile
	tar czf fastsharecz.host -C ${BUILDDIR} .

${BUILDDIR}/%: % | ${BUILDDIR}
	awk '{ if ($$0 == "//CUT FROM HERE") { cutting=1; } if (cutting==0) print $$0; if ($$0 == "//CUT UP TO HERE") cutting=0; }' $< > ${BUILDDIR}/.tmpfile
	sed -e s/REPLACEME_DATE/"$$(date -R)"/ ${BUILDDIR}/.tmpfile > $@
	rm ${BUILDDIR}/.tmpfile

$(BUILDDIR):
	mkdir -p ${BUILDDIR}

test:
	php -f host.php

clean:
	rm -rf ${BUILDDIR}
	rm -f fastsharecz.host
