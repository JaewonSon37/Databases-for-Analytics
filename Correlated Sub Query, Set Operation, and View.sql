DROP TABLE Memberof;
DROP TABLE Enrolled;
DROP TABLE StudentGroup;
DROP TABLE Course2;
DROP TABLE Student2;

CREATE TABLE Student2
(
  LastName VARCHAR(40),
  FirstName VARCHAR(40),
  SID NUMBER(5),
  SSN NUMBER(9),
  Career VARCHAR(4),
  Program VARCHAR(10),
  CitY VARCHAR(40),
  Started NUMBER(4),
  
  CONSTRAINT Student2_PK
     PRIMARY KEY (SID),
  
  UNIQUE (SSN)
);

CREATE TABLE Course2
(
  CID number(4),
  CourseName VARCHAR(40),
  Department VARCHAR(4),
  CourseNr CHAR(3),

  CONSTRAINT Course2_PK
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
       REFERENCES Student2(SID),
       
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
       REFERENCES Student2(SID),
    
  CONSTRAINT Enrolled_FK2
     FOREIGN KEY (CourseID)
       REFERENCES Course2(CID)
); 

CREATE TABLE Memberof (
  StudentID NUMBER(5),
  GroupID NUMBER(5),
  Joined NUMBER(4),
  
  CONSTRAINT Memberof_PK
     PRIMARY KEY (StudentID, GroupID),
     
  CONSTRAINT Memberof_FK1
     FOREIGN KEY (StudentID)
       REFERENCES Student2(SID),
    
  CONSTRAINT Memberof_FK2
     FOREIGN KEY (GroupID)
       REFERENCES Studentgroup(GID)
);

INSERT INTO Student2
    VALUES ('Brennigan', 'Marcus', 90421, 987654321, 'UGRD', 'COMP-GPH', 'Evanston', 2001);
INSERT INTO Student2
    VALUES ('Patel', 'Deepa', 14662, NULL, 'GRD', 'COMP-SCI', 'Evanston', 2003);
INSERT INTO Student2
    VALUES ('Snowdon', 'Jonathan', 08871, 123123123, 'GRD', 'INFO-SYS', 'Springfield', 2005);
INSERT INTO Student2
    VALUES ('Starck', 'Jason', 19992, 789789789, 'UGRD', 'INFO-SYS', 'Springfield', 2003);
INSERT INTO Student2
    VALUES ('Johnson', 'Peter', 32105, 123456789, 'UGRD', 'COMP-SCI', 'Chicago', 2004);
INSERT INTO Student2
    VALUES ('Winter', 'Abigail', 11035, 111111111, 'GRD', 'PHD', 'Chicago', 2003);
INSERT INTO Student2
    VALUES ('Patel', 'Prakash', 75234, NULL, 'UGRD', 'COMP-SCI', 'Chicago', 2001);
INSERT INTO Student2
    VALUES ('Snowdon', 'Jennifer', 93321, 321321321, 'GRD', 'COMP-SCI', 'Springfield', 2004);

INSERT INTO Course2
    VALUES (1020, 'Theory of Computation', 'CSC', 489);
INSERT INTO Course2
    VALUES (1092, 'Cryptography', 'CSC', 440);
INSERT INTO Course2
    VALUES (3201, 'Data Analysis', 'IT', 223);
INSERT INTO Course2
    VALUES (9219, 'Desktop Databases', 'IT', 240);
INSERT INTO Course2
    VALUES (3111, 'Theory of Computation', 'CSC', 389);
INSERT INTO Course2
    VALUES (8772, 'Survey of Computer Graphics', 'GPH', 425);
INSERT INTO Course2
    VALUES (2987, 'Topics in Digital Cinema', 'DC', 270);
    
INSERT INTO StudentGroup
    VALUES (2, 'Computer Science Society', 75234, 1999);
INSERT INTO StudentGroup
    VALUES (101, 'Robototics Society', null, 1998);
INSERT INTO StudentGroup
    VALUES (221, 'HerCTI', 93321, 2003);
INSERT INTO StudentGroup
    VALUES (42, 'DeFrag', 90421, 2004);
    
INSERT INTO Enrolled
    VALUES (11035, 1020, 'Fall', 2005);
INSERT INTO Enrolled
    VALUES (11035, 1092, 'Fall', 2005);
INSERT INTO Enrolled
    VALUES (75234, 3201, 'Winter', 2006);
INSERT INTO Enrolled
    VALUES (08871, 1092, 'Fall', 2005);
INSERT INTO Enrolled
    VALUES (90421, 8772, 'Spring', 2006);
INSERT INTO Enrolled
    VALUES (90421, 2987, 'Spring', 2006);
    
INSERT INTO Memberof
    VALUES (75234, 42, 2005);
INSERT INTO Memberof
    VALUES (11035, 221, 2005);
