# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make build LIBC=clib4
# 

LIB_VERSION=2.30.1-release2
LIBC?=newlib
DEBUG=

PKGNAME=sdl2-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
ifeq ($(LIB_VERSION),edge)
	@echo "${CCPINK}${CCBOLD}\n-> Cloning sdl2 repository ${PKGNAME}\n${CCEND}"
	@git clone https://github.com/AmigaPorts/SDL.git ${PKGNAME} -b SDL2 --depth 1
else
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://github.com/AmigaPorts/SDL-2.0/archive/refs/tags/v${LIB_VERSION}-amigaos4.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz && \
		mv ./SDL-${LIB_VERSION}-amigaos4 ${PKGNAME}
endif

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
	make -C ${PKGNAME} -f Makefile.amigaos4 ${DEBUG} \
		CRT=${LIBC} \
		-j$(shell nproc)

.PHONY: newlib clib2 clib4
newlib: ## Build using newlib crt and prepares the files for packaging
	@make build LIBC=$@
	@make package LIBC=$@
	@make clean
	@make build LIBC=$@ DEBUG=debug
	@make package LIBC=$@ DEBUG=debug
# clib2: ## Build using clib2 crt and prepares the files for packaging
# 	@make build LIBC=$@
# 	@make package LIBC=$@
clib4: ## Build using clib4 crt and prepares the files for packaging
	@make build LIBC=$@
	@make package LIBC=$@

#####################################################################
##@ Clean

.PHONY: clean
clean: ## Clean the latest build
	@echo "${CCPINK}${CCBOLD}\n-> Clean the build folder\n${CCEND}"
	@make -C ${PKGNAME} -f Makefile.amigaos4 clean

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init newlib clean clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/Documentation/SDL2
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/SDL2/
	@cp ${PKGNAME}/LICENSE* ./SDK/local/Documentation/SDL2/
	@cp ${PKGNAME}/CREDITS* ./SDK/local/Documentation/SDL2/

.PHONY: package
package:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging ${LIBC} based libraries...\n${CCEND}"
	@mkdir -p ./SDK/local/${LIBC}/lib
ifneq ($(DEBUG),debug)
	@mkdir -p ./SDK/local/${LIBC}/include/SDL2
	@cp -r ${PKGNAME}/include/* ./SDK/local/${LIBC}/include/SDL2/
	@cp ./${PKGNAME}/libSDL2.a ./${PKGNAME}/libSDL2_test.a \
		./${PKGNAME}/libSDL2-2.30.so \
		./SDK/local/${LIBC}/lib/
else
	@cp ./${PKGNAME}/libSDL2.a ./SDK/local/${LIBC}/lib/libSDL2_debug.a
	@cp ./${PKGNAME}/libSDL2-2.30.so ./SDK/local/${LIBC}/lib/libSDL2-2.30_debug.so
endif

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}_ogles2.lha
	@lha aq ./${PKGNAME}_ogles2.lha ./SDK/
