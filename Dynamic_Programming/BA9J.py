orig = ""
with open("input",'r') as file:
    orig = file.readline().rstrip()

table = [""] * len(orig)
for i in range(len(orig)):
    table = sorted(orig[i] + table[i] for i in range(len(orig)))

for x in table:
    if x.find('$') == (len(orig) - 1):
        print(x)