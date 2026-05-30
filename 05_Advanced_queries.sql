-- ============================================================================
-- FILE 5: ADVANCED QUERIES
-- Focus: Subqueries, CTEs (WITH clause), Window Functions (RANK, PARTITION)
-- ============================================================================

-- 1. SETUP (Creating table and adding data)

DROP TABLE IF EXISTS students;

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



-- 2. SUBQUERIES (A query inside a query)

-- Subqueries are useful when you need to calculate a value on the fly 
-- and use it immediately to filter your main query.

-- A. Subquery in the WHERE clause
-- Goal: Find all students who scored HIGHER than the overall class average.

-- The inner query (SELECT AVG...) runs first, finds the number (82.1), 
-- and then the outer query uses that number.


SELECT name, total_marks 
FROM students
WHERE total_marks > (
    SELECT AVG(total_marks) FROM students
);



-- B. Subquery in the SELECT clause
-- Goal: Show each student's marks alongside the maximum marks in the whole class.

SELECT 
    name, 
    total_marks, 
    (SELECT MAX(total_marks) FROM students) AS max_class_marks
FROM students;




-- 3. COMMON TABLE EXPRESSIONS (CTEs)

-- CTEs do the exact same thing as subqueries, but they make your code MUCH 
-- easier to read by defining the temporary result at the top using 'WITH'.

-- Goal: Find students in Section 'A' who have a CGPA > 8.50 using a CTE.
-- Step 1: Define the CTE (a temporary mini-table named 'section_a_students')


WITH section_a_students AS (
    SELECT name, cgpa 
    FROM students 
    WHERE section = 'A'
)


-- Step 2: Query against that temporary table

SELECT * FROM section_a_students 
WHERE cgpa > 8.50;




-- 4. WINDOW FUNCTIONS (Advanced Analytics)

-- Unlike GROUP BY which squashes rows together, Window Functions perform 
-- calculations across a set of rows but keep every individual row intact.

-- A. The RANK() Function
-- Goal: Rank all students from 1 to 10 based on their CGPA (Highest to Lowest)

SELECT 
    name, 
    cgpa, 
    RANK() OVER (ORDER BY cgpa DESC) AS class_rank
FROM students;



-- B. The PARTITION BY Clause (Grouping inside a Window Function)

-- Goal: Rank students based on their CGPA, but restart the ranking for EACH SECTION.
-- This tells us who is 1st in Section A, 1st in Section B, etc.

SELECT 
    name, 
    section, 
    cgpa, 
    RANK() OVER (PARTITION BY section ORDER BY cgpa DESC) AS section_rank
FROM students;



-- C. The ROW_NUMBER() Function

-- Similar to RANK, but it guarantees unique numbers even if there's a tie.

SELECT 
    name, 
    total_marks, 
    ROW_NUMBER() OVER (ORDER BY total_marks DESC) AS row_num
FROM students;

