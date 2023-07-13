#! /bin/bash

# make qemu for riscv
bash build_qemu_riscv.sh

# make riscv linux
bash build_linux_riscv.sh

# make kvmtool
bash build_kvmtool.sh

# make rootfs
bash mkinitrd4riscv.sh

# lanuch the riscv-linux using qemu tool
./qemu/build/qemu-system-riscv64 -cpu rv64 -M virt -m 512M -nographic -kernel ./build-riscv64/arch/riscv/boot/Image -initrd ./rootfs_kvm_riscv64.img -append "root=/dev/ram rw console=ttyS0 earlycon=sbi"
#qemu-system-riscv64 -cpu rv64 -M virt -m 512M -nographic -kernel ./riscv-linux/arch/riscv/boot/Image -initrd ./rootfs_kvm_riscv64.img -append "root=/dev/root rw console=ttyS0 earlycon=sbi"

