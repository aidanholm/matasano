from "../1.3/single_byte_xor" import score_english, crack_single_byte_xor
from "../util/hex" import raw_from_hex
from strutils import splitLines

var file = readFile("4.txt")
var best_result = (result: "", key: ' ', score: 0.0)

for line_hex in file.splitLines:
    var line = raw_from_hex(line_hex)
    var result = crack_single_byte_xor(line)
    if result.score >= best_result.score:
        best_result = result

echo("Answer: ", best_result.result)
echo("Score : ", best_result.score)
echo("Key   : ", best_result.key)
