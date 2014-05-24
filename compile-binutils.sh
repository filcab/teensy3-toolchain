#!/bin/sh

# configuration
export CC=clang
export CXX=clang++
export LD=clang
TARGET=arm-none-eabi

# We're assuming 'tar xf file' will autodetect compression
# if yours doesn't, change the extract_src function

# versions for the files in $ROOT/distfiles
BIN_VERSION=2.24

# We disable -Werror because the binutils people use deprecated functions
# that aren't in POSIX anymore, and silently truncate longs to ints in
# code that doesn't appear (target) 64-bit safe, but that shouldn't be a
# problem for my use-case. They don't seem to care because part of this
# comes from a warning that gcc doesn't have, and the other part is
# because I'm not using glibc.
BIN_CONF_FLAGS="--enable-interwork --disable-libstdcxx --disable-werror"

# Directory configs
pushd `dirname "$0"` > /dev/null
ROOT=`pwd`
popd > /dev/null

DISTFILES="$ROOT/distfiles"
SRCDIR="$ROOT/src"
OBJDIR="$ROOT/build"
PREFIX="$ROOT/$TARGET"

function die {
  echo $*
  exit 1
}

function extract_src {
  pkg="$1"
  ext="$2"
  if [ ! -d "$SRCDIR/$pkg" ]; then
    mkdir -p "$SRCDIR"
    pushd "$SRCDIR"
    tar xf "$DISTFILES/$pkg$ext"
    popd
  fi
}

# binutils
extract_src "binutils-$BIN_VERSION" ".tar.bz2"
mkdir -p "$OBJDIR/binutils"
pushd "$OBJDIR/binutils"
"$SRCDIR/binutils-$BIN_VERSION/configure" --prefix="$PREFIX" --target="$TARGET" $BIN_CONF_FLAGS
if [ $? != 0 ]; then
  die "Error configuring binutils"
fi
make all install || die "Error compiling binutils"
