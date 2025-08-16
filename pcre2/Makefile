# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=10.44
LIBC?=newlib

PKGNAME=pcre2-${LIB_VERSION}

ifeq ($(LIBC), clib4)
CODEC=ON
endif

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${LIB_VERSION}/pcre2-${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download patches
	@cd ${PKGNAME} && \
	mkdir build

patches:
	@echo "-> Apply the patches"
	@patch -s -p0 < ./patch-${LIB_VERSION}.diff

build:
	cd ${PKGNAME}/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -fPIC -athread=native" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC} -lbz2 -lz -lpthread -athread=native" \
		-DBUILD_SHARED_LIBS=OFF \
		-DPCRE2_SUPPORT_JIT=OFF \
		-DPCRE2_BUILD_PCRE2_16=ON \
		-DPCRE2_BUILD_PCRE2_32=ON \
		-DPCRE2_SUPPORT_LIBBZ2=ON \
		-DPCRE2_SUPPORT_LIBZ=ON \
		-DPCRE2_STATIC_PIC=ON \
		-DPCRE2GREP_SUPPORT_CALLOUT=OFF \
		-DBZIP2_INCLUDE_DIR=${SDK_PATH}/local/${LIBC}/include \
		-DBZIP2_LIBRARIES=${SDK_PATH}/local/${LIBC}/lib/libbz2.a \
		-DZLIB_INCLUDE_DIR=${SDK_PATH}/local/${LIBC}/include \
		-DZLIB_LIBRARY=${SDK_PATH}/local/${LIBC}/lib/libz.a \
		--install-prefix=${SDK_PATH}/local/${LIBC} \
	&& \
	make -j$(shell nproc)

#####################################################################
# Clean jobs

clean:
	@echo "-> Clean the build folder"
	@rm -rf ${PKGNAME}/build/*

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
# Release jobs

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/Documentation/pcre2
	@cp ${PKGNAME}/LICENCE ./SDK/local/Documentation/pcre2/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/pcre2/
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/pcre2/
	@cp ${PKGNAME}/ChangeLog* ./SDK/local/Documentation/pcre2/
	@cp -R ${PKGNAME}/doc/* ./SDK/local/Documentation/pcre2/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin \
		./SDK/local/$@/include
	@cp ./${PKGNAME}/build/libpcre2-*.a ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/pcre2*test ./${PKGNAME}/build/pcre2grep \
		./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libpcre2-*.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/build/pcre2.h ./SDK/local/$@/include/

clib2:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin \
		./SDK/local/$@/include
	@cp ./${PKGNAME}/build/libpcre2-*.a ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/pcre2*test ./${PKGNAME}/build/pcre2grep \
		./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libpcre2-*.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/build/pcre2.h ./SDK/local/$@/include/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin \
		./SDK/local/$@/include
	@cp ./${PKGNAME}/build/libpcre2-*.a ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/pcre2*test ./${PKGNAME}/build/pcre2grep \
		./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libpcre2-*.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/build/pcre2.h ./SDK/local/$@/include/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/

release: release-init newlib clean clib2 clean clib4 clean archive
