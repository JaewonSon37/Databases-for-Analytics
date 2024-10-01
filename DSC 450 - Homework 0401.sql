-- Part 1.A
DROP TABLE Handles;
DROP TABLE Animal;
DROP TABLE ZooKeeper;

CREATE TABLE ZooKeeper
(
  ZID NUMBER(3, 0),
  ZName VARCHAR2(25) NOT NULL,
  HourlyRate NUMBER(6, 2) NOT NULL,
  
  CONSTRAINT ZooKeeper_PK
     PRIMARY KEY(ZID)
);

CREATE TABLE Animal
(
  AID NUMBER(3, 0),
  AName VARCHAR(30) NOT NULL,
  -- ACategory: Animal category which can be 'common', 'rare', 'exotic', and NULL
  ACategory VARCHAR(18),
  -- TimeToFeed: Time it takes to feed the animal (hours)
  TimeToFeed NUMBER(4, 2),  
  
  CONSTRAINT Animal_PK
     PRIMARY KEY(AID)
);

CREATE TABLE Handles
(
  ZooKeepID NUMBER(3, 0),
  AnimalID NUMBER(3, 0),
  Assigned DATE,
  
  CONSTRAINT Handles_PK
     PRIMARY KEY(ZooKeepID, AnimalID),
    
  CONSTRAINT Handles_FK1
     FOREIGN KEY(ZooKeepID)
       REFERENCES ZooKeeper(ZID),
      
  CONSTRAINT Handles_FK2
     FOREIGN KEY(AnimalID)
       REFERENCES Animal(AID)
);

INSERT INTO ZooKeeper VALUES (1, 'Jim Carrey', 500);
INSERT INTO ZooKeeper VALUES (2, 'Tina Fey', 350);  
INSERT INTO ZooKeeper VALUES (3, 'Rob Schneider', 250);
  
INSERT INTO Animal VALUES(1, 'Galapagos Penguin', 'exotic', 0.5);
INSERT INTO Animal VALUES(2, 'Emperor Penguin', 'rare', 0.75);
INSERT INTO Animal VALUES(3, 'Sri Lankan sloth bear', 'exotic', 2.5);
INSERT INTO Animal VALUES(4, 'Grizzly bear', 'common', 3.0);
INSERT INTO Animal VALUES(5, 'Giant Panda bear', 'exotic', 1.5);
INSERT INTO Animal VALUES(6, 'Florida black bear', 'rare', 1.75);
INSERT INTO Animal VALUES(7, 'Siberian tiger', 'rare', 3.5);
INSERT INTO Animal VALUES(8, 'Bengal tiger', 'common', 2.75);
INSERT INTO Animal VALUES(9, 'South China tiger', 'exotic', 2.25);
INSERT INTO Animal VALUES(10, 'Alpaca', 'common', 0.25);
INSERT INTO Animal VALUES(11, 'Llama', NULL, 3.5);

INSERT INTO Handles VALUES(1, 1, '01-Jan-2000');
INSERT INTO Handles VALUES(1, 2, '02-Jan-2000');
INSERT INTO Handles VALUES(1, 10, '01-Jan-2000');
INSERT INTO Handles VALUES(2, 3, '02-Jan-2000');
INSERT INTO Handles VALUES(2, 4, '04-Jan-2000');
INSERT INTO Handles VALUES(2, 5, '03-Jan-2000');
INSERT INTO Handles VALUES(3, 7, '01-Jan-2000');
INSERT INTO Handles VALUES(3, 8, '03-Jan-2000');
INSERT INTO Handles VALUES(3, 9, '05-Jan-2000');
INSERT INTO Handles Values(3, 10,'04-Jan-2000');


-- Part 1.A-a
-- Find all the rare animals and sort the query output by feeding time in ascending order
SELECT AName, ACategory, TimeToFeed
  FROM Animal
  WHERE ACategory = 'rare'
  ORDER BY TimeToFeed ASC; 


-- Part 1.A-b
-- Find the animal names and categories for animals related to a tiger
SELECT AName, ACategory
  FROM Animal
  WHERE AName LIKE '%tiger%';


-- Part 1.A-c
-- Find the names of the animals that are related to the bear and are common
SELECT AName
  FROM Animal
  WHERE AName LIKE '%bear%' 
        AND ACategory = 'common';


-- Part 1.A-d
-- Find the names of the animals that are not related to the bear
SELECT AName
  FROM Animal
  WHERE AName NOT LIKE '%bear%';


-- Part 1.A-e
-- List the names of the animals and the ID of the zoo keeper assigned to them
SELECT AName, ZooKeepID
  FROM Animal
       JOIN Handles ON Animal.AID = Handles.AnimalID;


-- Part 1.A-f
-- Repeat the previous query and make sure that the animals without an assigned handler also appear
SELECT AName, ZooKeepID
  FROM Animal 
       LEFT JOIN Handles ON Animal.AID = Handles.AnimalID;


-- Part 1.A-g
-- For every zoo keeper's name, report the average number of hours they spend feeding an animal in their care
SELECT ZName, AVG(TimeToFeed) AS AverageSpendingFeedingTime
  FROM Animal
       JOIN Handles ON Animal.AID = Handles.AnimalID 
       JOIN ZooKeeper ON Handles.ZooKeepID = ZooKeeper.ZID
  GROUP BY ZName
  ORDER BY AverageSpendingFeedingTime DESC;


-- Part 1.A-h
-- Report every handling assignment and sort by the assignment date in ascending order
SELECT Assigned, ZName, AName
  FROM Animal
       JOIN Handles ON Animal.AID = Handles.AnimalID 
       JOIN ZooKeeper ON Handles.ZooKeepID = ZooKeeper.ZID
  ORDER BY Assigned ASC;



-- Part 2-a
-- Decompose the given schema to the Third Normal Form
/*
# Person Table
Attributes: (First, Last, Address)
Functional Dependency: First, Last ¡æ Address

# Job Table
Attributes: (Job, Salary, Assistant)
Functional Dependency: Job ¡æ Salary, Assistant
*/


-- Part 2-b
-- Write the necessary SQL DDL statements
DROP TABLE Job;
DROP TABLE Person;

CREATE TABLE Person
(
  First VARCHAR2(50),
  Last VARCHAR2(50),
  Address VARCHAR2(100),
  
  CONSTRAINT Person_PK
     PRIMARY KEY(First, Last)
);

CREATE TABLE Job
(
  Job VARCHAR2(100),
  Salary NUMBER(10, 2),
  Assistant VARCHAR2(3),
  
  CONSTRAINT Job_PK
     PRIMARY KEY(Job)
);
