# fontconfig for AmigaOS 4, set up to work for the Odyssey Web Browser

The scripts compile **fontconfig** from [https://www.freedesktop.org/wiki/Software/fontconfig/](https://www.freedesktop.org/wiki/Software/fontconfig/) for AmigaOS 4. 
A new release lha archive can be created to be used with the AmigaOS 4 SDK, for native and cross compiling.

**WARNING:** This version of the fontconfig library is made to work with Odyssey WebBrowser. As such, it is not recommended to be used in other projects, unless if its changes are useful to your project as well.

The majority of the changes that are applied in the this version of the library, were provided by **afxgroup**, **kas1e** and **Fab**. Thank you guys for your help.

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
