-- Part 3

-- Drop Tables
DROP TABLE Memberof;
DROP TABLE Enrolled;
DROP TABLE StudentGroup;
DROP TABLE Course3;
DROP TABLE Student3;

-- Create Tables
CREATE TABLE Student3 
(
  LastName VARCHAR(40),
  FirstName VARCHAR(40),
  SID NUMBER(5),
  SSN NUMBER(9),
  Career VARCHAR(4),
  Program VARCHAR(10),
  City VARCHAR(40),
  Started NUMBER(4),

  CONSTRAINT Student3_PK
	 PRIMARY KEY (SID),

  UNIQUE (SSN)
);

CREATE TABLE Course3
(
  CID NUMBER(4),
  CourseName VARCHAR(40),
  Department VARCHAR(4),
  CourseNr CHAR(3),

  CONSTRAINT Course3_PK
	 PRIMARY KEY (CID)
);

CREATE TABLE StudentGroup
(
  GID NUMBER(5),
  Name VARCHAR(40),
  PresidentID NUMBER(5),
  Founded NUMBER(4),

  CONSTRAINT StudentGroup_PK
	 PRIMARY KEY (GID),

  CONSTRAINT StudentGroup_FK
	 FOREIGN KEY (PresidentID)
       REFERENCES Student3(SID),
       
  UNIQUE (Name)
);

CREATE TABLE Enrolled 
(
  StudentID NUMBER(5),
  CourseID NUMBER(4),
  Quarter VARCHAR(6),
  Year NUMBER(4),
  
  CONSTRAINT Enrolled_PK
	 PRIMARY KEY (StudentID, CourseID),

  CONSTRAINT Enrolled_FK1
	 FOREIGN KEY (StudentID)
       REFERENCES Student3(SID),

  CONSTRAINT Enrolled_FK2
	 FOREIGN KEY (CourseID)
       REFERENCES Course3(CID)
); 

CREATE TABLE Memberof
(
  StudentID NUMBER(5),
  GroupID NUMBER(5),
  Joined NUMBER(4),
    
  CONSTRAINT Memberof_PK
	 PRIMARY KEY (StudentID, GroupID),

  CONSTRAINT Memberof_FK1
	 FOREIGN KEY (StudentID)
       REFERENCES Student3(SID),

  CONSTRAINT Memberof_FK2
	 FOREIGN KEY (GroupID)
       REFERENCES StudentGroup(GID)
);

-- Delete Tables
DELETE FROM Memberof;
DELETE FROM Enrolled;
DELETE FROM StudentGroup;
DELETE FROM Course3;
DELETE FROM Student3;

-- Insert Records
INSERT INTO Student3 VALUES ('Brennigan', 'Marcus', 90421, 987654321, 'UGRD', 'COMP-GPH', 'Evanston', 2001);
INSERT INTO Student3 VALUES ('Patel', 'Deepa', 14662, NULL, 'GRD', 'COMP-SCI', 'Evanston', 2003);
INSERT INTO Student3 VALUES ('Snowdon', 'Jonathan', 08871, 123123123, 'GRD', 'INFO-SYS', 'Springfield', 2005);
INSERT INTO Student3 VALUES ('Starck', 'Jason', 19992, 789789789, 'UGRD', 'INFO-SYS', 'Springfield', 2003);
INSERT INTO Student3 VALUES ('Johnson', 'Peter', 32105, 123456789, 'UGRD', 'COMP-SCI', 'Chicago', 2004);
INSERT INTO Student3 VALUES ('Winter', 'Abigail', 11035, 111111111, 'GRD', 'PHD', 'Chicago', 2003);
INSERT INTO Student3 VALUES ('Patel', 'Prakash', 75234, NULL, 'UGRD', 'COMP-SCI', 'Chicago', 2001);
INSERT INTO Student3 VALUES ('Snowdon', 'Jennifer', 93321, 321321321, 'GRD', 'COMP-SCI', 'Springfield', 2004);

