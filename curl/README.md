# curl for AmigaOS 4

Source: [https://github.com/curl/curl/releases](https://github.com/curl/curl/releases)

This makefile can be used to compile the above library and create a new release lha archive, to be used with the AmigaOS 4 SDK, for native and cross compiling.

**Note** Before compiling there is a need to rename the AmiSSL openssl folder at `SDK/includ/include_h/openssl` to something else, because of conflict.

**Supported libc**
- newlib

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

## Known bugs and todo
- support clib2 (needs openssl to be ported first)
- support clib4 (there is a failure with the curl binary compilation)