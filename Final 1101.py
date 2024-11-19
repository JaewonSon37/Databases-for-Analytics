# Part 1
## ===============================================================================================================

# Import library
import sqlite3
import json
import requests
import urllib.request
import time
import matplotlib.pyplot as plt

# Define path
url_path = 'http://dbgroup.cdm.depaul.edu/DSC450/OneDayOfTweets.txt'
text_file_path1 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File\\150000_tweets.txt"
text_file_path2 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File\\750000_tweets.txt"
database_path1 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Final 1101.db"
database_path2 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Final 1102.db"
database_path3 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Final 1103.db"
database_path4 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Final 1104.db"
database_path5 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Final 1105.db"
database_path6 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Final 1106.db"
image_file_path = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 11\\Data File\\runtime_comparison.png"


# Part 1-a
## Use Python to download tweets from the web and save them to a local text file 
## ===============================================================================================================

def download_tweets_and_save_to_text_file(url_path, text_file_path, tweet_count):
    
    # Record the start time
    start_time = time.time()

    # Open a text file in write mode
    with open(text_file_path, 'w', encoding = 'utf-8') as file:
        
        # Send a GET request to the URL to stream
        response = requests.get(url_path, stream = True) 
        
        # Initialize tweet counter
        count = 0 
        
        for line in response.iter_lines(decode_unicode = True):
            
            # Stop processing when reaching a specific tweet count
            if count >= tweet_count: 
                break
            
            try:
                tweet = json.loads(line.strip())
                file.write(json.dumps(tweet) + '\n')
                count += 1

            except json.JSONDecodeError:
                continue
            
    # Record the end time
    end_time = time.time()

    # Calculate the runtime
    runtime = end_time - start_time

    return count, runtime

count1, runtime1 = download_tweets_and_save_to_text_file(url_path, text_file_path1, 150000)
count2, runtime2 = download_tweets_and_save_to_text_file(url_path, text_file_path2, 750000)

print()
print("Part 1-a")
print("-" * 100)
print(f"{count1} tweets have been downloaded")
print(f"{count2} tweets have been downloaded")
print("=" * 100)


# Part 1-b
## Repeat Part 1-a, but populate the 3-table schema that previously created in SQLite
## ===============================================================================================================

