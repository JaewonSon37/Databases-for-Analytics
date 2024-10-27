-- PL-SQL Anonymous Block Examples

SET SERVEROUTPUT ON;

-- Hello World
DECLARE
  v_line VARCHAR2(40);
BEGIN
  v_line := 'Hello World';
  DBMS_OUTPUT.PUT_LINE(v_line);
END;
/

-- Value Concatenation
DECLARE
  v_line1 VARCHAR2(20);
  v_line2 VARCHAR2(20);
BEGIN
  v_line1 := 'Hello ...';
  v_line2 := '+... World';
  DBMS_OUTPUT.PUT_LINE(v_line1 || v_line2);
END;
/

-- Declaring Types
DECLARE
  v_line1 VARCHAR2(20);
  v_line2 v_line1%TYPE;
BEGIN
  v_line1 := 'Hello ...';
  v_line2 := '+... World';
  DBMS_OUTPUT.PUT_LINE(v_line1 || v_line2);
END;
/

-- Default Variable Settings
DECLARE
  v_line1 VARCHAR2(20) := 'Default A ';
  v_line2 VARCHAR2(20) := 'Default B';
BEGIN
  DBMS_OUTPUT.PUT_LINE('Before: ' || v_line1 || v_line2);
  v_line1 := 'Hello ...';
  v_line2 := '+... World';
  DBMS_OUTPUT.PUT_LINE(v_line1 || v_line2);
END;
/

-- Assign values of SQL statements
DECLARE
  first_started NUMBER;
BEGIN
  SELECT MIN(started) INTO first_started
    FROM Student2;
    DBMS_OUTPUT.PUT_LINE(first_started);
END;
/

-- Errors and Exceptions
DECLARE
  first_started NUMBER;
  sid NUMBER;
BEGIN
  SELECT MIN(started) INTO first_started
    FROM Student2;
  SELECT SID INTO sid
    FROM Student2
    WHERE started = first_started;
    DBMS_OUTPUT.PUT_LINE(sid);
END;
/

DECLARE
  first_started NUMBER;
  sid NUMBER;
BEGIN
  SELECT MIN(started) INTO first_started
    FROM Student2;
  SELECT SID INTO sid
    FROM Student2
    WHERE started = first_started;
    DBMS_OUTPUT.PUT_LINE(sid);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
       DBMS_OUTPUT.PUT_LINE('Several Students in First Year');
END;
/
