# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make build LIBC=clib4
# 

LIB_VERSION=1.14.10
LIBC?=newlib
DEBUG=

PKGNAME=libcairo

include ../_common/help.mk
include ../_common/checks.mk


ifeq ($(LIBC), clib4)
LIBC_INCLUDES=
endif

ifeq ($(LIBC), newlib)
LIBC_INCLUDES=-I${SDK_PATH}/local/${LIBC}/include/pixman-1 \
	-I${SDK_PATH}/local/common/include/libpng16 \
	-I${SDK_PATH}/local/common/include/freetype2
endif


.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Cloning libcairo repository ${PKGNAME}\n${CCEND}"
	@git clone https://github.com/salass00/cairo_lib.git ${PKGNAME} --depth 1

#####################################################################
##@ Build

.PHONY: init
init: download patch ## Download the archive and initialize the build

.PHONY: patch
patch:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@cd ./${PKGNAME} && \
		git apply --ignore-space-change --ignore-whitespace ../patch.diff

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@cd ./${PKGNAME}/cairo-${LIB_VERSION} && \
	CC="ppc-amigaos-gcc" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC ${LIBC_INCLUDES} \
		-Wno-maybe-uninitialized -Wno-enum-conversion \
		-Wno-implicit-fallthrough -Wno-int-in-bool-context \
		-Wno-array-bounds -Wno-misleading-indentation \
		-Wno-inline -Wno-attributes" \
	PKG_CONFIG_LIBDIR=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LIBS="-lauto -lpthread -athread=native" \
	png_REQUIRES=libpng16 \
	./configure --host=ppc-amigaos --enable-shared=yes \
		--enable-ft=yes \
		--enable-fc=auto \
		--enable-amigaos=yes \
		--enable-amigaos-font=yes \
		--enable-png=yes \
		--prefix=${SDK_PATH}/local/${LIBC} \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

.PHONY: newlib clib4
newlib: ## Build using newlib crt and prepares the files for packaging
	@make build LIBC=$@
	@make package LIBC=$@
clib4: ## Build using clib4 crt and prepares the files for packaging
	@make build LIBC=$@
	@make package LIBC=$@

#####################################################################
##@ Clean

.PHONY: clean
clean: ## Clean the latest build
	@echo "${CCPINK}${CCBOLD}\n-> Clean the build folder\n${CCEND}"
	@make -C ./${PKGNAME}/cairo-${LIB_VERSION} clean
	@make -C ./${PKGNAME}/cairo-${LIB_VERSION} distclean

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init newlib clean clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK
	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/Documentation/cairo
	@cp ./${PKGNAME}/cairo-${LIB_VERSION}/COPYING* ./SDK/local/Documentation/cairo/

.PHONY: package
package:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging ${LIBC} based libraries...\n${CCEND}"
	@mkdir -p ./SDK/local/${LIBC}/lib
	@mkdir -p ./SDK/local/${LIBC}/lib/pkgconfig
	@mkdir -p ./SDK/local/${LIBC}/include/cairo
	@cp -r ./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-amigaos.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-deprecated.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-features.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-ft.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-pdf.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-ps.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-script.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-svg.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/cairo-version.h \
		./${PKGNAME}/cairo-${LIB_VERSION}/util/cairo-script/cairo-script-interpreter.h \
		./SDK/local/${LIBC}/include/cairo/
	@cp ./${PKGNAME}/cairo-${LIB_VERSION}/src/.libs/libcairo.a \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/libcairo.la \
		./SDK/local/${LIBC}/lib/
	@cp ./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo.pc \
		./${PKGNAME}/cairo-${LIB_VERSION}/src/cairo-*.pc \
		./SDK/local/${LIBC}/lib/pkgconfig/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}-${LIB_VERSION}.lha
	@lha aq ./${PKGNAME}-${LIB_VERSION}.lha ./SDK/
