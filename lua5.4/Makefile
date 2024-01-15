# Set the libc to be used with the LIBC argument
# possible values newlib, clib2, clib4
# make LIBC=clib4
# 

LIB_VERSION=5.4.6
LIBC?=newlib

PKGNAME=lua-${LIB_VERSION}

all: build

download:
	@echo "-> Download archive ${PKGNAME}"
	@curl -fsSLk "https://www.lua.org/ftp/${PKGNAME}.tar.gz" -o ${PKGNAME}.tar.gz && \
		echo "-> Extract archive" && \
		tar xzpf ${PKGNAME}.tar.gz

init: download

build:
	@make -C ${PKGNAME}/src generic \
		CC="ppc-amigaos-gcc -mcrt=${LIBC} -std=gnu99" \
		-j$(shell nproc)

#####################################################################
# Clean jobs

cleanbuild:
	@echo "-> Clean the build folder"
	@make -C ${PKGNAME}/src clean

cleanall:
	@echo "-> Remove archive and folder"
	@rm -rf ./${PKGNAME}.tar.gz ./${PKGNAME} ./SDK

#####################################################################
# Release jobs

release-init:
	@echo "-> Clear previous release folders..."
	@rm -rf ./SDK
	@echo "-> Create release folders..."
	@mkdir -p ./SDK/local/common/include/lua54
	@mkdir -p ./SDK/local/Documentation/lua54
	@cp -r ${PKGNAME}/doc ./SDK/local/Documentation/lua54/
	@cp ${PKGNAME}/README* ./SDK/local/Documentation/lua54/

newlib:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/bin
	@cp ./${PKGNAME}/src/liblua.a ./SDK/local/$@/lib/liblua54.a
	@cp ./${PKGNAME}/src/lua ./${PKGNAME}/src/luac \
		./SDK/local/$@/bin/
	@cp ./${PKGNAME}/src/lua.h ./${PKGNAME}/src/lua.hpp \
		./${PKGNAME}/src/luaconf.h ./${PKGNAME}/src/lualib.h \
		./SDK/local/common/include/lua54/

clib2:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/bin
	@cp ./${PKGNAME}/src/liblua.a ./SDK/local/$@/lib/liblua54.a
	@cp ./${PKGNAME}/src/lua ./${PKGNAME}/src/luac \
		./SDK/local/$@/bin/

clib4:
	@echo "-> Building $@ based libraries..."
	@make LIBC=$@
	@mkdir -p ./SDK/local/$@/lib
	@mkdir -p ./SDK/local/$@/bin
	@cp ./${PKGNAME}/src/liblua.a ./SDK/local/$@/lib/liblua54.a
	@cp ./${PKGNAME}/src/lua ./${PKGNAME}/src/luac \
		./SDK/local/$@/bin/

archive:
	@echo "-> Creating the lha release file..."
	@rm -f ./${PKGNAME}.lha
	@lha aq ./${PKGNAME}.lha ./SDK/

release: release-init newlib cleanbuild clib2 cleanbuild clib4 cleanbuild archive