from "../util/base64" import raw_from_base64, base64_from_raw
from "../util/aes" import aes_random_key, aes_ecb_encrypt
from "../util/ecb_cbc_oracle" import aes_ecb_cbc_oracle
from "../util/pad" import pad_pkcs7
from strutils import repeatChar
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
    var prefix_len = 1+random(16)
    var plaintext = newString(prefix_len)
    for i in 0..prefix_len-1:
        plaintext[i] = chr(random(256))
    plaintext &= buf & secret
    pad_pkcs7(plaintext)
    return aes_ecb_encrypt(plaintext, key)

##############################################################################

proc gen_prefix_len_probe(): string =
    var probe = ""
    for i in countdown(16, 1):
        probe.add(repeatChar(32, chr(ord('A')+i)) & " ")
    return probe

proc get_prefix_len(ct: string): int =
    for prefix_len in 1..16:
        var i = 0
        while true:
            if ct[i .. i+15] == ct[i+16 .. i+31]:
                return 16-(i div 32)
            i += 16

const lp = gen_prefix_len_probe()

var probe = ""
var length : int
var blocksize : int

#
# Detect cipher blocksize, in bytes
#
const bs_probe = repeatChar(47, 'A')
var ct = aes_ecb_bad_encrypt(bs_probe)
if ct[16 .. 31] == ct[32 .. 47]:
    blocksize = 16
else:
    echo("Blocksize is not 16 bytes")

#
# Detect length of secret, in bytes
#
for i in 0..blocksize-1:
    probe = lp
    probe.add(repeatChar(i, 'A'))
    var ct1 : string
    while true:
        ct1 = aes_ecb_bad_encrypt(probe)
        if get_prefix_len(ct1) == 16:
            break

    probe.add('A')

    var ct2 : string
    while true:
        ct2 = aes_ecb_bad_encrypt(probe)
        if get_prefix_len(ct2) == 16:
            break

    if ct1.len < ct2.len:
        length = ct1.len-probe.len-15
        break

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
    echo(int((pt.len+1)/length*100), "% done")

    probe = lp
    var pad_len = (blocksize - pt.len mod blocksize - 1) mod blocksize
    for i in 1 .. pad_len:
        probe.add('A')

    var blk_offset = 16 + lp.len + (pt.len div blocksize)*blocksize
    var ct : string
    while true:
        ct = aes_ecb_bad_encrypt(probe)
        if get_prefix_len(ct) == blocksize:
            break
    var cipher_blk = ct[blk_offset .. blk_offset + blocksize - 1]

    probe.add(pt)
    probe.add('?')
    for byte in 0 .. 255:
        probe[probe.len-1] = chr(byte)
        while true:
            ct = aes_ecb_bad_encrypt(probe)
            if get_prefix_len(ct) == blocksize:
                break
        if cipher_blk == ct[blk_offset .. blk_offset + blocksize - 1]:
            pt.add(chr(byte))
            break
echo(pt)
