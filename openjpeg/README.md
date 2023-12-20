# openjpeg for AmigaOS 4

These scripts compile **openjpeg** from [https://github.com/uclouvain/openjpeg/releases/tag/v2.5.0](https://github.com/uclouvain/openjpeg/releases/tag/v2.5.0) for AmigaOS 4. 
A new release lha archive can be created to be used with the AmigaOS 4 SDK, for native and cross compiling.

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
- support for clib2 when `sys/times.h` is available