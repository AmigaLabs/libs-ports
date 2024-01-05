# icu for AmigaOS 4

Source: [https://github.com/unicode-org/icu/releases](https://github.com/unicode-org/icu/releases)

This makefile can be used to compile the above library and create a new release lha archive, to be used with the AmigaOS 4 SDK, for native and cross compiling.

Useful reading at [https://unicode-org.github.io/icu/userguide/icu4c/build.html#how-to-cross-compile-icu](https://unicode-org.github.io/icu/userguide/icu4c/build.html#how-to-cross-compile-icu)

**Supported libc**
WIP

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

With `make init` the library code is downloaded, extracted and the Linux build is happening under the `icu-release/icu4c/source/buildLinux` folder. This need to be done only once, so it is done on initialisation. This is part of th process and a mandatory step.

This library is not able to complete in a cross compiling environment. Thus it needs to be completed at an OS4 computer. To do that, please follow the steps below:

```
make init
make build
make buildCompilationArchive
```
The last step wil create an archive named `icu_compile_in_amiga_<libc name here>.lha`. This needs to be transferred and extracted under AmigaOS 4 environment which has the latest SDK installed. 

Then the following command needs to be executed in the generated folder.
```
execute amigaRunMe
```

The generated library files will be inside the _OUT folder.

## Known bugs and todo
- newlib compilation in AmigaOS 4 fails for now
- clib2 fails because of lack of <langinfo.h>
- clib4 fails because of compilation conflicts with SDK with Locale
