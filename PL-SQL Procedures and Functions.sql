-- PL-SQL Procedures and Functions Examples

-- Procedure Example 1
CREATE OR REPLACE PROCEDURE 
  Enroll (SID NUMBER, CID NUMBER, Quarter VARCHAR2, Year NUMBER) AS
BEGIN
  INSERT INTO Enrolled VALUES (SID, CID, Quarter, Year);
END;
/

CALL Enroll (11035, 3201, 'Fall', 2011); 
  
SELECT * FROM Enrolled;

-- Procedure Example 2
CREATE OR REPLACE PROCEDURE
  PFactorial (p_num IN OUT NUMBER) IS v_fact NUMBER;
BEGIN
   v_fact := 1;
   LOOP EXIT WHEN p_num = 0;
        v_fact := v_fact * p_num;
        p_num := p_num - 1;
   END LOOP;
   p_num := v_fact;
END;
/

DECLARE
  my_answer NUMBER;
BEGIN
   my_answer := 7;
   PFactorial(my_answer);
   DBMS_OUTPUT.PUT_LINE('Factorial is ' || my_answer);      
END;
/

-- Functions Example 1
CREATE OR REPLACE FUNCTION 
  Age_Yr (Year NUMBER) RETURN NUMBER AS
BEGIN
  RETURN EXTRACT (YEAR FROM SYSDATE) - YEAR;
END;
/

SELECT SID, Age_Yr(Started)
  FROM Student3;

-- Functions Example 2
CREATE OR REPLACE FUNCTION 
  Factorial (n POSITIVE) RETURN INTEGER IS  
BEGIN
  IF n = 1 THEN
     RETURN 1;
  ELSE RETURN n * Factorial(n - 1);
  END IF;
END;
/

DECLARE
  Result POSITIVE;
  ValN POSITIVE;
BEGIN
  ValN := 6;
  Result := Factorial(ValN);
  DBMS_OUTPUT.PUT_LINE('Factorial is ' || Result);    
END;
/

SELECT SID, Factorial(Started - 1990)
  FROM Student3;

-- Viewing Procedures and Functions in the Database
SELECT Object_Type, Object_Name
  FROM User_Objects
  WHERE Object_Type = 'PROCEDURE'
        OR Object_Type = 'FUNCTION';
