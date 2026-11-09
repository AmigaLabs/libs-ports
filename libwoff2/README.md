# libwoff2 for AmigaOS 4

Source: [https://github.com/google/woff2](https://github.com/google/woff2)

This makefile can be used to compile the above library and create a new release lha archive, to be used with the AmigaOS 4 SDK, for native and cross compiling.

**Supported libc**
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
- newlib and clib2 versions miss dependencies