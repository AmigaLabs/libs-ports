# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=1.11.2
LIBC?=newlib

PKGNAME=libzip-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSL "https://libzip.org/download/libzip-${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download ## Download the archive and initialize the build
	@cd ${PKGNAME} && \
	mkdir build

.PHONY: build
build: ## Build with specified LIBC=(newlib|clib2|clib4)
	cd ${PKGNAME}/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -O2 -fPIC -athread=native" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC} -lpthread -athread=native" \
		-DBUILD_SHARED_LIBS=OFF \
		-DENABLE_BZIP2=OFF \
		-DENABLE_LZMA=OFF \
		-DZLIB_INCLUDE_DIR=${SDK_PATH}/local/${LIBC}/include \
		-DZLIB_LIBRARY=${SDK_PATH}/local/${LIBC}/lib/libz.a \
		--install-prefix=${SDK_PATH}/local/${LIBC} \
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
	@mkdir -p ./SDK/local/Documentation/libzip/man
	@cp ${PKGNAME}/API-CHANGES.md ./SDK/local/Documentation/libzip/
	@cp ${PKGNAME}/AUTHORS ./SDK/local/Documentation/libzip/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/libzip/
	@cp ${PKGNAME}/SECURITY* ./SDK/local/Documentation/libzip/
	@cp ${PKGNAME}/NEWS* ./SDK/local/Documentation/libzip/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@if [ "$*" = "newlib" ]; then \
		cp ${PKGNAME}/build/man/*.3 ./SDK/local/Documentation/libzip/man/; \
	fi
	@mkdir -p ./SDK/local/$*/bin
	@mkdir -p ./SDK/local/examples/libzip
	@mkdir -p ./SDK/local/$*/include
	@mkdir -p ./SDK/local/$*/lib/pkgconfig
	@cp ${PKGNAME}/build/lib/libzip.a ./SDK/local/$*/lib/
	@cp ${PKGNAME}/build/libzip.pc ./SDK/local/$*/lib/pkgconfig/
	@cp ${PKGNAME}/build/zipconf.h ./SDK/local/$*/include/
	@cp ${PKGNAME}/lib/zip.h ./SDK/local/$*/include/
	@cp ${PKGNAME}/build/src/zip* ./SDK/local/$*/bin/
	@cp ${PKGNAME}/examples/*.c ./SDK/local/examples/libzip/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/
