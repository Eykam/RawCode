with open("input",'r') as file:
    sequence = file.read()
    x = 0
    count = 0
    map = {}
    ln = 0
    while x < len(sequence):
        if sequence[x] == '\n':
            ln = ln+1
            x = x+1
        else:
            if sequence[x] == 'C':
                count = count - 1

            elif sequence[x] == 'G':
                count = count + 1
            if x == 0:
                minim = count
            if count <= minim:
                minim = count
            map[x+1-ln] = count
            x = x + 1

    strng = ""
    for x in map:
        if map[x] == minim:
            strng = strng + " " +str(x)

    print(strng[1:])