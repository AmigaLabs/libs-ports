# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make -f Makefile.os4 LIBC=clib4
# 

LIB_VERSION=2.5.0
LIBC?=newlib

PKGNAME=openjpeg-${LIB_VERSION}

ifeq ($(LIBC), clib4)
CODEC=ON
endif

ifeq ($(LIBC), clib2)
$(error clib2 not supported. Missing sys/times.h) 
CODEC=OFF
endif

ifeq ($(LIBC), newlib)
CODEC=ON
endif

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://github.com/uclouvain/openjpeg/archive/refs/tags/v${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download
	@cd ${PKGNAME} && \
	mkdir build
	

build:
	cd ${PKGNAME}/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/include/include_h/exec/" \
		-DCMAKE_CXX_FLAGS="-mcrt=${LIBC} -O2 -fPIC" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC} -lpthread -athread=native" \
		-DBUILD_SHARED_LIBS=OFF \
		-DBUILD_CODEC=${CODEC} \
		-DBUILD_BINARY=OFF && \
	make -j$(shell nproc)

cleanbuild:
	@echo "-> Clean the build folder"
	@rm -rf ${PKGNAME}/build/*

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK \
		./libopenjpeg-${LIB_VERSION}.lha

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/common/include
# @mkdir -p ./SDK/local/clib2/lib
	@mkdir -p ./SDK/local/clib4/lib ./SDK/local/clib4/bin
	@mkdir -p ./SDK/local/newlib/lib ./SDK/local/newlib/bin

newlib:
	@echo "-> Building newlib based libraries..."
	@make LIBC=newlib
	@cp ./${PKGNAME}/build/bin/libopenjp2.a ./SDK/local/newlib/lib/
	@cp ./${PKGNAME}/build/bin/opj_* ./SDK/local/newlib/bin/
	@cp ./${PKGNAME}/src/lib/openjp2/openjpeg.h ./SDK/local/common/include/

# clib2:
# 	@echo "-> Building clib2 based libraries..."
# 	@make clib2 LIBC=clib2
# 	@cp ./${PKGNAME}/build/bin/libopenjp2.a ./SDK/local/clib2/lib/
# 	@cp ./${PKGNAME}/build/bin/opj_* ./SDK/local/clib2/bin/

archive:
	@echo "-> Creating the lha release file..."
	@lha -aeq ./libopenjpeg-${LIB_VERSION}.lha ./SDK/

clib4:
	@echo "-> Building clib4 based libraries..."
	@make LIBC=clib4
	@cp ./${PKGNAME}/build/bin/libopenjp2.a ./SDK/local/clib4/lib/
	@cp ./${PKGNAME}/build/bin/opj_* ./SDK/local/clib4/bin/

release: release-init newlib cleanbuild clib4 cleanbuild archive
