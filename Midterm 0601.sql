-- Part 2-a
-- Write a SQL column definition for PurchaseAmt that ensures that the purchase amount must be between 0 and 99.99
PurchaseAmt DECIMAL(4, 2) CHECK (PurchaseAmt > 0 AND PurchaseAmt <= 99.99);

-- Part 2-b
-- Write a SQL column definition that ensures that the street address is up to 18 characters and has to start from ¡®rue¡¯ 
Street VARCHAR(18) CHECK (Street LIKE 'rue%');

-- Part 2-c1
-- Display the list of student IDs and names for the students who graduated in the most recent two years
SELECT StudentID, Name
  FROM Student
  WHERE GradYear >= (SELECT MAX(GradYear) - 1
                       FROM Student);

-- Part 2-c2
-- Display student names and their taken course names for all students with the middle name of ¡®Muriel¡¯. Your query output should be sorted by grade
SELECT S.Name, G.CName
  FROM Student S
       JOIN Grade G ON S.StudentID = G.StudentID
  WHERE S.Name LIKE '% Muriel %'
  ORDER BY G.CGrade;

-- Part 2-c3
-- For students who are either not enrolled in any courses or are enrolled in only 1 course, list those students¡¯ names and graduation years
SELECT S.Name, S.GradYear
  FROM Student S
       LEFT JOIN Grad G ON S.StudentID = G.StudentID
  GROUP BY S.StudentID, S.Name S.GradYear
  HAVING COUNT(G.CName) <= 1;

-- Part 2-c4
-- Update all student records, to increase the graduation year by 3 for all students who live in Chicago
UPDATE Student
  SET GradYear = GradYear + 3
  WHERE Address LIKE '%Chicago%';

-- Part 2-c5
-- Modify the course table to add a Chair column that can be up to 26 characters
ALTER TABLE Course
  ADD Chair VARCHAR(26);
