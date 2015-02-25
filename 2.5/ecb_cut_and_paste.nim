from ../util/aes import aes_random_key, aes_ecb_encrypt, aes_ecb_decrypt
from ../util/pad import pad_pkcs7
from strutils import strip, split, replace, repeatChar
import tables

var key = aes_random_key()

proc profile_from_encrypted_string(ct: string): Table[string, string] =
    var profile = initTable[string, string]()
    var pt = aes_ecb_decrypt(ct, key)
    for pair in pt.strip().split('&'):
        var sep_i = pair.find('=')
        var key = pair[0 .. sep_i-1]
        var val = pair[sep_i+1 .. pair.len-1].replace("=", "")
        profile[key] = val
    return profile

proc profile_string_from_email(email: string): string =
    return "email=" & email & "&uid=10&role=user"

proc profile_for(email: string): string =
    var pt = profile_string_from_email(email)
    pad_pkcs7(pt)
    return aes_ecb_encrypt(pt, key)

const target_email = "account_address@gmail.com"

# Pad email so that "user<pad>" is sticking off the end
const base_len = ("email=" & target_email & "&uid=10&role=").len
var pad_len = (16 - base_len mod 16) mod 16
var email = target_email[0 .. target_email.find('@')-1] & "+" & repeatChar(pad_len-1, 'A') & target_email[target_email.find('@') .. target_email.len-1]

# Generate a block with "admin<pad>"
const attack_email = "..........admin           "
var blk = profile_for(attack_email)[16 .. 31]

# Replace the block, and produce the profile
var ct = profile_for(email)
ct = ct[0 .. ct.len-16-1] & blk
echo(profile_from_encrypted_string(ct))
