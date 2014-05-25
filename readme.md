teensy3-toolchain
=================

My small efforts to build a teensy3 toolchain with clang+llvm will be put here.

#### TL;DR
```shell
    $ ./fetch && ./compile-all
```
This command fetches binutils and the git submodules for teensy-core and pdclib and compiles everything, installing onto `$repo/prefix`.

#### Assumptions made by the scripts
  - `tar xf file` will automatically deal with compression if the file is compressed (`.tar.gz` or `.tar.bz2`)
  - `curl` is available
  - Dependencies for binutils are installed (at the very least, compiler + sh shell)
  - A (recent) `clang` capable of targeting ARM (with `-mcpu=cortex-m4`)
  - `cmake` and `ninja` (but since I'll be using `cmake` for the build system, `make` or another of `cmake`'s generators will be able to replace `ninja`)


#### What do the scripts do?

For now, the fetch script simply downloads binutils and initializes the git submodules for teensy-core and pdclib.
The `compile-*` scripts compile binutils and the static libraries putting the resulting binaries and headers in `$repo/armprefix`.

Documentation is currently nonexistent and the control variables are in the `utils/defs.sh` script and `cmake/toolchain.cmake`.

In the future I'll possibly add llvm's libcxx (as well as stuff from compiler_rt).

Everything will be tested on, at least, a recent Mac OS X.
