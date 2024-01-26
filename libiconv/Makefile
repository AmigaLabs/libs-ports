# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=1.17
LIBC?=newlib

PKGNAME=libiconv-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://ftp.gnu.org/pub/gnu/libiconv/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download patches

patches:
	@echo "-> Apply the patches"
	@patch -s -p0 < ./patch.diff

build:
	cd ${PKGNAME} && \
	CC="ppc-amigaos-gcc" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
	LDFLAGS="-mcrt=${LIBC} -Wl,--allow-shlib-undefined" \
	PKG_CONFIG_LIBDIR=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LIBS="" \
	./configure --host=ppc-amigaos \
		--enable-static=yes \
		--enable-shared=yes \
		--prefix=${SDK_PATH}/local/${LIBC} \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@make -C ${PKGNAME} clean
	@rm -rf ./${PKGNAME}/src/.libs ./${PKGNAME}/src/libmpfr.la \
		./${PKGNAME}/*.o ./${PKGNAME}/*.lo

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
# Release jobs

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/Documentation/libiconv
	@cp ${PKGNAME}/AUTHORS* ./SDK/local/Documentation/libiconv/
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/libiconv/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/libiconv/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/bin
	@mkdir -p ./SDK/local/$@/include
	@mkdir -p ./SDK/local/$@/lib
	@cp ./${PKGNAME}/lib/.libs/libiconv.a \
		./${PKGNAME}/lib/.libs/libiconv.lai \
		./${PKGNAME}/lib/.libs/libiconv.so \
		./${PKGNAME}/lib/libiconv.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/include/iconv.h ./SDK/local/$@/include/
	@cp ./${PKGNAME}/src/.libs/iconv_no_i18n ./SDK/local/$@/bin/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/

release: release-init clib4 cleanbuild archive