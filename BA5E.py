import pandas as pd

pam = pd.read_csv("PAM250.txt", delim_whitespace=True)
penalty = -5

with open("input",'r') as file:

    string1 = '-' + file.readline().rstrip('\n')
    string2 = '-' + file.readline().rstrip('\n')

    string1 = [x for x in string1]
    string2 = [x for x in string2]

    matrix = pd.DataFrame(columns=string2, index= string1)
    cols = matrix.columns
    rows = matrix.index

    matrix['-'] = 0
    for x in cols:
        matrix[x][0] = 0

    curr_max = {"val": 0,
                "row": 0,
                "col": 0}
    for col in range(1,len(matrix.columns)):
        for row in range(1, len(matrix)):
            matrix.iloc[row,col] = max(0,matrix.iloc[row-1,col-1] + pam.loc[rows[row],cols[col]],
                                   matrix.iloc[row-1,col] + penalty, matrix.iloc[row,col-1] + penalty)
            if curr_max["val"] < matrix.iloc[row,col]:
                curr_max["val"] = matrix.iloc[row,col]
                curr_max["row"] = row
                curr_max["col"] = col

    i = curr_max['row']
    j = curr_max['col']
    sub1 = ""
    sub2 = ""
    val = curr_max['val']

    while(matrix.iloc[i,j] != 0 & (i > 0) & (j > 0)):

        if val - pam.loc[rows[i], cols[j]] == matrix.iloc[i - 1, j - 1]:
            sub1 = string1[i] + sub1
            sub2 = string2[j] + sub2
            val = val - pam.loc[rows[i], cols[j]]
            i = i - 1
            j = j - 1

        elif val == matrix.iloc[i-1,j] - penalty:
            sub2 = string2[j] + sub2
            sub1 = "-" + sub1
            val = matrix.iloc[i,j] - penalty
            j = j -1

        elif val == matrix.iloc[i,j-1] - penalty:
            sub2 = "-" + sub2
            sub1 = string1[i] + sub1
            val = matrix.iloc[i,j] - penalty
            i = i - 1

    # def Backtrack(val,i,j):
    #     if matrix.iloc[i,j] == 0 | i == 0 | j == 0:
    #         return []
    #     if val - pam.loc[rows[row],cols[col]] == matrix.iloc[i-1,j-1]:
    #         return Backtrack(val - pam.loc[rows[row],cols[col]], i-1,j-1).insert(0,"D")
    #     elif val - (matrix.iloc[row-1,col] + penalty) == matrix.iloc[row-1,col]:
    #         return Backtrack(val - pam.loc[rows[row],cols[col]], i-1,j).insert(0,'U')
    #     elif val - (matrix.iloc[row,col-1] + penalty) == matrix.iloc[row,col-1]:
    #         return Backtrack(val - pam.loc[rows[row],cols[col]], i,j-1).insert(0,'L')

    print(curr_max['val'])
    print(sub1)
    print(sub2)