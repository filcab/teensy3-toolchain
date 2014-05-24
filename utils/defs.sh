#!/bin/sh

# This file is designed to be sourced from scripts in the top-level
# directory of the repository. It sets up a few variables and helper
# functions.

# Directory configs
pushd `dirname "$0"` > /dev/null
ROOT=`pwd`
popd > /dev/null

DISTFILES="$ROOT/distfiles"
SRCDIR="$ROOT/src"
OBJDIR="$ROOT/build"

function die {
  echo DIE: "$*"
  exit 1
}

function msg {
  echo "[*]" "$*"
}

# For now we either have info msgs or not. There's only one level to
# choose, that's why we test with -z
function msg_info {
  test ! -z $INFO_LEVEL && echo "[-]" "$*"
}