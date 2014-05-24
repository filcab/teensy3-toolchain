#!/bin/sh

# Directory configs
pushd `dirname $0` > /dev/null
ROOT=`pwd`
popd > /dev/null

DISTFILES="$ROOT/distfiles"
SRCDIR="$ROOT/src"
mkdir -p "$DISTFILES"

# Deal with git submodules first
echo Updating submodules
if [ ! -d "$SRCDIR/pdclib" ]; then
  git submodule init
fi
git submodule update

# Verifying the download's signature is left as an exercise for the reader
# The reader would also have to verify this repo, and there's no way they
# can.
BIN_FILE=binutils-2.24.tar.bz2
echo Downloading $BIN_FILE
curl -o "$DISTFILES/$BIN_FILE" "http://ftp.gnu.org/gnu/binutils/$BIN_FILE"
