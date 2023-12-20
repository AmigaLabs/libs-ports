# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
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
		-DBUILD_BINARY=OFF \
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
	@mkdir -p ./SDK/local/common/include
# @mkdir -p ./SDK/local/clib2/lib
	@mkdir -p ./SDK/local/Documentation/openjpeg
	@cp ${PKGNAME}/LICENSE ./SDK/local/Documentation/openjpeg/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/openjpeg/
	@cp ${PKGNAME}/NEWS* ./SDK/local/Documentation/openjpeg/
	@cp -R ${PKGNAME}/doc/man/* ./SDK/local/Documentation/openjpeg/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin
	@cp ./${PKGNAME}/build/bin/libopenjp2.a ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/bin/opj_* ./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libopenjp2.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/src/lib/openjp2/openjpeg.h ./SDK/local/common/include/

# clib2:
# 	@echo "-> Building $@ based libraries..."
# 	@make LIBC=$@
# 	@cp ./${PKGNAME}/build/bin/libopenjp2.a ./SDK/local/$@/lib/
# 	@cp ./${PKGNAME}/build/bin/opj_* ./SDK/local/$@/bin/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib \
		./SDK/local/$@/lib/pkgconfig \
		./SDK/local/$@/bin
	@cp ./${PKGNAME}/build/bin/libopenjp2.a ./SDK/local/$@/lib/
	@cp ./${PKGNAME}/build/bin/opj_* ./SDK/local/$@/bin/
	@cp ./${PKGNAME}/build/libopenjp2.pc ./SDK/local/$@/lib/pkgconfig/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha -aeq ./${PKGNAME}.lha ./SDK/

release: release-init newlib cleanbuild clib4 cleanbuild archive
