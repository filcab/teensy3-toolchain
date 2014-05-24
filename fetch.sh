#!/bin/sh

# Directory configs
pushd `dirname $0` > /dev/null
ROOT=`pwd`
popd > /dev/null

DISTFILES="$ROOT/distfiles"
mkdir -p "$DISTFILES"

BIN_FILE=binutils-2.24.tar.bz2
curl -o "$DISTFILES/$BIN_FILE" "http://ftp.gnu.org/gnu/binutils/$BIN_FILE"
