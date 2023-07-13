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

## Make rootfs

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-

    wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
    tar jxvf busybox-1.36.1.tar.bz2
    cp -f busybox-1.36.1_defconfig busybox-1.36.1/.config
    make -C busybox-1.36.1 oldconfig -j32
    make -C busybox-1.36.1 install -j32

    mkdir -p busybox-1.36.1/_install/etc/init.d
    mkdir -p busybox-1.36.1/_install/dev
    mkdir -p busybox-1.36.1/_install/proc
    mkdir -p busybox-1.36.1/_install/sys
    mkdir -p busybox-1.36.1/_install/modules
    ln -sf /sbin/init busybox-1.36.1/_install/init
    cp -f fstab busybox-1.36.1/_install/etc/
    cp -f rcS busybox-1.36.1/_install/etc/init.d/
    cp -f welcome busybox-1.36.1/_install/etc/
    cp -f kvmtool/lkvm-static busybox-1.36.1/_install/usr/bin/
    cp -f riscv-linux/arch/riscv/boot/Image busybox-1.36.1/_install/modules/
    cp -f riscv-linux/arch/riscv/kvm/kvm.ko busybox-1.36.1/_install/modules/

    cd busybox-1.36.1/_install; find ./ | cpio -o -H newc > ../../rootfs_kvm_riscv64.img; cd -

[reference wiki](https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU)
