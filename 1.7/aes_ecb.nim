from "../util/base64" import raw_from_base64
from "../util/aes" import aes_ecb_decrypt

var file = raw_from_base64(readFile("7.txt"))
var result = aes_ecb_decrypt(file, "YELLOW SUBMARINE")
echo("Plaintext: ", result)
