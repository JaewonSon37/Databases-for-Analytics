-- Part 1-a

/*
DROP TABLE Write;
DROP TABLE Book;
DROP TABLE Publisher;
DROP TABLE Author;
*/

CREATE TABLE Author
(
  LastName VARCHAR2(20),
  FirstName VARCHAR2(20),
  ID NUMBER(5, 0),
  BirthDate DATE,

  CONSTRAINT Author_PK
     PRIMARY KEY(ID)
);
  
CREATE TABLE Publisher
(
  Name VARCHAR2(50),
  PublisherNumber NUMBER(4, 0),
  Address VARCHAR2(100),
  
  CONSTRAINT Publisher_PK
     PRIMARY KEY(PublisherNumber)
); 
 
CREATE TABLE Book
(
  ISBN VARCHAR2(8),
  Title VARCHAR2(150),
  PublisherID NUMBER(4, 0),
  
  CONSTRAINT Book_PK
     PRIMARY KEY(ISBN),

  CONSTRAINT Book_FK
     FOREIGN KEY (PublisherID)
       REFERENCES Publisher(PublisherNumber),     
     
  CONSTRAINT Book_ISBN_Length
     CHECK (LENGTH(ISBN) = 8)
); 
 
CREATE TABLE Write
(
  AuthorID NUMBER(5, 0),
  ISBN VARCHAR2(8),
  Position NUMBER(*, 0),
  
  CONSTRAINT Write_PK
     PRIMARY KEY(AuthorID, ISBN),

  CONSTRAINT Write_FK1
     FOREIGN KEY (AuthorID)
       REFERENCES Author(ID),     
  
  CONSTRAINT Write_FK2
     FOREIGN KEY (ISBN)
       REFERENCES Book(ISBN),     
         
  CONSTRAINT Write_ISBN_Length
     CHECK (LENGTH(ISBN) = 8)
); 

INSERT INTO Author VALUES ('Son', 'Jaewon', 7759, to_date('March 07, 1998', 'Month DD, YYYY'));
INSERT INTO Author VALUES ('Seo', 'Jiyoung', 7255, to_date('May 17 1998', 'Month DD, YYYY'));
INSERT INTO Author VALUES ('Jin', 'Jessica', 4863, to_date('March 13 1999','Month DD, YYYY'));

INSERT INTO Publisher VALUES ('The New York Times', 311, '620 Eighth Avenue, New York NY');
INSERT INTO Publisher VALUES ('Chicago Tribune', 312, '777 West Chicago Avenue, Chicago, IL');

INSERT INTO Book VALUES ('9782-020', 'Databases for Analytics', 311);
INSERT INTO Book VALUES ('7580-981', 'Advanced Machine Learning', 312);
INSERT INTO Book VALUES ('8785-489', 'Python Programming', 312);

INSERT INTO Write VALUES (7759, '9782-020', 1);
INSERT INTO Write VALUES (7255, '7580-981', 1);
INSERT INTO Write VALUES (4863, '8785-489', 2);
INSERT INTO Write VALUES (7759, '8785-489', 1);

SELECT * FROM Author;
SELECT * FROM Publisher;
SELECT * FROM Book;
SELECT * FROM Write;


-- Part 1-b

/*
DROP TABLE Write;
DROP TABLE Book;
DROP TABLE Publisher;
DROP TABLE Author;
*/

INSERT INTO Author VALUES ('King', 'Stephen', 2, to_date('September 09, 1947', 'Month DD, YYYY'));
INSERT INTO Author VALUES ('Asimov', 'Isaac', 4, to_date('January 02, 1921', 'Month DD, YYYY'));
INSERT INTO Author VALUES ('Verne', 'Jules', 7, to_date('February 08, 1828', 'Month DD, YYYY'));
INSERT INTO Author VALUES ('Shelley', 'Mary', 37, to_date('August 30, 1797', 'Month DD, YYYY'));

INSERT INTO Publisher VALUES ('Bloomsbury Publishing', 17, 'London Borough of Camden');
INSERT INTO Publisher VALUES ('Arthur A Levine Books', 18, 'New York City');

INSERT INTO Book VALUES ('1111-111', 'Databases from Outer Space', 17);
INSERT INTO Book VALUES ('2223-233', 'Revenge of the SQL', 17);
INSERT INTO Book VALUES ('3333-323', 'The Night of the Living Databases', 18);

INSERT INTO Write VALUES (2, '1111-111', 1);
INSERT INTO Write VALUES (4, '1111-111', 2);
INSERT INTO Write VALUES (4, '2223-233', 1);
INSERT INTO Write VALUES (7, '2223-233', 2);
INSERT INTO Write VALUES (37, '3333-323', 1);
INSERT INTO Write VALUES (2, '3333-323', 2);

SELECT LastName, FirstName, ID, TO_CHAR(BirthDate, 'DD-MON-YYYY') AS BirthDate
FROM Author;
SELECT * FROM Publisher;
SELECT * FROM Book;
SELECT * FROM Write;


-- Part 1-c

/*
DROP TABLE Student;
DROP TABLE Advisor;
DROP TABLE Department;
*/

CREATE TABLE Department
(
  Name VARCHAR2(20),
  Chair VARCHAR2(40),
  College VARCHAR2(50),
  
  CONSTRAINT Department_PK
     PRIMARY KEY(Name)
); 

CREATE TABLE Advisor
(
  ID NUMBER(4, 0),
  Name VARCHAR2(40),
  Address VARCHAR2(100),
  ResearchArea VARCHAR2(20),
  ReferenceLink VARCHAR2(20),
  
  CONSTRAINT Advisor_PK
     PRIMARY KEY(ID),

  CONSTRAINT Advisor_FK
     FOREIGN KEY (ReferenceLink)
       REFERENCES Department(Name)
); 

CREATE TABLE Student
(
  StudentID NUMBER(7, 0),
  FirstName VARCHAR2(20),
  LastName VARCHAR2(20),
  DateOfBirth DATE,
  Telephone VARCHAR2(12),
  Reference NUMBER(4, 0),
  
  CONSTRAINT Student_PK
     PRIMARY KEY(StudentID),

  CONSTRAINT Student_FK
     FOREIGN KEY (Reference)
       REFERENCES Advisor(ID),       
         
  CONSTRAINT Student_Telephone_Length
     CHECK (LENGTH(Telephone) = 12)
); 

INSERT INTO Department VALUES ('Science', 'Dr. Tony Stark', 'College of Science and Health');

INSERT INTO Advisor VALUES (0810, 'Peter Parker', '1764 N Clark St, Chicago, IL', 'Physics', 'Science');
INSERT INTO Advisor VALUES (0210, 'Wanda Maximoff', '2041 N Kimball Ave, Chicago, IL', 'Telekinetic', 'Science');

INSERT INTO Student VALUES (2163284, 'Jaewon', 'Son', to_date('March 07, 1998', 'Month DD, YYYY'), '989.621.7759', 0210);
INSERT INTO Student VALUES (2114854, 'Jiyoung', 'Seo', to_date('May 17, 1998', 'Month DD, YYYY'), '989.854.7255', 0810);
INSERT INTO Student VALUES (2654871, 'Jessica', 'Seo', to_date('March 13, 1999', 'Month DD, YYYY'), '989.444.4863', 0210);

SELECT StudentID, FirstName, LastName, TO_CHAR(DateOfBirth, 'DD-MON-YYYY') AS BirthDate, Telephone, Reference
FROM Student;
SELECT * FROM Advisor;
SELECT * FROM Department;
