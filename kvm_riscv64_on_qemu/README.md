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

[reference wiki](https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU)

