# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make build LIBC=clib4
# 

LIB_VERSION=1.10.0
LIBC?=newlib

PKGNAME=lz4-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://github.com/lz4/lz4/archive/refs/tags/v${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download ## Download the archive and initialize the build

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building ${LIBC} based libraries...\n${CCEND}"
	@PREFIX=${SDK_PATH}/local/${LIBC} \
		make -C ${PKGNAME} \
			CC="ppc-amigaos-gcc" \
			CXX="ppc-amigaos-g++" \
			CFLAGS="-mcrt=${LIBC} -std=gnu99" \
			-j$(shell nproc)

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

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init build/newlib pack/newlib clean build/clib4 pack/clib4 clean archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/Documentation/${PKGNAME}
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/${PKGNAME}/
	@cp ${PKGNAME}/LICENSE* ./SDK/local/Documentation/${PKGNAME}/
	@cp ${PKGNAME}/SECURITY* ./SDK/local/Documentation/${PKGNAME}/
	@cp ${PKGNAME}/NEWS* ./SDK/local/Documentation/${PKGNAME}/
	@cp -R ${PKGNAME}/doc ./SDK/local/Documentation/${PKGNAME}/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/bin
	@mkdir -p ./SDK/local/$*/include/liblz4
	@mkdir -p ./SDK/local/$*/lib/pkgconfig
	@cp ${PKGNAME}/lib/liblz4.pc ./SDK/local/$*/lib/pkgconfig/
	@cp ${PKGNAME}/lib/*.h ./SDK/local/$*/include/liblz4/
	@cp ${PKGNAME}/lib/liblz4.a ${PKGNAME}/lib/liblz4.so ./SDK/local/$*/lib/
	@cp ${PKGNAME}/lz4 ./SDK/local/$*/bin

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/ ./AutoInstall
