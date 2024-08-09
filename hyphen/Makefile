# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=2.8.8
LIBC?=newlib

PKGNAME=hyphen-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Clone the ${PKGNAME} repository\n${CCEND}"
	@git clone https://github.com/hunspell/hyphen.git ${PKGNAME} --depth 1

#####################################################################
##@ Build

.PHONY: init
init: download ## Download the archive and initialize the build

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building with ${LIBC}...\n${CCEND}"
	cd ${PKGNAME} && \
	autoreconf -fvi && \
	CC="ppc-amigaos-gcc" CFLAGS="-mcrt=${LIBC} -O2 -fPIC" CXXFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
	./configure --host=ppc-amigaos --enable-shared=no \
		--prefix=${SDK_PATH}/local/${LIBC} \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

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
	@echo "${CCPINK}${CCBOLD}\n-> Clean the previous builds\n${CCEND}"
	@cd ${PKGNAME} && rm -rf .deps .libs autom4te.cache \
		compile config.guess config.log config.status config.sub \
		configure depcomp install-sh libtool ltmain.sh missing test-driver \
		INSTALL Makefile Makefile.in *.m4 *.lo *.o *.us* *.la \
		./doc/Makefile ./doc/Makefile.in \
		./tests/Makefile ./tests/Makefile.in \
		example hyph_en_US.dic substrings

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folder\n${CCEND}"
	@rm -rf ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: ## Build and create the release
	@make release-init
	@make newlib
	@make clean
	@make clib2
	@make clean
	@make clib4
	@make clean
	@make archive

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/common/include
	@mkdir -p ./SDK/local/Documentation/hyphen
	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/hyphen/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/hyphen/
	@cp ${PKGNAME}/NEWS ./SDK/local/Documentation/hyphen/
	@cp ./${PKGNAME}/*.h ./SDK/local/common/include/

.PHONY: package
package:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging ${LIBC} based libraries...\n${CCEND}"
	@mkdir -p ./SDK/local/${LIBC}/lib
	@cp ./${PKGNAME}/.libs/libhyphen.a \
		./${PKGNAME}/.libs/libhyphen.lai \
		./${PKGNAME}/libhyphen.la \
		./SDK/local/${LIBC}/lib/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/
