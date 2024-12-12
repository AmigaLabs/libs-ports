# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=1.5.1
LIBC?=newlib

PKGNAME=unshield-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
		@curl -fsSL "https://github.com/twogood/unshield/archive/refs/tags/${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download
	@cd ${PKGNAME} && \
	mkdir build

.PHONY: patch
patch:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@patch -s -p0 < ./patch-1.diff

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building using the ${LIBC}...\n${CCEND}"
	@cd ${PKGNAME}/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -O2 -fPIC" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC}" \
		-DBUILD_SHARED_LIBS=OFF \
		-DBUILD_STATIC=ON \
		-DZLIB_LIBRARY=${SDK_PATH}/local/${LIBC}/lib/libz.a \
		-DZLIB_INCLUDE_DIR=${SDK_PATH}/local/${LIBC}/include \
		--install-prefix=${SDK_PATH}/local/${LIBC} \
	&& \
	make -j$(shell nproc)

.PHONY: newlib clib2 clib4
newlib: ## Build using newlib crt and prepares the files for packaging
	@make build LIBC=$@
	@make package LIBC=$@
	@cp ./${PKGNAME}/build/src/unshield ./${PKGNAME}/build/src/unshield-deobfuscate \
		./release/${PKGNAME}/C/
clib4: ## Build using clib4 crt and prepares the files for packaging
	@make build LIBC=$@
	@make package LIBC=$@

#####################################################################
##@ Clean

.PHONY: clean
clean: ## Clean the latest build
	@echo "${CCPINK}${CCBOLD}\n-> Clean the build folder\n${CCEND}"
	@rm -rf ${PKGNAME}/build/*

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./release

#####################################################################
##@ Release

.PHONY: release
release: release-init newlib clean clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./release

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./release/${PKGNAME}/C

	@cp ${PKGNAME}/README* ./release/${PKGNAME}/
	@cp ${PKGNAME}/LICENSE* ./release/${PKGNAME}/

.PHONY: package
package:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging ${LIBC} based libraries...\n${CCEND}"
	@mkdir -p ./release/${PKGNAME}/SDK/local/${LIBC}/lib/pkgconfig
	@mkdir -p ./release/${PKGNAME}/SDK/local/${LIBC}/include
	@\cp ./${PKGNAME}/lib/libunshield.h ./release/${PKGNAME}/SDK/local/${LIBC}/include/
	@cp ./${PKGNAME}/build/lib/libunshield.a ./release/${PKGNAME}/SDK/local/${LIBC}/lib/
	@cp ./${PKGNAME}/build/libunshield.pc ./release/${PKGNAME}/SDK/local/${LIBC}/lib/pkgconfig/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@cd ./release && lha aq ../${PKGNAME}.lha ./${PKGNAME}/