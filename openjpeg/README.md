# openjpeg for AmigaOS 4

These scripts compile openjpeg 2.5.0 from [https://github.com/uclouvain/openjpeg/releases/tag/v2.5.0](https://github.com/uclouvain/openjpeg/releases/tag/v2.5.0) for newlib and clib4. A new release lha archive can be created to be used with the AmigaOS 4 SDK, for native and cross compiling.

## How to compile
```
make init
make release
```

## Bugs and todo
- support for clib2 when `sys/times.h` is available