# KVM RISCV64 on QEMU

## Build Qemu
You can skip this step if `qemu-system-riscv64` tool has existed in your building environment.

    git clone https://gitlab.com/qemu-project/qemu.git
    cd qemu
    git submodule update --init --recursive
    ./configure --target-list="riscv32-softmmu riscv64-softmmu"
    make -j 64
    cd -

## Build linux kernel for host and guest

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://github.com/kvm-riscv/linux.git
    mkdir riscv-linux
    make -C linux O=`pwd`/riscv-linux defconfig
    make -C linux O=`pwd`/riscv-linux -j 64

## Build libfdt and kvmtool
We need libfdt library in the cross-compile toolchain for compiling KVMTOOL RISC-V. The libfdt library is generally not available in the cross-compile toolchain so we need to explicitly compile libfdt from DTC project and add it to CROSS_COMPILE SYSROOT directory.

### Build libdft
    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    export CC="${CROSS_COMPILE}gcc -mabi=lp64d -march=rv64gc"
    TRIPLET=$($CC -dumpmachine)
    SYSROOT=$($CC -print-sysroot)
    git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
    cd dtc
    make libfdt -j 64
    make NO_PYTHON=1 NO_YAML=1 DESTDIR=$SYSROOT PREFIX=/usr LIBDIR=/usr/lib64/lp64d install-lib install-includes
    cd -

### Build kvmtool

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
    cd kvmtool
    make lkvm-static -j 64
    ${CROSS_COMPILE}strip lkvm-static
    cd -

[reference wiki](https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU)

