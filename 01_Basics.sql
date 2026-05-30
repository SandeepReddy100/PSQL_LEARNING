-- ==========================================
-- FILE 1: DDL (Data Definition Language)
-- Focus: CREATE, ALTER, DROP, TRUNCATE
-- ==========================================

-- 1. CREATE DATABASE

-- Creates a new database. (Run this, then connect to it using \c school_db)


CREATE DATABASE Repo_Db_Psql;



-- 2. CREATE TABLE

-- Defines the structure of the table and data types.


CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,    -- Auto-incrementing unique ID
    name VARCHAR(50) NOT NULL,        -- String, cannot be empty
    rollno VARCHAR(20) UNIQUE,        -- String, must be unique for everyone
    marks INT CHECK (marks >= 0),     -- Integer, must be 0 or higher
    section CHAR(1),                  -- Single character (A, B, C, etc.)
    grade VARCHAR(2),                 -- Max 2 characters (A+, B, etc.)
    cgpa DECIMAL(3,2)                 -- Number with 3 total digits, 2 after decimal (e.g., 9.85)
);


-- 3. INSERT DATA 


-- Adding 10 rows of dummy data to work with.


INSERT INTO students (name, rollno, marks, section, grade, cgpa) VALUES 
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

-- Data Check

SELECT * FROM students;


-- 4. ALTER TABLE COMMANDS


-- Used to modify the table structure after it has been created.

-- Add a completely new column

ALTER TABLE students 
ADD COLUMN city VARCHAR(50);

-- Modification Check

SELECT * FROM students;



-- Set a default value for the new column

ALTER TABLE students 
ALTER COLUMN city SET DEFAULT 'Hyderabad';

-- Modification Check

SELECT * FROM students;


-- Change the data type of an existing column 

ALTER TABLE students 
ALTER COLUMN name TYPE VARCHAR(100);


-- Modification Check

SELECT * FROM students;


-- Rename an existing column

ALTER TABLE students 
RENAME COLUMN marks TO total_marks;

-- Modification Check

SELECT * FROM students;


-- Add a new constraint (e.g., CGPA cannot exceed 10.00)

ALTER TABLE students 
ADD CONSTRAINT check_cgpa CHECK (cgpa <= 10.00);

-- Modification Check

SELECT * FROM students;


-- Drop (remove) a column we no longer need

ALTER TABLE students 
DROP COLUMN city;

-- Modification Check

SELECT * FROM students;


-- 5. TRUNCATE AND DROP (Commented out for safety)

-- These commands destroy data or structures.



-- TRUNCATE deletes all 10 rows instantly but leaves the empty table structure ready to use again.
-- TRUNCATE TABLE students;


-- DROP completely deletes the table structure and all its data. It will no longer exist.
-- DROP TABLE students;