def download_tweets_and_populate_to_schema(url_path, database_path, tweet_count):
    
    # Record the start time
    start_time = time.time()

    # Create User table
    User_table = """CREATE TABLE User
    (
      id INTEGER,
      name TEXT,
      screen_name TEXT,
      description TEXT,
      friends_count INTEGER
    );"""

    # Create Geo table
    Geo_Table = """CREATE TABLE Geo
    (
      type TEXT,
      longitude REAL,
      latitude REAL,
      id TEXT,
    
      CONSTRAINT Geo_PK
        PRIMARY KEY(id)
    );"""

    # Create Tweet table
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
      geo_id TEXT,

      CONSTRAINT Tweet_FK1
        FOREIGN KEY(user_id)
          REFERENCES User(id),

      CONSTRAINT Tweet_FK2
        FOREIGN KEY(geo_id)
          REFERENCES Geo(id)
    );"""

    # Connect to the database
    conn = sqlite3.connect(database_path)
    c = conn.cursor()

    # Create the tables
    c.execute(User_table)
    c.execute(Geo_Table)
    c.execute(Tweet_Table)

    # Commit all the changes
    conn.commit() 

    # Open the tweet data from the URL
    webFD = urllib.request.urlopen(url_path)  

    # Initialize tweet counter
    count = 0 

    # Flag to insert a default Geo entry
    geo_none_inserted = False

    for line in webFD:
        
        # Stop processing when reaching a specific tweet count
        if count >= tweet_count:
            break
        
        try:
            tweet = json.loads(line.decode('utf-8').strip()) 

            # Insert record into the User table
            c.execute("INSERT INTO User VALUES (?, ?, ?, ?, ?)",
                      (tweet.get('user', {}).get('id'),
                       tweet.get('user', {}).get('name'),
                       tweet.get('user', {}).get('screen_name'),
                       tweet.get('user', {}).get('description'),
                       tweet.get('user', {}).get('friends_count')))

            # Initialize Geo variables
            geo_type = None
            longitude = None
            latitude = None
            geo_id = None

            # Get the Geo information
            geo = tweet.get('geo')

            # Check if Geo information exists
            if geo:
                geo_type = geo['type']
                longitude, latitude = geo['coordinates']
                geo_id = f"{longitude}_{latitude}"

                # Insert record into the Geo table
                c.execute("INSERT OR IGNORE INTO Geo VALUES (?, ?, ?, ?)",
                          (geo_type,
                           longitude,
                           latitude,
                           geo_id))
                
            elif not geo_none_inserted:
                c.execute("INSERT OR IGNORE INTO Geo VALUES (?, ?, ?, ?)",
                          (None, None, None, None))
                geo_none_inserted = True

            # Insert record into the Tweet table
            c.execute("INSERT INTO Tweet VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
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
                       geo_id))

            # Increment the counter
            count += 1

        except json.JSONDecodeError:
            continue
    
    # Commit all the changes
    conn.commit()

    # Get the row counts for each table
    user_count = c.execute("SELECT COUNT(*) FROM User").fetchone()[0]
    geo_count = c.execute("SELECT COUNT(*) FROM Geo").fetchone()[0]
    tweet_count = c.execute("SELECT COUNT(*) FROM Tweet").fetchone()[0]

    # Close the connection
    conn.close()

    # Record the end time
    end_time = time.time()

    # Calculate the runtime
    runtime = end_time - start_time

    return user_count, geo_count, tweet_count, runtime

user_count1, geo_count1, tweet_count1, runtime3 = download_tweets_and_populate_to_schema(url_path, database_path1, 150000)
user_count2, geo_count2, tweet_count2, runtime4 = download_tweets_and_populate_to_schema(url_path, database_path2, 750000)

print()
print("Part 1-b")
print("-" * 100)
print("Row Count of Each Table")
print(f"User table: {user_count1} / Geo table: {geo_count1} / Tweet table: {tweet_count1}")
print(f"User table: {user_count2} / Geo table: {geo_count2} / Tweet table: {tweet_count2}")
print("=" * 100)


# Part 1-c
## Repeat Part 1-b, but use a locally saved tweet file to repeat the database population step
## ===============================================================================================================

def populate_schema_using_local_text_file(text_file_path, database_path, tweet_count):
    
    # Record the start time
    start_time = time.time()
    
    # Create User table
    User_table = """CREATE TABLE User
    (
      id INTEGER,
      name TEXT,
      screen_name TEXT,
      description TEXT,
      friends_count INTEGER
    );"""

    # Create Geo table
    Geo_Table = """CREATE TABLE Geo
    (
      type TEXT,
      longitude REAL,
      latitude REAL,
      id TEXT,
    
      CONSTRAINT Geo_PK
        PRIMARY KEY(id)
    );"""

    # Create Tweet table
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
      geo_id TEXT,

      CONSTRAINT Tweet_FK1
        FOREIGN KEY(user_id)
          REFERENCES User(id),

      CONSTRAINT Tweet_FK2
        FOREIGN KEY(geo_id)
          REFERENCES Geo(id)
    );"""

    # Connect to the database
    conn = sqlite3.connect(database_path)
    c = conn.cursor()

    # Create the tables
    c.execute(User_table)
    c.execute(Geo_Table)
    c.execute(Tweet_Table)

    # Commit changes
    conn.commit()

    # Open the local file for reading
    with open(text_file_path, 'r', encoding = 'utf-8') as file:
        
        # Initialize tweet counter
        count = 0

        # Flag to insert a default Geo entry
        geo_none_inserted = False

        for line in file:
            
            # Stop processing when reaching a specific tweet count
            if count >= tweet_count:
                break

            # Parse the tweet
            tweet = json.loads(line.strip())

            # Insert record into the User table
            c.execute("INSERT INTO User VALUES (?, ?, ?, ?, ?)",
                      (tweet.get('user', {}).get('id'),
                       tweet.get('user', {}).get('name'),
                       tweet.get('user', {}).get('screen_name'),
                       tweet.get('user', {}).get('description'),
                       tweet.get('user', {}).get('friends_count')))

            # Initialize Geo variables
            geo_type = None
            longitude = None
            latitude = None
            geo_id = None

            # Get the Geo information
            geo = tweet.get('geo')

            # Check if Geo information exists
            if geo:
                geo_type = geo['type']
                longitude, latitude = geo['coordinates']
                geo_id = f"{longitude}_{latitude}"

                # Insert record into the Geo table
                c.execute("INSERT OR IGNORE INTO Geo VALUES (?, ?, ?, ?)",
                          (geo_type,
                           longitude,
                           latitude,
                           geo_id))
                
            elif not geo_none_inserted:
                c.execute("INSERT OR IGNORE INTO Geo VALUES (?, ?, ?, ?)",
                          (None, None, None, None))
                geo_none_inserted = True

            # Insert record into the Tweet table
            c.execute("INSERT INTO Tweet VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
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
                       geo_id))

            # Increment the counter
            count += 1

    # Commit all changes and close the connection
    conn.commit()
    conn.close()

    # Record the end time
    end_time = time.time()

    # Calculate the runtime
    runtime = end_time - start_time

    return runtime

