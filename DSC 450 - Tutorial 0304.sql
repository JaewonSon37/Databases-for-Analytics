DROP TABLE Enrollment;
DROP TABLE Course;
DROP TABLE Student;

CREATE TABLE Student
(
  ID VARCHAR2(5),
  Name VARCHAR2(25) NOT NULL,
  Standing VARCHAR2(8),
  Age NUMBER(3, 0),
  
  CONSTRAINT Student_PK
     PRIMARY KEY(ID)
);

CREATE TABLE Course
(
  CourseID VARCHAR2(15),
  Name VARCHAR2(50) UNIQUE,
  Credits NUMBER(*,0) CHECK (Credits > 0),
  
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

INSERT INTO Course VALUES ('CSC211', 'Intro to Java I', 4);
INSERT INTO Course VALUES ('IT130', 'The Internet and the Web', 2);
INSERT INTO Course VALUES ('CSC452', 'Database Design', 4);

INSERT INTO Student VALUES ('12345', 'Paul K', 'Grad', 25);
INSERT INTO Student VALUES ('23456', 'Larry P', 'Grad', 27);
INSERT INTO Student VALUES ('34567', 'Ana B', 'Ugrad', 19);
INSERT INTO Student VALUES ('45678', 'Mary Y', 'Grad', 30);
INSERT INTO Student VALUES ('56789', 'Pat B', 'Ugrad', 21);
INSERT INTO Student VALUES ('66789', 'Pat A', 'Grad', 25);

INSERT INTO Enrollment VALUES('12345', 'CSC211', '01-Jan-2011');
INSERT INTO Enrollment VALUES('23456', 'IT130', '03-Jan-2011');
INSERT INTO Enrollment VALUES('34567', 'CSC211', '06-Jan-2011');
INSERT INTO Enrollment VALUES('34567', 'IT130', '07-Jan-2011');
INSERT INTO Enrollment VALUES('45678', 'IT130', '02-Jan-2011');
INSERT INTO Enrollment VALUES('45678', 'CSC211', '02-Jan-2011');

-- Part 1: Alter Table

ALTER TABLE Student
  ADD CONSTRAINT CheckName
      CHECK (Name IS NOT NULL);

ALTER TABLE Student 
  ADD CONSTRAINT BadConstraint Unique(Name);

ALTER TABLE Student
  ADD CONSTRAINT AgeRange
      CHECK (Age BETWEEN 10 and 99);

ALTER TABLE Student
  ADD Address VARCHAR2(15);

ALTER TABLE Student
  ADD (Income NUMBER(5, 2),
       Taxes NUMBER(5));

ALTER TABLE Student
  DROP COLUMN Address;

ALTER TABLE Student
  MODIFY Taxes NUMBER(5, 2);

ALTER TABLE Student
  RENAME Column Taxes TO Tax;

ALTER TABLE Student
  ADD CONSTRAINT MaxAge
      CHECK (Age < 100);

ALTER TABLE Student
  DROP COLUMN Age;
  
ALTER TABLE Enrollment
  ADD CONSTRAINT NoDSC
      CHECK (CourseID != 'DSC%');

ALTER TABLE Enrollment
  ADD CourseID VARCHAR2(50);

ALTER TABLE Enrollment
  MODIFY CourseID VARCHAR2(40);

ALTER TABLE Enrollment
  RENAME Column Enrolled TO EnrolledDate;    


-- Part 2 Update and Delete

DROP TABLE Transaction;
DROP TABLE Store;

CREATE TABLE Store
(
  StoreID NUMBER,
  City VARCHAR2(20) NOT NULL,
  State CHAR(2) NOT NULL,
      
  CONSTRAINT Store_PK
     PRIMARY KEY (StoreID)
);

CREATE TABLE Transaction
(
  StoreID NUMBER,
  TransID NUMBER,
  TDate DATE,
  Amount NUMBER(*, 2),

  CONSTRAINT DateCheck
     CHECK (TDate > TO_DATE('01-Jan-2010')),
     
  CONSTRAINT AmountCheck
     CHECK (Amount > 0.00),
     
  CONSTRAINT Transaction_ID
     PRIMARY KEY (StoreID, TransID),
     
  CONSTRAINT Transaction_FK1
     FOREIGN KEY (StoreID)
       REFERENCES Store(StoreID)
);

INSERT INTO Store VALUES (100, 'Chicago', 'IL');
INSERT INTO Store VALUES (200, 'Chicago', 'IL');
INSERT INTO Store VALUES (300, 'Schaumburg', 'IL');
INSERT INTO Store VALUES (400, 'Boston', 'MA');
INSERT INTO Store VALUES (500, 'Boston', 'MA');
INSERT INTO Store VALUES (600, 'Portland', 'ME');

INSERT INTO Transaction Values(100, 1, '10-Oct-2011', 100.00);
INSERT INTO Transaction Values(100, 2, '11-Oct-2011', 120.00);
INSERT INTO Transaction Values(200, 1, '11-Oct-2011', 50.00);
INSERT INTO Transaction Values(200, 2, '11-Oct-2011', 70.00);
INSERT INTO Transaction Values(300, 1, '12-Oct-2011', 20.00);
INSERT INTO Transaction Values(400, 1, '10-Oct-2011', 10.00);
INSERT INTO Transaction Values(400, 2, '11-Oct-2011', 20.00);
INSERT INTO Transaction Values(400, 3, '12-Oct-2011', 30.00);
INSERT INTO Transaction Values(500, 1, '10-Oct-2011', 10.00);
INSERT INTO Transaction Values(500, 2, '10-Oct-2011', 110.00);
INSERT INTO Transaction Values(500, 3, '11-Oct-2011', 90.00);
INSERT INTO Transaction Values(600, 1, '11-Oct-2011', 300.00);

UPDATE Store
  SET City = 'Bohston'
  WHERE City = 'Boston';
    
UPDATE Transaction
  SET TDate = NULL
  WHERE Amount <= 50;

UPDATE Store
  SET City = 'Bhoston'
  WHERE StoreID = 400;

UPDATE Store
  SET City = 'Boston'
  WHERE City LIKE 'B%ton';

UPDATE Transaction
  SET Amount = Amount * 1.1;

DELETE FROM Store
  WHERE City = 'Boston';

DELETE FROM Transaction
  WHERE StoreID IN (400, 500);

DELETE FROM Store
  WHERE City = 'Boston';

DELETE FROM Store
  WHERE StoreID = 600;   

DELETE FROM Transaction
  WHERE TransID = 1;

DELETE FROM Transaction
  WHERE TDate <= TO_DATE('11-Oct-2011');

DELETE FROM Transaction
  WHERE TDate != TO_DATE('12-Oct-2011');   

UPDATE Transaction 
  SET Amount = -4 
  WHERE StoreID = 100;


-- Part 3: Search

SELECT * FROM Store
  WHERE City LIKE 'B___ton';

SELECT * FROM Store
  WHERE City LIKE 'B__ton';

SELECT * FROM Store
  WHERE City LIKE 'B%ston';

SELECT * FROM Store
  WHERE City LIKE 'B__st__';

SELECT * FROM Store
  WHERE (State = 'IL' OR City = 'Portland')
         AND StoreID != 100;
 
SELECT * FROM Store
  ORDER BY State, City;
  
SELECT DISTINCT City
  FROM Store
  WHERE State = 'IL' OR State = 'ME';

SELECT TDate, Amount 
  FROM Transaction;

SELECT TDate, Amount
  FROM Transaction
  WHERE Amount >= 100;

SELECT TDate, Amount
  FROM Transaction
  WHERE Amount > 40 AND Amount < 80;

SELECT TDate, Amount
  FROM Transaction
  WHERE (Amount >= 20 AND Amount < 35)
         OR (Amount > 100 AND Amount <= 120);

SELECT Amount, TDate, TransID
  FROM Transaction
  ORDER BY Amount;

SELECT TDate, Amount
  FROM Transaction
  WHERE Amount >=20
  ORDER BY TDate, Amount;

SELECT * FROM Store, Transaction;

SELECT * FROM Store, Transaction
  WHERE Store.StoreID = Transaction.StoreID;
  
-- Part 4: Calculation  

SELECT COUNT(DISTINCT State)
  FROM Store;

SELECT SUM(Amount)
  FROM Transaction
  WHERE Amount <= 20 
        OR Amount >= 100;

SELECT AVG(Amount)
  FROM Transaction
  WHERE TDate = TO_DATE('11-Oct-2011');

SELECT MIN(Amount)
  FROM Transaction
  WHERE TDate = TO_DATE('12-Oct-2011');

SELECT MAX(Amount)
  FROM Transaction
  WHERE TDate = TO_DATE('10-Oct-2011');

SELECT MAX(Amount)
  FROM Transaction
  WHERE Amount < 55;

SELECT State, COUNT(StoreID)
  FROM Store
  GROUP BY State;

SELECT TDate, SUM(Amount)
  FROM Transaction
  GROUP BY TDate;
