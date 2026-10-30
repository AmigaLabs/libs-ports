# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=1.1.45
LIBC?=newlib

PKGNAME=libxslt-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk

.PHONY: download
download:
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://github.com/GNOME/libxslt/archive/refs/tags/v${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz

#####################################################################
##@ Build

.PHONY: init
init: download  ## Download the archive and initialize the build

.PHONY: patch
patch:
	@echo "${CCPINK}${CCBOLD}\n-> Apply the patches\n${CCEND}"
	@patch -s -p0 < ./patch-${LIB_VERSION}.diff

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	@echo "${CCPINK}${CCBOLD}\n-> Building using the ${LIBC}...\n${CCEND}"
	@cd ${PKGNAME} && \
		CC="ppc-amigaos-gcc" \
		CFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
		CXXFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
		LIBXML_CFLAGS=-I${SDK_PATH}/local/common/include/libxml2 \
		LIBXML_LIBS=-lxml2 \
		./autogen.sh --host=ppc-amigaos --enable-shared=no \
			--prefix=${SDK_PATH}/local/${LIBC} \
			--includedir=${SDK_PATH}/local/${LIBC}/include \
			--without-python \
		&& \
		make -j$(shell nproc)

#   $ ./configure --host=ppc-amigaos --prefix=/opt/packages/libxslt_1.1.38_amd64/usr/ppc-amigaos/SDK/local/clib4/ CPPFLAGS=-mcrt=clib4 -mstrict-align LDFLAGS=-mcrt=clib4 -athread=native --without-python LIBXML_CFLAGS=-I/usr/ppc-amigaos/SDK/local/clib4/include/libxml2 LIBXML_LIBS=-lxml2 LIBS=-lz -lpthread --disable-shared --enable-static


.PHONY: build/%
build/%:
	@echo "${CCPINK}${CCBOLD}\n-> Compiling for $*\n${CCEND}"
	@make build LIBC=$*

#####################################################################
##@ Clean

.PHONY: clean
clean: ## Clean the latest build
	@echo "${CCPINK}${CCBOLD}\n-> Clean the build\n${CCEND}"
	@make -C ${PKGNAME} clean

.PHONY: cleanall
cleanall: ## Clean the downloaded files and folders
	@echo "${CCPINK}${CCBOLD}\n-> Remove archive and folders\n${CCEND}"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
##@ Release

.PHONY: release
release: release-init build/newlib pack/newlib clean build/clib2 pack/clib2 clean build/clib4 pack/clib4 archive ## Build and create the release

.PHONY: release-init
release-init: ## Prepare the release folders
	@echo "${CCPINK}${CCBOLD}\n-> Clear previous release folders...\n${CCEND}"
	@rm -rf ./SDK

	@echo "${CCPINK}${CCBOLD}\n-> Create release folders...\n${CCEND}"
	@mkdir -p ./SDK/local/Documentation/libxslt ./SDK/local/common/include/libxslt
	@cp ${PKGNAME}/Copyright ./SDK/local/Documentation/libxslt/
	@cp ${PKGNAME}/README.md ./SDK/local/Documentation/libxslt/

.PHONY: pack/%
pack/%:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging for $*\n${CCEND}"
	@mkdir -p ./SDK/local/$*/lib/pkgconfig
	@cp ${PKGNAME}/libxslt/*.h ./SDK/local/common/include/libxslt/
	@cp ${PKGNAME}/libxslt/.libs/libxslt.* ./SDK/local/$*/lib/
	@cp ${PKGNAME}/libxslt.pc ./SDK/local/$*/lib/pkgconfig/

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/ ./AutoInstall