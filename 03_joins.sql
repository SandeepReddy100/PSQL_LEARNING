-- ============================================================================
-- FILE 3: JOINS & RELATIONSHIPS
-- Focus: Foreign Keys, INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
-- ============================================================================

-- 1. SETUP 

DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;

-- Table A: Departments

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

-- Table B: Students (Notice the 'dept_id' column)

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    rollno VARCHAR(20) UNIQUE,
    cgpa DECIMAL(3,2),
    dept_id INT -- This will link to departments.dept_id
);

-- Add Foreign Key Constraint

-- This ensures a student can only be assigned to a dept_id that actually exists.


ALTER TABLE students 
ADD CONSTRAINT fk_department 
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Modification Check

SELECT * FROM students;
SELECT * FROM departments;

-- 2. INSERTING DATA (Creating intentional mismatches for testing)

-- Insert 4 Departments (Dept 4 'Civil' will have NO students)


INSERT INTO departments (dept_name) VALUES 
('Computer Science'),  -- ID 1
('Information Tech'),  -- ID 2
('Electronics'),       -- ID 3
('Civil');             -- ID 4

-- Insert 10 Students 

INSERT INTO students (name, rollno, cgpa, dept_id) VALUES 
('Aarav Mehta', 'R001', 8.50, 1), -- CS
('Isha Singh', 'R002', 9.20, 1),  -- CS
('Kabir Das', 'R003', 7.60, 2),   -- IT
('Neha Sharma', 'R004', 8.90, 3), -- Electronics
('Rohan Verma', 'R005', 6.50, 2), -- IT
('Ananya Iyer', 'R006', 9.50, 1), -- CS
('Rahul Nair', 'R007', 8.10, 3),  -- Electronics
('Pooja Patel', 'R008', 7.80, 2), -- IT
('Vikram Rao', 'R009', 8.80, NULL), -- UNASSIGNED
('Sanya Kapoor', 'R010', 7.20, NULL); -- UNASSIGNED


-- 3. THE JOINS (Combining data from both tables)

-- A. INNER JOIN

-- Rule: Returns ONLY the records that have matching values in BOTH tables.

-- Result: Vikram, Sanya, and the 'Civil' department will NOT show up.

SELECT students.name, students.rollno, departments.dept_name
FROM students
INNER JOIN departments ON students.dept_id = departments.dept_id;


-- B. LEFT JOIN (or LEFT OUTER JOIN)

-- Rule: Returns ALL records from the LEFT table (students), plus matched records from the RIGHT (departments).

-- Result: Vikram and Sanya WILL show up, but their dept_name will be NULL. 'Civil' dept is missing.


SELECT students.name, students.rollno, departments.dept_name
FROM students
LEFT JOIN departments ON students.dept_id = departments.dept_id;


-- C. RIGHT JOIN (or RIGHT OUTER JOIN)

-- Rule: Returns ALL records from the RIGHT table (departments), plus matched records from the LEFT.

-- Result: The 'Civil' department WILL show up with NULLs for student details. Vikram and Sanya are missing.

SELECT students.name, students.rollno, departments.dept_name
FROM students
RIGHT JOIN departments ON students.dept_id = departments.dept_id;


-- D. FULL JOIN (or FULL OUTER JOIN)

-- Rule: Returns ALL records when there is a match in EITHER left or right table.

-- Result: EVERYONE shows up. Vikram/Sanya have NULL departments, 'Civil' has NULL students.

SELECT students.name, students.rollno, departments.dept_name
FROM students
FULL JOIN departments ON students.dept_id = departments.dept_id;


-- 4. USING ALIASES (Making queries shorter)

-- Instead of typing 'students.name', we can temporarily nickname tables using 'AS' or just a space.

-- 's' for students, 'd' for departments.

SELECT s.name, s.cgpa, d.dept_name
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id
WHERE s.cgpa > 8.00;