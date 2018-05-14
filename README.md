# Arch Linux ARM - U-Boot Bootloaders for Allwinner H5 based boards

## Supported devices

* [OrangePi Zero Plus](http://www.orangepi.org/OrangePiZeroPlus/) - `uboot-orangepi-zero` (requires additional DTB from `orangepi-dtbs`)
* [OrangePi PC2](http://www.orangepi.org/orangepipc2/) - `uboot-orangepi-pc2` (optionally uses tweaked DTB from `orangepi-dtbs`)
* [NanoPi Neo2](http://www.friendlyarm.com/index.php?route=product/product&product_id=180) - `uboot-nanopi-neo2` (optionally uses tweaked DTB from `nanopi-dtbs`)

Theese bootloaders are ready to apply additional DT overlays from [Armbian's Device Tree overlays for sunxi devices](//github.com/armbian/sunxi-DT-overlays).
See [this](//github.com/RoEdAl/alarm-sunxi-dt-overlays-aarch64) repository for more info.

## SD Card preparation

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
1. Download appropriate DTBS package  from [releases](//github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases) (*OrangePi Zero Plus* only):
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases/download/vx-y/orangepi-dtbs-x.yy-r-aarch64.pkg.tar.xz
   ```
1. Extract and install DTB (*OrangePi Zero Plus* only):
   ```
   bsdtar -xf orangepi-dtbs-x.yy-r-aarch64.pkg.tar.xz boot/dtbs-extra/allwinner/sun50i-h5-orangepi-zero-plus.dtb
   mv boot/dtbs-extra root/boot
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
1. After logging into the system install U-Boot and DTBS packages:
   ```
   pacman -U pacman -U https://github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases/download/vx-y/uboot-<your board name>-yyyy.mm-r-aarch64.pkg.tar.xz https://github.com/RoEdAl/alarm-uboot-sunxi-aarch64/releases/download/vx-y/<brand-name>-dtbs-x.yy-r-aarch64.pkg.tar.xz
   ```
## Build issues

* `uboot-*` packages: Due to `git-apply` behaviour packages you must build `uboot-*` packages  **outside** a git repository.
  Specify **BUILDDIR** in [`~/.makepkg.conf`](http://www.archlinux.org/pacman/makepkg.conf.5.html) file.
* `uboot-orangepi-pc2` package: HDMI port is not initialized - no HDMI output.
