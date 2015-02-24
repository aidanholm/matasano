from "../util/base64" import raw_from_base64
from "../util/aes" import aes_cbc_decrypt

var file = raw_from_base64(readFile("10.txt"))
var key = "YELLOW SUBMARINE"
var iv  = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
var pt = aes_cbc_decrypt(file, key, iv)
echo("Plaintext: ", pt)
