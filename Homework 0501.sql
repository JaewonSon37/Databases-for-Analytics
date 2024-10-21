-- Part 1

DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE PROJECT CASCADE CONSTRAINTS;
DROP TABLE WORKS_ON CASCADE CONSTRAINTS;

CREATE TABLE EMPLOYEE
(
  FName VARCHAR(20),
  Minit CHAR(1),
  LName VARCHAR(20),
  SSN CHAR(9),
  BDate DATE,
  Address VARCHAR(30),
  Sex CHAR(1),
  Salary NUMBER(5),
  Super_SSN	CHAR(9),
  DNo NUMBER(1),
 
  CONSTRAINT EMPLOYEE_PK
	 PRIMARY KEY (SSN),
  
  CONSTRAINT EMPLOYEE_FK1
	 FOREIGN KEY (Super_SSN)
       REFERENCES EMPLOYEE(SSN)
);

INSERT INTO EMPLOYEE VALUES ('James', 'E', 'Borg', '888665555', DATE '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1);
INSERT INTO EMPLOYEE VALUES ('Jennifer', 'S', 'Wallace', '987654321', DATE '1941-06-20', '291 Berry, Bellaire, Tx', 'F', 37000, '888665555', 4);
INSERT INTO EMPLOYEE VALUES ('Franklin', 'T', 'Wong', '333445555', DATE '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, '888665555', 5);
INSERT INTO EMPLOYEE VALUES ('John', 'B', 'Smith', '123456789', DATE '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Alicia', 'J', 'Zelaya', '999887777', DATE '1968-01-19', '3321 castle, Spring, TX', 'F', 25000, '987654321', 4);
INSERT INTO EMPLOYEE VALUES ('Ramesh', 'K', 'Narayan', '666884444', DATE '1920-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Joyce', 'A', 'English', '453453453', DATE '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Ahmad', 'V', 'Jabbar', '987987987', DATE '1969-03-29', '980 Dallas, Houston, TX', 'M', 22000, '987654321', 4);
INSERT INTO EMPLOYEE VALUES ('Melissa', 'M', 'Jones', '808080808', DATE '1970-07-10', '1001 Western, Houston, TX', 'F', 27500, '333445555', 5);

CREATE TABLE DEPARTMENT
(
  DName	VARCHAR(20),
  DNumber NUMBER(1),
  Mgr_SSN CHAR(9),
  Mgr_Start_Date DATE,

  CONSTRAINT DEPARTMENT_PK
	 PRIMARY KEY (DNumber),

  CONSTRAINT DEPARTMENT_FK
	 FOREIGN KEY (Mgr_SSN)
       REFERENCES EMPLOYEE(SSN)
);

INSERT INTO DEPARTMENT VALUES ('Research', 5, '333445555', DATE '1988-05-22');
INSERT INTO DEPARTMENT VALUES ('Administration', 4, '987654321', DATE '1995-01-01');
INSERT INTO DEPARTMENT VALUES ('Headquarters', 1, '888665555', DATE '1981-06-19');

ALTER TABLE EMPLOYEE   
  ADD CONSTRAINT EMPLOYEE_FK2
         FOREIGN KEY (DNo)
           REFERENCES DEPARTMENT(DNumber);

CREATE TABLE PROJECT
(
  PName VARCHAR(20),
  PNumber NUMBER(2),
  PLocation VARCHAR(20),
  DNum NUMBER(1),

  CONSTRAINT PROJECT_PK
     PRIMARY KEY (PNumber)
);

INSERT INTO PROJECT VALUES ('ProductX', 1, 'Bellaire', 5);
INSERT INTO PROJECT VALUES ('ProductY', 2, 'Sugarland', 5);
INSERT INTO PROJECT VALUES ('ProductZ', 3, 'Houston', 5);
INSERT INTO PROJECT VALUES ('Computerization', 10, 'Stafford', 4);
INSERT INTO PROJECT VALUES ('Reorganization', 20, 'Houston', 1);
INSERT INTO PROJECT VALUES ('Newbenefits', 30, 'Stafford', 4);

CREATE TABLE WORKS_ON
(
  ESSN CHAR(9),
  PNo NUMBER(2),
  Hours NUMBER(3,1),

  CONSTRAINT WORKS_ON_PK
	 PRIMARY KEY (ESSN, PNo),

  CONSTRAINT WORKS_ON_FK1
	 FOREIGN KEY (ESSN)
       REFERENCES EMPLOYEE(SSN),

  CONSTRAINT WORKS_ON_FK2
     FOREIGN KEY (PNo)
       REFERENCES PROJECT(PNumber)
);

INSERT INTO WORKS_ON VALUES ('123456789', 1, 32.0);
INSERT INTO WORKS_ON VALUES ('123456789', 2, 8.0);
INSERT INTO WORKS_ON VALUES ('453453453', 1, 20.0);
INSERT INTO WORKS_ON VALUES ('453453453', 2, 20.0);
INSERT INTO WORKS_ON VALUES ('333445555', 1, 10.0);
INSERT INTO WORKS_ON VALUES ('333445555', 2, 10.0);
INSERT INTO WORKS_ON VALUES ('333445555', 3, 5.0);
INSERT INTO WORKS_ON VALUES ('333445555', 10, 10.0);
INSERT INTO WORKS_ON VALUES ('333445555', 20, 10.0);
INSERT INTO WORKS_ON VALUES ('333445555', 30, 5.0);
INSERT INTO WORKS_ON VALUES ('999887777', 30, 30.0);
INSERT INTO WORKS_ON VALUES ('999887777', 10, 10.0);
INSERT INTO WORKS_ON VALUES ('987987987', 10, 35.0);
INSERT INTO WORKS_ON VALUES ('987987987', 30, 5.0);
INSERT INTO WORKS_ON VALUES ('987654321', 30, 20.0);
INSERT INTO WORKS_ON VALUES ('987654321', 20, 15.0);
INSERT INTO WORKS_ON VALUES ('888665555', 20, 10.0);

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;


-- Part 1-a
-- Find the names of all employees who are directly supervised by 'Franklin T Wong'
SELECT FName, Minit, LName
  FROM EMPLOYEE
  WHERE SUPER_SSN = (SELECT SSN
                       FROM EMPLOYEE 
                       WHERE FName = 'Franklin'
                             AND Minit = 'T'
                             And LName = 'Wong');


-- Part 1-b
-- List the project name, project number, and the average hours per week for each project
SELECT P.PName, P.PNumber, AVG(W.Hours)
  FROM PROJECT P
       JOIN WORKS_ON W ON P.PNumber = W.PNo
  GROUP BY P.PName, P.PNumber;


-- Part 1-c
-- Retrieve the department name and the maximum salary of employees working in that department for each department and order the output by department number in ascending order
SELECT D.DName, MAX(E.Salary)
  FROM DEPARTMENT D
       JOIN EMPLOYEE E ON D.DNumber = E.DNo
  GROUP BY D.DName, D.DNumber
  ORDER BY D.DNumber ASC;


-- Part 1-d
-- Retrieve the average salary of all male employees
SELECT AVG(Salary)
  FROM EMPLOYEE
  WHERE Sex = 'M';


-- Part 1-e
--  For each department whose average salary is greater than $43,000, retrieve the department name and the number of employees in that department
SELECT D.DName, COUNT(E.SSN)
  FROM DEPARTMENT D
       JOIN EMPLOYEE E ON D.DNumber = E.DNo
  GROUP BY D.DName
  HAVING AVG(E.Salary) > 43000;


-- Part 1-f
-- Retrieve the names of employees whose salary is within $22,000 of the salary of the employee who is paid the most in the company 
SELECT FName, Minit, LName, Salary
  FROM EMPLOYEE
  WHERE Salary >= (SELECT MAX(Salary) - 22000
                     FROM EMPLOYEE);


-- Part 1-g
-- Find all female employees using 'Plain SELECT Query' and 'Sub-Query'
SELECT FName, Minit, LName
  FROM EMPLOYEE
  WHERE Sex = 'F';

SELECT FName, Minit, LName
  FROM EMPLOYEE
  WHERE SSN IN (SELECT SSN
                  FROM EMPLOYEE
                  WHERE Sex = 'F');


-- Part 1-h
-- Find all employees who are not assigned to any project using a SET operation
SELECT FName, Minit, LName
  FROM EMPLOYEE
MINUS
SELECT E.FName, E.Minit, E.LName
  FROM EMPLOYEE E
       JOIN WORKS_ON W ON E.SSN = W.ESSN;
