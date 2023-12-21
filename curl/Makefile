# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=8.5.0
LIBC?=newlib

PKGNAME=curl-${LIB_VERSION}

ifeq ($(LIBC), clib4)
LIBC_CONFIGS="--disable-shared"
endif

ifeq ($(LIBC), clib2)
LIBC_CONFIGS="--disable-shared"
endif

ifeq ($(LIBC), newlib)
LIBC_CONFIGS="--disable-shared"
endif

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://curl.se/download/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz

init: download patches

patches:
	@echo "-> Apply the patches"
	@patch -s -p0 < ./patch-1.diff

build:
	@cd ${PKGNAME} && \
	CC="ppc-amigaos-gcc" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
	PKG_CONFIG_PATH=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LIBS="-use-dynld -lpthread -athread=native" \
	./configure --host=ppc-amigaos \
		--enable-shared \
		--enable-static \
		--disable-ntlm-wb \
		--enable-threaded-resolver \
		--disable-ipv6 \
		--with-openssl \
		--without-brotli \
		--disable-dependency-tracking \
		--with-ca-bundle="S:curl-ca-bundle.crt" \
		--prefix=${SDK_PATH}/local/${LIBC} \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@make -C ${PKGNAME} clean
	@rm -rf ./${PKGNAME}/lib/.libs ./${PKGNAME}/lib/libcurl.la \
		./${PKGNAME}/*.o ./${PKGNAME}/*.lo

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
# Release jobs

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/Documentation/curl
	@mkdir -p ./SDK/local/common/include/curl
	@mkdir -p ./SDK/local/examples
	@cp -r ./${PKGNAME}/docs ./SDK/local/Documentation/curl/
	@mv ./SDK/local/Documentation/curl/docs/examples ./SDK/local/examples/curl
	@cp ./${PKGNAME}/include/curl/*.h ./SDK/local/common/include/curl/
	@cp ./${PKGNAME}/CHANGES* ./SDK/local/Documentation/curl/
	@cp ./${PKGNAME}/COPYING* ./SDK/local/Documentation/curl/
	@cp ./${PKGNAME}/README* ./SDK/local/Documentation/curl/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/bin
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/lib/pkgconfig
	@cp ./${PKGNAME}/src/curl ./SDK/local/$@/bin/
	@cp ./${PKGNAME}/lib/.libs/libcurl.a \
		./${PKGNAME}/lib/.libs/libcurl.lai \
		./${PKGNAME}/lib/.libs/libcurl.so \
		./${PKGNAME}/lib/libcurl.la \
		./SDK/local/$@/lib/
	@cp ./${PKGNAME}/libcurl.pc ./SDK/local/$@/lib/pkgconfig/

# clib2:
# 	@echo "-> Building $@ based libraries..."
# 	@make LIBC=$@
# 	@mkdir -p ./SDK/local/$@/lib
# 	@mkdir -p ./SDK/local/$@/lib/pkgconfig
# 	@cp ./${PKGNAME}/lib/.libs/libcurl.a \
# 		./${PKGNAME}/lib/.libs/libcurl.lai \
# 		./${PKGNAME}/lib/libcurl.la \
# 		./SDK/local/$@/lib/
# 	@cp ./${PKGNAME}/libcurl.pc ./SDK/local/$@/lib/pkgconfig/

# clib4:
# 	@echo "-> Building $@ based libraries..."
# 	@make LIBC=$@
# 	@mkdir -p ./SDK/local/$@/bin
# 	@mkdir -p ./SDK/local/$@/lib
# 	@mkdir -p ./SDK/local/$@/lib/pkgconfig
# 	@cp ./${PKGNAME}/src/curl ./SDK/local/$@/bin/
# 	@cp ./${PKGNAME}/lib/.libs/libcurl.a \
# 		./${PKGNAME}/lib/.libs/libcurl.lai \
# 		./${PKGNAME}/lib/libcurl.la \
# 		./SDK/local/$@/lib/
# 	@cp ./${PKGNAME}/libcurl.pc ./SDK/local/$@/lib/pkgconfig/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha -aeq ./${PKGNAME}.lha ./SDK/

release: release-init newlib cleanbuild archive
