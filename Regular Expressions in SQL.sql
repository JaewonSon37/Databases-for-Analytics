SELECT *
  FROM Course
  WHERE CourseID LIKE '_____';

SELECT *
  FROM Course
  WHERE REGEXP_LIKE(CourseID, '\w\w\w\w\w');
  
SELECT *
  FROM Course
  WHERE REGEXP_LIKE(CourseID, '\w\w\w\w\w\w');
  
SELECT *
  FROM Course
  WHERE REGEXP_LIKE(CourseID, '\w{6}');

SELECT *
  FROM Course
  WHERE REGEXP_LIKE(Credits, '\d');

SELECT *
  FROM Course
  WHERE REGEXP_LIKE(CourseID, 'CSC\w\w\w');

SELECT *
  FROM Course
  WHERE REGEXP_LIKE(CourseID, 'CSC\w\w2');

SELECT *
  FROM Course
  WHERE REGEXP_LIKE(Name, 'a');

SELECT *
  FROM Course
  WHERE REGEXP_LIKE(Name, '^D');

DROP TABLE Contacts;

CREATE TABLE Contacts
(
  L_Name VARCHAR2(30), 
  P_Number VARCHAR2(30),
  
  CONSTRAINT Contacts_P_Number_CHECK 
     CHECK (REGEXP_LIKE(P_number, '^\(\d{3}\) \d{3}-\d{4}$'))
);

-- Success to insert
INSERT INTO Contacts (P_number) VALUES('(650) 555-5555'); 
INSERT INTO Contacts (P_number) VALUES('(215) 555-3427'); 

-- Fail to insert
INSERT INTO Contacts (P_number) VALUES(' (215) 555-3427'); 
INSERT INTO Contacts (P_number) VALUES('650 555-5555');
INSERT INTO Contacts2 (P_number) VALUES('(650) 555 5555'); 
INSERT INTO Contacts (P_number) VALUES('(650) 5555555'); 
INSERT INTO Contacts (P_number) VALUES('(650)555-5555'); 

DROP TABLE Contacts2;

CREATE TABLE Contacts2
(
  L_Name VARCHAR2(30), 
  P_Number VARCHAR2(30),
  
  CONSTRAINT Contacts2_P_Number_CHECK 
     CHECK (REGEXP_LIKE(P_number, '^\(?\d{3}\)? ?\d{3}-?\d{4}$'))
);

-- Success to insert
INSERT INTO Contacts2 (P_number) VALUES('(650) 555-5555'); 
INSERT INTO Contacts2 (P_number) VALUES('(215) 555-3427'); 
INSERT INTO Contacts2 (P_number) VALUES('650 555-5555'); 
INSERT INTO Contacts2 (P_number) VALUES('(650) 5555555'); 
INSERT INTO Contacts2 (P_number) VALUES('(650)555-5555'); 

-- Fail to insert
INSERT INTO Contacts2 (P_number) VALUES(' (215) 555-3427'); 
INSERT INTO Contacts2 (P_number) VALUES('(650) 555 5555'); 
