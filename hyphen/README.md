# hyphen for AmigaOS 4

These scripts compile **hyphen 2.8.8** from [https://github.com/hunspell/hyphen](https://github.com/hunspell/hyphen) for newlib, clib2 and clib4. A new release lha archive can be created to be used with the AmigaOS 4 SDK, for native and cross compiling.

## How to compile
```
make init
make release
```

## Known bugs and todo
- create shared objects, which is not working now