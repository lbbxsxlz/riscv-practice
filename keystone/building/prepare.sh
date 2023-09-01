#! /bin/bash

sudo apt install autoconf automake autotools-dev bc \
bison build-essential curl expat libexpat1-dev flex gawk gcc git \
gperf libgmp-dev libmpc-dev libmpfr-dev libtool texinfo tmux \
patchutils zlib1g-dev wget bzip2 patch vim-common lbzip2 python3 \
pkg-config libglib2.0-dev libpixman-1-dev libssl-dev screen \
device-tree-compiler expect makeself unzip cpio rsync cmake ninja-build p7zip-full

git clone https://github.com/keystone-enclave/keystone.git
cd keystone

## riscv-gnu-toolchain has installed in my host, riscv64-unknown-elf- also is needed to build bootrom
git rm riscv-gnu-toolchain
git rm runtime/test/cmocka

PWD=$(pwd)
export KEYSTONE_SDK_DIR=$PWD/sdk/build64

cd sdk
mkdir -p build
cd build
cmake ..
make
make install
cd $PWD
