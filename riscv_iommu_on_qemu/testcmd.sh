#! /bin/bash

echo "0000:00:04.0" > /sys/bus/pci/devices/0000:00:04.0/driver/unbind
echo "1b36 0010" > /sys/bus/pci/drivers/vfio-pci/new_id


lkvm-static run -m 256 -c2 --console virtio -p "nokaslr console=ttyS0 root=/dev/nvme0n1" -k /usr/share/Image --vfio-pci 0000:00:04.0 -d /dev/nvme0n1
