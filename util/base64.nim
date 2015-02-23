proc base64_char_from_int *(num: int): char =
    return case num:
        of  0..25: chr(num+ord('A'))
        of 26..51: chr(num-26+ord('a'))
        of 52..61: chr(num-52+ord('0'))
        of 62: '+'
        of 63: '/'
        else:
            chr(0)

proc int_from_base64_char(ch: char): int =
    return case ch:
        of  'A'..'Z': ord(ch)-ord('A')
        of 'a'..'z': ord(ch)-ord('a')+26
        of '0'..'9': ord(ch)-ord('0')+52
        of '+': 62
        of '/': 63
        else:
            0

proc base64_from_raw *(raw: string): string =
    var result = ""
    for i in countup(0, len(raw)-1, 3):
        var bytes : array[0..2, range[0..255]]
        case len(raw) - i:
            of 1: bytes = [ord(raw[i]), 0, 0]
            of 2: bytes = [ord(raw[i]), ord(raw[i+1]), 0]
            else: bytes = [ord(raw[i]), ord(raw[i+1]), ord(raw[i+2])]

        var value = bytes[0] shl 16 or bytes[1] shl 8 or bytes[2]

        add(result, base64_char_from_int(value shr 18))
        add(result, base64_char_from_int(value shr 12 and 0x3f))
        if len(raw) - i >= 2:
            add(result, base64_char_from_int(value shr 6 and 0x3f))
        else:
            add(result, "=")
        if len(raw) - i >= 3:
            add(result, base64_char_from_int(value shr 0 and 0x3f))
        else:
            add(result, "=")
    return result

proc raw_from_base64 *(b64: string): string =
    var result = ""
    var i = 0
    while i < len(b64)-3:
        if b64[i] == "\n"[0] or b64[i] == "\r"[0]:
            i += 1
            continue

        var q = [int_from_base64_char(b64[i]), int_from_base64_char(b64[i+1]),
        int_from_base64_char(b64[i+2]), int_from_base64_char(b64[i+3])]
        var value = q[0] shl 18 or q[1] shl 12 or q[2] shl 6 or q[3]
        var triple = [value shr 16, value shr 8 and 0xff, value and 0xff]
        result.add(chr(triple[0]))
        result.add(chr(triple[1]))
        result.add(chr(triple[2]))
        i += 4

    return result
