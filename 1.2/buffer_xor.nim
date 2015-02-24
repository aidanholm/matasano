from "../util/hex" import raw_from_hex, hex_from_raw
from "../util/buffer" import buffer_xor

var line_a = raw_from_hex(readLine(stdin))
var line_b = raw_from_hex(readLine(stdin))

if line_a == nil or line_b == nil:
    stderr.writeln("Error: input is not hexadecimal")
elif len(line_a) != len(line_b):
    stderr.writeln("Error: input has differing lengths")
else:
    echo(hex_from_raw(buffer_xor(line_a, line_b)))
