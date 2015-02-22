proc raw_from_hex *(hex: string): string =
    var result = ""
    if len(hex) mod 2 != 0:
        return nil
    for i in countup(0, len(hex)-1, 2):
        var decimal = 0
        case hex[i]:
            of '0'..'9': decimal += ord(hex[i]) - ord('0')
            of 'a'..'f': decimal += ord(hex[i]) - ord('a') + 10
            of 'A'..'F': decimal += ord(hex[i]) - ord('A') + 10
            else: return nil
        decimal *= 16
        case hex[i+1]:
            of '0'..'9': decimal += ord(hex[i+1]) - ord('0')
            of 'a'..'f': decimal += ord(hex[i+1]) - ord('a') + 10
            of 'A'..'F': decimal += ord(hex[i+1]) - ord('A') + 10
            else: return nil
        add(result, chr(decimal))
    return result

proc hex_from_raw *(raw: string): string =
    var result = ""
    for i in countup(0, len(raw)-1):
        var chars = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']
        add(result, chars[ord(raw[i]) div 16])
        add(result, chars[ord(raw[i]) mod 16])
    return result
