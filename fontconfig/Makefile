# Set the lic to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make -f Makefile.os4 LIBC=clib4
# 

LIB_VERSION=2.14.2
LIBC?=newlib

PKGNAME=fontconfig-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://www.freedesktop.org/software/fontconfig/release/fontconfig-${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download

build:
	cd ${PKGNAME} && \
	CC="ppc-amigaos-gcc" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/local/${LIBC}/include/freetype2" \
	PKG_CONFIG_LIBDIR=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LIBS="-lfreetype -lbz2 -lpng -lbrotlicommon" \
	./configure --host=ppc-amigaos --enable-shared=no \
	&& \
	make -j$(shell nproc)

clean:
	@echo "-> Clean the build folder"
# @rm -rf ${PKGNAME}/build/*

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

