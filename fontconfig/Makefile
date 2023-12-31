# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=2.14.2
LIBC?=newlib

PKGNAME=fontconfig-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://www.freedesktop.org/software/fontconfig/release/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download

build:
	cd ${PKGNAME} && \
	CC="ppc-amigaos-gcc" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/local/${LIBC}/include/freetype2" \
	PKG_CONFIG_PATH=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LIBS="-lfreetype -lbz2 -lpng16 -lbrotlidec -lbrotlicommon -lz" \
	./configure --host=ppc-amigaos --enable-shared=no \
		--prefix=${SDK_PATH}/local/${LIBC} \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@rm -rf ./${PKGNAME}/src/.libs ./${PKGNAME}/src/libfontconfig.la

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
# Release jobs

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/common/include/fontconfig
	@mkdir -p ./SDK/local/Documentation/fontconfig
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/fontconfig/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/fontconfig/

# newlib:
# 	@echo "-> Building $@ based libraries..."

# clib2:
# 	@echo "-> Building $@ based libraries..."

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/bin
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/lib/pkgconfig
	@cp ./${PKGNAME}/src/.libs/libfontconfig.a \
		./${PKGNAME}/src/libfontconfig.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/fontconfig.pc ./SDK/local/$@/lib/pkgconfig/
	@cp ./${PKGNAME}/fontconfig/*.h ./SDK/local/common/include/fontconfig/
	@cp ./${PKGNAME}/doc/*.pdf ./SDK/local/Documentation/fontconfig/
	@cp ./${PKGNAME}/fc-cache/fc-cache \
		./${PKGNAME}/fc-cat/fc-cat \
		./${PKGNAME}/fc-conflist/fc-conflist \
		./${PKGNAME}/fc-list/fc-list \
		./${PKGNAME}/fc-match/fc-match \
		./${PKGNAME}/fc-pattern/fc-pattern \
		./${PKGNAME}/fc-query/fc-query \
		./${PKGNAME}/fc-scan/fc-scan \
		./${PKGNAME}/fc-validate/fc-validate \
		./SDK/local/$@/bin/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/

release: release-init clib4 cleanbuild archive
