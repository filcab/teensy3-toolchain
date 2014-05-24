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

# The CPPFLAGS are a hack to make bfd play well when calling abs with a
# bfd_signed_vma on a 64-bit host
BIN_CONF_FLAGS="--enable-interwork --disable-libstdcxx --disable-werror"

# Directory configs
pushd `dirname $0` > /dev/null
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
  pkg=$1
  ext=$2
  if [ ! -d $SRCDIR/$pkg ]; then
    mkdir -p $SRCDIR
    pushd $SRCDIR
    tar xf $DISTFILES/$pkg$ext
    popd
  fi
}

# binutils
extract_src "binutils-$BIN_VERSION" ".tar.bz2"
mkdir -p "$OBJDIR/binutils"
pushd "$OBJDIR/binutils"
"$SRCDIR/binutils-$BIN_VERSION/configure" --prefix=$PREFIX --target=$TARGET $BIN_CONF_FLAGS
if [ $? != 0 ]; then
  die Error in binutils configure
fi
make || die Error compiling binutils

