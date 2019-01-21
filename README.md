# Arch Linux ARM - U-Boot bootloaders for Allwinner-based boards [64-bit]

## Supported devices

 Board | U-Boot package | WiFi package(s) | Bootlog
:-----:|:--------------:|:---------------:|:-------:|
[OrangePi Zero Plus](http://www.orangepi.org/OrangePiZeroPlus/)|`uboot-orangepi-zero`|[`rtl8189fs-dkms`](//github.com/RoEdAl/alarm-wifi-dkms/tree/master/rtl8189fs-dkms)|[here](bootlog/orangepi-zero-plus.log)
[OrangePi PC2](http://www.orangepi.org/orangepipc2/)|`uboot-orangepi-pc2`|N/A|[here](bootlog/orangepi-pc2.log)
[NanoPi Neo2](http://www.friendlyarm.com/index.php?route=product/product&product_id=180)|`uboot-nanopi-neo2`|N/A|[here](bootlog/nanopi-neo2.log)

Theese bootloaders are ready to apply additional DT overlays from [Armbian's Device Tree overlays for sunxi devices](//github.com/armbian/sunxi-DT-overlays).
See [this](//github.com/RoEdAl/alarm-sunxi-dt-overlays-aarch64) repository for more info.

## SD Card preparation

### Classic way

Replace sdX in the following instructions with the device name for the SD card as it appears on your computer.

1. Zero the beginning of the SD card:
   ```
   dd if=/dev/zero of=/dev/sdX bs=1M count=8
   ```
1. Start fdisk to partition the SD card:
   ```
   fdisk /dev/sdX
   ```
1. At the fdisk prompt, create the new partition:
   - Type **o**. This will clear out any partitions on the drive.
   - Type **p** to list partitions. There should be no partitions left.
   - Type **n**, then **p** for primary, **1** for the first partition on the drive, **4096** for the first sector,
     and then press **ENTER** to accept the default last sector.
   - Write the partition table and exit by typing **w**.
1. Create the ext4 filesystem:
   ```
   mkfs.ext4 /dev/sdX1
   ```
1. Mount the filesystem:
   ```
   mkdir root
   mount /dev/sdX1 root
   ```
1. Download and extract the root filesystem:
   ```
   wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
   bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C root
   ```
1. Download appropriate U-Boot package from [releases](//github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases):
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases/download/vyyy.mm-r/uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz
   ```
1. Extract required U-Boot binary and compiled script from package:
   ```
   bsdtar -xf uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz boot/u-boot-sunxi-with-spl.bin boot/boot.scr
   ```
1. Install the U-Boot bootloader:
   ```
   dd if=boot/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=8k seek=1
   cp boot/boot.scr root/boot
   sync
   ```
1. Umount the partition:
   ```
   umount root   
   ```
1. Insert the micro SD card into the board, connect ethernet, and apply 5V power.
1. Use the serial console or SSH to the IP address given to the board by your router.
   - Login as the default user *alarm* with the password *alarm*.
   - The default *root* password is *root*.
1. After logging into the system initialize the pacman keyring and populate the Arch Linux ARM [package signing](//archlinuxarm.org/about/package-signing) keys:
   ```
   pacman-key --init
   pacman-key --populate archlinuxarm
   ```
1. Install *U-Boot* package:
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases/download/vx-y/uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz
   pacman -U uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz
    ```

### Separate boot (ext4) and root (f2fs) partitions

Replace sdX in the following instructions with the device name for the SD card as it appears on your computer.

1. Zero the beginning of the SD card:
   ```
   dd if=/dev/zero of=/dev/sdX bs=1M count=8
   ```
1. Start fdisk to partition the SD card:
   ```
   fdisk /dev/sdX
   ```
1. At the fdisk prompt, create the new partition:
   - Type **o**. This will clear out any partitions on the drive.
   - Type **p** to list partitions. There should be no partitions left.
   - Type **n**, then **p** for primary, **1** for the first partition on the drive, **4096** for the first sector,
     and then type **+256M** for the last sector.
   - Type **n**, then **p** for primary, **2** for the second partition on the drive, **528384** for the first sector, and then press **ENTER** to accept the default last sector.
   - Write the partition table and exit by typing **w**.
1. Create the boot filesystem:
   ```
   mkfs.ext4 /dev/sdX1
   ```
1. Mount the filesystem:
   ```
   mkdir boot
   mount /dev/sdX1 boot
   ```
1. Create the root filesystem:
   ```
   mkfs.f2fs /dev/sdX2
   ```
1. Mount the filesystem:
   ```
   mkdir root
   mount /dev/sdX2 root
   ```
1. Download and extract the root filesystem:
   ```
   wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
   bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C root
   ```
1. Move boot files to the first partition
   ```
   mv root/boot/* boot
   ```
1. Download appropriate U-Boot package from [releases](//github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases):
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases/download/vyyy.mm-r/uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz
   ```
1. Extract required U-Boot binary and compiled script from package:
   ```
   bsdtar -xf uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz boot/u-boot-sunxi-with-spl.bin boot/boot.scr
   ```
1. Install the U-Boot bootloader:
   ```
   dd if=boot/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=8k seek=1
   sync
   rm boot/u-boot-sunxi-with-spl.bin
   ```
1. Inform bootloader that root filestystem is on second partition:
   ```
   touch boot/root-is-on-2nd-partition
   ```
1. Add `fstab` entry to mount boot partition:
   ```
   echo '/dev/mmcblk0p1 /boot ext4 defaults 0 2' >> root/etc/fstab
   ```
1. Optionally configure *systemd-journald* service to store log data only in memory:
   ```
   mkdir -p root/usr/lib/systemd/journald.conf.d
   echo '[Journal]' > root/usr/lib/systemd/journald.conf.d/storage-volatile.conf
   echo 'Storage=volatile' >> root/usr/lib/systemd/journald.conf.d/storage-volatile.conf
   ```
1. Umount the partitions:
   ```
   umount root boot  
   ```
1. Insert the micro SD card into the board, connect ethernet, and apply 5V power.
1. Use the serial console or SSH to the IP address given to the board by your router.
   - Login as the default user *alarm* with the password *alarm*.
   - The default *root* password is *root*.
1. After logging into the system initialize the pacman keyring and populate the Arch Linux ARM [package signing](//archlinuxarm.org/about/package-signing) keys:
   ```
   pacman-key --init
   pacman-key --populate archlinuxarm
   ```
1. Install *U-Boot* package:
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases/download/vx-y/uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz
   pacman -U uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz
   ```
1. Install `f2fs-tools` package and rebuild *initcpio*:
   ```
   pacman -Syu f2fs-tools
   mkinitcpio -p linux-aarch64
   ```

## Build issues

* `uboot-*` packages: Due to `git-apply` behaviour packages you must build `uboot-*` packages  **outside** a git repository.
  Specify **BUILDDIR** in [`~/.makepkg.conf`](http://www.archlinux.org/pacman/makepkg.conf.5.html) file.
* `uboot-orangepi-pc2` package: ~~HDMI port is not initialized - no HDMI output~~ HDMI initialization was added in kernel 4.17.
