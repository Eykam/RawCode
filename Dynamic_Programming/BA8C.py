import numpy as np

points_int = []
k = 0
n = 0

with open("input",'r') as file:
    line_One = file.readline().split()
    ints = [int(x) for x in line_One]

    k = ints[0]
    n = ints[1]

    points_str = file.readlines()
    points_int = []
    for x in points_str:
        points_int.append([float(y) for y in x.rstrip('\n').split()])

centers = []

for x in range(0,k):
    centers.append(points_int[x])

def reassign(points,centers):
    clusters = {}
    for x in points:
        curr_min = 99999
        cluster = []
        for y in centers:
            dist = np.linalg.norm(np.subtract(x,y))
            if curr_min > dist:
                curr_min = dist
                cluster = y

        if str(cluster) in clusters:
             clusters[str(cluster)].append(x)
        else:
            clusters[str(cluster)] = [x]
    return(clusters)

def recompute_centers(clusters_arr):
    new_centers = []
    for x in list(clusters_arr.values()):
        new_centers.append(list(np.average(x, axis=0)))

    return(new_centers)

prev_centers=[]
while(centers != prev_centers):
    curr_clusters = reassign(points_int, centers)
    prev_centers = centers
    centers = recompute_centers(curr_clusters)

for x in centers:
    strin = ""
    for y in x:
        strin = strin + " " +"%.3f" % y
    strin = strin.rstrip(" ")
    print(strin)