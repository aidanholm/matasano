proc pad_pkcs7 *(buf: var string) =
    var padding_size = (16 - buf.len mod 16) mod 16
    for i in 0 .. padding_size-1:
        buf.add(chr(padding_size))
