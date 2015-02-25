from ../util/aes import aes_random_key, aes_cbc_encrypt, aes_cbc_decrypt
from ../util/pad import pad_pkcs7
from strutils import find, replace, repeatChar

var key = aes_random_key()
var iv  = aes_random_key()

proc encrypt_string(userdata: string): string =
    var pt = "comment1=cooking%20MCs;userdata="
    pt &= userdata.replace("=","%3d").replace(";", "%3b")
    pt &= ";comment2=%20like%20a%20pound%20of%20bacon"
    pad_pkcs7(pt)
    return aes_cbc_encrypt(pt, key, iv)

proc string_is_admin(ct: string): bool =
    return aes_cbc_decrypt(ct, key, iv).find(";admin=true;") != -1

const pad_len = (16 - len("comment1=cooking%20MCs;userdata=") mod 16) mod 16
const userdata = repeatChar(pad_len, '.') & "corrupt this blk" & "12345+admin-true"
var ct = encrypt_string(userdata)
const plus_i = len("comment1=cooking%20MCs;userdata=") - 16 + userdata.find('+')
const dash_i = len("comment1=cooking%20MCs;userdata=") - 16 + userdata.find('-')
ct[plus_i] = chr(ord(ct[plus_i]) xor 0x10)
ct[dash_i] = chr(ord(ct[dash_i]) xor 0x10)

echo("Admin: ", string_is_admin(ct))
