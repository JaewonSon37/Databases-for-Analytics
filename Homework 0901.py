# Part 1
## ==========================================================================================================

# Import library
import sqlite3
import json
import urllib.request
import time
import matplotlib.pyplot as plt

# URL to the dataset
url = 'http://dbgroup.cdm.depaul.edu/DSC450/Module7.txt'

# Define database paths
database_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0801.db"

# Create tables
User_table = """CREATE TABLE User
(
  id INTEGER,
  name TEXT,
  screen_name TEXT,
  description TEXT,
  friends_count INTEGER
);"""

Geo_Table = """CREATE TABLE Geo
(
  id INTEGER,
  type TEXT,
  longitude REAL,
  latitude REAL,

  CONSTRAINT Geo_PK
     PRIMARY KEY(id, longitude, latitude)
);"""

Tweet_Table = """CREATE TABLE Tweet
(
  created_at TEXT,
  id_str TEXT,
  text TEXT,
  source TEXT,
  in_reply_to_status_id TEXT,
  in_reply_to_user_id TEXT,
  in_reply_to_screen_name TEXT,
  contributors TEXT,
  retweet_count INTEGER,
  user_id INTEGER,
  geo_id INTEGER,
  geo_longitude REAL,
  geo_latitude REAL,
  
  CONSTRAINT Tweet_FK1
     FOREIGN KEY(user_id)
       REFERENCES User(id),

  CONSTRAINT Tweet_FK2
     FOREIGN KEY(geo_id, geo_longitude, geo_latitude)
       REFERENCES Geo(id, longitude, latitude)
);"""

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database
c.execute(User_table) # Create the User table
c.execute(Geo_Table) # Create the Geo table
c.execute(Tweet_Table) # Create the Tweet table
conn.commit() # Commit all the changes
conn.close() # Close the connection

webFD = urllib.request.urlopen(url)  # Open the tweet data from the URL
valid_tweets = [] # Initialize lists to hold valid tweets

for line in webFD:
    try:
        tweet = json.loads(line.decode('utf-8').strip()) # Decode the line
        valid_tweets.append(tweet) # Append to the list
    except ValueError:
        continue

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Populate records to the tables
for tweet in valid_tweets:

    # Insert record into the User table
    c.execute("INSERT INTO User VALUES (?, ?, ?, ?, ?)",
              (tweet.get('user', {}).get('id'),
               tweet.get('user', {}).get('name'),
               tweet.get('user', {}).get('screen_name'),
               tweet.get('user', {}).get('description'),
               tweet.get('user', {}).get('friends_count')))

    # Initialize geo variables
    geo_id = tweet.get('id')
    geo_type = None
    longitude = None
    latitude = None

    # Get the geo information
    geo = tweet.get('geo')

    # Check if geo information exists
    if geo:
        geo_type = geo['type']
        longitude, latitude = geo['coordinates']
    else:
        geo_type = None
        longitude = None
        latitude = None

    # Insert record into the Geo table
    c.execute("INSERT INTO Geo VALUES (?, ?, ?, ?)",
              (geo_id,
               geo_type,
               longitude,
               latitude))

    # Insert record into the Tweet table
    c.execute("INSERT INTO Tweet VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
              (tweet.get('created_at'), 
               tweet.get('id_str'), 
               tweet.get('text'), 
               tweet.get('source'), 
               tweet.get('in_reply_to_status_id'), 
               tweet.get('in_reply_to_user_id'), 
               tweet.get('in_reply_to_screen_name'), 
               tweet.get('contributors'), 
               tweet.get('retweet_count'), 
               tweet.get('user', {}).get('id'),
               geo_id,
               longitude,
               latitude))

conn.commit() # Commit all the changes
conn.close() # Close the connection


# Part 1-a
## Using SQL, find tweets where tweet "id_str" contains "78", "8" or "8791" anywhere in the column
## ==========================================================================================================

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Record the current time
start_time = time.time() 

# Fetch records from a table with a given condition
c.execute("""SELECT * 
               FROM Tweet 
               WHERE id_str LIKE '%78%' OR 
                     id_str LIKE '%8%' OR 
                     id_str LIKE '%8791%'""")
results = c.fetchall()

# Report runtime
sql_run_time = time.time() - start_time
print()
print(f"SQL Query Run Time: {sql_run_time:.4f} seconds")
print(f"Number of tweets matching the condition:", len(results))

conn.close() # Close the connection


# Part 1-b
## Using Python, find tweets where tweet "id_str" contains "78", "8" or "8791" anywhere in the column
## ==========================================================================================================

# Record the current time
start_time = time.time() 

# Filter records with a given condition
results = [tweet for tweet in valid_tweets 
           if "78" in tweet.get('id_str', '') or
              "8" in tweet.get('id_str', '') or 
              "8791" in tweet.get('id_str', '')]

# Report runtime
python_run_time = time.time() - start_time
print()
print(f"Python Query Run Time: {python_run_time:.4f} seconds")
print(f"Number of tweets matching the condition: {len(results)}")


# Part 1-c
## Using SQL, find how many unique values are there in the "friends_count" column
## ==========================================================================================================

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Record the current time
start_time = time.time() 

# Fetch records from a table with a given condition
c.execute("SELECT DISTINCT friends_count FROM User")
results = c.fetchall()
conn.close() # Close the connection

# Report runtime
sql_run_time = time.time() - start_time
print()
print(f"SQL Query Run Time: {sql_run_time:.4f} seconds")
print("Number of unique friends_count values:", len(results))


# Part 1-d
## Using Python, find how many unique values are there in the "friends_count" column
## ==========================================================================================================

# Record the current time
start_time = time.time() 

# Filter records with a given condition
results = [tweet['user']['friends_count'] for tweet in valid_tweets]

# Report runtime
python_run_time = time.time() - start_time
print()
print(f"Python Query Run Time: {python_run_time:.4f} seconds")
print(f"Number of unique friends_count values:", len(set(results)))


# Part 1-e
## Plot the lengths of the first 90 tweets versus the length of the username for the user on a graph
## ==========================================================================================================

# Extract lengths of tweets and usernames for the first 90 tweets
length_of_tweets = [len(tweet.get('text', '')) for tweet in valid_tweets[:90]]
length_of_usernames = [len(tweet.get('user', {}).get('screen_name', '')) for tweet in valid_tweets[:90]]

# Create scatter plot
scatter_plot = plt.figure()
plt.scatter(length_of_tweets, length_of_usernames)
plt.title('Tweet Lengths vs Username Lengths')
plt.xlabel('Length of the Tweets')
plt.ylabel('Length of the Username')
plt.show()

# Save the figure in both PNG and PDF formats
file_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 9\\Data File"
scatter_plot.savefig(f'{file_path}\\Tweet Lengths vs Username Lengths.png')
scatter_plot.savefig(f'{file_path}\\Tweet Lengths vs Username Lengths.pdf', bbox_inches = 'tight')
