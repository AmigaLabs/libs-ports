# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
#

LIB_VERSION=1.3.1
LIBC?=newlib

PKGNAME=zlib-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSL "https://www.zlib.net/zlib-${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download patches ## Download the archive and initialize the build
	@cd ${PKGNAME} && \
	mkdir -p build

.PHONY: patches
patches:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@patch -s -p0 < ./patch-1.diff

.PHONY: build
build: ## Build with specified LIBC=(newlib|clib2|clib4)
	cd ${PKGNAME}/build && \
	CC=ppc-amigaos-gcc CFLAGS="-mcrt=${LIBC}" ../configure \
		--prefix=${SDK_PATH}/local/${LIBC} \
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
	@rm -rf ${PKGNAME}/build/*

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
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
	@mkdir -p ./SDK/local/Documentation/zlib/doc
	@mkdir -p ./SDK/local/Documentation/zlib/man
	@mkdir -p ./SDK/local/examples/zlib
	@cp ${PKGNAME}/doc/* ./SDK/local/Documentation/zlib/doc/
	@cp ${PKGNAME}/ChangeLog ./SDK/local/Documentation/zlib/
	@cp ${PKGNAME}/FAQ ./SDK/local/Documentation/zlib/
	@cp ${PKGNAME}/LICENSE ./SDK/local/Documentation/zlib/
	@cp ${PKGNAME}/README ./SDK/local/Documentation/zlib/
	@cp ${PKGNAME}/zlib.3 ./SDK/local/Documentation/zlib/man/
	@cp ${PKGNAME}/zlib.3.pdf ./SDK/local/Documentation/zlib/
	@cp ${PKGNAME}/examples/*.c ./SDK/local/examples/zlib/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/bin
	@mkdir -p ./SDK/local/$*/include
	@mkdir -p ./SDK/local/$*/lib/pkgconfig
	@cp ${PKGNAME}/build/libz.a ./SDK/local/$*/lib/
	@cp ${PKGNAME}/build/libz.so* ./SDK/local/$*/lib/
	@cp ${PKGNAME}/build/zlib.pc ./SDK/local/$*/lib/pkgconfig/
	@cp ${PKGNAME}/build/zconf.h ./SDK/local/$*/include/
	@cp ${PKGNAME}/zlib.h ./SDK/local/$*/include/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/
