-- Materialized View Example

CREATE OR REPLACE VIEW ECStudents AS
  SELECT *
  FROM Student2
  WHERE City IN ('Evanston', 'Chicago');

SELECT * FROM ECStudents;

CREATE MATERIALIZED VIEW ECStudentsMV AS
  SELECT * 
  FROM Student2
  WHERE City IN ('Evanston', 'Chicago');

SELECT * FROM ECStudentsMV;
