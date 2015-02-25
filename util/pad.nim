proc pad_pkcs7 *(buf: var string) =
    var padding_size = 16 - buf.len mod 16
    for i in 0 .. padding_size-1:
        buf.add(chr(padding_size))

proc unpad_pkcs7 *(buf: var string): bool =
    if buf.len mod 16 != 0:
        return false
    var padding_size = ord(buf[buf.len-1])
    if padding_size > 16 or padding_size == 0:
        return false
    for i in buf.len-padding_size .. buf.len-1:
        if ord(buf[i]) != padding_size:
            return false
    buf = buf[0 .. buf.len-padding_size-1]
    return true
