# RISCV IOMMU on qemu

## Build Qemu
add --enable-slirp option for -netdev

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://github.com/tjeznach/qemu.git
    cd qemu
    git checkout tjeznach/riscv-iommu
    git submodule update --init
    ./configure --target-list="riscv32-softmmu riscv64-softmmu" --enable-slirp
    make -j 64
    cd -

## Build linux kernel
    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://github.com/tjeznach/linux.git
    cd linux
    git checkout tjeznach/riscv-iommu-aia
    cd -

    mkdir build
    make  O=build -j64 defconfig
    cd build
    ../scripts/kconfig/merge_config.sh .config ../../vfio.config
    cd ..
    make O=build -j64 Image
    cd ../

 ## Make the rootfs
    sudo su
    truncate -s 1G kinetic.img
    mkfs.ext4 kinetic.img
    mkdir -p kinetic
    mount -oloop kinetic.img kinetic
    debootstrap --arch=riscv64 kinetic kinetic
    sed 's/root:.:/root::/' -i kinetic/etc/shadow
    echo 'riscv-guest' > kinetic/etc/hostname
    umount kinetic
    cp kinetic.img nvme1.img
    mount -oloop kinetic.img kinetic
    cp lkvm-static kinetic/usr/bin
    cp linux/build/arch/riscv/boot/Image kinetic/usr/share/Image
    echo 'riscv-host' > kinetic/etc/hostname
    cp testcmd.sh kinetic/usr/bin
    umount kinetic
    cp kinetic.img nvme0.img
    rm -rf kinetic*
    exit


[reference](https://raw.githubusercontent.com/tjeznach/docs/master/riscv-iommu/run-qemu.sh)