INSERT INTO Memberof
    VALUES (93321, 221, 2005);
INSERT INTO Memberof
    VALUES (75234, 2, 2005);
INSERT INTO Memberof
    VALUES (32105, 42, 2005);
INSERT INTO Memberof
    VALUES (32105, 2, 2005);
INSERT INTO Memberof
    VALUES (32105, 221, 2005);
INSERT INTO Memberof
    VALUES (32105, 101, 2005);


-- Part 1: Correlated Subqueries

SELECT LastName, FirstName, SID
  FROM Student2
  WHERE EXISTS (SELECT *
                  FROM Enrolled
                  WHERE SID = StudentID);

SELECT LastName, FirstName, SID
  FROM Student2
  WHERE NOT EXISTS (SELECT * 
                      FROM Enrolled
                      WHERE SID = StudentID);

SELECT *
  FROM Course2 CourseOuter
  WHERE EXISTS (SELECT CourseNr
                  FROM Course2
                  WHERE CourseOuter.CourseName = Course2.CourseName
                        AND CourseOuter.CourseNr < Course2.CourseNr);

SELECT LastName, FirstName, SID
  FROM Student2
  WHERE (SELECT COUNT(*)
           FROM Enrolled
           WHERE SID = StudentID) >= 2;

SELECT LastName, FirstName, SID, (SELECT COUNT(*) FROM Enrolled WHERE SID = StudentID) AS EnrCrs
  FROM Student2;

SELECT LastName, FirstName, SID, (SELECT COUNT(*) FROM Enrolled WHERE SID = StudentID) AS EnrCrs
  FROM Student2
  WHERE (SELECT COUNT(*)
           FROM Enrolled
           WHERE SID = StudentID) = 0;

SELECT *
  FROM StudentGroup
  WHERE (SELECT COUNT(*)
           FROM Memberof, Student2
           WHERE GroupID = GID
                 AND Student2.Career = 'UGRD'
                 AND StudentID = SID) > 0
         AND (SELECT COUNT(*)
                FROM Memberof, Student2
                WHERE GroupID = GID
                      AND Student2.Career = 'GRD'
                      AND StudentID = SID) > 0;


-- Part 2: Operations

SELECT *
  FROM Student2
MINUS  
SELECT *
  FROM Student2
  WHERE SID IN (SELECT StudentID
                  FROM Enrolled);

SELECT *
  FROM Student2
MINUS  
SELECT LastName, FirstName, SID, SSN, Career, Program, City, Started
  FROM Student2, Enrolled
  WHERE StudentID = SID;

SELECT Name
  FROM StudentGroup
UNION
SELECT CourseName
  FROM Course2;

SELECT LastName, FirstName, SID, Career
  FROM Student2, Memberof, StudentGroup
  WHERE StudentID = SID
        AND GID = GroupID
        AND Name = 'HerCTI'
INTERSECT
SELECT LastName, FirstName, SID, Career
  FROM Student2, Enrolled
  WHERE StudentID = SID;

SELECT LastName, FirstName, SID, Career
  FROM Student2
  WHERE SID IN (SELECT PresidentID
                  FROM StudentGroup)
INTERSECT
SELECT LastName, FirstName, SID, Career
  FROM Student2
  WHERE SID IN (SELECT StudentID
                  FROM Enrolled
                  WHERE YEAR = 2006);


-- Part 3: Views

DROP VIEW GradStudent1;
DROP VIEW GradStudent2;
DROP VIEW RestrictChicagoStudent;

CREATE VIEW GradStudent1 AS
SELECT *
  FROM Student2
  WHERE Career = 'GRD';

SELECT *
  FROM GradStudent1;

CREATE VIEW RestrictChicagoStudent AS
SELECT FirstName, LastName, SID, City
  FROM Student2
  WHERE City = 'Chicago';

SELECT *
  FROM RestrictChicagoStudent;

INSERT INTO GradStudent1
    VALUES ('Bren', 'Mark', 14165, 987674321, 'GRD', 'COMP-GPH', 'Evanston', 2003);

SELECT *
  FROM Student2;

SELECT *
  FROM GradStudent1;

CREATE VIEW GradStudent2 AS
SELECT *
  FROM Student2
  WHERE Career = 'GRD'
  WITH CHECK OPTION;

INSERT INTO GradStudent2
    VALUES ('Tony', 'Cross', 98488, 982174321, 'GRD', 'COMP-GPH', 'Evanston', 2003);
INSERT INTO GradStudent2
    VALUES ('Marco', 'Reus', 13565, 847674384, 'UGRD', 'COMP-GPH', 'Evanston', 2003);

INSERT INTO RestrictChicagoStudent
    VALUES ('Jane', 'Doe', 15474, 'Chicago');

SELECT *
  FROM Student2;
