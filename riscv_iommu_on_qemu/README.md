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

[reference](https://raw.githubusercontent.com/tjeznach/docs/master/riscv-iommu/run-qemu.sh)

