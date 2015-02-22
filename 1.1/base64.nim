proc base64_char(num: int): char =
    return case num:
        of  0..25: chr(num+ord('A'))
        of 26..51: chr(num-26+ord('a'))
        of 52..61: chr(num-52+ord('0'))
        of 62: '+'
        of 63: '/'
        else:
            chr(0)

proc base64_from_raw(raw: string): string =
    var result = ""
    for i in countup(0, len(raw)-1, 3):
        var bytes : array[0..2, range[0..255]]
        case len(raw) - i:
            of 1: bytes = [ord(raw[i]), 0, 0]
            of 2: bytes = [ord(raw[i]), ord(raw[i+1]), 0]
            else: bytes = [ord(raw[i]), ord(raw[i+1]), ord(raw[i+2])]

        var value = bytes[0] shl 16 or bytes[1] shl 8 or bytes[2]

        add(result, base64_char(value shr 18))
        add(result, base64_char(value shr 12 and 0x3f))
        if len(raw) - i >= 2:
            add(result, base64_char(value shr 6 and 0x3f))
        else:
            add(result, "=")
        if len(raw) - i >= 3:
            add(result, base64_char(value shr 0 and 0x3f))
        else:
            add(result, "=")
    return result
