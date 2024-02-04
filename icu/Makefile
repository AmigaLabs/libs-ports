# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=72.1
LIBC?=newlib

PKGNAME=icu-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSL "https://github.com/unicode-org/icu/archive/refs/tags/release-72-1.tar.gz" -o ${PKGNAME}.tar.gz && \
	echo "-> Extract archive" && \
	tar xzpf ${PKGNAME}.tar.gz && \
	mv icu-release-72-1 icu-release

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
# -D__USE_AMIGAOS_NAMESPACE__
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
		--enable-tests     \
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
		./icu-release/icu4c/source/buildAmigaOS4/data/out/build/icudt72b \
		./icu-release/icu4c/source/buildAmigaOS4/data/out/tmp/icudata.lst \
		./icu-release/icu4c/source/buildAmigaOS4/data/icupkg.inc \
		./icu-release/icu4c/source/buildAmigaOS4/common \
		./icu_compile_in_amiga_${LIBC}/ && \
	cp -r ./icu-release/icu4c/source/common ./icu_compile_in_amiga_${LIBC}/include/

	@echo "-> Make some necessary changes in the files"
	@sed -i 's,ppc-amigaos-,,g' ./icu_compile_in_amiga_${LIBC}/icupkg.inc && \
	sed -i 's,-I../../common,-Iinclude/common,' ./icu_compile_in_amiga_${LIBC}/icupkg.inc && \
	sed -i 's,-I../common,-Icommon,' ./icu_compile_in_amiga_${LIBC}/icupkg.inc && \
	echo "bin/pkgdata -O icupkg.inc -c -s icudt72b -d _OUT -e icudt72  -T _TMP -p icudt72b -m static -r 72.1 -L icudata_${LIBC} icudata.lst" > \
		./icu_compile_in_amiga_${LIBC}/amigaRunMe && \
	chmod +x ./icu_compile_in_amiga_${LIBC}/amigaRunMe

	@echo "-> Create the archive"
	@lha aq ./icu_${LIB_VERSION}_compile_in_amiga_${LIBC}.lha ./icu_compile_in_amiga_${LIBC}



#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@rm -rf ./icu-release/icu4c/source/buildAmigaOS4 ./files_for_amiga_${LIBC}

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./icu-release ./SDK
