from algorithm import sort
from buffer import buffer_xor
from math import random

proc aes_sbox(byte: char): char =
    var sbox = [
        0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
        0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
        0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
        0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
        0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
        0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
        0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
        0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
        0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
        0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
        0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
        0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
        0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
        0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
        0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
        0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
    ]
    return chr(sbox[ord(byte)])

proc aes_inv_sbox(byte: char): char =
    var sbox = [
        0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
        0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
        0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
        0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
        0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
        0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
        0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
        0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
        0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
        0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
        0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
        0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
        0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
        0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
        0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
        0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D
    ]
    return chr(sbox[ord(byte)])

proc aes_sub_bytes(blk: var string) =
    for i in 0..15:
        blk[i] = aes_sbox(blk[i])

proc aes_inv_sub_bytes(blk: var string) =
    for i in 0..15:
        blk[i] = aes_inv_sbox(blk[i])

proc aes_shift_row(blk: var string) =
    var tmp = blk[1]
    blk[1]  = blk[5]
    blk[5]  = blk[9]
    blk[9]  = blk[13]
    blk[13] = tmp

    tmp     = blk[2]
    blk[2]  = blk[10]
    blk[10] = tmp
    tmp     = blk[6]
    blk[6]  = blk[14]
    blk[14] = tmp

    tmp     = blk[3]
    blk[3]  = blk[15]
    blk[15] = blk[11]
    blk[11] = blk[7]
    blk[7]  = tmp

proc aes_inv_shift_row(blk: var string) =
    var tmp = blk[1]
    blk[1]  = blk[13]
    blk[13] = blk[9]
    blk[9]  = blk[5]
    blk[5]  = tmp

    tmp     = blk[2]
    blk[2]  = blk[10]
    blk[10] = tmp
    tmp     = blk[6]
    blk[6]  = blk[14]
    blk[14] = tmp

    tmp     = blk[7]
    blk[7]  = blk[11]
    blk[11] = blk[15]
    blk[15] = blk[3]
    blk[3]  = tmp

proc aes_add_round_key(blk: var string, key: string) =
    for i in 0..15:
        blk[i] = chr(ord(blk[i]) xor ord(key[i]))

proc aes_rotate_column(key: var string): string =
    var i = key.len()
    assert(i mod 16 == 0 and i > 0)
    var result = "1234"
    result[0] = key[i-3]
    result[1] = key[i-2]
    result[2] = key[i-1]
    result[3] = key[i-4]
    return result

proc aes_galois_multiply(x, y: int): int =
    var p = 0
    var a = x
    var b = y
    assert(a >= 0 and a <= 0xff)
    assert(b >= 0 and b <= 0xff)
    for i in 0..7:
        if (b and 0x01) != 0:
            p = p xor a
        var a_high = (a and 0x80) != 0
        a = a shl 1 and 0xff
        if a_high:
            a = a xor 0x1b
        b = b shr 1
    assert(p >= 0 and p <= 0xff)
    return p

proc aes_galois_mat_multiply(blk: var string, mat: array[0..15, int]) =
    assert(blk.len() == 16)
    var new_block: array[0..15, int]
    for x in 0..3:
        for y in 0..3:
            new_block[x*4+y] = 0
            for z in 0..3:
                var gp = aes_galois_multiply(ord(blk[x*4+z]), mat[z*4+y])
                new_block[x*4+y] = new_block[x*4+y] xor gp
    for i in 0..15:
        blk[i] = chr(new_block[i])

proc aes_mix_cols(blk: var string) =
    const mat = [2,1,1,3,3,2,1,1,1,3,2,1,1,1,3,2]
    aes_galois_mat_multiply(blk, mat)

proc aes_inv_mix_cols(blk: var string) =
    const mat = [14,9,13,11,11,14,9,13,13,11,14,9,9,13,11,14]
    aes_galois_mat_multiply(blk, mat)

proc aes_encrypt_block(bk: string, keys:string): string =
    assert(bk.len() == 16)
    assert(keys.len() == 16*11)
    var blk = bk

    aes_add_round_key(blk, keys[0..15])

    for i in 1 .. 9:
        aes_sub_bytes(blk)
        aes_shift_row(blk)
        aes_mix_cols(blk)
        aes_add_round_key(blk, keys[16*i..16*i+15])

    aes_sub_bytes(blk)
    aes_shift_row(blk)
    aes_add_round_key(blk, keys[16*10..16*10+15])

    return blk

proc aes_decrypt_block(bk: string, keys:string): string =
    assert(bk.len() == 16)
    assert(keys.len() == 16*11)
    var blk = bk

    aes_add_round_key(blk, keys[16*10..16*10+15])
    aes_inv_shift_row(blk)
    aes_inv_sub_bytes(blk)

    for i in countdown(9, 1):
        aes_add_round_key(blk, keys[16*i..16*i+15])
        aes_inv_mix_cols(blk)
        aes_inv_shift_row(blk)
        aes_inv_sub_bytes(blk)

    aes_add_round_key(blk, keys[0..15])

    return blk

