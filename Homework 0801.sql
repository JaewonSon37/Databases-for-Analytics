-- Part 2
-- Write an anonymous PL/SQL block
--------------------------------------------------------------------------------

-- Drop tables
DROP TABLE STUDENT CASCADE CONSTRAINTS;
DROP TABLE WEIGHTS CASCADE CONSTRAINTS;

-- Create STUDENT table
CREATE TABLE STUDENT
(
  ID CHAR(3),
	Name VARCHAR2(20),
	Midterm	NUMBER(3,0) CHECK (Midterm >= 0 AND Midterm <= 100),
	Final NUMBER(3,0)	CHECK (Final >= 0 AND Final <= 100),
	Homework NUMBER(3,0) CHECK (Homework >= 0 AND Homework <= 100),

	PRIMARY KEY (ID)
);

-- Create WEIGHTS table
CREATE TABLE WEIGHTS
(
	MidPct NUMBER(2, 0) CHECK (MidPct >= 0 AND MidPct <= 100),
	FinPct NUMBER(2, 0) CHECK (FinPct >= 0 AND FinPct <= 100),
	HWPct	NUMBER(2, 0) CHECK (HWPct >= 0 AND HWPct <= 100)
);

-- Insert records
INSERT INTO STUDENT VALUES ('445', 'Seinfeld', 86, 90, 99);
INSERT INTO STUDENT VALUES ('909', 'Costanza', 74, 72, 86);
INSERT INTO STUDENT VALUES ('123', 'Benes', 93, 89, 91);
INSERT INTO STUDENT VALUES ('111', 'Kramer', 99, 91, 93);
INSERT INTO STUDENT VALUES ('667', 'Newman', 78, 82, 84);
INSERT INTO STUDENT VALUES ('889', 'Banya', 51, 66, 50);

INSERT INTO WEIGHTS VALUES (30, 30, 40);

-- Commit to save the inserted records
COMMIT;

-- Enable output display
SET SERVEROUTPUT ON;

-- Begin anonymous PL/SQL block
DECLARE
  MidPct WEIGHTS.MidPct%TYPE;
  FinPct WEIGHTS.FinPct%TYPE;
  HWPct WEIGHTS.HWPct%TYPE;
  OverallScore NUMBER(5, 2);
  Grade CHAR(1);
  
  CURSOR Student_Cursor IS
    SELECT ID, Name, Midterm, Final, Homework 
      FROM STUDENT;

BEGIN
  SELECT MidPct, FinPct, HWPct
    INTO MidPct, FinPct, HWPct
    FROM WEIGHTS;
    DBMS_OUTPUT.PUT_LINE('Weights are ' || MidPct || ', ' || FinPct || ', ' || HWPct);
  
  FOR Student_record IN Student_Cursor
    LOOP OverallScore := (Student_record.Midterm * MidPct / 100) + 
                         (Student_record.Final * FinPct / 100) +
                         (Student_record.Homework * HWPct / 100);
      IF OverallScore >= 90 THEN Grade := 'A';
      ELSIF OverallScore >= 80 THEN Grade := 'B';
      ELSIF OverallScore >= 65 THEN Grade := 'C';
      ELSE Grade := 'F';
      END IF;
      DBMS_OUTPUT.PUT_LINE(Student_record.ID || ' ' || Student_record.Name || ' ' || OverallScore || ' ' || Grade);
    END LOOP;

END;
/



-- Part 3
--------------------------------------------------------------------------------

-- Drop tables
DROP TABLE ENROLLMENT CASCADE CONSTRAINTS;
DROP TABLE SECTION CASCADE CONSTRAINTS;


-- Create SECTION table
CREATE TABLE SECTION
(
  SectionID CHAR(5),
  Course VARCHAR2(8),
  Students NUMBER DEFAULT 0,
 
  CONSTRAINT SECTION_PK 
     PRIMARY KEY (SectionID)
);

-- Create ENROLLMENT table
CREATE TABLE ENROLLMENT
(
 SectionID CHAR(5),
 StudentID CHAR(7),

 CONSTRAINT ENROLLMENT_PK
		PRIMARY KEY (SectionID, StudentID),

 CONSTRAINT ENROLLMENT_FK_ 
		FOREIGN KEY (SectionID)
		  REFERENCES SECTION (SectionID)
);

-- Insert records
INSERT INTO SECTION (SectionID, Course) VALUES ('12345', 'CSC 355');
INSERT INTO SECTION (SectionID, Course) VALUES ('22109', 'CSC 309');
INSERT INTO SECTION (SectionID, Course) VALUES ('99113', 'CSC 300');
INSERT INTO SECTION (SectionID, Course) VALUES ('99114', 'CSC 300');

-- Commit to save the inserted records
COMMIT;


-- Part 3.a
-- Write a trigger that will fire when attempts to INSERT a row into ENROLLMENT
--------------------------------------------------------------------------------

-- Create a trigger
CREATE OR REPLACE TRIGGER Class_Enroll
  BEFORE INSERT ON ENROLLMENT
  FOR EACH ROW

DECLARE
  Student_Number NUMBER;
        
BEGIN
  SELECT Students
    INTO Student_Number
    FROM SECTION
    WHERE SectionID = :NEW.SectionID;

    IF Student_Number >= 5 THEN
       raise_application_error(-20102, 'Section is full.');
    ELSE UPDATE SECTION
           SET Students = Students + 1
           WHERE SectionID = :NEW.SectionID;
    END IF;
  
END;
/

-- Insert records
INSERT INTO ENROLLMENT VALUES ('12345', '1234567');
INSERT INTO ENROLLMENT VALUES ('12345', '2234567');
INSERT INTO ENROLLMENT VALUES ('12345', '3234567');
INSERT INTO ENROLLMENT VALUES ('12345', '4234567');
INSERT INTO ENROLLMENT VALUES ('12345', '5234567');
INSERT INTO ENROLLMENT VALUES ('12345', '6234567');

-- Display contents
SELECT * FROM SECTION;
SELECT * FROM ENROLLMENT;


-- Part 3.b
-- Write a trigger that will fire when attempts to DELETE rows from ENROLLMENT
--------------------------------------------------------------------------------

-- Create a trigger 
CREATE OR REPLACE TRIGGER Class_Drop
  AFTER DELETE ON ENROLLMENT
  FOR EACH ROW
        
BEGIN
  UPDATE SECTION
    SET Students = Students - 1
    WHERE SectionID = :OLD.SectionID;
    
END;
/

-- Delete record
DELETE FROM ENROLLMENT WHERE StudentID = '1234567';

-- Display contents
SELECT * FROM SECTION;
SELECT * FROM ENROLLMENT;
