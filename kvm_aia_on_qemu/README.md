# KVM riscv AIA on qemu

## Build Qemu
For this case, the qemu must include riscv hypersior extension and aia.

    git clone https://gitlab.com/qemu-project/qemu.git
    cd qemu
    git submodule update --init --recursive
    ./configure --target-list="riscv32-softmmu riscv64-softmmu"
    make -j 64
    cp build/qemu-system-riscv64 ./
    cd -

## Build kvmtool
libdft has been installed in building environment, so can skip the steps.
If you want to install libdft, please see the [document](../kvm_riscv64_on_qemu/README.md).

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-

    git clone https://github.com/avpatel/kvmtool.git
    cd kvmtool
    git checkout riscv_aia_v1
    make lkvm-static -j 64
    ${CROSS_COMPILE}strip lkvm-static
    cd -

## Build linux kernel for host and guest

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://github.com/avpatel/linux.git
    cd linux
    git checkout riscv_aia_v6
    cd -
    mkdir -p riscv_aia_v6
    make -C linux O=`pwd`/riscv_aia_v6 defconfig
    make -C linux O=`pwd`/riscv_aia_v6 -j 64

 ## Update the rootfs
 The steps of making `rootfs_kvm_riscv64.img` are described in [document](../kvm_riscv64_on_qemu/README.md).

    mkdir initrd
    cp rootfs_kvm_riscv64.img initrd/
    cd initrd
    cpio -ivmd < rootfs_kvm_riscv64.img
    rm rootfs_kvm_riscv64.img

    cp -f ../kvmtool/lkvm-static usr/bin/
    cp -f ../riscv_aia_v6/arch/riscv/boot/Image modules/
    cp -f ../riscv_aia_v6/arch/riscv/kvm/kvm.ko modules/

    find ./ | cpio -o -H newc > ../rootfs_kvm_riscv64.img
    cd -
    rm initrd -rf

## launch the VM

    ./qemu-system-riscv64 -cpu rv64 -M virt,aia=aplic-imsic,aia-guests=7 -m 512M -nographic -smp 4 -bios opensbi/build/platform/generic/firmware/fw_jump.bin -kernel riscv_aia_v6/arch/riscv/boot/Image -initrd ./rootfs_kvm_riscv64.img -append "root=/dev/ram rw console=ttyS0 earlycon=sbi"

