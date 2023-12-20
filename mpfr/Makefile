# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=4.2.1
LIBC?=newlib

PKGNAME=mpfr-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://www.mpfr.org/mpfr-current/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download

build:
	cd ${PKGNAME} && \
	CC="ppc-amigaos-gcc" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/local/${LIBC}/include/freetype2" \
	PKG_CONFIG_LIBDIR=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LIBS="" \
	./configure --host=ppc-amigaos --enable-shared=yes \
		--prefix=${SDK_PATH} \
	&& \
	make -j$(shell nproc)

#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@rm -rf ./${PKGNAME}/src/.libs ./${PKGNAME}/src/libmpfr.la

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
# Release jobs

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/common/include/mpfr
	@mkdir -p ./SDK/local/common/examples/mpfr
# @mkdir -p ./SDK/local/clib2/lib
# @mkdir -p ./SDK/local/clib2/lib/pkgconfig
	@mkdir -p ./SDK/local/clib4/lib
	@mkdir -p ./SDK/local/clib4/lib/pkgconfig
	@mkdir -p ./SDK/local/newlib/lib
	@mkdir -p ./SDK/local/newlib/lib/pkgconfig
	@mkdir -p ./SDK/local/Documentation/mpfr
	@cp ${PKGNAME}/AUTHORS* ./SDK/local/Documentation/mpfr/
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/mpfr/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/mpfr/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@cp ./${PKGNAME}/src/.libs/libmpfr.a \
		./${PKGNAME}/src/.libs/libmpfr.lai \
		./${PKGNAME}/src/.libs/libmpfr.so \
		./${PKGNAME}/src/libmpfr.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/mpfr.pc ./SDK/local/clib4/lib/pkgconfig/
	@cp ./${PKGNAME}/src/generic/*.h ./SDK/local/common/include/mpfr/
	@cp ./${PKGNAME}/examples/* ./SDK/local/common/examples/mpfr/
	@cp ./${PKGNAME}/m4/*.m4 ./SDK/local/Documentation/mpfr/

# clib2:
# 	@echo "-> Building $@ based libraries..."
# 	@make LIBC=$@
# 	@cp ./${PKGNAME}/src/.libs/libmpfr.a \
# 		./${PKGNAME}/src/.libs/libmpfr.la \
# 		./SDK/local/$@/lib/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@cp ./${PKGNAME}/src/.libs/libmpfr.a \
		./${PKGNAME}/src/.libs/libmpfr.lai \
		./${PKGNAME}/src/.libs/libmpfr.so \
		./${PKGNAME}/src/libmpfr.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/mpfr.pc ./SDK/local/clib4/lib/pkgconfig/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha -aeq ./${PKGNAME}.lha ./SDK/

release: release-init newlib cleanbuild clib4 cleanbuild archive