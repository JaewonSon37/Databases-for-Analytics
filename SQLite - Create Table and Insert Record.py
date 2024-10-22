import sqlite3

db_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Tutorial 0301.db"
conn = sqlite3.connect(db_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Create the Student table
Student_Table = """CREATE TABLE Student
(
  ID VARCHAR(5),
  Name VARCHAR(25),
  Standing VARCHAR(8),  
  CONSTRAINT Student_PK
     PRIMARY KEY(ID)
); """

c.execute(Student_Table)
c.execute("INSERT INTO Student VALUES ('12345', 'Paul K', 'Grad');"); # Insert record

# Create the Course table
Course_Table = """CREATE TABLE Course
(
  CourseID VARCHAR(15),
  Name VARCHAR(50),
  Credits INTEGER,
  CONSTRAINT Course_PK
     PRIMARY KEY( CourseID)
); """

c.execute(Course_Table)
c.execute("INSERT INTO Course VALUES ('CSC451', 'Database Design', 4);"); # Insert record

# New dataset
new_student_data =[['23456', 'Larry P', 'Grad'],
                   ['34567', 'Ana B', 'Ugrad'],
                   ['45678', 'Mary Y', 'Grad'],
                   ['56789', 'Pat B', 'Ugrad']]

# Insert the first row
larry = new_student_data[0]
c.execute("INSERT INTO Student VALUES (?, ?, ?);", larry);

# Insert the other rows
otherThreeStudents = new_student_data[1:]
c.executemany("INSERT INTO Student VALUES (?, ?, ?);", otherThreeStudents);

conn.commit() # Commit all the changes
conn.close() # Close the connection
