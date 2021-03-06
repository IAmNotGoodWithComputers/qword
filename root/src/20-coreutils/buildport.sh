#!/usr/bin/env bash

set -e

PKG_NAME=coreutils
PKG_VERSION=8.30
PKG_URL=https://ftp.gnu.org/gnu/coreutils/coreutils-$PKG_VERSION.tar.xz
PKG_TARBALL=$PKG_NAME-$PKG_VERSION.tar.xz
PKG_ARCHIVE_DIR=$PKG_NAME-$PKG_VERSION
PKG_PREFIX=/

if [ "$1" = "clean" ]; then
    rm -rf $PKG_ARCHIVE_DIR
    exit 0
fi

QWORD_ROOT=$(realpath ../..)

if [ ! "$OSTYPE" = "qword" ]; then
    QWORD_BASE=$(realpath ../../..)
    export PATH=$QWORD_BASE/host/toolchain/cross-root/bin:$PATH
fi

set -x

rm -rf $PKG_ARCHIVE_DIR
if [ ! -f $PKG_TARBALL ]; then
    wget $PKG_URL
fi

tar -xf $PKG_TARBALL
cd $PKG_ARCHIVE_DIR
patch -p1 < ../$PKG_NAME-$PKG_VERSION.patch

CFLAGS=-DSLOW_BUT_NO_HACKS ./configure --host=x86_64-qword --prefix=$PKG_PREFIX --enable-no-install-program=du,df,stat,sleep,sort,tail
make "$@"
make DESTDIR=$QWORD_ROOT install
