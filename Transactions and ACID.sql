-- Transactions and ACID

DROP TABLE Z;

CREATE TABLE Z
(
  A INTEGER,
  B VARCHAR2(20),

  CONSTRAINT Z_PK
    PRIMARY KEY (A)
);

INSERT INTO Z VALUES(1, 'abc');
INSERT INTO Z VALUES(2, 'def');

SELECT * FROM Z;

COMMIT;

INSERT INTO Z VALUES(3, 'qqq');
INSERT INTO Z VALUES(4, 'OPT');

SELECT * FROM Z;

-- You might lose your connection if you don't commit
-- COMMIT;