-- Part 1
DROP TABLE Animal;

CREATE TABLE Animal
(
  AID NUMBER(3, 0),
  AName VARCHAR2(32) NOT NULL,
  -- ACategory: Animal category which can be 'common', 'rare', 'exotic', and NULL
  ACategory VARCHAR2(18),
  -- TimeToFeed: Time it takes to feed the animal (hours)
  TimeToFeed NUMBER(4, 2), 
 
  CONSTRAINT Animal_PK
     PRIMARY KEY(AID)
);

INSERT INTO Animal VALUES(1, 'Galapagos Penguin', 'exotic', 0.6);
INSERT INTO Animal VALUES(2, 'Emperor Penguin', 'rare', 0.75);
INSERT INTO Animal VALUES(3, 'Sri Lankan sloth bear', 'exotic', 2.5);
INSERT INTO Animal VALUES(4, 'Grizzly bear', 'common', 3.0);
INSERT INTO Animal VALUES(5, 'Giant Panda bear', 'exotic', 1.5);
INSERT INTO Animal VALUES(6, 'Florida black bear', 'rare', 1.5);
INSERT INTO Animal VALUES(7, 'Siberian tiger', 'rare', 3.25);
INSERT INTO Animal VALUES(8, 'Bengal tiger', 'common', 2.75);
INSERT INTO Animal VALUES(9, 'South China tiger', 'exotic', 2.5);
INSERT INTO Animal VALUES(10, 'Alpaca', 'common', 0.25);
INSERT INTO Animal VALUES(11, 'Llama', NULL, 3.75);


-- Part 1-a
-- Find animals that take less than 2 hours to feed
SELECT AName
  FROM Animal
  WHERE TimeToFeed < 2;


-- Part 1-b
-- Find both the 'rare' and 'exotic' animals
SELECT AName, ACategory
  FROM Animal
  WHERE ACategory = 'rare' OR ACategory = 'exotic';


-- Part 1-c
-- Return the listings for all animals whose rarity is missing
SELECT * FROM Animal
  WHERE ACategory IS NULL;


-- Part 1-d
-- Find the rarity of all animals that require between 1.75 and 2.5 hours to be fed
SELECT AName, ACategory, TimeToFeed
  FROM Animal
  WHERE TimeToFeed BETWEEN 1.75 AND 2.5;


-- Part 1-e
-- Find the minimum and maximum feeding time
SELECT MIN(TimeToFeed) AS MinFeedingTime,
       MAX(TimeToFeed) AS MaxFeedingTime
  FROM Animal;


-- Part 1-f
-- Find the average feeding time for all of the common animals
SELECT AVG(TimeToFeed) AS AverageFeedingTime
  FROM Animal
  WHERE ACategory = 'common';


-- Part 1-g
-- Determine how many NULLs there are in the ACategory column
SELECT COUNT(*) AS NullCount
  FROM Animal
  WHERE ACategory IS NULL;


-- Part 1-h
-- Find all animals named 'Alpaca', 'Llama' or any other animals that are not listed as 'exotic'
SELECT AName, ACategory
  FROM Animal
  WHERE AName IN ('Alpaca', 'Llama')
        OR ACategory != 'exotic';
