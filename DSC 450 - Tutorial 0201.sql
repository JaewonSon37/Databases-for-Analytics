-- Part 1

DROP TABLE Enrollment;
DROP TABLE Course;
DROP TABLE Student;

CREATE TABLE Student
(
  ID VARCHAR2(5),
  Name VARCHAR2(25),
  Standing VARCHAR2(8),
  
  CONSTRAINT Student_PK
     PRIMARY KEY(ID)
);

CREATE TABLE Course
(
  CourseID VARCHAR2(15),
  Name VARCHAR2(50),
  Credits NUMBER(*,0),
  
  CONSTRAINT Course_PK
     PRIMARY KEY(CourseID)
);

CREATE TABLE Enrollment
(
  StudentID VARCHAR2(5),
  CourseID VARCHAR2(15),
  Enrolled DATE,

  CONSTRAINT Enrollment_PK
     PRIMARY KEY(CourseID, StudentID),
  
  CONSTRAINT Enrollment_FK1
     FOREIGN KEY (CourseID)
       REFERENCES Course(CourseID),
       
  CONSTRAINT Enrollment_FK2
     FOREIGN KEY (StudentID)
       REFERENCES Student(ID)
);

INSERT INTO Student VALUES ('12345', 'Paul K', 'Grad');
INSERT INTO Student VALUES ('23456', 'Larry P', 'Grad');
INSERT INTO Student VALUES ('34567', 'Ana B', 'Ugrad');
INSERT INTO Student VALUES ('45678', 'Mary Y', 'Grad');
INSERT INTO Student VALUES ('56789', 'Pat B', 'Ugrad');

INSERT INTO Course VALUES ('CSC211', 'Intro to Java I', 4);
INSERT INTO Course VALUES ('IT130', 'The Internet and the Web', 2);
INSERT INTO Course VALUES ('CSC451', 'Database Design', 4);

INSERT INTO Enrollment VALUES('12345', 'CSC211', '01-Jan-2011');
INSERT INTO Enrollment VALUES('12345', 'CSC451', '02-Jan-2011');

INSERT INTO Enrollment VALUES('23456', 'IT130', '03-Jan-2011');
INSERT INTO Enrollment VALUES('23456', 'CSC211', to_date('January 03, 2019', 'Month dd, YYYY'));

INSERT INTO Enrollment VALUES('34567', 'CSC211', '06-Jan-2011');
INSERT INTO Enrollment VALUES('34567', 'IT130', '07-Jan-2011');
INSERT INTO Enrollment VALUES('34567', 'CSC451', '11-Jan-2011');

INSERT INTO Enrollment VALUES('45678', 'IT130', '02-Jan-2011');
INSERT INTO Enrollment VALUES('45678', 'CSC211', '02-Jan-2011');

SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Enrollment;


-- Part 2

DROP TABLE Ownership;
DROP TABLE Cars;
DROP TABLE People;

CREATE TABLE People
(
  ID NUMBER(7),
  Name VARCHAR2(25),
  Phone VARCHAR2(12),
    
  CONSTRAINT People_PK
     PRIMARY KEY(ID)
);

CREATE Table Cars
(
  Plate VARCHAR2(10),
  Color VARCHAR2(8),
    
  CONSTRAINT Cars_PK
     PRIMARY KEY(Plate)
);

CREATE Table Ownership
(
  ID NUMBER(7),
  CarPlate VARCHAR2(10),

  CONSTRAINT Ownership_PK
     PRIMARY KEY(ID, CarPlate),
    
  CONSTRAINT Ownership_FK1
     FOREIGN KEY (ID)
       REFERENCES People(ID),
    
  CONSTRAINT Ownership_FK2
     FOREIGN KEY (CarPlate)
       REFERENCES Cars(Plate)
);

INSERT INTO People VALUES(1, 'Jane', '222');
INSERT INTO People VALUES(2, 'Mike', '333');

INSERT INTO Cars VALUES('DBA1', 'Red');
INSERT INTO Cars VALUES('486K', 'Black');

INSERT INTO Ownership VALUES(1, 'DBA1');
INSERT INTO Ownership VALUES(2, '486K');
INSERT INTO Ownership VALUES(1, '486K');

SELECT * FROM People;
SELECT * FROM Cars;
SELECT * FROM Ownership;


-- Part 3

DROP TABLE Cars_2;
DROP TABLE People_2;

CREATE TABLE People_2
(
  ID NUMBER(7),
  Name VARCHAR2(25),
  Phone VARCHAR2(12),
  
  CONSTRAINT People_2_PK
     PRIMARY KEY(ID)
);

CREATE Table Cars_2
(
  Plate VARCHAR2(10),
  Color VARCHAR2(8),
  Owner NUMBER(7),
    
  CONSTRAINT Cars_2_PK
     PRIMARY KEY(Plate),

  CONSTRAINT Cars_2_FK
     FOREIGN KEY (Owner)
       REFERENCES People_2(ID)
);

INSERT INTO People_2 VALUES(1, 'Jane', '222');
INSERT INTO People_2 VALUES(2, 'Mike', '333');

INSERT INTO Cars_2 VALUES('DBA1', 'Red', 1);
INSERT INTO Cars_2 VALUES('486K', 'Black', 2);

SELECT * FROM People_2;
SELECT * FROM Cars_2;
