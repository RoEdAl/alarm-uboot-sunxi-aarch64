# Arch Linux ARM - U-Boot Bootloaders for Allwinner H5 based boards

## Supported devices:

* [OrangePi Zero Plus](http://www.orangepi.org/OrangePiZeroPlus/) - `uboot-orangepi-zero` (requires additional DTB from `orangepi-dtbs`)
* [OrangePi PC2](http://www.orangepi.org/orangepipc2/) - `uboot-orangepi-pc2` (requires additional DTB from `orangepi-dtbs`)
* [NanoPi Neo2](http://www.friendlyarm.com/index.php?route=product/product&product_id=180) - `uboot-nanopi-neo` (requires additional DTB from `nanopi-dtbs`)

Theese bootloaders are ready to apply additional DT overlays from [Armbian's Device Tree overlays for sunxi devices](//github.com/armbian/sunxi-DT-overlays).
See [this](//github.com/RoEdAl/alarm-sunxi-dt-overlays-aarch64) repository for more info.

## Build issues:

* `uboot-*` packages: Build fails when `dtc` package is installed.
* `uboot-*` packages: Due to `git-apply` behaviour packages you must build `uboot-*` packages  **outside** a git repository.
  Specify **BUILDDIR** in [`~/.makepkg.conf`](http://www.archlinux.org/pacman/makepkg.conf.5.html) file.
* `uboot-orangepi-pc2` package: HDMI port is not initialized - no HDMI output.
