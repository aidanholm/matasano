from "../util/hex" import raw_from_hex, hex_from_raw

proc buffer_xor(buf_a: string, buf_b: string): string =
    var result = ""
    if len(buf_a) != len(buf_b):
        return nil
    for i in countup(0, len(buf_a)-1):
        add(result, chr(ord(buf_a[i]) xor ord(buf_b[i])))
    return result

var line_a = raw_from_hex(readLine(stdin))
var line_b = raw_from_hex(readLine(stdin))

if line_a == nil or line_b == nil:
    stderr.writeln("Error: input is not hexadecimal")
elif len(line_a) != len(line_b):
    stderr.writeln("Error: input has differing lengths")
else:
    echo(hex_from_raw(buffer_xor(line_a, line_b)))
