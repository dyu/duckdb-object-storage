#!/bin/sh

set -eo pipefail

CURRENT_DIR=$PWD
# locate
if [ -z "$BASH_SOURCE" ]; then
    SCRIPT_DIR=`dirname "$(readlink -f $0)"`
elif [ -e '/bin/zsh' ]; then
    F=`/bin/zsh -c "print -lr -- $BASH_SOURCE(:A)"`
    SCRIPT_DIR=`dirname $F`
elif [ -e '/usr/bin/realpath' ]; then
    F=`/usr/bin/realpath $BASH_SOURCE`
    SCRIPT_DIR=`dirname $F`
else
    F=$BASH_SOURCE
    while [ -h "$F" ]; do F="$(readlink $F)"; done
    SCRIPT_DIR=`dirname $F`
fi

cd $SCRIPT_DIR

export GEN='ninja'

if [ "$XC" = '1' ]; then
  BIN_DIR=`readlink -f ~/.pixi/envs/xclang/opt/xclang/bin`
  export CC="$BIN_DIR/clang"
  export CXX="$BIN_DIR/clang++"
elif command -v clang-20 > /dev/null 2>&1; then
  BIN_DIR=`dirname $(which clang-20)`
  export CC="$BIN_DIR/clang-20"
  export CXX="$BIN_DIR/clang++-20"
fi

make release
