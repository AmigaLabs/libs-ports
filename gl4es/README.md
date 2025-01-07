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

## Notes

gl4es v1.1.6 has a change in `src/gl/gl4es.c` setting `glstate->list.active->use_vbo_array = 0;`, as it can be seen from the patch file `patch-1.1.6.diff`. This was proposed by the user baldric, because based on his tests, this increases the speed of gl4es on AmigaOS 4. This is **EXPERIMENTAL**.
This takes the following values:
```C
int      use_vbo_array;   // 0=Not evaluated, 1=No, 2=Yes
```

## Bugs and todo
- clib2 is not supported because of lack of `SIGBUS` and `SIGQUIT`
