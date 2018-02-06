# Arch Linux ARM - U-Boot Bootloaders for Allwinner H5 based boards

## upported devices:

* [OrangePi Zero Plus](http://www.orangepi.org/OrangePiZeroPlus/) - `uboot-orangepi-zero` (requires additional DTB from `orangepi-dtbs`)
* [NanoPi Neo2](http://www.friendlyarm.com/index.php?route=product/product&product_id=180) - `uboot-nanopi-neo` (requires additional DTB from `nanopi-dtbs`)

Theese bootloaders are ready to apply additional DT overlays from [Armbian's Device Tree overlays for sunxi devices](http://github.com/armbian/sunxi-DT-overlays).
See [this](http://github.com/RoEdAl/alarm-sunxi-dt-overlays-aarch64) repository for more info.

---

All bootloaders requires Linux kernel version *4.15.0* or above.

---

Build issues:

* U-Boot: Build fail when `dtc` package is installed.
* Due to `git-apply` behaviour packages must be built **outside** a git repository - 
  specify **BUILDIR** in [`~/.makepkg.conf`](http://www.archlinux.org/pacman/makepkg.conf.5.html) file.
