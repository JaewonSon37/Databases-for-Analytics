-- Functional Dependencies
-- Floor, Room -> Company, Representative
-- Company -> Room
-- Representative -> Company

DROP TABLE OfficeAssignments;

CREATE TABLE OfficeAssignments
(
  Floor NUMBER(3),
  Room CHAR(1),
  Company VARCHAR(25),
  Representative VARCHAR(20),
  
  CONSTRAINT OfficeAssignments_PK
     PRIMARY KEY (Floor, Room)
);

INSERT INTO OfficeAssignments VALUES (10, 'D', 'Dunder Mifflin', 'Jack');
INSERT INTO OfficeAssignments VALUES (12, 'D', 'Dunder Mifflin', 'Jack');
INSERT INTO OfficeAssignments VALUES (20, 'W', 'Wayne Enterprises', 'Karen');
INSERT INTO OfficeAssignments VALUES (15, 'M', 'Massive Dynamic', 'Max');
INSERT INTO OfficeAssignments VALUES (18, 'M', 'Massive Dynamic', 'Max');
INSERT INTO OfficeAssignments VALUES (19, 'M', 'Massive Dynamic', 'Jane');

SELECT Representative, COUNT(*)
  FROM OfficeAssignments
  GROUP BY Representative;

SELECT Representative, COUNT(DISTINCT Company)
  FROM OfficeAssignments
  GROUP BY Representative;

SELECT Representative, COUNT(DISTINCT Company)
  FROM OfficeAssignments
  GROUP BY Representative
  HAVING COUNT(DISTINCT Company) > 1;

INSERT INTO OfficeAssignments VALUES (10, 'W', 'Wayne Enterprises', 'Jack');

-- Violation indicating that Representative Jack is assigned to two different companies
SELECT Representative, COUNT(DISTINCT Company)
  FROM OfficeAssignments
  GROUP BY Representative
  HAVING COUNT(DISTINCT Company) > 1;


-- Normalizaing Schema
DROP TABLE OfficeAssignmentsDecomposed;
DROP TABLE Representative;

CREATE TABLE Representative
(
  Company VARCHAR(25),
  Representative VARCHAR(20),
  
  CONSTRAINT Representative_PK
     PRIMARY KEY (Representative)
);

CREATE TABLE OfficeAssignmentsDecomposed
(
  Floor NUMBER(3),
  Room CHAR(1),
  Representative VARCHAR(20),
  
  CONSTRAINT OfficeAssignmentsDecomposed_PK
     PRIMARY KEY (Floor, Room),
     
  CONSTRAINT OfficeAssignmentsDecomposed_FK
     FOREIGN KEY (Representative)
       REFERENCES Representative(Representative)
);

INSERT INTO Representative VALUES ('Dunder Mifflin', 'Jack');
INSERT INTO Representative VALUES ('Wayne Enterprises', 'Karen');  
INSERT INTO Representative VALUES ('Massive Dynamic', 'Max');
INSERT INTO Representative VALUES ('Massive Dynamic', 'Jane');

INSERT INTO OfficeAssignmentsDecomposed VALUES (10, 'D', 'Jack');
INSERT INTO OfficeAssignmentsDecomposed VALUES (12, 'D', 'Jack');
INSERT INTO OfficeAssignmentsDecomposed VALUES (20, 'W', 'Karen');
INSERT INTO OfficeAssignmentsDecomposed VALUES (15, 'M', 'Max');
INSERT INTO OfficeAssignmentsDecomposed VALUES (18, 'M', 'Max');
INSERT INTO OfficeAssignmentsDecomposed VALUES (19, 'M', 'Jane');
  
SELECT Company, COUNT(DISTINCT Room)
  FROM OfficeAssignmentsDecomposed
       NATURAL JOIN Representative 
  GROUP BY Company
  HAVING COUNT(DISTINCT Room) > 1;
  
INSERT INTO Representative VALUES ('Massive Dynamic', 'Jay');

INSERT INTO OfficeAssignmentsDecomposed VALUES (19, 'K', 'Jay');

-- Can't determine the room anymore because of the created violation
SELECT Company, COUNT(DISTINCT Room)
  FROM OfficeAssignmentsDecomposed
       NATURAL JOIN Representative 
  GROUP BY Company
  HAVING COUNT(DISTINCT Room) > 1;
