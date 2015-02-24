from "../util/hex" import raw_from_hex
from "../util/aes" import detect_aes_ecb
from strutils import splitLines

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
