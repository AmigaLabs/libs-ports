# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make build LIBC=clib4
# 

LIB_VERSION=1.18.2
LIBC?=newlib
DEBUG=

LIBNAME=libopenal
PKGNAME=${LIBNAME}-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

MAJOR = $(word 1, $(subst ., ,$(LIB_VERSION)))
MINOR = $(word 2, $(subst ., ,$(LIB_VERSION)))

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Cloning ${LIBNAME} repository ${PKGNAME}\n${CCEND}"
	@git clone https://github.com/salass00/openal_lib.git ${PKGNAME} --depth 1

#####################################################################
##@ Build

.PHONY: init
init: download patch ## Download the archive and initialize the build

.PHONY: patch
patch:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@patch -s -p0 < ./patch-${LIB_VERSION}.diff

.PHONY: build
build: ## Build with specified LIBC=(newlib|clib4)
	@make -C ${PKGNAME}/openal-soft-${LIB_VERSION} \
		-f makefile.amigaos4 libopenal.a libopenal.so \
		LIBC=${LIBC} \
		-j$(shell nproc --ignore=1)

.PHONY: build/%
build/%:
	@echo "${CCPINK}${CCBOLD}\n-> Compiling for $*\n${CCEND}"
	@make build LIBC=$*

#####################################################################
##@ Clean

.PHONY: clean
clean: ## Clean the latest build
	@echo "${CCPINK}${CCBOLD}\n-> Clean the build folder\n${CCEND}"
	@make -C ${PKGNAME}/openal-soft-${LIB_VERSION} -f makefile.amigaos4 clean

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
	@mkdir -p ./SDK/local/Documentation/${LIBNAME}
	@cp -r ${PKGNAME}/openal-soft-${LIB_VERSION}/README* \
		${PKGNAME}/openal-soft-${LIB_VERSION}/COPYING* \
		${PKGNAME}/openal-soft-${LIB_VERSION}/docs \
		./SDK/local/Documentation/${LIBNAME}/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/include \
			./SDK/local/$*/lib
	@cp ${PKGNAME}/openal-soft-${LIB_VERSION}/${LIBNAME}.a \
		${PKGNAME}/openal-soft-${LIB_VERSION}/${LIBNAME}.so* \
		./SDK/local/$*/lib/
	@cp -r ${PKGNAME}/openal-soft-${LIB_VERSION}/include/* ./SDK/local/$*/include/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/
