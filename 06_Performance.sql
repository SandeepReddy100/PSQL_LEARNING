-- ============================================================================
-- FILE 6: PERFORMANCE & DATABASE OBJECTS
-- Focus: VIEWS, INDEXES, EXPLAIN ANALYZE, TRIGGERS
-- ============================================================================

-- 1. SETUP 

DROP TABLE IF EXISTS students CASCADE;



CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    rollno VARCHAR(20) UNIQUE,
    total_marks INT CHECK (total_marks >= 0),
    section CHAR(1),
    grade VARCHAR(2),
    cgpa DECIMAL(3,2)
);



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


-- 2. VIEWS (Virtual Tables)

-- A View is a saved query that acts like a table. It doesn't store data itself;

-- it just pulls data from the main table whenever you query it. Useful for 

-- saving complex joins or filtering sensitive columns (like passwords).

-- A. Create a View for Top Performers (CGPA > 8.5)

CREATE VIEW top_students AS
SELECT name, rollno, section, cgpa 
FROM students 
WHERE cgpa >= 8.50;



-- B. Query the View just like a normal table

SELECT * FROM top_students ORDER BY cgpa DESC;



-- C. Drop a View

-- DROP VIEW top_students;


-- 3. INDEXES (Speeding up Lookups)


-- Indexes are like a book's index. Instead of scanning every single row (a "Seq Scan"),

-- Postgres can jump straight to the row you need. 

-- Note: Primary Keys and Unique columns get indexes automatically.


-- A. Create an Index on the 'name' column

-- If you frequently search by name (e.g., WHERE name = 'Rahul Nair'), this speeds it up.

CREATE INDEX idx_student_name ON students(name);



-- B. Create a Composite Index (Multiple columns)

-- Useful if you frequently filter by both section AND grade.

CREATE INDEX idx_section_grade ON stu


-- C. Drop an Index

-- DROP INDEX idx_student_name;


-- 4. EXPLAIN ANALYZE (Debugging Performance)

-- If a query is slow, put EXPLAIN ANALYZE in front of it. Postgres will run the 

-- query and output a detailed report of exactly how long it took and what path it took.


EXPLAIN ANALYZE 
SELECT * FROM students 
WHERE name = 'Isha Singh';


-- Look at the output in your terminal. It will tell you if it used the Index 
-- we created above ("Index Scan") or if it checked every row ("Seq Scan").


-- 5. TRIGGERS & FUNCTIONS (Automating Actions)

-- Triggers listen for an event (INSERT, UPDATE, DELETE) and automatically 
-- run a function in response. 

-- Step 1: Create an Audit Table to track deleted records


CREATE TABLE deleted_students_log (
    log_id SERIAL PRIMARY KEY,
    deleted_name VARCHAR(100),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- Step 2: Create a PL/pgSQL Function that dictates WHAT happens

CREATE OR REPLACE FUNCTION log_student_deletion()
RETURNS TRIGGER AS $$
BEGIN
    -- 'OLD' refers to the row that is being deleted
    INSERT INTO deleted_students_log (deleted_name) VALUES (OLD.name);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;



-- Step 3: Create the Trigger that dictates WHEN it happens

CREATE TRIGGER after_student_delete
AFTER DELETE ON students
FOR EACH ROW
EXECUTE FUNCTION log_student_deletion();



-- Step 4: Test the Trigger!

DELETE FROM students WHERE rollno = 'R010';

-- Step 5: Check the log table. Sanya Kapoor's name was automatically saved here!

SELECT * FROM deleted_students_log;

