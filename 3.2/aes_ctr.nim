from ../util/base64 import raw_from_base64
from ../util/aes import aes_ctr_crypt

const key = "YELLOW SUBMARINE"
const ct = raw_from_base64("L77na/nrFsKvynd6HzOoG7GHTLXsTVu9qvY/2syLXzhPweyyMTJULu/6/kXX0KSvoOLSFQ==")
const nonce = 0

echo(aes_ctr_crypt(ct, key, nonce))
