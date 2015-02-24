from "../util/base64" import raw_from_base64, base64_from_raw
from "../util/aes" import aes_random_key, aes_ecb_encrypt
from "../util/ecb_cbc_oracle" import aes_ecb_cbc_oracle
from "../util/pad" import pad_pkcs7
from math import random, randomize
from times import epochTime

##############################################################################

const secret = raw_from_base64("""
Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
YnkK
""")

randomize(int(epochTime()))
var key = aes_random_key()

proc aes_ecb_bad_encrypt(buf: string): string =
    var plaintext = buf & secret
    pad_pkcs7(plaintext)
    return aes_ecb_encrypt(plaintext, key)

##############################################################################

var probe = ""
var length : int
var blocksize : int

#
# Detect cipher blocksize, in bytes
#
var l1 = 0
var l2 = 0
for i in 0..128:
    length = aes_ecb_bad_encrypt(probe).len
    probe.add('A')
    if length < aes_ecb_bad_encrypt(probe).len:
        if l1 == 0:
            l1 = length
        elif l2 == 0:
            l2 = length
        else:
            blocksize = l2 - l1
            break

#
# Detect length of secret, in bytes
#
probe = ""
for i in 0..blocksize-1:
    length = aes_ecb_bad_encrypt(probe).len
    probe.add('A')
    if length < aes_ecb_bad_encrypt(probe).len:
        length -= i
        break

echo("Blocksize: ", blocksize)
echo("Length   : ", length)
case aes_ecb_cbc_oracle(aes_ecb_bad_encrypt):
    of "ECB":
        echo("ECB detected")
    of "CBC":
        echo("CBC detected")
    else: discard

#
# Break ECB (the fun bit)
#
var pt = ""
while pt.len < length:
    if pt.len mod 8 == 0:
        echo(int((pt.len+1)/length*100), "% done")

    probe = ""
    var pad_len = (blocksize - pt.len mod blocksize - 1) mod blocksize
    for i in 1 .. pad_len:
        probe.add('A')

    var blk_offset = (pt.len div blocksize)*blocksize
    var cipher_blk = aes_ecb_bad_encrypt(probe)[blk_offset .. blk_offset + blocksize - 1]

    probe.add(pt)
    probe.add('?')
    for byte in 0 .. 255:
        probe[probe.len-1] = chr(byte)
        if cipher_blk == aes_ecb_bad_encrypt(probe)[blk_offset .. blk_offset + blocksize - 1]:
            pt.add(chr(byte))
            break
echo(pt)
