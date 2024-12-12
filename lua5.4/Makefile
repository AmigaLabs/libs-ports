# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=5.4.7
LIBC?=newlib

PKGNAME=lua-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://www.lua.org/ftp/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download patch

.PHONY: patch
patch:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@patch -s -p0 < ./patch-${LIB_VERSION}.diff

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building ${LIBC} based libraries...\n${CCEND}"
	@make -C ${PKGNAME}/src generic \
		CC="ppc-amigaos-gcc -mcrt=${LIBC} -std=gnu99" \
		-j$(shell nproc)

.PHONY: newlib clib2 clib4
newlib: ## Build using newlib crt and prepares the files for packaging
	@make build LIBC=$@
	@make package LIBC=$@
clib2: ## Build using clib2 crt and prepares the files for packaging
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
	@make -C ${PKGNAME}/src clean

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init newlib clean clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the re folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/common/include/lua54
	@mkdir -p ./SDK/local/Documentation/lua54
	@cp -r ${PKGNAME}/doc ./SDK/local/Documentation/lua54/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/lua54/

.PHONY: package
package:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging ${LIBC} based libraries...\n${CCEND}"
	@mkdir -p ./SDK/local/${LIBC}/lib
	@mkdir -p ./SDK/local/${LIBC}/bin

ifneq ($(LIBC),newlib)
	@cp ./${PKGNAME}/src/lauxlib.h ./${PKGNAME}/src/lua.h \
		./${PKGNAME}/src/lua.hpp \
		./${PKGNAME}/src/luaconf.h ./${PKGNAME}/src/lualib.h \
		./SDK/local/common/include/lua54/
endif
	@cp ./${PKGNAME}/src/liblua.a ./SDK/local/${LIBC}/lib/liblua54.a
	@cp ./${PKGNAME}/src/lua ./${PKGNAME}/src/luac \
		./SDK/local/${LIBC}/bin/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/ ./AutoInstall