runtime5 = populate_schema_using_local_text_file(text_file_path1, database_path3, 150000)
runtime6 = populate_schema_using_local_text_file(text_file_path2, database_path4, 750000)

print()
print("Part 1-c")
print("-" * 100)
print("Data population into the schema has been completed")
print("=" * 100)


# Part 1-d
## Repeat the same step with a batching size of 2,500
## ===============================================================================================================

def populate_schema_using_local_text_file_with_batching(text_file_path, database_path, tweet_count, batch_size):
    
    # Record the start time
    start_time = time.time()

    # Create User table
    User_table = """CREATE TABLE User
    (
      id INTEGER,
      name TEXT,
      screen_name TEXT,
      description TEXT,
      friends_count INTEGER
    );"""

    # Create Geo table
    Geo_Table = """CREATE TABLE Geo
    (
      type TEXT,
      longitude REAL,
      latitude REAL,
      id TEXT,
    
      CONSTRAINT Geo_PK
        PRIMARY KEY(id)
    );"""

    # Create Tweet table
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
      geo_id TEXT,

      CONSTRAINT Tweet_FK1
        FOREIGN KEY(user_id)
          REFERENCES User(id),

      CONSTRAINT Tweet_FK2
        FOREIGN KEY(geo_id)
          REFERENCES Geo(id)
    );"""

    # Connect to the database
    conn = sqlite3.connect(database_path)
    c = conn.cursor()

    # Create the tables
    c.execute(User_table)
    c.execute(Geo_Table)
    c.execute(Tweet_Table)

    # Commit changes
    conn.commit()

    # Open the local file for reading
    with open(text_file_path, 'r', encoding = 'utf-8') as file:
        
        # Initialize tweet counter
        count = 0

        # Flag to insert a default Geo entry
        geo_none_inserted = False

        # Initialize lists for batch inserts
        user_batch = []
        geo_batch = []
        tweet_batch = []

        for line in file:
            
            # Stop processing when reaching a specific tweet count
            if count >= tweet_count:
                break

            # Parse the tweet
            tweet = json.loads(line.strip())

            # Prepare User data
            user_batch.append((tweet.get('user', {}).get('id'),
                               tweet.get('user', {}).get('name'),
                               tweet.get('user', {}).get('screen_name'),
                               tweet.get('user', {}).get('description'),
                               tweet.get('user', {}).get('friends_count')))

            # Initialize Geo variables
            geo_type = None
            longitude = None
            latitude = None
            geo_id = None

            # Get the Geo information
            geo = tweet.get('geo')

            # Check if Geo information exists
            if geo:
                geo_type = geo['type']
                longitude, latitude = geo['coordinates']
                geo_id = f"{longitude}_{latitude}"

                # Prepare Geo data
                geo_batch.append((geo_type,
                              longitude,
                              latitude,
                              geo_id))
                
            elif not geo_none_inserted:
                geo_batch.append((None, None, None, None))
                geo_none_inserted = True           

            # Prepare Tweet data
            tweet_batch.append((tweet.get('created_at'),
                                tweet.get('id_str'),
                                tweet.get('text'),
                                tweet.get('source'),
                                tweet.get('in_reply_to_status_id'),
                                tweet.get('in_reply_to_user_id'),
                                tweet.get('in_reply_to_screen_name'),
                                tweet.get('contributors'),
                                tweet.get('retweet_count'),
                                tweet.get('user', {}).get('id'),
                                geo_id))

            # Insert in batches
            if len(user_batch) >= batch_size:
                c.executemany("INSERT INTO User VALUES (?, ?, ?, ?, ?)", user_batch)
                c.executemany("INSERT OR IGNORE INTO Geo VALUES (?, ?, ?, ?)", geo_batch)
                c.executemany("INSERT INTO Tweet VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", tweet_batch)
                user_batch = []            
                geo_batch = []
                tweet_batch = []

            # Increment the counter
            count += 1

        # Insert any remaining data in User batch
        if user_batch:
            c.executemany("INSERT INTO User VALUES (?, ?, ?, ?, ?)", user_batch)

        # Insert remaining data in Geo batch
        if geo_batch:
            c.executemany("INSERT OR IGNORE INTO Geo VALUES (?, ?, ?, ?)", geo_batch)

        # Insert remaining data in Tweet batch
        if tweet_batch:
            c.executemany("INSERT INTO Tweet VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", tweet_batch)

    # Commit all changes and close the connection
    conn.commit()
    conn.close()

    # Record the end time
    end_time = time.time()

    # Calculate the runtime
    runtime = end_time - start_time

    return runtime

runtime7 = populate_schema_using_local_text_file_with_batching(text_file_path1, database_path5, 150000, 2500)
runtime8 = populate_schema_using_local_text_file_with_batching(text_file_path2, database_path6, 750000, 2500)

print()
print("Part 1-d")
print("-" * 100)
print("Data population into the schema using batching has been completed")
print("=" * 100)


# Part 1-e
## Plot the resulting runtimes using matplotlib for Part 1-a, 1-b, 1-c, and 1-d
## ===============================================================================================================

# Define the list of runtimes
runtimes_for_150000_tweets = [runtime1, runtime3, runtime5, runtime7]
runtimes_for_750000_tweets = [runtime2, runtime4, runtime6, runtime8]

# Plot the runtimes
plt.plot(runtimes_for_150000_tweets, marker = 'o', linestyle = '-', color = 'b', label = '150,000 Tweets')
plt.plot(runtimes_for_750000_tweets, marker = 'o', linestyle = '-', color = 'r', label = '750,000 Tweets')
plt.xticks([0, 1, 2, 3], ['1-a', '1-b', '1-c', '1-d'])
plt.ylabel('Runtime (seconds)')
plt.title('Runtime Comparison from 1-a to 1-d')
plt.grid(True)
plt.legend()
plt.savefig(image_file_path)
plt.show()



# Part 2
## ===============================================================================================================

# Import library
import sqlite3
import json
import time
from collections import defaultdict
import re


## Part 2-a
## Write and execute an SQL query to find the minimum longitude and maximum latitude value for each user ID
## ===============================================================================================================

# Write a query based on the given conditions
query = """SELECT Tweet.user_id,
                  MIN(Geo.longitude) AS min_longitude, 
                  MAX(Geo.latitude) AS max_latitude
            FROM Tweet, Geo
            WHERE Tweet.geo_id = Geo.id
            GROUP BY Tweet.user_id;"""


# Part 2-b
## Re-execute the SQL query in Part 2-a 5 times and 25 times and measure the total runtime 
## ===============================================================================================================

def measure_query_runtime1(database_path, query, execution_counts):
    
    # Connect to the database
    conn = sqlite3.connect(database_path)
    c = conn.cursor()

    # Initialize a list to store the runtime for each number of executions
    runtime_list = []
    
    # Loop through different numbers of executions to measure the query runtime
    for runs in execution_counts:
        
        # Record the start time
        start_time = time.time()
        
        for _ in range(runs):
            c.execute(query)
        
        # Record the end time
        end_time = time.time()
        
        # Calculate the runtime
        runtime = end_time - start_time

        # Append to the list
        runtime_list.append(runtime)

    # Commit and close the connection
    conn.commit()
    conn.close()
    
    return runtime_list

runtimes = measure_query_runtime1(database_path6, query, [5, 25])

print()
print("Part 2-b")
print("-" * 100)
for runs, runtime in zip([5, 25], runtimes):
    print(f"Runtime for {runs} executions: {runtime:.2f} seconds")
    if runs == 25:
        expected_runtime = runtimes[0] * 5
        if abs(runtime - expected_runtime) < 0.1 * expected_runtime:
            print("Runtime scales linearly")
        else:
            print("Runtime does not scale linearly")
print("=" * 100)


# Part 2-c
## Write the equivalent of the Part 2-a query in Python by reading it from the file with 750,000 tweets
## ===============================================================================================================

def read_tweets_file(file_path):
    
    # Initialize a defaultdict to store lists of coordinates for each user
    records = defaultdict(list)

    # Open the file in read mode
    with open(file_path, 'r') as file:
        
        # Iterate through each line in the file
        for line in file:
            
            # Parse the JSON data from the tweet line
            tweet = json.loads(line)

            # Extract the user ID and geolocation from the tweet
            user_id = tweet.get('user', {}).get('id')
            geo = tweet.get('geo')
            if geo:
                longitude, latitude = geo['coordinates']
                records[user_id].append((longitude, latitude))
    
    # Initialize an empty dictionary
    result = {}

    # Find the minimum longitude and maximum latitude for each user's tweets
    for user_id, coordinates in records.items():
        min_longitude = min(coordinate[0] for coordinate in coordinates)
        max_latitude = max(coordinate[1] for coordinate in coordinates)
        result[user_id] = {'MinLongitude': min_longitude, 'MaxLatitude': max_latitude}
    
    return result


# Part 2-d
## Re-execute the query in Part 2-c 5 times and 25 times and measure the total runtime
## ===============================================================================================================

def measure_query_runtime2(file_path, execution_counts):
    
    # Initialize a list to store the runtime for each number of executions
    runtime_list = []
    
    # Loop through different numbers of executions to measure the query runtime
    for runs in execution_counts:
        
        # Record the start time
        start_time = time.time()
        
        for _ in range(runs):
            read_tweets_file(file_path)
        
        # Record the end time
        end_time = time.time()
        
        # Calculate the runtime
        runtime = end_time - start_time

        # Append to the list
        runtime_list.append(runtime)
    
    return runtime_list

runtimes = measure_query_runtime2(text_file_path2, [5, 25])

print()
print("Part 2-d")
print("-" * 100)
for runs, runtime in zip([5, 25], runtimes):
    print(f"Runtime for {runs} executions: {runtime:.2f} seconds")
    if runs == 25:
        expected_runtime = runtimes[0] * 5
        if abs(runtime - expected_runtime) < 0.1 * expected_runtime:
            print("Runtime scales linearly")
        else:
            print("Runtime does not scale linearly")
print("=" * 100)


# Part 2-e
## Write the equivalent of the Part 2-a query in Python by using regular expressions
## ===============================================================================================================

def read_tweets_file_with_regex(file_path):
    
    # Initialize a defaultdict to store lists of coordinates for each user
    records = defaultdict(list)

    # Define regular expressions
    user_id_regex = r'"user":\s*\{"id":\s*(\d+)'
    geo_coordinate_regex = r'"geo":\s*\{"type":\s*"Point",\s*"coordinates":\s*\[([\-0-9.]+),\s*([\-0-9.]+)\]\}'

    # Open the file in read mode
    with open(file_path, 'r') as file:
        
        # Iterate through each line in the file
        for line in file:

            # Extract the user ID and geolocation from the tweet using regular expressions
            user_id_match = re.search(user_id_regex, line)
            geo_match = re.search(geo_coordinate_regex, line)

            if user_id_match and geo_match:
                user_id = int(user_id_match.group(1))
                longitude = float(geo_match.group(1))
                latitude = float(geo_match.group(2))
                records[user_id].append((longitude, latitude))
    
    # Initialize an empty dictionary
    result = {}

    # Find the minimum longitude and maximum latitude for each user's tweets
    for user_id, coordinates in records.items():
        min_longitude = min(coordinate[0] for coordinate in coordinates)
        max_latitude = max(coordinate[1] for coordinate in coordinates)
        result[user_id] = {'MinLongitude': min_longitude, 'MaxLatitude': max_latitude}
    
    return result


# Part 2-f
## Re-execute the query in Part 2-e 5 times and 25 times and measure the total runtime. 
## ===============================================================================================================

def measure_query_runtime3(file_path, execution_counts):
    
    # Initialize a list to store the runtime for each number of executions
    runtime_list = []
    
    # Loop through different numbers of executions to measure the query runtime
    for runs in execution_counts:
        
        # Record the start time
        start_time = time.time()
        
        for _ in range(runs):
            read_tweets_file_with_regex(file_path)
        
        # Record the end time
        end_time = time.time()
        
        # Calculate the runtime
        runtime = end_time - start_time

        # Append to the list
        runtime_list.append(runtime)
    
    return runtime_list

runtimes = measure_query_runtime3(text_file_path2, [5, 25])

print()
print("Part 2-f")
print("-" * 100)
for runs, runtime in zip([5, 25], runtimes):
    print(f"Runtime for {runs} executions: {runtime:.2f} seconds")
    if runs == 25:
        expected_runtime = runtimes[0] * 5
        if abs(runtime - expected_runtime) < 0.1 * expected_runtime:
            print("Runtime scales linearly")
        else:
            print("Runtime does not scale linearly")
print("=" * 100)



# Part 3
## ===============================================================================================================

# Import library
import sqlite3
import json
import csv
import os

# Define path
json_file_path = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File\\750000_tweets.json"
csv_file_path1 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File"
csv_file_path2 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File\\Tweet.csv"
csv_file_path3 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File\\User.csv"
csv_file_path4 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File\\Geo.csv"
csv_file_path5 = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\Databases for Analytics\\DSC 450 - Week 11\\Data File\\Pre_Join.csv"


## Part 3-a
## Create a new table that corresponds to the join of all tables in the database
## ===============================================================================================================

def create_pre_join_table(database_path):

    # Connect to the database
    conn = sqlite3.connect(database_path)
    c = conn.cursor()
    
    # # Write a query based on the given conditions
    query = """CREATE TABLE Pre_Join AS
                 SELECT User.id AS user_id,
                        User.name AS user_name,
                        User.screen_name AS user_screen_name,
                        User.description AS user_description,
                        User.friends_count AS user_friends_count,
                        Geo.type AS geo_type,
                        Geo.longitude AS geo_longitude,
                        Geo.latitude AS geo_latitude,
                        Geo.id AS geo_id,
                        Tweet.created_at AS tweet_created_at,
                        Tweet.id_str AS tweet_id_str,
                        Tweet.text AS tweet_text,
                        Tweet.source AS tweet_source,
                        Tweet.in_reply_to_status_id AS tweet_in_reply_to_status_id,
                        Tweet.in_reply_to_user_id AS tweet_in_reply_to_user_id,
                        Tweet.in_reply_to_screen_name AS tweet_in_reply_to_screen_name,
                        Tweet.contributors AS tweet_contributors,
                        Tweet.retweet_count AS tweet_retweet_count
                   FROM Tweet
                        LEFT JOIN User ON Tweet.user_id = User.id
                        LEFT JOIN Geo ON Tweet.geo_id = Geo.id;"""
    
    # Execute query
    c.execute(query)

    # Commit and close the connection
    conn.commit()
    conn.close()

create_pre_join_table(database_path6)

print()
print("Part 3-a")
print("-" * 100)
print("Pre-Join table has been created")
print("=" * 100)


## Part 3-b
## Export the Tweet table, User table, Geo table, and the new PreJoin table from 3-a into a new JSON file
## ===============================================================================================================

def export_tables_to_json(database_path, json_file_path):

    # Connect to the database
    conn = sqlite3.connect(database_path)
    c = conn.cursor()
    
    # Define the list of tables to be exported
    tables = ["Tweet", "User", "Geo", "Pre_Join"]

    # Dictionary to store table data
    data = {}
    
    for table in tables:

        # Execute a query
        c.execute(f"SELECT * FROM {table}")

        # Fetch column names for the current table
        columns = [description[0] for description in c.description]
        
        # Fetch all rows from the current table
        rows = c.fetchall()
        
        # Combine column names and rows
        data[table] = [dict(zip(columns, row)) for row in rows]
    
    # Close the connection
    conn.close()
    
    # Write a JSON file
    with open(json_file_path, 'w') as json_file:
        json.dump(data, json_file)
    
export_tables_to_json(database_path6, json_file_path)

print()
print("Part 3-b")
print("-" * 100)
print("Contents of tables have been exported to JSON file")
print("=" * 100)


## Part 3-c
## Export the Tweet table, User table, Geo table, and the new PreJoin table from 3-a into a csv file
## ===============================================================================================================

def export_tables_to_csv(database_path, csv_file_path):

    # Connect to the database
    conn = sqlite3.connect(database_path)
    c = conn.cursor()
    
    # Define the list of tables to be exported
    tables = ["Tweet", "User", "Geo", "Pre_Join"]
    
    for table in tables:

        # Execute a query
        c.execute(f"SELECT * FROM {table}")
        
        # Fetch column names for the current table
        columns = [description[0] for description in c.description]

        # Fetch all rows from the current table
        rows = c.fetchall()
        
        # Write to CSV file for each table
        file_path = f"{csv_file_path}/{table}.csv"
        with open(file_path, 'w', newline = '', encoding = 'utf-8') as csv_file:
            writer = csv.writer(csv_file)
            writer.writerow(columns)
            writer.writerows(rows)
    
    # Close the connection
    conn.close()

export_tables_to_csv(database_path6, csv_file_path1)

print()
print("Part 3-c")
print("-" * 100)
print("Contents of tables have been exported to CSV file")
print("=" * 100)


## Part 3-d
## Compare the file sizes in 3-b and 3-c as well as the sum of the individual tables
## ===============================================================================================================

# List of file paths
files = [json_file_path, csv_file_path2, csv_file_path3, csv_file_path4, csv_file_path5]
file_names = ['750000_tweets.json', 'Tweet.csv', 'User.csv', 'Geo.csv', 'Pre_Join.csv']

# Variable to accumulate the total size of CSV files
csv_total_size = 0

print()
print("Part 3-d")
print("-" * 100)
for file, file_name in zip(files, file_names):
    file_size = os.path.getsize(file) / (1024 * 1024)
    if file_name.endswith('.csv'):
        csv_total_size += file_size
    print(f"Size of {file_name}: {file_size:.2f} MB")
print(f"Size of the sum of CSV files: {csv_total_size:.2f} MB")
print("=" * 100)
