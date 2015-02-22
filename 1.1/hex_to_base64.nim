include hex, base64

var raw = raw_from_hex(readLine(stdin))
if raw != nil:
    echo(base64_from_raw(raw))
else:
    stderr.writeln("Input is not hexadecimal")
