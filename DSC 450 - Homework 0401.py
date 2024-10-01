# Part 1.B

# Define the file path
file_path = "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 4\\Data File\\animal.txt"
    
# Open the file and read each line
with open(file_path, 'r') as file:
        record = [line.strip().split(', ') for line in file.readlines()]
    
# Define the headers
headers = ['Animal_ID', 'Animal_Name', 'Animal_Category', 'Feeding_Time']

# Create a list of dictionaries
animals_dict = [dict(zip(headers, row)) for row in record[1:]]


# Part 1.B-a
## Find the names of the animals and categories for animals not related to a bear

# Function to find the names of animals and categories
def not_related_to_bear(animals_dict):
    
    # Initialize an empty list
    animals_not_related_to_bear_list = []

    # Filter animal records with given condition
    for animal in animals_dict:
        if 'bear' not in animal['Animal_Name']:
            animals_not_related_to_bear_list.append((animal['Animal_Name'], animal['Animal_Category']))
    
    # Return the filtered list
    return animals_not_related_to_bear_list

# Call the function
animals_not_related_to_bear = not_related_to_bear(animals_dict)

# Print the result
print("\nAnimal Name / Animal Category")
for name, category in animals_not_related_to_bear:
    print(name, "/", category)


# Part 1.B-b
## Find the names of the animals that are related to the tiger and are not common

# Function to find the names of animals and categories
def related_to_tiger_and_not_common(animals_dict):
    
    # Initialize an empty list
    related_to_tiger_and_not_common_list = []

    # Filter animal records with given condition
    for animal in animals_dict:
        if 'tiger' in animal['Animal_Name'] and animal['Animal_Category'] != 'common':
            related_to_tiger_and_not_common_list.append((animal['Animal_Name'], animal['Animal_Category']))

    # Return the filtered list
    return related_to_tiger_and_not_common_list

# Call the function                  
animals_related_to_tiger_and_not_common = related_to_tiger_and_not_common(animals_dict)

# Print the result
print("\nAnimal Name / Animal Category")
for name, category in animals_related_to_tiger_and_not_common:
    print(name, "/", category)



# Part 2-c
## Write a script that is going to create tables and populate them with data automatically
    
# Import library
import sqlite3

# Define File paths
db_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0401.db"
file_path = 'C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 4\\Data File\\data_module4_part2.txt'

# Create the Person table
Person_Table = """CREATE TABLE Person
(
  First VARCHAR2(50),
  Last VARCHAR2(50),
  Address VARCHAR2(100),
  
  CONSTRAINT Person_PK
     PRIMARY KEY(First, Last)
);"""

# Create the Job table
Job_Table = """CREATE TABLE Job
(
  Job VARCHAR2(100),
  Salary NUMBER(10, 2),
  Assistant VARCHAR2(3),
  
  CONSTRAINT Job_PK
     PRIMARY KEY(Job)
);"""

conn = sqlite3.connect(db_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database
c.execute(Person_Table) # Create the Person table
c.execute(Job_Table) # Create the Job table

# Read records from a text file and insert it into the tables
with open(file_path, 'r') as file:
    for line in file:
        record = line.strip().split(', ')
        record = [None if value == 'NULL' else value for value in record]
        c.execute("INSERT OR IGNORE INTO Person VALUES(?, ?, ?)", record[:3]);
        c.execute("INSERT OR IGNORE INTO Job VALUES(?, ?, ?)", record[3:]);

# Fetch and print records from Person table
c.execute("SELECT * FROM Person")
person_records = c.fetchall()
print("\nPerson Table Records:")
for record in person_records:
    print(record)

# Fetch and print records from Job table
c.execute("SELECT * FROM Job")
job_records = c.fetchall()
print("\nJob Table Records:")
for record in job_records:
    print(record)

conn.commit() # Commit all the changes
conn.close() # Close the connection


# Part 2-d
## Verify that NULLs are loaded correctly

conn = sqlite3.connect(db_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Fetch records from a table
salary_null = c.execute("SELECT * FROM Job WHERE Salary IS NULL") # Execute the query
print("\n", salary_null.fetchall())

conn.close() # Close the connection
