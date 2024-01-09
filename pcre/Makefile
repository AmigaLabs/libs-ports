# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=8.45
LIBC?=newlib

PKGNAME=pcre-${LIB_VERSION}

ifeq ($(LIBC), clib4)
CODEC=ON
endif

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://sourceforge.net/projects/pcre/files/pcre/${LIB_VERSION}/pcre-${LIB_VERSION}.tar.gz/download" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download patches
	@cd ${PKGNAME} && \
	mkdir build

patches:
	@echo "-> Apply the patches"
	@patch -s -p0 < ./patch.diff

build:
	cd ${PKGNAME}/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -O2 -fPIC -athread=native" \
		-DCMAKE_CXX_FLAGS="-mcrt=${LIBC} -O2 -fPIC -athread=native" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC} -lpthread -athread=native" \
		-DCMAKE_EXE_LINKER_FLAGS="-mcrt=${LIBC} -lpthread -athread=native" \
		-DBUILD_SHARED_LIBS=OFF \
		--install-prefix=${SDK_PATH}/local/${LIBC} \
	&& \
	make -j$(shell nproc)

#####################################################################
# Clean jobs

cleanbuild:
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
	@mkdir -p ./SDK/local/Documentation/pcre
	@cp ${PKGNAME}/LICENCE ./SDK/local/Documentation/pcre/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/pcre/
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/pcre/
	@cp ${PKGNAME}/ChangeLog* ./SDK/local/Documentation/pcre/
	@cp -R ${PKGNAME}/doc ./SDK/local/Documentation/pcre/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin \
		./SDK/local/$@/include
	@cp ./${PKGNAME}/build/libpcre*.a \
		 ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/pcretest ./${PKGNAME}/build/pcregrep \
		./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libpcre*.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/build/pcre.h ./SDK/local/$@/include/

clib2:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin \
		./SDK/local/$@/include
	@cp ./${PKGNAME}/build/libpcre*.a \
		 ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/pcretest ./${PKGNAME}/build/pcregrep \
		./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libpcre*.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/build/pcre.h ./SDK/local/$@/include/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin \
		./SDK/local/$@/include
	@cp ./${PKGNAME}/build/libpcre*.a \
		 ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/pcretest ./${PKGNAME}/build/pcregrep \
		./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libpcre*.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/build/pcre.h ./SDK/local/$@/include/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/

release: release-init newlib cleanbuild clib2 cleanbuild clib4 cleanbuild archive
