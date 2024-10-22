# Import library
import urllib.request
import json

tweetData = 'http://cdmgcsarprd01.dpu.depaul.edu/DSC450/tweet_data.txt' # URL of the tweet data file
webFD = urllib.request.urlopen(tweetData) # Open the tweet data from the URL
ln = webFD.readline() # Skip the first line
ln = webFD.readline() # Read the second line
tweet = json.loads(ln[6:]) # Load the tweet data

print(tweet.keys(), "\n") # Print all available keys
print(tweet['created_at'], "\n") # Timestamp of when the tweet was created
print(tweet['lang'], "\n") # The language in which the tweet is written
print(tweet['source'], "\n") # Source from which the tweet was posted
print(tweet['geo'], "\n") # Location information
print(tweet['coordinates'], "\n") # Coordinates of the tweet

tweetUser = tweet['user'] # Access user data from the tweet
print(tweetUser['created_at'], "\n") # Timestamp of when the user account was created
print(tweet['user']['created_at'], "\n") # Another way to access the same user account creation timestamp
