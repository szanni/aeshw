AESHW
=====

AESHW is an attempt to provide AES hardware acceleration for the Linux kernel
and other components using the Linux Crypto API on the ZYBO development board.

It consists of 3 main components:

  * The VHDL AES core providing key expansion, encryption, and decryption for
    128-bit keys
  * The Linux kernel driver and other necessary files to run Linux on the ZYBO
    development board
  * The Xilinx Vivado project files for generating the bitstream file for the
    ZYBO development board

See the README in the respective subdirectories for more information.

License
=======

BSD 2-Clause license, see the LICENSE file for more details.

