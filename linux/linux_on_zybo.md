Introduction
============

The following tutorial will describe how to install ArchLinux (or any other
Linux distribution) on the ZYBO development board.

Here an overview of the files and topics that will be touched:

* bootfs
  * boot.bin
    * fsbl.elf
    * system.bit
    * u-boot.elf
  * uImage
  * uramdisk.image.gz
    * ramdisk.image.gz
  * devicetree.dtb
* rootfs


Setup
=====

The setup assumes you have installed the *Vivado Design Suite 2013.4* and are
running a Linux system. Run this set of commands to set up the development
environment:

    bash
    source /opt/Xilinx/Vivado/2013.4/settings64.sh
    export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
    export ARCH=arm


Building U-Boot
===============

    git clone https://github.com/Digilent/u-boot-Digilent-Dev u-boot-digilent-dev
    cd u-boot-digilent-dev
    make zynq_zybo_config
    make
    cp u-boot ../u-boot.elf
    cd ..


Building the Linux Kernel
=========================

    git clone https://github.com/Digilent/linux-Digilent-Dev linux-digilent-dev
    cd linux-digilent-dev
    git checkout 7ad8e6023d969336961312ef751228cbb8874752
    make mrproper
    make xilinx_zynq_defconfig
    make menuconfig #for archlinux enable: `open by fhandle syscalls' and `Control Group Support'
    make UIMAGE_LOADADDR=0x8000 uImage modules
    cp arch/arm/boot/uImage ../
    cd ..


Building Bitstream
==================

    curl -O http://www.digilentinc.com/Data/Products/ZYBO/zybo_base_system.zip
    unzip zybo_base_system.zip
    vivado zybo_base_system/source/vivado/hw/zybo_bsd/zybo_bsd.xpr

Export Bitstream.


Building First Stage Bootloader
===============================

<!--
xsdk -wait -script my_SDKproj.xml -workspace `pwd`
xsdk -wait -eclipseargs -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -build all -data `pwd` -vmargs -Dorg.eclipse.cdt.core.console=org.eclipse.cdt.core.systemConsole
-->


Create .dts file
================

<!--
Navigate to the SDK_Export folder
git clone git://github.com/Xilinx/device-tree.git bsp/device-tree
cd bsp/device-tree
git checkout xilinx-v2013.4
cd ../../

cp project1_fsbl_bsp/system.mss .

Edit the OS section so that it looks like this:

BEGIN OS
 PARAMETER OS_NAME = device-tree
  PARAMETER PROC_INSTANCE = ps7_cortexa9_0
END

libgen -hw hw_platform_0/system.xml -lp device-tree -pe ps7_cortexa9_0 -log libgen.log system.mss
-->


Create .dtb file
================

    cp zybo_base_system/source/vivado/SDK/bootgen/system_wrapper.bit .

<!--
linux-digilent-dev/scripts/dtc/dtc -I dts -O dtb -o devicetree.dtb ps7_cortexa9_0/libsrc/device-tree/xilinx.dts
-->


Create boot.bif
===============

Create a file named `boot.bif` with the flollowing contents:

    image :
    {
    	[bootloader]fsbl.elf
    	system_wrapper.bit
    	u-boot.elf
    }


Create boot.bin
===============

    bootgen -w -image boot.bif -o i boot.bin


Partition
=========

    fdisk /dev/mmcblk0

    mkfs.vfat -n "bootfs" -F 32 /dev/mmcblk0p1
    mkfs.ext4 -L "rootfs" /dev/mmcblk0p2

    tar -xf ArchLinuxARM-zedboard-latest.tar.gz -C /media/rootfs
    cp boot.bin uImage devicetree.dtb uramdisk.image.gz /media/bootfs


Reset QSPI flash
================

Reset old u-boot configs: connect to device via serial port, press any key during startup
to drop into the u-boot shell, run:

    env default -a
    saveenv

