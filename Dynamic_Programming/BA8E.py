import numpy as np
import numpy.ma as npm
from scipy.spatial import distance

points_int = []
with open("input",'r') as file:
    line_One = file.readline().split()
    n = int(line_One[0])

    points_str = file.readlines()

    for x in points_str:
        points_int.append([float(y) for y in x.rstrip('\n').split()])


clusters = []
for x in range(0,len(points_int)):
    clusters.append([x])
matr = np.array(points_int)

edges = {}
while(len(clusters) > 2):
    minval = np.min(matr[np.nonzero(matr)])
    coord = list(np.where(matr == minval)[0])
    min_set = clusters[coord[0]]+clusters[coord[1]]
    for index in sorted(coord, reverse=True):
        del clusters[index]

    min_str = list(map(lambda x:x+1,min_set))
    temp = ""
    for x in min_str:
        temp = temp + str(x) + " "
    print(temp.rstrip())
    clusters.append(min_set)
    matr = np.array(matr)
    # print(list(map(lambda x:x+1,min_coord)))
    matr = np.zeros((len(clusters),len(clusters)))

    for x in range(0,len(clusters)):
        for y in range(0,len(clusters)):
            if x != y:
                new_coords = [[i,j] for i in clusters[x] for j in clusters[y]]
                total = 0
                for z in new_coords:
                    total = total + points_int[z[0]][z[1]]
                matr[x,y] = total/len(new_coords)
            else:
                matr[x,y] = 0

temp = ""
x = list(range(1,len(points_int)+1))
for y in x:
    temp = temp + str(y) + " "
print(temp.rstrip())