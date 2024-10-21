# Part 2

# Import library
import csv
import sqlite3
import requests

# URL to the dataset
url = "http://dbgroup.cdm.depaul.edu/DSC450/Public_Chauffeurs_Short_hw3.csv"

# Define paths
database_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0501-1.db"

# Create the Public Chaufferus table
Public_Chauffeurs_Table = """CREATE TABLE Public_Chauffeurs
(
  License_Number,
  Renewed,
  Status,	
  Status_Date,
  Driver_Type,	
  License_Type,	
  Original_Issue_Date,
  Name,
  Sex,
  Chauffeur_City,
  Chauffeur_State,	
  Record_Number
);"""

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database
c.execute(Public_Chauffeurs_Table) # Create the Public Chaufferus table

# Fetch the data from the URL
response = requests.get(url)
content = response.content.decode('utf-8').splitlines()
reader = csv.reader(content)
next(reader) # Skip the header row

# Insert data into the table
for row in reader:
    record = [None if value == 'NULL' or value == '' else value for value in row] # Replace 'NULL' or empty values with None
    c.execute("INSERT INTO Public_Chauffeurs VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", record)

conn.commit() # Commit all the changes
conn.close() # Close the connection


# Part 2-a
## Verify how many records are in the Chauffeurs table

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Query to count the total records
record1 = c.execute("SELECT COUNT(*) FROM Public_Chauffeurs")
count_record1 = record1.fetchone()[0]
print("\n")
print(f"There are {count_record1} records in the Public Chauffeurs table")

conn.commit() # Commit all the changes
conn.close() # Close the connection


# Part 2-b
## Verify how many of the records are missing in the Original_Issue_Date column

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Query to count the missing values in the Original_Issue_Date column
record2 = c.execute("SELECT COUNT(*) FROM Public_Chauffeurs WHERE Original_Issue_Date IS NULL")
count_record2 = record2.fetchone()[0]
print("\n")
print(f"There are {count_record2} missing values in the Original_Issue_Date column")

conn.commit() # Commit all the changes
conn.close() # Close the connection



# Part 3

# Import library
import sqlite3
import json
import urllib.request

# URL to the dataset
url = 'http://dbgroup.cdm.depaul.edu/DSC450/Module5.txt'

# Define paths
database_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0501-2.db"


# Part 3-a
## Create an SQL table to contain given attributes of a tweet

# Create the Module5 table
Module5_Table = """CREATE TABLE Module5
(
  created_at TEXT,
  id_str TEXT,
  text TEXT,
  source TEXT,
  in_reply_to_status_id TEXT,
  in_reply_to_user_id TEXT,
  in_reply_to_screen_name TEXT,
  contributors TEXT,
  retweet_count INTEGER
);"""

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database
c.execute(Module5_Table) # Create the Module5 table
conn.commit() # Commit all the changes
conn.close() # Close the connection


# Part 3-b
## Write Python code to read through the file and populate the table from the previous question

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Open tweet data from the URL
web_file_descriptor = urllib.request.urlopen(url)
record = web_file_descriptor.read().decode('utf-8')
tweets = record.split('EndOfTweet')

# Parse and store each tweet data
tweets_list = []
for tweet in tweets:
    tweet_json = json.loads(tweet)
    tweets_list.append({'created_at': tweet_json.get('created_at'),
                        'id_str': tweet_json.get('id_str'),
                        'text': tweet_json.get('text'),
                        'source': tweet_json.get('source'),
                        'in_reply_to_status_id': tweet_json.get('in_reply_to_status_id'),
                        'in_reply_to_user_id': tweet_json.get('in_reply_to_user_id'),
                        'in_reply_to_screen_name': tweet_json.get('in_reply_to_screen_name'),
                        'contributors': tweet_json.get('contributors'),
                        'retweet_count': tweet_json.get('retweet_count')})

# Insert data into the table
for tweet in tweets_list:
    tweet_data = [None if value == 'NULL' or value == '' 
                  else value for value in (tweet['created_at'],
                                           tweet['id_str'],
                                           tweet['text'],
                                           tweet['source'],
                                           tweet['in_reply_to_status_id'],
                                           tweet['in_reply_to_user_id'],
                                           tweet['in_reply_to_screen_name'],
                                           tweet['contributors'],
                                           tweet['retweet_count'])]
    c.execute("INSERT INTO Module5 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", tweet_data)

# Fetch records from a table
c.execute('SELECT * FROM Module5')
module5_records = c.fetchall()
print("\nModule5 Table Records:")
for record in module5_records:
    print(record)

conn.commit() # Commit all the changes
conn.close() # Close the connection
