# gl4es for AmigaOS 4

Source: [https://github.com/ptitSeb/gl4es](https://github.com/ptitSeb/gl4es)

This makefile can be used to compile the above library and create a new release lha archive, to be used with the AmigaOS 4 SDK, for native and cross compiling.

If `LIB_VERSION` is set to `edge` then the latest code from the official repository is used. The generated archive will have the date of the last commit.

**Supported libc**
- newlib
- clib4

## How to compile
```
make init
make build
```

The clib that will be used while compiling can be selected by using the `LIBC=` argument.
Valid options are newlib (default), clib2 and clib4
```
make build LIBC=clib4
```

To create a release package the following steps need to be done.
```
make init
make release
```

## Bugs and todo
- clib2 is not supported because of lack of `SIGBUS` and `SIGQUIT`
