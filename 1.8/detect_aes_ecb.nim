from "../util/hex" import raw_from_hex
from strutils import splitLines
from algorithm import sort

proc detect_aes_ecb *(buf: string): float =
    if buf.len mod 16 != 0:
        return 0.0

    var num_blocks = buf.len div 16
    var blocks = newSeq[string](num_blocks)
    for i in 0 .. num_blocks-1:
        blocks[i] = buf[i*16..i*16+15]
    blocks.sort(proc (x,y: string): int = return cmp(x, y))

    var result = 0.0
    for i in 1..num_blocks-1:
        if blocks[i] == blocks[i-1]:
            result += 1.0
    result /= float(num_blocks)

    return result

var file = readFile("8.txt")
var best_score = 0.0
var best_match : string

for line_hex in file.splitLines:
    var line = raw_from_hex(line_hex)
    var score = detect_aes_ecb(line)
    if score >= best_score:
        best_score = score
        best_match = line_hex

echo("Score: ", best_score)
echo("Line : ", best_match)
