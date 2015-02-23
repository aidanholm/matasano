from "../util/base64" import raw_from_base64
from "../1.3/single_byte_xor" import score_english, crack_single_byte_xor
from "../1.5/repeating_key_xor" import buffer_xor_bytes
from algorithm import sort

proc hamming_distance *(buf_a: string, buf_b: string): int =
    var distance = 0
    if len(buf_a) != len(buf_b):
        return -1
    for i in countup(0, len(buf_a)-1):
        var ch = ord(buf_a[i]) xor ord(buf_b[i])
        for j in countup(0, 7):
            distance += 0x1 and ch shr j
    return distance

proc crack_repeating_key_xor_keysized(buf: string, keysize: int): tuple[key: string, score: float] =
    var blocks = newSeq[string](keysize)
    var result = ""
    var score = 0.0
    for i in countup(0, keysize-1):
        blocks[i] = ""
        for j in countup(i, len(buf)-1, keysize):
            add(blocks[i], buf[j])
        var sbx_result = crack_single_byte_xor(blocks[i])
        add(result, sbx_result.key) 
        score += sbx_result.score
    score /= float(keysize)
    return (key: result, score: score)

proc crack_repeating_key_xor *(buf: string): tuple[result: string, key: string, score: float] =
    var max_key_len = min(40, len(buf) div 4)
    var keysizes = newSeq[tuple[score: float, key: string]](max_key_len + 1)

    keysizes[0] = (score: 100000.0, key: "")
    keysizes[1] = (score: 100000.0, key: "")

    for keysize in countup(2, max_key_len):
        echo("Trying a keysize of ", keysize)
        var dist = 0.0
        var count = 0
        for i in countup(0, len(buf)-2*keysize, keysize):
            dist += float(hamming_distance(buf[i..i+keysize-1], buf[i+keysize.. i+2*keysize-1])) / float(keysize)
            count+=1

        var result = crack_repeating_key_xor_keysized(buf, keysize)
        keysizes[keysize] = (score: dist/float(count), key: result.key)

    keysizes.sort(proc (x,y: tuple[score: float, key: string]): int =
        cmp(x.score, y.score))

    var best_score = 0.0
    var best_key : string
    var best_plaintext: string

    for keysize in countup(0, min(2, max_key_len)):
        var key = keysizes[keysize].key
        var plaintext = buffer_xor_bytes(buf, key)
        var score = score_english(plaintext)
        if score > best_score:
            best_score = score
            best_key = keysizes[keysize].key
            best_plaintext = plaintext
    return (result: best_plaintext, key: best_key, score: best_score)

when isMainModule:
    var file = readFile("6.txt")
    var result = crack_repeating_key_xor(raw_from_base64(file))
    echo("Key      : ", result.key)
    echo("Score    : ", result.score)
    echo("Plaintext: ", result.result)
