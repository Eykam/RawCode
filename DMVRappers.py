import tweepy
import numpy as np
import pandas as pd
import re
from pprint import pprint


"""
BEFORE RUNNING MAKE SURE YOU CHANGE THE TO_CSV URL IN EACH FUNCTION TO YOUR OWN PATH
INSTALL DEPENDENCIES
FUNCTION CALLS ARE AT BOTTOM, COMMENT OUT THE ONES YOU ARE NOT USING
"""

consumerKey = ""
consumerSecret = ""
accessKey = ""
accessSecret = ""

auth = tweepy.OAuthHandler(consumer_key= consumerKey, consumer_secret=consumerSecret)
auth.set_access_token(accessKey, accessSecret)
api= tweepy.API(auth,wait_on_rate_limit=True)

def clean_tweet(tweet):
 '''
 Utility function to clean tweet text by removing links, special characters
 using simple regex statements.
 '''
 return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])| (\w+:\ / \ / \S+)"," ", tweet).split())

def getTotalMentions():
        name=input("Enter name to search: ")
        fileName=input("Enter file name: ")
        mentions=tweepy.Cursor(api.search, q=name+" -filter:retweets").items()
        text=[]
        user=[]
        retweets=[]
        favs=[]
        for tweet in mentions:
            text.append(clean_tweet(tweet.text))
            user.append(tweet.user.id_str)
            retweets.append(tweet.retweet_count)
            favs.append(tweet.favorite_count)
        df = pd.DataFrame({'Tweet': text,
                           'User': user,
                           'Retweets': retweets,
                           'Favorites': favs})
        #df.to_csv("C:\\Users\\Eyad Kamil\\Desktop\\"+fileName+".csv") #Change to path you want
        return df

def getUserInfo():
        name=input("Enter username (@_____): ")
        fileName = input("Enter file name: ")
        userInfo=api.get_user(name)
        id=userInfo.id_str
        location=userInfo.location
        verification=userInfo.verified
        followers=userInfo.followers_count
        friends=userInfo.friends_count
        #listOfFollowers=api.followers_ids(name)
        #listOfFriends=api.friends_ids(name)
        df=pd.DataFrame({'ID': [id],
                     'Location': [location],
                     'Verification': [verification],
                     'Followers':[followers],
                     'Friends':[friends]
                     #'List of Follwers':listOfFollowers,
                     #'List of Friends':listOfFriends
                     })
        #df.to_csv("C:\\Users\\Eyad Kamil\\Desktop\\" + fileName + ".csv") #change to path you want
        return df

def getUserMentions():
    name=input("Enter username: ")
    fileName=input("Enter filename: ")
    userInfo = api.get_user(name)
    id = userInfo.id_str
    allTweets=[]
    replyTo=[] #Current user replied to another user
    quoteOf=[] #Current user quoted another user
    retweetOf=[] #Current user retweeted another user
    mentions=[] #Users current user mentions
    for tweet in tweepy.Cursor(api.user_timeline, id=id).items():
        allTweets.append(clean_tweet(tweet.text))
        replyTo.append(tweet.in_reply_to_user_id_str)
        if hasattr(tweet,'quoted_status'):
            quotedTweet=tweet.quoted_status.user.id_str
            quoteOf.append(quotedTweet)
        if hasattr(tweet,'quoted_status')==False:
            quoteOf.append('null')
        if hasattr(tweet,'retweeted_status'):
            retweetOf.append(tweet.retweeted_status.user.id_str)
        if hasattr(tweet,'retweeted_status')==False:
            retweetOf.append('null')
        try:
            if tweet.entities['user_mentions'][0]['id_str']==tweet.retweeted_status.user.id_str:
                mentions.append('null')
            else:
                mentions.append(tweet.entities['user_mentions'][0]['id_str'])
        except IndexError:
            mentions.append('null')
    df=pd.DataFrame({'Tweets':allTweets,
                     'Replied to':replyTo,
                     'Quoted Tweet of':quoteOf,
                     'Retweeted':retweetOf,
                     'Mentioned Users':mentions
                    })
    #df.to_csv("C:\\Users\\Eyad Kamil\\Desktop\\" + fileName + ".csv")  # change to path you want
    return df

