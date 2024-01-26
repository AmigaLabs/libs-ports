# libiconv for AmigaOS 4

Source: [https://ftp.gnu.org/pub/gnu/libiconv](https://ftp.gnu.org/pub/gnu/libiconv)

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

## Known bugs and todo
- newlib (lack of pthread_sigmask)
- clib2 (lack of pthread_sigmask)