import hatchet as ht
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

def main():
    data = {
        "1" : "./data/hpctoolkit-lulesh2.0-database-1358372",
        "8" : "./data/hpctoolkit-lulesh2.0-database-1358366",
        "27" : "./data/hpctoolkit-lulesh2.0-database-1358376"
    }

    frames = []

    for x in data.keys():
        
        currFrame = ht.GraphFrame.from_hpctoolkit(data[x])
        currFrame.drop_index_levels()
        
        currFrame = filterByTime(currFrame)
        currFrame = filterNames(currFrame)
        
        currFrame.dataframe = currFrame.dataframe.sort_values(by=['time'], ascending=False)
        currFrame.dataframe['cores'] = int(x)

        print(currFrame.dataframe.head(5))
        frames.append(currFrame.dataframe.head(5))
    
    results = pd.concat(frames)

    df = results.pivot_table(index="cores", columns="name", values="time", aggfunc="mean")
    
    plt.figure(0)
    df.loc[:,:].plot.bar(stacked=True, figsize=(15,15))
    plt.legend(ncols=2,fontsize="medium",loc="best")
    plt.savefig("./images/task1_bar.png")
  
    plt.figure(1)
    df.loc[:,:].plot.line(stacked=True, figsize=(15,15))
    plt.legend(ncols=2,fontsize="medium",loc="best")
    plt.savefig("./images/task1_line.png")
    plt.show()

def filterByTime(df):
    filter_func = lambda x : x['time'] > 0 
    return df.filter(filter_func, squash=True)

def filterNames(df):
    filter_func = lambda x : "unknown" not in x['name']
    return df.filter(filter_func, squash=True)

def printCol(df, col):
    print(df.dataframe.iloc[:][col])

if __name__ == "__main__":
    main()