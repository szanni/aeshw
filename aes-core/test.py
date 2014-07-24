
import mmap
from binascii import hexlify, unhexlify
import struct

"""
Expected output of the program, no errors :)
============================================

Expecting DIN 4x 32-bit registers at:  0x43c30000
Expecting DOUT 4x 32-bit registers at: 0x43c30010
Expecting 32-bit control register at:  0x43c30020
Expecting 32-bit status register at:   0x43c30024

Setting key:        000102030405060708090a0b0c0d0e0f
Status register:    1

Encryption input:   00112233445566778899aabbccddeeff
Expected output:    69c4e0d86a7b0430d8cdb78070b4c55a
Actual output:      69c4e0d86a7b0430d8cdb78070b4c55a
Status register:    1
Chained encrypt and decrypt works!

Decryption input:   69c4e0d86a7b0430d8cdb78070b4c55a
Expected output:    00112233445566778899aabbccddeeff
Actual output:      00112233445566778899aabbccddeeff
Status register:    1
Chained decrypt and encrypt works!
"""

AES_CORE_ADDR = 0x43c30000
OFFSET_DIN  = 0x00 # 16 bytes
OFFSET_DOUT = 0x10 # 16 bytes
OFFSET_CTL  = 0x20 # 4 bytes
OFFSET_STAT = 0x24 # 4 bytes

PLAINTEXT =  "\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99\xaa\xbb\xcc\xdd\xee\xff"
KEY =        "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
CIPHERTEXT = "\x69\xc4\xe0\xd8\x6a\x7b\x04\x30\xd8\xcd\xb7\x80\x70\xb4\xc5\x5a"

CTL_ENCRYPT = "\x00\x00\x00\x00"
CTL_DECRYPT = "\x01\x01\x01\x01"
CTL_SETKEY  = "\x02\x02\x02\x02"

with open("/dev/mem", "r+b") as f:
    mm = mmap.mmap(f.fileno(), 40, offset=AES_CORE_ADDR)
    
    def din_write(value):
        # What it is supposed to be
        #mm[OFFSET_DIN:OFFSET_DIN+16] = value
        
        # What it is, seems like endianness problem
        mm[OFFSET_DIN:OFFSET_DIN+16] = \
            "".join(reversed(value[0:4])) + \
            "".join(reversed(value[4:8])) + \
            "".join(reversed(value[8:12])) + \
            "".join(reversed(value[12:16]))
        
    def dout_read():
        # What it's supposed to be:       
        #return mm[OFFSET_DOUT:OFFSET_DOUT+16]

        # What actually works
        return "".join(reversed(mm[OFFSET_DOUT:OFFSET_DOUT+4])) + \
        "".join(reversed(mm[OFFSET_DOUT+4:OFFSET_DOUT+8])) + \
        "".join(reversed(mm[OFFSET_DOUT+8:OFFSET_DOUT+12])) + \
        "".join(reversed(mm[OFFSET_DOUT+12:OFFSET_DOUT+16]))

    def setctl(value):
        mm[OFFSET_CTL:OFFSET_CTL+4] = value
        
    def getstat():
        j, = struct.unpack("L", mm[OFFSET_STAT:OFFSET_STAT+4])
        return j
        
    def setkey(key):
        din_write(key)
        setctl(CTL_SETKEY)
        
    def encrypt(plaintext):
        din_write(plaintext)
        setctl(CTL_ENCRYPT)
        return dout_read()

    def decrypt(ciphertext):
        din_write(ciphertext)
        setctl(CTL_DECRYPT)
        return dout_read()    
        
    print "Expecting DIN 4x 32-bit registers at:  0x%08x" % (AES_CORE_ADDR + OFFSET_DIN)
    print "Expecting DOUT 4x 32-bit registers at: 0x%08x" % (AES_CORE_ADDR + OFFSET_DOUT)
    print "Expecting 32-bit control register at:  0x%08x" % (AES_CORE_ADDR + OFFSET_CTL)
    print "Expecting 32-bit status register at:   0x%08x" % (AES_CORE_ADDR + OFFSET_STAT)
    print

    print "Setting key:       ", hexlify(KEY)
    setkey(KEY)
    test_status = getstat()
    print "Status register:   ", test_status
    if test_status != 1:
        print "ERROR: Expected status register to be 1, got %d" % test_status
        
    print
    
    print "Encryption input:  ", hexlify(PLAINTEXT)
    print "Expected output:   ", hexlify(CIPHERTEXT)
    
    test_ciphertext = encrypt(PLAINTEXT)
    if test_ciphertext != CIPHERTEXT:
        print "ERROR: Was expecting %s, got %s" % (hexlify(CIPHERTEXT), hexlify(test_ciphertext))
    
    test_status = getstat()
    if test_status != 1:
        print "ERROR: Expected status register to be 1, got %d" % test_status
    
    print "Actual output:     ", hexlify(test_ciphertext)
    print "Status register:   ", test_status
    
    test_plaintext = decrypt(test_ciphertext)
    if test_plaintext == PLAINTEXT:
        print "Chained encrypt and decrypt works!"
    else:
        print "ERROR: Chained encrypt and decrypt does not work, something seriously broken!"

    print
    print "Decryption input:  ", hexlify(CIPHERTEXT)
    print "Expected output:   ", hexlify(PLAINTEXT)
    test_plaintext = decrypt(CIPHERTEXT)
    if test_plaintext != PLAINTEXT:
        print "ERROR: Was expecting  %s, got %s" % (hexlify(PLAINTEXT), hexlify(test_plaintext))
    test_status = getstat()
    if test_status != 1:
        print "ERROR: Expected status register to be 1, got %d" % test_status

    print "Actual output:     ", hexlify(test_plaintext)
    print "Status register:   ", test_status
    test_ciphertext = encrypt(test_plaintext)
    
    if test_ciphertext != CIPHERTEXT:
        print "ERROR: Chained decrypt and encrypt does not work, something seriously broken!"
    else:
        print "Chained decrypt and encrypt works!"

    
    mm.close()
