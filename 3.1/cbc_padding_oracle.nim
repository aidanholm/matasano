from ../util/base64 import raw_from_base64
from ../util/aes import aes_random_key, aes_cbc_encrypt, aes_cbc_decrypt
from ../util/pad import pad_pkcs7, unpad_pkcs7
from math import random
from strutils import find, replace, repeatChar

var key = aes_random_key()
var iv  = aes_random_key()
const secrets = [
    "MDAwMDAwTm93IHRoYXQgdGhlIHBhcnR5IGlzIGp1bXBpbmc=",
    "MDAwMDAxV2l0aCB0aGUgYmFzcyBraWNrZWQgaW4gYW5kIHRoZSBWZWdhJ3MgYXJlIHB1bXBpbic=",
    "MDAwMDAyUXVpY2sgdG8gdGhlIHBvaW50LCB0byB0aGUgcG9pbnQsIG5vIGZha2luZw==",
    "MDAwMDAzQ29va2luZyBNQydzIGxpa2UgYSBwb3VuZCBvZiBiYWNvbg==",
    "MDAwMDA0QnVybmluZyAnZW0sIGlmIHlvdSBhaW4ndCBxdWljayBhbmQgbmltYmxl",
    "MDAwMDA1SSBnbyBjcmF6eSB3aGVuIEkgaGVhciBhIGN5bWJhbA==",
    "MDAwMDA2QW5kIGEgaGlnaCBoYXQgd2l0aCBhIHNvdXBlZCB1cCB0ZW1wbw==",
    "MDAwMDA3SSdtIG9uIGEgcm9sbCwgaXQncyB0aW1lIHRvIGdvIHNvbG8=",
    "MDAwMDA4b2xsaW4nIGluIG15IGZpdmUgcG9pbnQgb2g=",
    "MDAwMDA5aXRoIG15IHJhZy10b3AgZG93biBzbyBteSBoYWlyIGNhbiBibG93"
]

proc get_ciphertext(num: int): string =
    var pt = raw_from_base64(secrets[num])
    pad_pkcs7(pt)
    return aes_cbc_encrypt(pt, key, iv)

proc padding_oracle(iv:string, ct: string): bool =
    var pt = aes_cbc_decrypt(ct, key, iv)
    return unpad_pkcs7(pt)

proc break_cbc(iv: string, ct: string, oracle: proc (iv: string, ct: string):bool): string =
    var pt = newString(ct.len)
    for bi in countup(0, ct.len - 1, 16): # For each block...
        for j in countdown(15, 0): # For each byte, LSB to MSB...
            for i in 0 .. 255: # For each possible value...
                var blk = if bi == 0: iv else: ct[bi-16 .. bi-1]
                blk[j] = chr(ord(blk[j]) xor 16-j xor i)
                for x in j+1 .. 15:
                    blk[x] = chr(ord(blk[x]) xor 16-j xor ord(pt[bi + x]))
                if oracle(blk, ct[bi .. bi+15]):
                    pt[bi + j] = chr(i)
    if not unpad_pkcs7(pt):
        return nil
    return pt


for secret in 0 .. secrets.len-1:
    var ct = get_ciphertext(secret)
    var pt = break_cbc(iv, ct, padding_oracle)
    echo(pt)
    echo(pt == raw_from_base64(secrets[secret]))
