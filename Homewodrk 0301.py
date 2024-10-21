# Part 2-a

# Import library
import sqlite3

# File paths
db_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0301-1.db"
animal_txt_file_path = r'C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 3\\Data File\\animal.txt'

# Create the Animal table
CREATE_TABLE_Animal1 = """CREATE TABLE Animal
(
  AID NUMBER(3, 0),
  AName VARCHAR2(30) NOT NULL,
  ACategory VARCHAR2(18),
  TimeToFeed NUMBER(4,2),

  CONSTRAINT Animal_PK
     PRIMARY KEY(AID)
); """

# List to insert
animals_list = ["INSERT INTO Animal VALUES(1, 'Galapagos Penguin', 'exotic', 0.5);",
                "INSERT INTO Animal VALUES(2, 'Emperor Penguin', 'rare', 0.75);",
                "INSERT INTO Animal VALUES(3, 'Sri Lankan sloth bear', 'exotic', 2.5);",
                "INSERT INTO Animal VALUES(4, 'Grizzly bear', 'common', 3.0);",
                "INSERT INTO Animal VALUES(5, 'Giant Panda bear', 'exotic', 1.5);",
                "INSERT INTO Animal VALUES(6, 'Florida black bear', 'rare', 1.75);",
                "INSERT INTO Animal VALUES(7, 'Siberian tiger', 'rare', 3.25);",
                "INSERT INTO Animal VALUES(8, 'Bengal tiger', 'common', 2.75);",
                "INSERT INTO Animal VALUES(9, 'South China tiger', 'exotic', 2.5);",
                "INSERT INTO Animal VALUES(10, 'Alpaca', 'common', 0.25);",
                "INSERT INTO Animal VALUES(11, 'Llama', NULL, 3.5);"]

conn = sqlite3.connect(db_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database
c.execute(CREATE_TABLE_Animal1) # Create the Animal table

# Insert the records
for list in animals_list:
    c.execute(list)

# Query the table
animal_table = c.execute('SELECT * FROM Animal')
animal_table_records = animal_table.fetchall()

# Write a text file
with open(animal_txt_file_path, 'w') as file:
    for record in animal_table_records:
        file.write(', '.join(map(str, record)) + '\n')

conn.commit() # Commit all the changes
conn.close() # Close the connection

# Part 2-b

# File paths
db_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Homework 0301-2.db"
animal_txt_file_path = r'C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 3\\Data File\\animal.txt'

# Create the Animal table
CREATE_TABLE_Animal2 = """CREATE TABLE Animal
(
  AID NUMBER(3, 0),
  AName VARCHAR2(30) NOT NULL,
  ACategory VARCHAR2(18),
  TimeToFeed NUMBER(4,2),

  CONSTRAINT Animal_PK
     PRIMARY KEY(AID)
); """

conn = sqlite3.connect(db_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database
c.execute(CREATE_TABLE_Animal2) # Create the Animal table

# Load data from the txt file
with open(animal_txt_file_path, 'r') as file:
    animal_table_records = [line.strip().split(', ') for line in file]

# Insert records into the table
c.executemany("INSERT INTO Animal VALUES (?, ?, ?, ?);", animal_table_records)

# Verify how many rows were loaded
record_count = c.execute("SELECT COUNT(*) FROM Animal;").fetchone()[0]
print(f"Number of rows loaded: {record_count}")

conn.commit() # Commit all the changes
conn.close() # Close the connection
