-- PL-SQL Branch and Loops Examples

SET SERVEROUTPUT ON;

-- Branching

DECLARE
  myName VARCHAR2(15) := 'Name1';
  yourName VARCHAR2(15) := 'Name2';
BEGIN
  IF myName = yourName THEN
     DBMS_OUTPUT.PUT_LINE('Our names are the same!');
  END IF;
END;
/

DECLARE
  myName VARCHAR2(15) := 'Jaewon';
  yourName VARCHAR2(15) := 'Jaewon';
BEGIN
  IF myName = yourName THEN
     DBMS_OUTPUT.PUT_LINE('Our names are the same!');
  END IF;
END;
/

DECLARE
  sales NUMBER(8, 2) := 12100;
  quota NUMBER(8, 2) := 10000;
  bonus NUMBER(6, 2);
BEGIN
  IF sales > (quota + 200) THEN
     bonus := (sales - quota) / 4;
  ELSE
     bonus := 50;
  END IF;
  DBMS_OUTPUT.PUT_LINE('The final bouns is... ' || bonus);
END;
/

BEGIN
  IF DBMS_RANDOM.value(0, 1) > 0.5 THEN
     DBMS_OUTPUT.PUT_LINE('Head');
  ELSE DBMS_OUTPUT.PUT_LINE('Tail');
  END IF;
END;
/

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';
  IF grade = 'A' THEN
     DBMS_OUTPUT.PUT_LINE('Excellent');
  ELSIF grade = 'B' THEN
        DBMS_OUTPUT.PUT_LINE('Very Good');
  ELSIF grade = 'C' THEN
        DBMS_OUTPUT.PUT_LINE('Good');
  ELSIF grade = 'D' THEN
        DBMS_OUTPUT.PUT_LINE('Fair');
  ELSIF grade = 'F' THEN
        DBMS_OUTPUT.PUT_LINE('Poor');
  ELSE DBMS_OUTPUT.PUT_LINE('No such grade');
  END IF;
END;
/

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';
  CASE grade
    WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('Very Good');
    WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN 'D' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    WHEN 'F' THEN DBMS_OUTPUT.PUT_LINE('Poor');
    ELSE DBMS_OUTPUT.PUT_LINE('No such grade');
  END CASE;
END;
/


-- Loops

DECLARE
  hundreds_counter NUMBER(3);
BEGIN
  hundreds_counter := 100;
  LOOP DBMS_OUTPUT.PUT_LINE(hundreds_counter);
       hundreds_counter := hundreds_counter + 100;
  END LOOP;
END;
/

DECLARE
  hundreds_counter NUMBER(3);
BEGIN
  hundreds_counter := 100;
  LOOP DBMS_OUTPUT.PUT_LINE(hundreds_counter);
       hundreds_counter := hundreds_counter + 100;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('That is as high as you can go.');
END;
/

DECLARE
  hundreds_counter NUMBER(3);
BEGIN
  hundreds_counter := 100;
  WHILE hundreds_counter <= 800
    LOOP DBMS_OUTPUT.PUT_LINE(hundreds_counter);
         hundreds_counter := hundreds_counter + 100;
    END LOOP;
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('That is as high as you can go.');
END;
/

DECLARE
  i NUMBER := 1;
BEGIN
  LOOP i := i + 1;
    EXIT WHEN i >= 10;
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;
/

DECLARE
  fin CHAR(50) := 'That''s all numbers between 50 and 55';
  counter NUMBER(3);
BEGIN
  FOR counter IN 50 .. 55
    LOOP DBMS_OUTPUT.PUT_LINE('Counter  = ' || counter);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(fin);
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('This would have been an error.');
END;
/

DECLARE
  fin CHAR(50) := 'That''s all numbers between 55 and 50';
  counter NUMBER(3);
BEGIN
  FOR counter IN REVERSE 50 .. 55
    LOOP DBMS_OUTPUT.PUT_LINE('Counter  = ' || counter);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(fin);
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('This would have been an error.');
END;
/

DECLARE
  counter NUMBER(3);
BEGIN
  FOR counter IN -5 .. 5
    LOOP DBMS_OUTPUT.PUT_LINE('37 divided by ' || counter || ' = ' || (37 / counter));
    END LOOP;
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('This would have been an error.');
END;
/
