-- PL-SQL Cursors Examples

DROP TABLE Point2D;

CREATE TABLE Point2D
(
  X INTEGER,
  Y INTEGER,
  
  CONSTRAINT Point2D_PK
     PRIMARY KEY (X, Y)
);

INSERT INTO Point2D VALUES (5, 6);
INSERT INTO Point2D VALUES (6, 7);
INSERT INTO Point2D VALUES (11, 13);

-- Select one row into variables
DECLARE
  A NUMBER;
  B NUMBER;
BEGIN
  SELECT X, Y INTO A, B 
    FROM Point2D 
    WHERE Y > 12;
  IF (B > A) THEN
   	 INSERT INTO Point2D VALUES(B, A);
  END IF;
END;
/

SELECT * FROM Point2D;

-- Doesn't work when more than one row returns
DECLARE
  A NUMBER;
  B NUMBER;
BEGIN
  SELECT X, Y INTO A, B 
    FROM Point2D 
    WHERE Y < 12;
  IF (B > A) THEN
   	 INSERT INTO Point2D VALUES(B, A);
  END IF;
END;
/

-- Find all points between 1 and 10 (x-axis)
DECLARE
  A NUMBER;
  B NUMBER;
  vCount NUMBER;
BEGIN
  FOR counter IN 1 .. 10 
    LOOP SELECT COUNT(*) INTO vCount 
           FROM Point2D 
           WHERE X BETWEEN counter AND counter + 1; 
  IF vCount = 1 THEN
     SELECT X,Y INTO A, B
       FROM Point2D 
       WHERE X BETWEEN counter AND counter + 1;
       DBMS_OUTPUT.PUT_LINE('Found ' || A || ' and ' || B);
  ELSE DBMS_OUTPUT.PUT_LINE('Too many (or too few) values -> ' || vCount);
  END IF;
  END LOOP;
END;
/

DROP TABLE Point2D;

CREATE TABLE Point2D
(
  X INTEGER,
  Y INTEGER,
  
  CONSTRAINT Point2D_PK
     PRIMARY KEY (X, Y)
);

INSERT INTO Point2D VALUES (5, 6);
INSERT INTO Point2D VALUES (6, 7);
INSERT INTO Point2D VALUES (11, 13);
INSERT INTO Point2D VALUES (37, 42);
INSERT INTO Point2D VALUES (15, 14);

-- A more complicated query
DECLARE
  A Point2D.X%TYPE;
  B Point2D.Y%TYPE;
  CURSOR T1Cursor IS
    SELECT X, Y
      FROM Point2D   
      WHERE X < Y;    
BEGIN
  OPEN T1Cursor;
  LOOP FETCH T1Cursor INTO A, B;
       IF T1Cursor%FOUND THEN
          DBMS_OUTPUT.PUT_LINE('I just found ' || A || ', ' || B);
       END IF;
       EXIT WHEN T1Cursor%NOTFOUND;
       INSERT INTO Point2D VALUES(B, A);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('In total, we fetched ' || T1Cursor%rowcount || ' rows.');
  CLOSE T1Cursor;
END;
/

SELECT * FROM Point2D;

-- A parametrized cursor
DECLARE
  A Point2D.X%TYPE;
  B Point2D.Y%TYPE;
  CURSOR T1Cursor (LOW INTEGER, HIGH INTEGER) IS
    SELECT X, Y
      FROM Point2D   
      WHERE X BETWEEN LOW AND HIGH;    
BEGIN
  OPEN T1Cursor(1, 8);
  LOOP FETCH T1Cursor INTO A, B;
       EXIT WHEN T1Cursor%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE('We will try to insert (' || B || ', ' || A || ')');
       DBMS_OUTPUT.PUT_LINE('In total, we fetched ' || T1Cursor%rowcount || ' row(s).');
  END LOOP;
  CLOSE T1Cursor;
END;
/

SELECT * FROM Point2D;

-- An example with Student2 table
DECLARE
  st_id Student2.SID%TYPE;
  ln Student2.LastName%TYPE;
  fn Student2.FirstName%TYPE;
  CURSOR STCursor IS
    SELECT SID, LastName, FirstName
      FROM Student2;
BEGIN
  OPEN STCursor;
  LOOP FETCH STCursor INTO st_id, ln, fn;
       EXIT WHEN STCursor%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE('Student: ' || fn || ' ' || ln);
  END LOOP;
  CLOSE STCursor;
END;
/