def searchTweet(query,num):
    tweet=tweepy.Cursor(api.search,q=query).items(num)
    for tweets in tweet:
        print(tweets.text)

def searchID(id):
    tweet=api.get_status(id)
    print(tweet.text)
    return tweet

def checkRetweets():
    name = input("Enter username: ")
    fileName = input("Enter filename: ")
    userInfo = api.get_user(name)
    id = userInfo.id_str
    for tweet in tweepy.Cursor(api.user_timeline, id=id).items(3):
        pprint(vars(tweet))

def mentionedRappers(dataframe):
    num=int(input("How many people do you want to check: "))
    listOfIds=[]
    for x in range(0,num):
        name=input("What is the userName: ")
        name=int(getUserID(name))
        listOfIds.append(name)
    print (listOfIds)
    #print(dataframe.ix[100])
    newDf=dataframe.isin(listOfIds)
    #newDf.to_csv("C:\\Users\\Eyad Kamil\\Desktop\\bool1.csv")
    #print(newDf)
    foo = newDf.index[newDf['Replied to']
                   | newDf['Quoted Tweet of']
                   | newDf['Retweeted']
                   | newDf['Mentioned Users']].tolist()
    #print(foo)
    if len(foo)!=0:
        df = pd.DataFrame({'Tweets': [],
                       'Replied to': [],
                       'Quoted Tweet of': [],
                       'Retweeted': [],
                       'Mentioned Users': []
                       })
        for x in foo:
            df.loc[dataframe.index[x]] =dataframe.iloc[x]
        #print(df.head(50))
        #df.to_csv("C:\\Users\\Eyad Kamil\\Desktop\\bool2.csv") Change to path you want
    else:
        print("No matches")
    #print(dataframeNew.head(50))

def getUserID(name):
    userInfo = api.get_user(name)
    id = userInfo.id_str
    return id

def getUserName(dataframe):
    rows=len(dataframe)
    for row in range(0,rows):
        for i in range (1,5):
            if pd.isnull(dataframe.iloc[row,i])==False:
                print(int(dataframe.iloc[row,i]))
                userInfo = api.get_user(int(dataframe.iloc[row,i]))
                screen_name = userInfo.screen_name
                dataframe.iloc[row,i]=screen_name
    #dataframe.to_csv("C:\\Users\\Eyad Kamil\\Desktop\\bool3.csv") #Change to path you want
    print(dataframe.head(50))
def areFriends():
    followingRapper=[]
    followedBack=[]
    currentUser = input("Enter username of current rapper (@______): ")
    listOfRappers=[]
    num=int(input("How many rappers do you want to check: "))
    for x in range(0,num):
        name=input("Enter rappers @_____: ")
        listOfRappers.append(name)
    user=api.get_user(currentUser)
    for x in listOfRappers:
        print(x)
        status = api.show_friendship(source_screen_name=currentUser, target_screen_name=x)
        followingRapper.append(status[0].following)
        followedBack.append(status[1].following)
    df=pd.DataFrame({'List':listOfRappers,
                     'Following':followingRapper,
                     'Followed By':followedBack})
    print(df.head(50))

"""
Run methods down here 
"""

#getTotalMentions()
#getUserInfo()
#getUserMentions()
#searchTweet("bitcoin",1)
#tweet=searchID(1066370523729403909)
#checkRetweets()

#mentionedRappers(pd.read_csv("C:\\Users\\Eyad Kamil\\Desktop\\FINAL.csv"))
#getUserName(pd.read_csv("C:\\Users\\Eyad Kamil\\Desktop\\bool2.csv"))
#df=pd.read_csv("C:\\Users\\Eyad Kamil\\Desktop\\bool2.csv")
#print(len(df))
#print(df['Quoted Tweet of'])
#user=api.get_user(3863795009)
#print(user.screen_name)
