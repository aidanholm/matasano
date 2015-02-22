from "../util/hex" import raw_from_hex

proc score_english(buf: string): float =
    var score : float = 0;
    for i in countup(0, len(buf)-1):
        case buf[i]:
            of 'e': score += 0.5
            of 't': score += 0.4
            of 'a': score += 0.4
            of 'o': score += 0.35
            of 'i': score += 0.30
            of 'n': score += 0.30
            of 's': score += 0.27
            of 'h': score += 0.25
            of 'r': score += 0.20
            of 'd': score += 0.15
            of ' ': score += 1
            else:   score += 0.0
    return score/(float)len(buf)

proc buffer_xor_byte(buf_a: string, byte: char): string =
    var result = ""
    for i in countup(0, len(buf_a)-1):
        add(result, chr(ord(buf_a[i]) xor ord(byte)))
    return result

var line_a = raw_from_hex("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")

var best_score = 0.0
var second_best_score : float
var key : char
var best_result : string

for i in countup(0, 255):
    var byte = chr(i)
    var result = buffer_xor_byte(line_a, byte)
    var score = score_english(result)
    if score > best_score:
        second_best_score = best_score
        key = byte
        best_score = score
        best_result = result

echo("Answer: ", best_result)
echo("Score : ", best_score, " (runner up = ", second_best_score, ")")
echo("Key   : ", key)
