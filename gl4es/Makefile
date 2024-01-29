# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make build LIBC=clib4
# 

# Latest release tag is 1.1.4 - Set to edge to clone repo
LIB_VERSION=edge
LIBC?=newlib

PKGNAME=gl4es-${LIB_VERSION}

include ../_common/help.mk
include ../_common/checks.mk


.PHONY: download
download:
ifeq ($(LIB_VERSION),edge)
	@echo "${CCPINK}${CCBOLD}\n-> Cloning gl4es repository ${PKGNAME}\n${CCEND}"
	@git clone https://github.com/ptitSeb/gl4es.git ${PKGNAME} --depth 1
# mv ${PKGNAME} ${PKGNAME}-$(shell git -C gl4es-edge log -1 --format=format:"%h")
else
	@echo "${CCPINK}${CCBOLD}\n-> Download archive ${PKGNAME}\n${CCEND}"
	@curl -fsSLk "https://github.com/ptitSeb/gl4es/archive/refs/tags/v${LIB_VERSION}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "${CCPINK}${CCBOLD}\n-> Extract archive\n${CCEND}" && \
		tar xzpf ${PKGNAME}.tar.gz
endif

#####################################################################
##@ Build

.PHONY: init
init: download  ## Download the archive and initialize the build
	@cd ${PKGNAME} && \
	mkdir build

.PHONY: build
build: # Build with specified LIBC=(newlib|clib2|clib4)
	cd ${PKGNAME}/build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(realpath amigaos4.cmake) \
		-DCMAKE_C_FLAGS="-mcrt=${LIBC} -O2 -fPIC -I${SDK_PATH}/include/include_h/exec/" \
		-DCMAKE_MODULE_LINKER_FLAGS="-mcrt=${LIBC} -lpthread -athread=native" \
		-DAMIGAOS4=ON \
		-DSTATICLIB=ON \
		-DNOX11=ON \
		-DNOEGL=ON \
		-DBUILD_SHARED_LIBS=OFF \
		--install-prefix=${SDK_PATH}/local/${LIBC} \
	&& \
	make -j$(shell nproc)

.PHONY: newlib clib2 clib4
newlib: ## Build using newlib crt and prepares the files for packaging
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
	@rm -rf ${PKGNAME}/build/*

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
	@mkdir -p ./SDK/local/Documentation/gl4es
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/gl4es/
	@cp ${PKGNAME}/LICENSE* ./SDK/local/Documentation/gl4es/
	@cp ${PKGNAME}/CHANGELOG* ./SDK/local/Documentation/gl4es/

.PHONY: package
package:
	@echo "${CCPINK}${CCBOLD}\n-> Packaging ${LIBC} based libraries...\n${CCEND}"
	@mkdir -p ./SDK/local/${LIBC}/lib
	@mkdir -p ./SDK/local/${LIBC}/include/GL4ES
	@cp -r ${PKGNAME}/include/GL/* ./SDK/local/${LIBC}/include/GL4ES
	@cp ./${PKGNAME}/lib/libGL.a ./SDK/local/${LIBC}/lib/libGL4ES.a

.PHONY: archive
archive: ## Create the release archive
	@echo "${CCPINK}${CCBOLD}\n-> Creating the lha release file...\n${CCEND}"
ifeq ($(LIB_VERSION),edge)
	$(eval PKGNAME := gl4es-edge-$(shell git -C gl4es-edge log -1 --format=format:"%ai" | cut -d " " -f 1))
endif
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/
