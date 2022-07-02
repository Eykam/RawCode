with open("input",'r') as file:
    pattern = file.readline()
    sequence = file.read()
    if sequence[0] == '\n':
        sequence = sequence[1:]
    if pattern[len(pattern)-1] == '\n':
        pattern = pattern[:len(pattern)-1]
    index = []
    curr = 0
    x = 0
    nl = 0
    while x < len(sequence):
        if sequence[x] == '\n':
            nl = nl +1
            x = x + 1
        elif sequence[x] == pattern[curr]:
            curr = curr + 1
            x = x + 1
            if curr == len(pattern) :
                ind = x - len(pattern)
                index.append(ind-nl)
                curr = 0
                x = ind + 1
        else:
            x = x + 1
            curr = 0

    string = ""
    for x in index:
        string = string + str(x) + " "
    string = string[:len(string)-1]
    print(string)
