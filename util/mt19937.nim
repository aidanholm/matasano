var state : array[0..623, int]
var i = 0

proc mt19937_init *(seed: int) =
    state[0] = seed
    i = 0
    for i in 1..state.len-1:
        state[i] = 0xffffffff and (0x6c078965 * (state[i-1] xor (state[i-1] shr 30)) + 1)

proc mt19937_generate() =
    for i in 0..state.len-1:
        var y = (state[i] and 0x80000000) + (state[(i+1) mod state.len] and 0x7fffffff)
        state[i] = state[(i+397) mod state.len] xor (y shr 1)
        if y mod 2 != 0:
            state[i] = state[i] xor 0x9908b0df

proc mt19937_rand *(): int =
    if i == 0:
        mt19937_generate()

    var y = state[i]
    y = y xor (y shr 11)
    y = y xor ((y shl 7) and 0x9d2c5680)
    y = y xor ((y shl 14) and 0xefc60000)
    y = y xor (y shr 18)

    i = (i+1) mod state.len

    return y
