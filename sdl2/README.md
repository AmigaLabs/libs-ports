# SDL2 based on OGLES2 for AmigaOS 4

Source: [https://github.com/AmigaPorts/SDL-2.0](https://github.com/AmigaPorts/SDL-2.0)

This makefile can be used to compile the above library and create a new release lha archive, to be used with the AmigaOS 4 SDK, for native and cross compiling.

**Supported libc**
- newlib
- clib4

## How to compile
```
make init
make build
```

The clib that will be used while compiling can be selected by using the `LIBC=` argument.
Valid options are newlib, clib2 and clib4
```
make build LIBC=clib4
```

To create a release package the following steps need to be done.
```
make init
make release
```

## Bugs and todo
- No clib2 version because of lack of OpenGL libraries
- clib4 doesn't have the debug libraries, because of compilation issues at `/src/main/amigaos4/SDL_os4debug.h`. The `IExec` seems to not be defined