import sqlite3

db_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Tutorial 0301.db"
conn = sqlite3.connect(db_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Fetch records from a table
result = c.execute('SELECT * FROM Student')
print(result.fetchone())
print(result.fetchall())

result = c.execute('SELECT * FROM Student')
print(result.fetchall())

# Read records from a text file
file_path = 'C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 3\\Data File\\students.txt'
file_descriptor = open(file_path, 'r')

# Print the first line
first_line = file_descriptor.readline() 
print(first_line)

# Print the second line
second_line = file_descriptor.readline()
print(second_line)

# Print every line 1
file_descriptor.seek(0)
every_line1 = file_descriptor.readlines()
for line in every_line1:
    print(line)

# Print every line 2
file_descriptor.seek(0)
every_line2 = file_descriptor.read().split('\n')
every_line2 = every_line2[:-1]
for line in every_line2:
    values = line.split(', ')
    print(values)

file_descriptor.close()  # Close the file  
conn.commit() # Commit all the changes
conn.close() # Close the connection
