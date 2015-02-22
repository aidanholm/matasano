from "../util/hex" import hex_from_raw

proc buffer_xor_bytes *(buf: string, key: string): string =
    var result = ""
    for i in countup(0, len(buf)-1):
        add(result, chr(ord(buf[i]) xor ord(key[i mod len(key)])))
    return result

when isMainModule:
    var input = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
    echo(hex_from_raw(buffer_xor_bytes(input, "ICE")))