INSERT INTO Course3 VALUES (1020, 'Theory of Computation', 'CSC', 489);
INSERT INTO Course3 VALUES (1092, 'Cryptography', 'CSC', 440);
INSERT INTO Course3 VALUES (3201, 'Data Analysis', 'IT', 223);
INSERT INTO Course3 VALUES (9219, 'Desktop Databases', 'IT', 240);
INSERT INTO Course3 VALUES (3111, 'Theory of Computation', 'CSC', 389);
INSERT INTO Course3 VALUES (8772, 'Survey of Computer Graphics', 'GPH', 425);
INSERT INTO Course3 VALUES (2987, 'Topics in Digital Cinema', 'DC', 270);
    
INSERT INTO StudentGroup VALUES (2, 'Computer Science Society', 75234, 1999);
INSERT INTO StudentGroup VALUES (101, 'Robototics Society', NULL, 1998);
INSERT INTO StudentGroup VALUES (221, 'HerCTI', 93321, 2003);
INSERT INTO StudentGroup VALUES (42, 'DeFrag', 90421, 2004);
    
INSERT INTO Enrolled VALUES (11035, 1020, 'Fall', 2005);
INSERT INTO Enrolled VALUES (11035, 1092, 'Fall', 2005);
INSERT INTO Enrolled VALUES (75234, 3201, 'Winter', 2006);
INSERT INTO Enrolled VALUES (08871, 1092, 'Fall', 2005);
INSERT INTO Enrolled VALUES (90421, 8772, 'Spring', 2006);
INSERT INTO Enrolled VALUES (90421, 2987, 'Spring', 2006);
    
INSERT INTO Memberof VALUES (75234, 42, 2005);
INSERT INTO Memberof VALUES (11035, 221, 2005);
INSERT INTO Memberof VALUES (93321, 221, 2005);
INSERT INTO Memberof VALUES (75234, 2, 2005);
INSERT INTO Memberof VALUES (32105, 42, 2005);
INSERT INTO Memberof VALUES (32105, 2, 2005);
INSERT INTO Memberof VALUES (32105, 221, 2005);
INSERT INTO Memberof VALUES (32105, 101, 2005);


-- Part 3-a
-- Write a PL/SQL trigger that will cap the course number column at 597
CREATE OR REPLACE TRIGGER Cap_Course_Number
  BEFORE INSERT OR UPDATE ON Course3
  FOR EACH ROW
  BEGIN
    IF :NEW.CourseNr >= 598 
      THEN :NEW.CourseNR := '597';
      DBMS_OUTPUT.PUT_LINE('Rejected Change of Course Number.');
      DBMS_OUTPUT.PUT_LINE('It will be set to 597.');
    END IF;
  END;
/

SET SERVEROUTPUT ON;

-- Example samples (Insert)
INSERT INTO Course3 VALUES (3737, 'Databases for Analytics', 'CSC', 450);
INSERT INTO Course3 VALUES (7373, 'Python Programming', 'CSC', 600);

-- Example samples (Update)
UPDATE Course3 SET CourseNR = '457' WHERE CID = 1020;
UPDATE Course3 SET CourseNR = '612' WHERE CID = 1092;

SELECT * FROM Course3;


-- Part 3-b
-- Write a regular expression and create the code to validate that the regular expression works

-- Drop Tables
DROP TABLE CreditCard;

-- Create Tables
CREATE TABLE CreditCard
(
  Card_Number VARCHAR2(30),
    
  CONSTRAINT Card_Number_CHECK 
     CHECK (REGEXP_LIKE(Card_Number, '^\d{4}-?\d{4}-?\d{4}-?\d{4}$'))
);

-- Example samples (Valid)
INSERT INTO CreditCard VALUES('9239-9239-9239-9239');
INSERT INTO CreditCard VALUES('9239923992399239');

-- Example samples (Invalid)
INSERT INTO CreditCard VALUES('9239-9239-9239-923');
INSERT INTO CreditCard VALUES('9239-9239-9239-92399');
INSERT INTO CreditCard VALUES(' 9239-9239-9239-9239 ');
INSERT INTO CreditCard VALUES('9239-9239-9239-923S');

SELECT * FROM CreditCard;
