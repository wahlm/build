# DO NOT EDIT THIS FILE
#
# Please edit /boot/armbianEnv.txt to set supported parameters
#

setenv load_addr "0x6000000"
#setenv fdt_addr_r "0x4000_0000"
setenv overlay_error "false"
# default values
setenv console "serial"
setenv rootfstype "ext4"
setenv devnum "0"
setenv rootdev "/dev/vda1"
setenv earlycon "on"
setenv devtype "virtio"
setenv prefix "/boot/"
setenv bootlogo "off"
#if virtio dev ${devnum}; then devtype=virtio; run scan_dev_for_boot_part; fi 
part uuid virtio ${devnum}:1 partuuid;

echo "Boot script loaded from ${devtype}"
if test -e ${devtype} ${devnum} ${prefix}armbianEnv.txt; then
	load ${devtype} ${devnum} ${load_addr} ${prefix}armbianEnv.txt
	env import -t ${load_addr} ${filesize}
fi

if test "${console}" = "display" || test "${console}" = "both"; then setenv consoleargs "console=ttyAMA0 console=tty1"; fi
if test "${console}" = "serial"; then setenv consoleargs "console=ttyAMA0"; fi
if test "${earlycon}" = "on"; then setenv consoleargs "earlycon ${consoleargs}"; fi
if test "${bootlogo}" = "true"; then setenv consoleargs "bootsplash.bootfile=bootsplash.armbian ${consoleargs}"; fi

setenv bootargs "root=${rootdev} rw rootdelay=5 rootwait rootfstype=${rootfstype} ${consoleargs} loglevel=7 apparmor=0 nousb selinux=0 ${extraargs} ${extraboardargs}"
load ${devtype} ${devnum} ${ramdisk_addr_r} ${prefix}uInitrd
load ${devtype} ${devnum} ${kernel_addr_r} ${prefix}Image

booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr}

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr