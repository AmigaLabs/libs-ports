# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=6.3.0
LIBC?=newlib

PKGNAME=gmp-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://gmplib.org/download/gmp/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download

build:
	cd ${PKGNAME} && \
	CC="ppc-amigaos-gcc" \
	CXX="ppc-amigaos-g++" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC -lpthread -athread=native" \
	CXXFLAGS="-mcrt=${LIBC} -O2 -fPIC -lpthread -athread=native" \
	./configure --host=ppc-amigaos --enable-cxx=yes --enable-shared=yes \
		--prefix=${SDK_PATH}/local/${LIBC} \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@rm -rf ./${PKGNAME}/src/.libs ./${PKGNAME}/src/libgmp.la \
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
	@mkdir -p ./SDK/local/common/include
	@mkdir -p ./SDK/local/Documentation/gmp
	@cp ${PKGNAME}/AUTHORS* ./SDK/local/Documentation/gmp/
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/gmp/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/gmp/
	@cp ${PKGNAME}/NEWS* ./SDK/local/Documentation/gmp/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/lib/pkgconfig
	@cp ./${PKGNAME}/.libs/libgmp*.a \
		./${PKGNAME}/.libs/libgmp*.lai \
		./${PKGNAME}/.libs/libgmp*.so \
		./${PKGNAME}/libgmp*.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/gmp*.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/gmp.h ./${PKGNAME}/gmpxx.h ./SDK/local/common/include/

clib2:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/lib/pkgconfig
	@cp ./${PKGNAME}/.libs/libgmp*.a \
		./${PKGNAME}/.libs/libgmp*.lai \
		./${PKGNAME}/.libs/libgmp*.so \
		./${PKGNAME}/libgmp*.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/gmp*.pc ./SDK/local/$@/lib/pkgconfig/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/lib/pkgconfig
	@cp ./${PKGNAME}/.libs/libgmp*.a \
		./${PKGNAME}/.libs/libgmp*.lai \
		./${PKGNAME}/.libs/libgmp*.so \
		./${PKGNAME}/libgmp*.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/gmp*.pc ./SDK/local/$@/lib/pkgconfig/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/

release: release-init newlib cleanbuild clib2 cleanbuild clib4 cleanbuild archive