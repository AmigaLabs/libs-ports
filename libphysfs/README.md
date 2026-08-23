# PhysicsFS 3.3.0 for AmigaOS 4

Source: [https://github.com/icculus/physfs](https://github.com/icculus/physfs)

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

## Compilation options used

```bash
-- PhysicsFS will build with the following options:
--   ZIP support: enabled
--   7zip support: enabled
--   GRP support: enabled
--   WAD support: enabled
--   CSM support: enabled
--   HOG support: enabled
--   MVL support: enabled
--   QPAK support: enabled
--   ROFS support: enabled
--   SLB support: enabled
--   VDF support: enabled
--   ISO9660 support: enabled
--   GOB/LAB/LFD support: enabled
--   POD support: enabled
--   SDL3 filesystem support: disabled
--   Build static library: enabled
--   Build shared library: enabled
--   Build stdio test program: disabled
--   Build Doxygen documentation: enabled
```

## Known bugs and todo

- Not available for clib2