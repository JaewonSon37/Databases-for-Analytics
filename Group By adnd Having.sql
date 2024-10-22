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
     
  CONSTRAINT Transaction_PK
     PRIMARY KEY (StoreID, TransID),
     
  CONSTRAINT Transaction_FK
     FOREIGN KEY (StoreID)
       REFERENCES Store(StoreID)
);

INSERT INTO Store VALUES (100, 'Chicago', 'IL');
INSERT INTO Store VALUES (200, 'Chicago', 'IL');
INSERT INTO Store VALUES (300, 'Schaumburg', 'IL');
INSERT INTO Store VALUES (400, 'Boston', 'MA');
INSERT INTO Store VALUES (500, 'Boston', 'MA');
INSERT INTO Store VALUES (600, 'Portland', 'ME');

INSERT INTO Transaction VALUES(100, 1, '10-Oct-2011', 100.00);
INSERT INTO Transaction VALUES(100, 2, '11-Oct-2011', 120.00);
INSERT INTO Transaction VALUES(200, 1, '11-Oct-2011', 50.00);
INSERT INTO Transaction VALUES(200, 2, '11-Oct-2011', 70.00);
INSERT INTO Transaction VALUES(300, 1, '12-Oct-2011', 20.00);
INSERT INTO Transaction VALUES(400, 1, '10-Oct-2011', 10.00);
INSERT INTO Transaction VALUES(400, 2, '11-Oct-2011', 20.00);
INSERT INTO Transaction VALUES(400, 3, '12-Oct-2011', 30.00);
INSERT INTO Transaction VALUES(500, 1, '10-Oct-2011', 10.00);
INSERT INTO Transaction VALUES(500, 2, '10-Oct-2011', 110.00);
INSERT INTO Transaction VALUES(500, 3, '11-Oct-2011', 90.00);
INSERT INTO Transaction VALUES(600, 1, '11-Oct-2011', 300.00);
INSERT INTO Transaction VALUES(600, 2, NULL, 300.00);

SELECT *
  FROM Store;

SELECT * 
  FROM Transaction;

SELECT *
  FROM Transaction
  WHERE TDate IS NULL;
  
SELECT DISTINCT City
  FROM Store;

SELECT DISTINCT City, State
  FROM Store;

SELECT *
  FROM Store
  WHERE StoreID >= 500;

SELECT *
  FROM Store
  WHERE StoreID != 600;

SELECT *
  FROM Store
  WHERE State = 'IL';

SELECT StoreID, Amount, TDate
  FROM Transaction
  WHERE TDate >= TO_DATE('11-Oct-2011');

SELECT *
  FROM Store
  WHERE State LIKE '__';

SELECT *
  FROM Store
  WHERE City LIKE '_h%';

SELECT DISTINCT City, State
  FROM Store
  WHERE State = 'IL' OR State = 'ME';

SELECT *
  FROM Transaction
  WHERE Amount < 50 OR Amount > 100;

SELECT *
  FROM Transaction
  WHERE Amount > 50 AND Amount < 100;

SELECT *
  FROM Transaction
  WHERE (TDate = TO_DATE('11-Oct-2011') OR Amount > 100)
         AND Amount < 150;

SELECT TDate, Amount
  FROM Transaction
  WHERE (Amount >= 20 AND Amount < 35)
         OR (Amount > 100 AND Amount <= 120);

SELECT *
  FROM Transaction
  WHERE (Amount >= 20 AND Amount < 35)
         OR (Amount > 100 AND Amount <= 120)
  ORDER BY Amount ASC;

SELECT *
  FROM Store
  ORDER BY State;

SELECT *
  FROM Store
  ORDER BY State, City DESC;

SELECT COUNT(*)
  FROM Store;

SELECT COUNT(*)
  FROM Transaction;

SELECT COUNT(State)
  FROM Store;

SELECT AVG(Amount)
  FROM Transaction;

SELECT SUM(Amount) / COUNT(Amount) 
  FROM Transaction;

SELECT SUM(Amount), COUNT(StoreID), COUNT(Amount)
  FROM Transaction;

/*
Below will generate an error
SELECT SUM(Amount), StoreID
  FROM Transaction;
*/

SELECT COUNT(*), COUNT(Amount), COUNT(TDate)
  FROM Transaction;

SELECT COUNT(*) - COUNT(TDate), COUNT(*) - COUNT(Amount)
  FROM Transaction;

SELECT COUNT(*), COUNT(State), COUNT(DISTINCT State)
  FROM Store;

SELECT SUM(Amount)
  FROM Transaction
  WHERE Amount <= 20 OR Amount >= 100;

SELECT State, COUNT(StoreID)
  FROM Store
  GROUP BY State;

SELECT State, COUNT(DISTINCT City)
  FROM Store
  GROUP BY State;

SELECT State, City, COUNT(StoreID)
  FROM Store
  GROUP BY State, City
  ORDER BY COUNT(StoreID);

SELECT TDate, SUM(Amount)
  FROM Transaction
  GROUP BY TDate;

SELECT StoreID, MAX(Amount)
  FROM Transaction
  GROUP BY StoreID
  ORDER BY StoreID;

SELECT MAX(Amount)
  FROM Transaction
  GROUP BY StoreID;

SELECT StoreID, 0.9 * MIN(Amount)
  FROM Transaction
  GROUP BY StoreID
  ORDER BY MAX(Amount);

SELECT MAX(Amount)
  FROM Transaction
  GROUP BY StoreID
  HAVING MAX(Amount) > 100;

SELECT State, COUNT(City)
  FROM Store
  GROUP BY State
  HAVING COUNT(City) >= 3;
