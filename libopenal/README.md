# OpenAL 1.18.2 for AmigaOS 4

Source: [https://github.com/salass00/openal_lib](https://github.com/salass00/openal_lib)

This makefile can be used to compile the above library and create a new release lha archive, to be used with the AmigaOS 4 SDK, for native and cross compiling.

**Supported libc**
- newlib
- clib4

## How to compile

```bash
make init
make build
```

The clib that will be used while compiling can be selected by using the `LIBC=` argument.
Valid options are newlib and clib4

```bash
make build LIBC=clib4
```

To create a release package the following steps need to be done.
```bash
make init
make release
```


## Known bugs and todo

- Not available for clib2