# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=74.1
LIBC?=newlib

PKGNAME=icu-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://github.com/unicode-org/icu/archive/refs/tags/release-74-1.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz && \
	mv icu-release-74-1 icu-release

init: download buildLinux

buildLinux:
	@echo "-> Prepare the Linux build"
	@mkdir -p icu-release/icu4c/source/buildLinux && \
	cd icu-release/icu4c/source/buildLinux && \
	CC="/usr/bin/gcc" \
	CXX="/usr/bin/g++" \
	LD="/usr/bin/ld" \
	AR="/usr/bin/ar" \
	AS="/usr/bin/as" \
	RANLIB="/usr/bin/ranlib" \
		sh ../runConfigureICU Linux/gcc && \
	make -j$(shell nproc) && \
	cp ../config/mh-linux ../config/mh-unknown

build:
	@mkdir -p icu-release/icu4c/source/buildAmigaOS4 && \
	cd icu-release/icu4c/source/buildAmigaOS4 && \
	CC="ppc-amigaos-gcc" \
	CXX="ppc-amigaos-g++" \
	CFLAGS="-mcrt=${LIBC} -O2 -fPIC" \
	CXXFLAGS="-mcrt=${LIBC} -std=gnu++11 -fPIC" \
	PKG_CONFIG_LIBDIR=${SDK_PATH}/local/${LIBC}/lib/pkgconfig \
	LDFLAGS="-mcrt=${LIBC} -athread=native" \
	LIBS="" \
	../configure \
		--host=ppc-amigaos \
		--disable-shared   \
		--enable-static    \
		--disable-dyload   \
		--enable-release   \
		--disable-debug    \
		--disable-tests     \
		--enable-samples   \
		--disable-extras   \
		--enable-layoutex  \
		--with-cross-build="$(realpath ./icu-release/icu4c/source/buildLinux)" \
		--prefix=${SDK_PATH}/local/${LIBC} \
		--includedir=${SDK_PATH}/local/common/include \
	&& \
	make -j$(shell nproc)

buildCompilationArchive:
	@echo "-> Create folder structure"
	@mkdir -p icu_compile_in_amiga_${LIBC}/include \
		icu_compile_in_amiga_${LIBC}/_OUT \
		icu_compile_in_amiga_${LIBC}/_TMP

	@echo "-> Copy the necessary files"
	@cp -r ./icu-release/icu4c/source/buildAmigaOS4/lib \
		./icu-release/icu4c/source/buildAmigaOS4/bin \
		./icu-release/icu4c/source/buildAmigaOS4/data/out/build/icudt74b \
		./icu-release/icu4c/source/buildAmigaOS4/data/out/tmp/icudata.lst \
		./icu-release/icu4c/source/buildAmigaOS4/data/icupkg.inc \
		./icu-release/icu4c/source/buildAmigaOS4/common \
		./icu_compile_in_amiga_${LIBC}/ && \
	cp -r ./icu-release/icu4c/source/common ./icu_compile_in_amiga_${LIBC}/include/

	@echo "-> Make some necessary changes in the files"
	@sed -i 's,ppc-amigaos-,,g' ./icu_compile_in_amiga_${LIBC}/icupkg.inc && \
	sed -i 's,-I../../common,-Iinclude/common,' ./icu_compile_in_amiga_${LIBC}/icupkg.inc && \
	sed -i 's,-I../common,-Icommon,' ./icu_compile_in_amiga_${LIBC}/icupkg.inc && \
	echo "bin/pkgdata -O icupkg.inc -c -s icudt74b -d _OUT -e icudt74  -T _TMP -p icudt74b -m static -r 74.1 -L icudata_${C_LIB} icudata.lst" > \
		./icu_compile_in_amiga_${LIBC}/amigaRunMe && \
	chmod +x ./icu_compile_in_amiga_${LIBC}/amigaRunMe

	@echo "-> Create the archive"
	@lha aq ./icu_compile_in_amiga_${LIBC}.lha ./icu_compile_in_amiga_${LIBC}



#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@rm -rf ./icu-release/icu4c/source/buildAmigaOS4 ./files_for_amiga_${LIBC}

cleanall:
	@echo "-> Remove archive and folder"
# @rm -rf ./${PKGNAME}.tar.gz ./icu-release ./SDK

#####################################################################
# Release jobs

# release-init:
# 	@echo "-> Clear previous release folders..."
# 	@rm -rf ./SDK
# 	@echo "-> Create release folders..."
# 	@mkdir -p ./SDK/local/common/include/mpfr
# 	@mkdir -p ./SDK/local/common/examples/mpfr
# 	@mkdir -p ./SDK/local/Documentation/mpfr
# 	@cp ${PKGNAME}/AUTHORS* ./SDK/local/Documentation/mpfr/
# 	@cp ${PKGNAME}/COPYING* ./SDK/local/Documentation/mpfr/
# 	@cp ${PKGNAME}/README* ./SDK/local/Documentation/mpfr/

# newlib:
# 	@echo "-> Building $@ based libraries..."
# 	@make LIBC=$@
# 	@mkdir -p ./SDK/local/$@/lib
# 	@mkdir -p ./SDK/local/$@/lib/pkgconfig
# 	@cp ./${PKGNAME}/src/.libs/libmpfr.a \
# 		./${PKGNAME}/src/.libs/libmpfr.lai \
# 		./${PKGNAME}/src/.libs/libmpfr.so \
# 		./${PKGNAME}/src/libmpfr.la \
# 		./SDK/local/$@/lib/
# 	@cp ./${PKGNAME}/mpfr.pc ./SDK/local/$@/lib/pkgconfig/
# 	@cp ./${PKGNAME}/src/generic/*.h ./SDK/local/common/include/mpfr/
# 	@cp ./${PKGNAME}/examples/* ./SDK/local/common/examples/mpfr/
# 	@cp ./${PKGNAME}/m4/*.m4 ./SDK/local/Documentation/mpfr/

# clib2:
# 	@echo "-> Building $@ based libraries..."
# 	@make LIBC=$@
# 	@mkdir -p ./SDK/local/$@/lib
# 	@mkdir -p ./SDK/local/$@/lib/pkgconfig
# 	@cp ./${PKGNAME}/src/.libs/libmpfr.a \
# 		./${PKGNAME}/src/.libs/libmpfr.lai \
# 		./${PKGNAME}/src/.libs/libmpfr.so \
# 		./${PKGNAME}/src/libmpfr.la \
# 		./SDK/local/$@/lib/
# 	@cp ./${PKGNAME}/mpfr.pc ./SDK/local/$@/lib/pkgconfig/

# clib4:
# 	@echo "-> Building $@ based libraries..."
# 	@make LIBC=$@
# 	@mkdir -p ./SDK/local/$@/lib
# 	@mkdir -p ./SDK/local/$@/lib/pkgconfig
# 	@cp ./${PKGNAME}/src/.libs/libmpfr.a \
# 		./${PKGNAME}/src/.libs/libmpfr.lai \
# 		./${PKGNAME}/src/.libs/libmpfr.so \
# 		./${PKGNAME}/src/libmpfr.la \
# 		./SDK/local/$@/lib/
# 	@cp ./${PKGNAME}/mpfr.pc ./SDK/local/$@/lib/pkgconfig/

# archive:
# 	@echo "-> Creating the lha release file..."
# 	@rm -f ./${PKGNAME}.lha
# 	@lha aq ./${PKGNAME}.lha ./SDK/

# release: release-init newlib cleanbuild clib2 cleanbuild clib4 cleanbuild archive