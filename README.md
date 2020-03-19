# rpi-initramfs-tools

As per '[Where is "rpi-initramfs-tools"?](https://www.raspberrypi.org/forums/viewtopic.php?t=241313)"'
this is a small package based on the original scripts from Debian's initramfs-tools.

## Purpose

Have the Raspberry Pi / Raspbian automatically build an initrd to use btrfs for the
root file system or automatically load netconsole to send kernel / boot logs to a
monitoring host running rsyslog with a UDP listener.
You might want to do other things.

```
# for example in /etc/initramfs-tools/modules
btrfs
netconsole netconsole=12345@192.168.0.2/eth0,514@192.168.0.254/00:16:e5:e5:b9:9d
```

## Installation

```
sudo make install
echo 'RPI_INITRD=Yes' | sudo tee -a /etc/default/raspberrypi-kernel
# optinal, keep the initrd small
echo 'MODULES=list' | sudo tee /etc/initramfs-tools/conf.d/modules-list.conf
```

## Configure the bootloader
In ```/boot/config.txt``` add the option for your kernel, e.g.

```
# with arm_64bit enabled
initramfs initrd8.img followkernel

# Pi 1, Pi Zero, and Compute Module
initramfs initrd.img followkernel

# Pi 2, Pi 3, and Compute Module 3
initramfs initrd7.img followkernel

# Pi 4 default mode (i.e. 32 bit Raspbian)
initramfs initrd7l.img followkernel
```

See https://www.raspberrypi.org/documentation/configuration/config-txt/boot.md for details.

## Where's the initrd for my other Pi?

By default only the initrd for the currently running CPU architecture will be built.
To build all variants, an environment variable needs to be set.
```
echo 'export RPI_INITRD_ALL=Yes' | sudo tee -a /etc/default/raspberrypi-kernel
```

## Limitations

The scripts expect to be called by the hooks in ```/etc/kernel``` with the new version
and the full path of the kernel file. It is expected to have "kernel" in its name.
The initrd will use this name and replace "kernel" with "initrd"

The initrd files will be kept in ```/var/lib/rpi-initramfs``` with only the most recent
one being copied to ```/boot``` similar to the behavior of ```raspberrypi-kernel```.

If the kernel gets updated without calling the hook scripts, your system may not be able
to boot anymore. This seems to happen with rpi-update unless
[Hexxeh/rpi-firmware#252](https://github.com/Hexxeh/rpi-update/issues/252)
gets implemented.
