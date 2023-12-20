# fontconfig for AmigaOS 4 - WIP

The scripts compile **fontconfig** from [https://www.freedesktop.org/wiki/Software/fontconfig/](https://www.freedesktop.org/wiki/Software/fontconfig/) for AmigaOS 4. 
A new release lha archive can be created to be used with the AmigaOS 4 SDK, for native and cross compiling.

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
- support for clib2 and newlib