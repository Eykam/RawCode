import hatchet as ht
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

def main():
    data_weak = {
        "01" : "./data/hpctoolkit-lulesh2.0-database-1358372",
        "08" : "./data/hpctoolkit-lulesh2.0-database-1358366",
        "27" : "./data/hpctoolkit-lulesh2.0-database-1358376"
    }

    data_strong = {
        "01" : "./data/hpctoolkit-lulesh2.0-database-1358383",
        "08" : "./data/hpctoolkit-lulesh2.0-database-1358385",
        "27" : "./data/hpctoolkit-lulesh2.0-database-1358386"
    }

    frame_1 = []
    frame_8 = []
    frame_27 = []

    for x in data_weak.keys():
        
        currFrameWeak = ht.GraphFrame.from_hpctoolkit(data_weak[x])
        currFrameWeak.drop_index_levels()

        currFrameStrong = ht.GraphFrame.from_hpctoolkit(data_strong[x])
        currFrameStrong.drop_index_levels()
        
        currFrameWeak = filterByTime(currFrameWeak)
        currFrameWeak = filterNames(currFrameWeak)

        currFrameStrong = filterByTime(currFrameStrong)
        currFrameStrong = filterNames(currFrameStrong)
        
        currFrameWeak.dataframe = currFrameWeak.dataframe.sort_values(by=['time'], ascending=False)
        currFrameWeak.dataframe['cores'] = x + "_weak"

        currFrameStrong.dataframe = currFrameStrong.dataframe.sort_values(by=['time'], ascending=False)
        currFrameStrong.dataframe['cores'] = x + "_strong"
        
        results = None

        if(x == 1):
            print(currFrameStrong.dataframe.head(5))
            frame_1.append(currFrameStrong.dataframe.head(5))

            print(currFrameWeak.dataframe.head(5))
            frame_1.append(currFrameWeak.dataframe.head(5))

            results = pd.concat(frame_1)

        elif x == 8:
            print(currFrameStrong.dataframe.head(5))
            frame_8.append(currFrameStrong.dataframe.head(5))
            
            print(currFrameWeak.dataframe.head(5))
            frame_8.append(currFrameWeak.dataframe.head(5))

            results = pd.concat(frame_8)

        else:
            print(currFrameStrong.dataframe.head(5))
            frame_27.append(currFrameStrong.dataframe.head(5))

            print(currFrameWeak.dataframe.head(5))
            frame_27.append(currFrameWeak.dataframe.head(5))

            results = pd.concat(frame_27)
        
        

        df = results.pivot_table(index="cores", columns="name", values="time", aggfunc="mean")

        plt.figure(int(x))
        df.loc[:,:].plot.bar(stacked=True, figsize=(15,15))
        plt.legend(ncols=2,fontsize="medium",loc="best")
        plt.savefig("./images/task2_bar_"+x+".png")
    

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