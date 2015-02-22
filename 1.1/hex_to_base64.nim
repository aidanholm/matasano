from "../util/hex" import raw_from_hex
from "../util/base64" import base64_from_raw

var raw = raw_from_hex(readLine(stdin))
if raw != nil:
    echo(base64_from_raw(raw))
else:
    stderr.writeln("Input is not hexadecimal")
