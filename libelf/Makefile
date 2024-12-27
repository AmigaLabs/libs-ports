# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=0.8.13
LIBC?=newlib

PKGNAME=libelf-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://fossies.org/linux/misc/old/libelf-${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
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
	@cd ${PKGNAME} && \
		CC="ppc-amigaos-gcc" \
		CFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
		PKG_CONFIG_PATH=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
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
	@rm -rf ${PKGNAME}/stamp-h

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
	@mkdir -p ./SDK/local/Documentation/libelf
	@cp ${PKGNAME}/ChangeLog ./SDK/local/Documentation/libelf/
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/libelf/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/libelf/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/include
	@mkdir -p ./SDK/local/$*/lib/pkgconfig
	@cp ${PKGNAME}/lib/gelf.h ${PKGNAME}/lib/libelf.h ${PKGNAME}/lib/nlist.h \
		./SDK/local/$*/include/
	@cp ${PKGNAME}/lib/libelf.a ./SDK/local/$*/lib/
	@cp ${PKGNAME}/libelf.pc ./SDK/local/$*/lib/pkgconfig/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/