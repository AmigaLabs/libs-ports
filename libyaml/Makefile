# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=0.2.5
LIBC?=newlib

PKGNAME=libyaml-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://github.com/yaml/libyaml/archive/refs/tags/${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download  ## Download the archive and initialize the build

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building using the ${LIBC}...\n${CCEND}"
	@cd ${PKGNAME} && ./bootstrap && \
		CC="ppc-amigaos-gcc" \
		CFLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/local/${LIBC}/include/freetype2" \
		PKG_CONFIG_LIBDIR=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
		LIBS="" \
		./configure --host=ppc-amigaos --enable-shared=no \
			--prefix=${SDK_PATH}/local/${LIBC} \
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
	@make -C ${PKGNAME} clean
# @rm -rf ${PKGNAME}/build/*

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init build/newlib pack/newlib clean build/clib2 pack/clib2 clean build/clib4 pack/clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/Documentation/libyaml
	@cp ${PKGNAME}/License ./SDK/local/Documentation/libyaml/
	@cp ${PKGNAME}/ReadMe* ./SDK/local/Documentation/libyaml/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/common/include
	@mkdir -p ./SDK/local/$*/lib/pkgconfig
	@cp ${PKGNAME}/include/yaml.h ./SDK/local/common/include/
	@cp ${PKGNAME}/src/.libs/libyaml.* ./SDK/local/$*/lib/
	@cp ${PKGNAME}/yaml-0.1.pc ./SDK/local/$*/lib/pkgconfig/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/ ./AutoInstall