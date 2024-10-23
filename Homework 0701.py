# Part 1-a
## Write a function to generate a list of x random numbers between 39 and 100
## ==========================================================================================================

# Import library
import random

# Function to generate a list of random numbers between 39 and 100
def random_number_generater(x):

    # Initialize a list
    random_number_list = []

    # Loop to generate random numbers
    for i in range(x):
        random_number = random.randint(39, 100) # Generate a random number between 39 and 100
        random_number_list.append(random_number) # Append the generated number to the list
    
    return random_number_list


# Part 1-b
## Create a list of 90 random numbers and determine how many of the numbers are below 55 using pd.Series
## ==========================================================================================================

# Import library
import pandas as pd

# Generate 90 random numbers
random_numbers = random_number_generater(90)

# Convert to Pandas Series
random_numbers_series = pd.Series(random_numbers)

# Count numbers below 55
count_number_below_55 = random_numbers_series[random_numbers_series < 55].count()
print()
print(f"{count_number_below_55} random numbers are below 55.")


# Part 1-c
## Create an 8x10 numpy array with 80 random numbers and replace numbers greater than or equal to 55 with 55
## ==========================================================================================================

# Import library
import numpy as np

# Generate 80 random numbers
random_numbers = random_number_generater(80)

# Convert to a NumPy array
random_numbers_array = np.array(random_numbers)

# Reshape the array to 8x10
reshaped_random_numbers_array = random_numbers_array.reshape(8, 10)

# Replace all numbers greater than or equal to 55 with 55
reshaped_random_numbers_array[reshaped_random_numbers_array >= 55] = 55
print()
print("Modified Random Number Array:")
print(reshaped_random_numbers_array)



# Part 2-a
## Modify Module5 table and create User table
## ==========================================================================================================

# Import library
import sqlite3
import json

# Define file paths
database_path1 = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0701-1.db"
database_path2 = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0701-2.db"

# Create the User table
User_table = """CREATE TABLE User
(
  id INTEGER,
  name TEXT,
  screen_name TEXT,
  description TEXT,
  friends_count INTEGER
);"""

conn1 = sqlite3.connect(database_path1) # Connect to the database
c1 = conn1.cursor() # Create a cursor object to interact with the database
c1.execute(User_table) # Create the User table
conn1.commit() # Commit all the changes

# Create the Modified_Module5 table
Modified_Module5_Table = """CREATE TABLE Modified_Module5
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

  CONSTRAINT Modified_Module5_FK
     FOREIGN KEY(user_id)
       REFERENCES User(id)
);"""

conn2 = sqlite3.connect(database_path2) # Connect to the database
c2 = conn2.cursor() # Create a cursor object to interact with the database
c2.execute(Modified_Module5_Table) # Create the User table
conn2.commit() # Commit all the changes


# Part 2-b
## Read and load the Module7 text file directly from the web. Next, populate both tables
## ==========================================================================================================

# Import library
import urllib.request

# URL to the dataset
url = 'http://dbgroup.cdm.depaul.edu/DSC450/Module7.txt'

# Open file to store problematic tweets
error_file_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 7\\Data File\\Module7_errors.txt"
error_file = open(error_file_path, 'w', encoding = 'utf-8')

# Initialize lists to hold valid tweets and damaged tweets
valid_tweets = []
damaged_tweets = []

# Open the URL and read the content
with urllib.request.urlopen(url) as response:

    for tweet in response:

        try:
            tdict = json.loads(tweet.decode('utf8')) # Try to parse the JSON
            valid_tweets.append(tdict) 

        except ValueError:
            damaged_tweets.append(tweet.decode('utf8'))

# Write damaged tweets to the Module7_errors.txt file
for damaged_tweet in damaged_tweets:
    error_file.write(damaged_tweet + '\n')

error_file.close() # Close the connection

# Populate the User and Module5 tables
for tweet in valid_tweets:

    # Insert record into the User table
    c1.execute("INSERT INTO User VALUES (?, ?, ?, ?, ?)",
              (tweet.get('user', {}).get('id'),
               tweet.get('user', {}).get('name'),
               tweet.get('user', {}).get('screen_name'),
               tweet.get('user', {}).get('description'),
               tweet.get('user', {}).get('friends_count')))

    # Insert record into the Module5 table
    c2.execute("INSERT INTO Modified_Module5 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
              (tweet.get('created_at'), 
               tweet.get('id_str'), 
               tweet.get('text'), 
               tweet.get('source'), 
               tweet.get('in_reply_to_status_id'), 
               tweet.get('in_reply_to_user_id'), 
               tweet.get('in_reply_to_screen_name'), 
               tweet.get('contributors'), 
               tweet.get('retweet_count'), 
               tweet.get('user', {}).get('id')))
    
    conn1.commit() # Commit all the changes
    conn2.commit() # Commit all the changes

# Fetch records from the User table
print()
print("User Table Records:")
c1.execute("SELECT * FROM User LIMIT 3")
for record in c1.fetchall():
    print(record)

# Fetch records from the Module5 table
print()
print("Modified Module5 Table Records:")
c2.execute('SELECT * FROM Modified_Module5 LIMIT 3')
for record in c2.fetchall():
    print(record)

conn1.commit() # Commit all the changes
conn2.commit() # Commit all the changes
conn1.close() # Close the connection
conn2.close() # Close the connection



# Part 3-b
## Write a regular expression and create the code to validate that the regular expression works
## ==========================================================================================================

# Import library
import re

# Regular expression for validating credit card numbers
credit_card_number_regex = re.compile("^(\d{4}-?\d{4}-?\d{4}-?\d{4})$")

# Example samples
example_samples = ['9239-9239-9239-9239',
                   '9239923992399239',
                   '9239-9239-9239-923',
                   '9239-9239-9239-92399',
                   ' 9239-9239-9239-9239 ',
                   '9239-9239-9239-923S']

# Function to validate a credit card number
def validate_credit_card_number(credit_card_number):

    # Check if the credit card number matches the regular expression
    if re.match(credit_card_number_regex, credit_card_number):
        return True
    
    return False

print()
print("Credit Card Number Validation Test:")
for credit_card_number in example_samples:
    validated_credit_card_number = validate_credit_card_number(credit_card_number)
    print(f"{credit_card_number}: {'Valid' if validated_credit_card_number else 'Invalid'}")
