-- ============================================================================
-- FILE 2: DML (Data Manipulation Language) & CRUD Operations
-- Focus: INSERT (Create), SELECT (Read), UPDATE (Update), DELETE (Delete)
-- ============================================================================

-- 1. SETUP 

DROP TABLE IF EXISTS students; -- Clears table if it already exists


CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    rollno VARCHAR(20) UNIQUE,
    total_marks INT CHECK (total_marks >= 0),
    section CHAR(1),
    grade VARCHAR(2),
    cgpa DECIMAL(3,2)
);



-- INSERT: Adding multiple rows into the table


INSERT INTO students (name, rollno, total_marks, section, grade, cgpa) VALUES 
('Aarav Mehta', 'R001', 85, 'A', 'A', 8.50),
('Isha Singh', 'R002', 92, 'A', 'A+', 9.20),
('Kabir Das', 'R003', 76, 'B', 'B', 7.60),
('Neha Sharma', 'R004', 89, 'A', 'A', 8.90),
('Rohan Verma', 'R005', 65, 'C', 'C', 6.50),
('Ananya Iyer', 'R006', 95, 'B', 'A+', 9.50),
('Rahul Nair', 'R007', 81, 'C', 'A', 8.10),
('Pooja Patel', 'R008', 78, 'B', 'B', 7.80),
('Vikram Rao', 'R009', 88, 'A', 'A', 8.80),
('Sanya Kapoor', 'R010', 72, 'C', 'B', 7.20);



-- 2. SELECT COMMANDS 


-- A. Fetch everything from the table

SELECT * FROM students;



-- B. Fetch only specific columns

SELECT name, rollno, cgpa FROM students;



-- C. Filter rows using WHERE 

SELECT * FROM students 
WHERE section = 'A';



-- D. Filter using numbers 

SELECT name, total_marks FROM students 
WHERE total_marks > 80;



-- E. Filter using multiple conditions (AND / OR)

SELECT name, section, grade FROM students 
WHERE section = 'B' AND total_marks > 75;



-- F. Pattern matching using LIKE (% means any character sequence)
-- Finds anyone whose name starts with 'R'

SELECT name FROM students 
WHERE name LIKE 'R%';



-- G. Sorting the results using ORDER BY (DESC for highest to lowest)

SELECT name, cgpa FROM students 
ORDER BY cgpa DESC;



-- H. Limit the number of results (Top 3 students)

SELECT name, cgpa FROM students 
ORDER BY cgpa DESC 
LIMIT 3;





-- 3. UPDATE COMMANDS (Modifying existing data)


-- A. Update a single row (Give Rohan extra marks)
-- ALWAYS use a WHERE clause with UPDATE, or it will change every row!

UPDATE students 
SET total_marks = 68, cgpa = 6.80 
WHERE rollno = 'R005';

-- Modification Check

SELECT * FROM students;

-- B. Update multiple rows based on a condition
-- Give everyone in section C a 'B' grade

UPDATE students 
SET grade = 'B' 
WHERE section = 'C';

-- Modification Check

SELECT * FROM students;



-- 4. DELETE COMMANDS (Removing rows)


-- A. Delete a specific row
-- ALWAYS use a WHERE clause, or it deletes everything!

DELETE FROM students 
WHERE rollno = 'R010';

-- Modification Check

SELECT * FROM students;


-- B. Delete multiple rows based on a condition
-- Remove all students whose total marks are below 70

DELETE FROM students 
WHERE total_marks < 70;

-- Modification Check

SELECT * FROM students;


 
-- 5. THE 'RETURNING' CLAUSE (PostgreSQL specific magic)

-- In Postgres, you can see exactly what row you just Updated/Inserted/Deleted
-- without having to write a separate SELECT query.


UPDATE students 
SET cgpa = 9.90 
WHERE rollno = 'R006' 
RETURNING name, cgpa; -- Instantly shows Ananya's new CGPA

-- Modification Check

SELECT * FROM students;