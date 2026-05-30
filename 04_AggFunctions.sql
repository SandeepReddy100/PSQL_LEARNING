-- ============================================================================
-- FILE 4: AGGREGATIONS & GROUPING
-- Focus: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- ============================================================================

-- 1. SETUP 


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

-- Inserting 10 students distributed across Sections A, B, and C

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




-- 2. BASIC AGGREGATE FUNCTIONS (Summarizing the whole table)



-- A. COUNT: How many students are there in total?


SELECT COUNT(*) AS total_students 
FROM students;



-- B. SUM: What is the sum of all marks combined?

SELECT SUM(total_marks) AS sum_of_all_marks 
FROM students;



-- C. AVG: What is the average CGPA of the entire class?

-- Note: ROUND() is used to keep the result to 2 decimal places

SELECT ROUND(AVG(cgpa), 2) AS average_cgpa 
FROM students;



-- D. MIN & MAX: Find the lowest and highest marks

SELECT MIN(total_marks) AS lowest_score, MAX(total_marks) AS highest_score 
FROM students;




-- 3. THE 'GROUP BY' CLAUSE (Summarizing by category)

-- Rule: If you SELECT a normal column (like section) alongside an aggregate 

-- function (like COUNT), you MUST use GROUP BY on the normal column.

-- A. Count how many students are in each section


SELECT section, COUNT(student_id) AS student_count
FROM students
GROUP BY section
ORDER BY section; -- Sorting A, B, C



-- B. Find the average marks for each section

SELECT section, ROUND(AVG(total_marks), 2) AS avg_marks
FROM students
GROUP BY section;



-- C. Find the highest CGPA inside each specific grade bracket (A+, A, B, C)

SELECT grade, MAX(cgpa) AS top_cgpa
FROM students
GROUP BY grade
ORDER BY top_cgpa DESC;




-- 4. THE 'HAVING' CLAUSE (Filtering grouped data)

-- Rule: WHERE filters individual rows BEFORE they are grouped.

-- HAVING filters the groups AFTER they are created.

-- A. Find sections where the average marks are greater than 80

SELECT section, ROUND(AVG(total_marks), 2) AS avg_marks
FROM students
GROUP BY section
HAVING AVG(total_marks) > 80;



-- B. Find sections that have more than 3 students

SELECT section, COUNT(student_id) AS total_students
FROM students
GROUP BY section
HAVING COUNT(student_id) > 3;



-- C. Complex combination: WHERE, GROUP BY, HAVING, and ORDER BY all together

-- Find sections with average marks > 75, but ONLY look at students who have more than 70 marks.

SELECT section, ROUND(AVG(total_marks), 2) AS avg_marks
FROM students
WHERE total_marks > 70          -- Step 1: Filter rows first
GROUP BY section                -- Step 2: Group what's left
HAVING AVG(total_marks) > 75    -- Step 3: Filter the groups
ORDER BY avg_marks DESC;        -- Step 4: Sort the final output