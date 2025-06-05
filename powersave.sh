#!/bin/bash

# This script sets an aggressive power-saving, keeping the Bluetooth active (e.g. for connecting to the mount) and creating some zram 

powerprofilesctl set power-saver
echo 'disabled' > '/sys/class/net/enp2s0/device/power/wakeup'
echo 'disabled' > '/sys/bus/usb/devices/usb1/power/wakeup'
echo 'disabled' > '/sys/bus/usb/devices/1-8/power/wakeup'
echo 'disabled' > '/sys/bus/usb/devices/usb2/power/wakeup';
echo 'disabled' > '/sys/bus/usb/devices/1-4/power/wakeup';
echo 'auto' > '/sys/bus/i2c/devices/i2c-2/device/power/control'
echo 'auto' > '/sys/bus/i2c/devices/i2c-3/device/power/control'
echo 'auto' > '/sys/bus/i2c/devices/i2c-0/device/power/control'
echo 'auto' > '/sys/bus/i2c/devices/i2c-1/device/power/control'
#echo 'auto' > '/sys/bus/usb/devices/usb1/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:15.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:03:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:0f.0/power/control';
#echo 'auto' > '/sys/block/sda/device/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:00.1/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:14.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:02.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:0e.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.1/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:12.0/ata1/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:12.0/ata2/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:12.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:13.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:02:00.0/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:00:13.2/power/control';
echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'i
echo '0' > '/proc/sys/kernel/nmi_watchdog'

modprobe zram
zramctl /dev/zram0 --algorithm zstd --size "$(($(grep MemTotal /proc/meminfo | tr -dc '0-9')))KiB"
mkswap -U clear /dev/zram0
swapon --discard --priority 100 /dev/zram0
sudo rfkill unblock bluetooth
sudo bluetoothctl discoverable on
