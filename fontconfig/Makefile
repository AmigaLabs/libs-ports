# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=2.14.2
LIBC?=clib4

PKGNAME=fontconfig-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSL "https://www.freedesktop.org/software/fontconfig/release/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download patch ## Download the archive and initialize the build

.PHONY: patch
patch:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@patch -s -p0 < ./patch-${LIB_VERSION}.diff

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building ${LIBC} based libraries...\n${CCEND}"
	cd ${PKGNAME} && \
	CC="ppc-amigaos-gcc" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/local/${LIBC}/include/freetype2" \
	PKG_CONFIG_PATH=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LIBS="-mcrt=${LIBC} -lfreetype -lbz2 -lpng16 -lbrotlidec -lbrotlicommon -lz -athread=native" \
	./configure --host=ppc-amigaos --disable-shared \
		--enable-libxml2 \
		--disable-dependency-tracking \
		--with-cache-dir=/PROGDIR/conf/fonts/ \
		--with-configdir=/PROGDIR/conf/fonts/ \
		--with-default-fonts=/FONTS/_TrueType,/FONTS/_ttf \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

.PHONY: build/%
build/%:
	@echo "${CCPINK}${CCBOLD}\n-> Compiling for $*\n${CCEND}"
	@make build LIBC=$*

#####################################################################
##@ Clean

.PHONY: clean
clean: ## Clean the latest build
	@echo "${CCPINK}${CCBOLD}\n-> Clean the build folder\n${CCEND}"
	@rm -rf ./${PKGNAME}/src/.libs ./${PKGNAME}/src/libfontconfig.la
	@make -C ${PKGNAME} clean

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init build/clib4 pack/clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/clib4/include/fontconfig
	@mkdir -p ./SDK/local/Documentation/fontconfig
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/fontconfig/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/fontconfig/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/bin
	@mkdir -p ./SDK/local/$*/lib
	@mkdir -p ./SDK/local/$*/lib/pkgconfig
	@cp ./${PKGNAME}/src/.libs/libfontconfig.a \
		./${PKGNAME}/src/libfontconfig.la \
		./SDK/local/$*/lib/
	@cp ./${PKGNAME}/fontconfig.pc ./SDK/local/$*/lib/pkgconfig/
	@cp ./${PKGNAME}/fontconfig/*.h ./SDK/local/clib4/include/fontconfig/
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
		./SDK/local/$*/bin/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/ ./AutoInstall
