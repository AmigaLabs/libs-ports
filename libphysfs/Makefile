# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make build LIBC=clib4
# 

LIB_VERSION=3.3.0
LIBC?=newlib
DEBUG=

LIBNAME=libphysfs
PKGNAME=${LIBNAME}-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

MAJOR = $(word 1, $(subst ., ,$(LIB_VERSION)))
MINOR = $(word 2, $(subst ., ,$(LIB_VERSION)))

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Cloning libphysfs repository ${PKGNAME}\n${CCEND}"
	@git clone https://github.com/icculus/physfs.git ${PKGNAME} --depth 1

#####################################################################
##@ Build

.PHONY: init
init: download patch ## Download the archive and initialize the build
	@cd ${PKGNAME} && \
		mkdir build

.PHONY: patch
patch:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@patch -s -p0 < ./patch-${LIB_VERSION}.diff

.PHONY: build
build: ## Build with specified LIBC=(newlib|clib2|clib4)
	@cd ${PKGNAME}/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -O2 -fPIC -athread=native" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC} -lpthread -athread=native" \
		-DBUILD_SHARED_LIBS=ON \
		-DPHYSFS_BUILD_SHARED=ON \
		-DPHYSFS_BUILD_TEST=OFF \
		-DPHYSFS_PLATFORM_SDL3=OFF \
		-DPHYSFS_BUILD_DOCS=ON \
		--install-prefix=${SDK_PATH}/local/${LIBC} && \
		cmake --build ./ --parallel $$(nproc --ignore=1)
# --verbose

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
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init build/newlib pack/newlib clean build/clib4 pack/clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/Documentation/${LIBNAME}/man
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/${LIBNAME}/
	@cp ${PKGNAME}/LICENSE* ./SDK/local/Documentation/${LIBNAME}/
	@cp -r ${PKGNAME}/docs ./SDK/local/Documentation/${LIBNAME}/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/include \
			./SDK/local/$*/lib/pkgconfig \
			./SDK/local/$*/lib/cmake/physfs
	@cp ${PKGNAME}/build/${LIBNAME}.a \
		${PKGNAME}/build/${LIBNAME}.so \
		./SDK/local/$*/lib/
	@cp ${PKGNAME}/build/physfs.pc ./SDK/local/$*/lib/pkgconfig/
	@cp ${PKGNAME}/build/PhysFSConfig*.cmake ./SDK/local/$*/lib/cmake/physfs/
	@cp ${PKGNAME}/src/physfs.h ./SDK/local/$*/include/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/

.PHONY: download_tests
download_tests:
ifeq ($(LIB_VERSION),edge)
	@echo "${CCPINK}${CCBOLD}\n-> Cloning litehtml-tests repository \n${CCEND}"
	@git clone https://github.com/litehtml/litehtml-tests.git --depth 1
endif

.PHONY: init_tests
init_tests: download_tests ## Download the archive and initialize the build
	@cd litehtml-tests && \
	mkdir build

.PHONY: build_tests
build_tests: ## Build with specified LIBC=(newlib|clib2|clib4)
	cd litehtml-tests/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -O2 -fPIC -athread=native" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC} -lpthread -athread=native" \
		-DBUILD_SHARED_LIBS=OFF \
		-DLITEHTML_PATH=../litehtml-edge \
		--install-prefix=${SDK_PATH}/local/${LIBC} \
	&& \
	make -j$(shell nproc)