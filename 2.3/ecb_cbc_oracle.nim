from "../util/aes" import aes_random_key, aes_ecb_encrypt, aes_cbc_encrypt, detect_aes_ecb
from math import random, randomize
from times import epochTime

proc aes_random_encrypt(buf: string): tuple[result: string, mode: string] =
    var pt = ""
    var pp = random(10)
    for i in 0 .. pp:
        pt.add(chr(random(256)))
    pt.add(buf)
    for i in 0 .. 4+random(6):
        pt.add(chr(random(256)))
    while pt.len mod 16 != 0:
        pt.add(chr(random(256)))

    if random(2) == 0:
        return (result: aes_ecb_encrypt(pt, aes_random_key()), mode: "ECB")
    else:
        return (result: aes_cbc_encrypt(pt, aes_random_key(), aes_random_key()), mode: "CBC")

proc gen_oracle_buf(): string =
    var result = ""
    for i in countdown(10, 1):
        for j in 0 .. 16 - i - 1:
            result.add(" ")
        result.add("YELLOW SUBMARINE")
        result.add("YELLOW SUBMARINE")
        result.add(" ")
    return result

proc aes_ecb_cbc_oracle *(encrypter: proc(buf: string):string): string =
    const buf = gen_oracle_buf()
    var ciphertext = encrypter(buf)
    return if detect_aes_ecb(ciphertext) != 0.0: "ECB" else: "CBC"

randomize(int(epochTime()))

echo("Testing...")
var num_correct = 0

for i in 1..100:
    if i mod 10 == 0:
        echo(i , "% done")
    var mode : string
    var answer = aes_ecb_cbc_oracle(proc (x: string): string =
        var res = aes_random_encrypt(x)
        mode = res.mode
        return res.result
    )
    if mode == answer:
        num_correct += 1

echo("Accuracy: ", num_correct, "% (", num_correct, "/100)")

