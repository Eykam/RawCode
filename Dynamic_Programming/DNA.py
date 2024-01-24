with open("input", 'r') as file:
    sequence = file.read()
    map = {
            'A': 0,
            'C': 0,
            'G': 0,
            'T': 0
        }

    for x in sequence:
        if x == '\n':
            pass
        else:
            map[x] = map[x] + 1
    print(str(map['A'])+" "+str(map['C'])+" "+str(map['G'])+" "+str(map['T']))
