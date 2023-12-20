# hyphen for AmigaOS 4

These scripts compile **hyphen** from [https://github.com/hunspell/hyphen](https://github.com/hunspell/hyphen) for AmigaOS 4. 
A new release lha archive can be created to be used with the AmigaOS 4 SDK, for native and cross compiling.

**Supported libc**
- newlib
- clib2
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
- create shared objects, which is not working now