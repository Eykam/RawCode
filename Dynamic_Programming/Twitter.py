from textblob import TextBlob
import tweepy
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import math
import re


consumerKey = ""
consumerSecret = ""
accessKey = ""
accessSecret = ""

def percentage(number,total):
    return float(number)/float(total)

def clean_tweet(tweet):
 '''
 Utility function to clean tweet text by removing links, special characters
 using simple regex statements.
 '''
 return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])| (\w+:\ / \ / \S+)"," ", tweet).split())

auth = tweepy.OAuthHandler(consumer_key= consumerKey, consumer_secret=consumerSecret)
auth.set_access_token(accessKey, accessSecret)
api= tweepy.API(auth)

searchName = input("Enter a keyword to search for: ")
num= float(input("How many tweets to search: "))

tweets=tweepy.Cursor(api.search, q=searchName).items(num)

data = []
analysis=[]
for tweet in tweets:
    data.append(clean_tweet(tweet.text))
    analysis.append(TextBlob(clean_tweet(tweet.text)).sentiment.polarity)
    #print (data)

print (analysis)
print(data)
print(len(data))
print(len(analysis))

x=pd.DataFrame(
    {"Tweet" : data,
     "Sentiment" : analysis
    })

print(x.head(50))
x.to_csv("C:\\Users\\Eyad Kamil\\Desktop\\Duck1.csv")



plt.hist(analysis, bins=int(math.sqrt(num))+1)
plt.show()

"""for tweet in tweets:
    #print(tweet)  # print tweet's text
   # print (tweet.user.location)
    analysis = TextBlob(tweet.text)
    data = pd.DataFrame(data=[tweet.user.screen_name,tweet.text,tweet.retweet_count,tweet.favorite_count,tweet.created_at,tweet.user.location], columns=['Name','Tweet','Retweets','Favorites','Time','Location'])
   # print(analysis.sentiment)  # print tweet's polarity"""

#tweet.text,tweet.retweet_count,tweet.favorite_count,tweet.created_at,tweet.user.location]
