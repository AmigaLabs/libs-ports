# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=4_13
LIBC?=clib4

PKGNAME=libtasn1-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://github.com/gnutls/libtasn1/archive/refs/tags/libtasn1_${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz && \
		mv libtasn1-libtasn1_${LIB_VERSION} ${PKGNAME}

#####################################################################
##@ Build

.PHONY: init
init: download  ## Download the archive and initialize the build
	@cd ${PKGNAME} && \
		touch ChangeLog && \
		autoreconf -fiv

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building using the ${LIBC}...\n${CCEND}"
	@cd ${PKGNAME} && \
		CC="ppc-amigaos-gcc" \
		CFLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/local/${LIBC}/include/freetype2" \
		PKG_CONFIG_LIBDIR=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
		LIBS="" \
		./configure --host=ppc-amigaos \
			--disable-doc \
			--prefix=${SDK_PATH}/local/${LIBC} \
			--includedir=${SDK_PATH}/local/common/include \
		&& \
		make 
# 		-j$(shell nproc)

.PHONY: build/%
build/%:
	@echo "${CCPINK}${CCBOLD}\n-> Compiling for $*\n${CCEND}"
	@make build LIBC=$*

#####################################################################
##@ Clean

.PHONY: clean
clean: ## Clean the latest build
	@echo "${CCPINK}${CCBOLD}\n-> Clean the build folder\n${CCEND}"
	@make -C ${PKGNAME} clean
# @rm -rf ${PKGNAME}/build/*

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
	@mkdir -p ./SDK/local/Documentation/libtasn1
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/libtasn1/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/libtasn1/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/include \
		./SDK/local/$*/lib/pkgconfig
	@cp ${PKGNAME}/lib/libtasn1.h ./SDK/local/$*/include/
	@cp ${PKGNAME}/lib/.libs/libtasn1.* ./SDK/local/$*/lib/
	@cp ${PKGNAME}/lib/libtasn1.pc ./SDK/local/$*/lib/pkgconfig/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/ ./AutoInstall