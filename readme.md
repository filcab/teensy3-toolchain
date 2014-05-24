teensy3-toolchain
=================

My small efforts to build a teensy3 toolchain with clang+llvm will be put here

For now, it simply downloads binutils (via the `fetch.sh`) script and compiles it with the `compile-binutils.sh` script, putting the resulting binaries in `$repo/arm-none-eabi`

In the future I'll add a libc (pdclib) and, possibly, llvm's libcxx (as well as stuff from compiler_rt).

Everything will be tested on, at least, a recent Mac OS X.

Assumptions made on the scripts:
  - `tar xf file` will automatically deal with compression if the file is compressed (`.tar.gz` or `.tar.bz2`)
  - `curl` is available
  - Dependencies for binutils are installed (at the very least, compiler + sh shell)
  
  - In the future, it will be assumed a (recent) clang capable of targeting ARM (preferably with -mcpu=cortex-m4) is available (for pdclib and actual compilation).
  - cmake and ninja will be assumed by the instructions I'll write here. But since I'll be using cmake, make or another of cmake's generator will be able to replace ninja.
