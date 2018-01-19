#!/bin/bash

dd if=/boot/u-boot-sunxi-with-spl.bin of=/dev/mmcblk0 bs=8k seek=1 conv=notrunc status=noxfer
