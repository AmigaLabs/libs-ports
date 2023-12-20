# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=2.8.8
LIBC?=newlib

PKGNAME=hyphen-${LIB_VERSION}

all: build

download:
	@echo "-> Clone the ${PKGNAME} repository"
	@git clone https://github.com/hunspell/hyphen.git ${PKGNAME} --depth 1

init: download	

build:
	cd ${PKGNAME} && \
	autoreconf -fvi && \
	CC="ppc-amigaos-gcc" CFLAGS="-mcrt=${LIBC} -O2 -fPIC" CXXFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
	./configure --host=ppc-amigaos --enable-shared=no \
		--prefix=${SDK_PATH}/local/${LIBC} \
	&& \
	make -j$(shell nproc)

cleanbuild:
	@echo "-> Clean the previous builds"
	@cd ${PKGNAME} && rm -rf .deps .libs autom4te.cache \
		compile config.guess config.log config.status config.sub \
		configure depcomp install-sh libtool ltmain.sh missing test-driver \
		INSTALL Makefile Makefile.in *.m4 *.lo *.o *.us* *.la

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME} ./SDK

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/common/include
	@mkdir -p ./SDK/local/Documentation/hyphen
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/hyphen/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/hyphen/
	@cp ${PKGNAME}/NEWS ./SDK/local/Documentation/hyphen/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@cp ./${PKGNAME}/.libs/libhyphen.a \
		./${PKGNAME}/.libs/libhyphen.lai \
		./${PKGNAME}/libhyphen.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/*.h ./SDK/local/common/include/

clib2:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@cp ./${PKGNAME}/.libs/libhyphen.a \
		./${PKGNAME}/.libs/libhyphen.lai \
		./${PKGNAME}/libhyphen.la \
		./SDK/local/$@/lib/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@cp ./${PKGNAME}/.libs/libhyphen.a \
		./${PKGNAME}/.libs/libhyphen.lai \
		./${PKGNAME}/libhyphen.la \
		./SDK/local/$@/lib/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha -aeq ./${PKGNAME}.lha ./SDK/

release: release-init newlib cleanbuild clib2 cleanbuild clib4 cleanbuild archive
