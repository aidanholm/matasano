proc buffer_xor *(buf_a: string, buf_b: string): string =
    var result = ""
    if len(buf_a) != len(buf_b):
        return nil
    for i in countup(0, len(buf_a)-1):
        add(result, chr(ord(buf_a[i]) xor ord(buf_b[i])))
    return result
