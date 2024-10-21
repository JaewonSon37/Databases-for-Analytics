# Part 4
## Create the schema with at least 5 students, 4 courses, and 7 enrollments

# Import library
import sqlite3

# Define paths
database_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Midterm 0601.db"
file_path = 'C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 6\\Data File\\student_records.txt'

# Create the Student table
Student_Table = """
CREATE TABLE Student(
  
  StudentID INTEGER,
  Name VARCHAR2(30),	
  Address VARCHAR2(100),
  GradYear INTEGER,

  CONSTRAINT Student_PK
     PRIMARY KEY(StudentID),

  CONSTRAINT StudentID_CHECK
     CHECK(StudentID BETWEEN 0000000 AND 9999999),

  CONSTRAINT GradYear_CHECK
     CHECK(GradYear BETWEEN 1950 AND 2050));
"""

# Records for Student table
student = [(6558461, 'Jiyoung Seo', '628 W Broomfield St, Mount Pleasant', 2024),
           (2163284, 'Jaewon Son', '2041 N Kimball Ave, Chicago', 2025),
           (3351847, 'Marco Reus', '18400 Avalon Blvd, Carson', 2025),
           (4515178, 'Toni Kroos', '1410 Special Olympics Dr, Chicago', 2025),
           (1487465, 'Lionel Messi', '1350 NW 55th St, Fort Lauderdale', 2026)]

# Create the Course table
Course_Table = """
CREATE TABLE Course(

  CName VARCHAR2(50),
  Department VARCHAR2(30),	
  Credits INTEGER,
  
  CONSTRAINT Course_PK
     PRIMARY KEY(CName),

  CONSTRAINT Credits_CHECK
     CHECK(Credits BETWEEN 1 AND 4));
"""

# Records for Course table
course = [('Database 450', 'Data Science', 4),
          ('Applied Statistic 411', 'Mathematics', 3),
          ('Python Programming 423', 'Computer Science', 3),
          ('Deep Learning and AI 555', 'Data Science', 4)]
   
# Create the Grade table
Grade_Table = """
CREATE TABLE Grade(

  CName VARCHAR2(50),
  StudentID INTEGER,
  CGrade DECIMAL(3, 2),

  CONSTRAINT Grade_PK
     PRIMARY KEY(CName, StudentID),

  CONSTRAINT Grade_FK1
     FOREIGN KEY(CName)
       REFERENCES Course(CName),

  CONSTRAINT Grade_FK2
     FOREIGN KEY(StudentID)
       REFERENCES Student(StudentID),

  CONSTRAINT StudentID_CHECK
     CHECK(StudentID BETWEEN 0 AND 9999999),

  CONSTRAINT CGrade_CHECK
     CHECK(CGrade BETWEEN 0.0 AND 4.0));
"""

# Records for Grade table
grade = [('Database 450', 6558461, 3.5),
         ('Database 450', 2163284, 4.0),
         ('Python Programming 423', 2163284, 4.0),
         ('Database 450', 3351847, 3.7),
         ('Python Programming 423', 4515178, 2.8),
         ('Applied Statistic 411', 4515178, 3.9),
         ('Python Programming 423', 3351847, 3.6)]

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Create the tables
c.execute(Student_Table) 
c.execute(Course_Table)
c.execute(Grade_Table)  

# Insert records into tables
c.executemany("""INSERT INTO Student (StudentID, Name, Address, GradYear) VALUES (?, ?, ?, ?);""", student)
c.executemany("""INSERT INTO Course (CName, Department, Credits) VALUES (?, ?, ?);""", course)
c.executemany("""INSERT INTO Grade (CName, StudentID, CGrade) VALUES (?, ?, ?);""", grade)

conn.commit() # Commit all the changes
conn.close() # Close the connection

# Part 4-a
## Create a view that joins the three tables, including all of the records from the Student table

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Create the view
c.execute("""
          CREATE VIEW Student_Record AS
            SELECT Student.StudentID, Student.Name, Student.Address, Student.GradYear,
                   Course.CName, Course.Department, Course.Credits, Grade.CGrade
              FROM Student
                   LEFT JOIN Grade ON Student.StudentID = Grade.StudentID
                   LEFT JOIN Course ON Grade.CName = Course.CName;
          """)