proc aes_expand_key(key: string): string =
    var rcon = [[0x01,0,0,0], [0x02,0,0,0], [0x04,0,0,0], [0x08,0,0,0], [0x10,0,0,0], [0x20,0,0,0], [0x40,0,0,0], [0x80,0,0,0], [0x1b,0,0,0], [0x36,0,0,0]]
    var k = key

    for n in countup(0, 9):
        var column : array[0..3, char]
        var last_col = aes_rotate_column(k)
        for i in countup(k.len()-16, k.len()-13):
            var j = i-(k.len()-16)
            column[j] = chr(ord(k[i]) xor ord(aes_sbox(last_col[j])) xor ord(rcon[n][j]))
        for ch in column:
            k.add(ch)

        for nn in countup(0, 2):
            for i in countup(k.len()-16, k.len()-13):
                var j = i-(k.len()-16)
                column[j] = chr(ord(k[i]) xor ord(k[12+i]))
            for ch in column:
                k.add(ch)
    return k

proc aes_ecb_encrypt *(plaintext: string, key: string): string =
    assert(plaintext.len() mod 16 == 0)
    assert(key.len() == 16)
    result = ""
    var keys = aes_expand_key(key)
    for i in countup(0, plaintext.len()-1, 16):
        var blk = aes_encrypt_block(plaintext[i..i+15], keys)
        result.add(blk)
    assert(plaintext.len() == result.len())
    return result

proc aes_ecb_decrypt *(ciphertext: string, key: string): string =
    assert(ciphertext.len() mod 16 == 0)
    assert(key.len() == 16)
    result = ""
    var keys = aes_expand_key(key)
    for i in countup(0, ciphertext.len()-1, 16):
        var blk = aes_decrypt_block(ciphertext[i..i+15], keys)
        result.add(blk)
    assert(ciphertext.len() == result.len())
    return result

proc aes_cbc_encrypt *(plaintext: string, key: string, iv: string): string =
    assert(plaintext.len() mod 16 == 0)
    assert(key.len() == 16)
    assert(iv.len() == 16)
    result = ""
    var keys = aes_expand_key(key)
    var prev_blk = iv
    for i in countup(0, plaintext.len()-1, 16):
        var sum = buffer_xor(plaintext[i..i+15], prev_blk)
        prev_blk = aes_encrypt_block(sum, keys)
        result.add(prev_blk)
    assert(plaintext.len() == result.len())
    return result

proc aes_cbc_decrypt *(ciphertext: string, key: string, iv: string): string =
    assert(ciphertext.len() mod 16 == 0)
    assert(key.len() == 16)
    assert(iv.len() == 16)
    result = ""
    var keys = aes_expand_key(key)
    var prev_blk = iv
    for i in countup(0, ciphertext.len()-1, 16):
        var blk = aes_decrypt_block(ciphertext[i..i+15], keys)
        var sum = buffer_xor(blk, prev_blk)
        prev_blk = ciphertext[i..i+15]
        result.add(sum)
    assert(ciphertext.len() == result.len())
    return result

from strutils import intToStr

proc aes_ctr_crypt *(buf: string, key: string, nonce: uint64): string =
    assert(key.len() == 16)
    var keys = aes_expand_key(key)
    var blk_ctr : uint64
    var result = ""
    blk_ctr = 0
    for i in countup(0, buf.len()-1, 16):
        var ctr = ""
        for ch in cast[array[0..7,char]](nonce):
            ctr.add(ch)
        assert(ctr.len == 8)
        for ch in cast[array[0..7,char]](blk_ctr):
            ctr.add(ch)
        assert(ctr.len == 16)
        var key = aes_encrypt_block(ctr, keys)
        var last_i = min(16, buf.len-i)-1
        var res = buffer_xor(buf[i..i+last_i], key[0..last_i])
        result.add(res)
        blk_ctr += 1
    return result

proc aes_random_key *(): string =
    var result = newString(16)
    for i in 0..15:
        result[i] = chr(random(256))
    return result

proc detect_aes_ecb *(buf: string): float =
    if buf.len mod 16 != 0:
        return 0.0

    var num_blocks = buf.len div 16
    var blocks = newSeq[string](num_blocks)
    for i in 0 .. num_blocks-1:
        blocks[i] = buf[i*16..i*16+15]
    blocks.sort(proc (x,y: string): int = return cmp(x, y))

    var result = 0.0
    for i in 1..num_blocks-1:
        if blocks[i] == blocks[i-1]:
            result += 1.0
    result /= float(num_blocks)

    return result