# Query the view
c.execute("""SELECT * FROM Student_Record;""")
student_record = c.fetchall()
print("\nStudent Records:")
for record in student_record:
    print(record)

conn.commit() # Commit all the changes
conn.close() # Close the connection

# Part 4-b
## Write and execute Python code that uses the view to export all data into a single text file

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Query the view
c.execute("""SELECT * FROM Student_Record;""")
student_record = c.fetchall()

# Open a text file and write records
with open (file_path, 'w') as file:
    file.write('StudentID\tName\tAddress\tGradYear\tCName\tDepartment\tCredits\tCGrade\n')
    for line in student_record:
        file.write('\t'.join([str(item) if item is not None else 'NULL' for item in line]) + '\n')

conn.commit() # Commit all the changes
conn.close() # Close the connection

print()
print("Student records are successfully exported to student_records.txt.")

# Part 4-c
## Add a new row to the de-normalized text file that violates the functional dependency

# New record to violates the functional dependency
new_student_record = '3351847\tMarco Reus\t18400 Avalon Blvd, Carson\t2025\tPython Programming 423\tComputer Science\t4\t3.6\n'

# Open the text file and add the new row
with open (file_path, 'a') as file:
    file.write(new_student_record)

print()
print("New record is successfully added to student_records.txt.")

# Part 4-d
## Write Python code that will identify the values for which functional dependency was violated in the text file

# Function to check for functional dependency violations
def functional_dependency_violation_identifier(file_path):

    with open(file_path, 'r') as file:

        header = file.readline().strip().split('\t') # Read the header
        course_name_index = header.index('CName') # Get the index for CName
        course_credit_index = header.index('Credits') # Get the index for Credits
        
        # Initialize a dictionary
        course_name_and_credit = {} 

        for record in file:
            value = record.strip().split('\t')
            course_name = value[course_name_index] # Extract the course name
            course_credit = value[course_credit_index] # Extract the credit

            # Add the course name and its credit if the course name is not already in the dictionary
            if course_name not in course_name_and_credit:
                    course_name_and_credit[course_name] = course_credit

            # Report a violation if the course name already exists in the dictionary but credits are different
            elif course_name_and_credit[course_name] != course_credit:
                    print()
                    print("Functional Dependency Violation Found:")
                    print(f"'{course_name}' has different credits: {course_name_and_credit[course_name]} and {course_credit}")

functional_dependency_violation_identifier(file_path)

# Part 4-e1
## Use the view from Part 4-a to re-write the query

conn = sqlite3.connect(database_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Create the view
c.execute("""
          SELECT Department, AVG(GradYear) AS Average_Graduation_Year_by_Department
            FROM Student_Record
            GROUP BY Department;
          """)

# Query the view
average_graduation_year_by_department = c.fetchall()
print("\nAverage Graduation Year by Department:")
for record in average_graduation_year_by_department:
    print(record)

conn.commit() # Commit all the changes
conn.close() # Close the connection

# Part 4-e2
## Use the text file containing de-normalized data from Part 4-b to answer the query with Python

# Function to calculate average graduation year by department
def calculate_average_graduation_year(file_path):
    
    with open(file_path, 'r') as file:
        
        header = file.readline().strip().split('\t')  # Read the header
        department_index = header.index('Department')  # Get index for Department
        graduation_year_index = header.index('GradYear')  # Get index for GradYear
        
        # Initialize a dictionary
        department_and_graduation_year = {}
        
        for record in file:
            value = record.strip().split('\t')
            department = value[department_index] # Extract the department
            graduation_year = value[graduation_year_index] # Extract the graduation year

            if department and graduation_year:
                graduation_year = int(graduation_year)
                
                # Initialize the dictionary entry
                if department not in department_and_graduation_year:
                    department_and_graduation_year[department] = {'total': 0, 'count': 0}
                
                # Update graduation years and the count
                department_and_graduation_year[department]['total'] += graduation_year
                department_and_graduation_year[department]['count'] += 1

        print()
        print("Average Graduation Year by Department:")
        
        # Calculate the average graduation year for each department
        for department, total_and_count in department_and_graduation_year.items():
            average_graduation_year = total_and_count['total'] / total_and_count['count']
            print(f"{department}: {average_graduation_year:.2f}")

calculate_average_graduation_year(file_path)
