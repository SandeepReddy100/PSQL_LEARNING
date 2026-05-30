-- ============================================================================
-- FILE 8: FUNCTIONS & STORED PROCEDURES
-- Focus: PL/pgSQL, User-Defined Functions, Procedures, IF/ELSE logic
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







-- 2. USER-DEFINED FUNCTIONS (UDFs)

-- Functions MUST return something. They are great for calculations and 
-- formatting data on the fly. You can use them right inside a SELECT statement.



-- A. A Simple Scalar Function (Returns a single value)
-- Goal: Create a function that calculates a percentage based on 100 total marks.

CREATE OR REPLACE FUNCTION get_percentage(marks INT) 
RETURNS DECIMAL(5,2) AS $$
BEGIN
    RETURN (marks::DECIMAL / 100) * 100;
END;
$$ LANGUAGE plpgsql;

-- Using the function:
SELECT name, total_marks, get_percentage(total_marks) AS percentage 
FROM students;




-- B. A Function with Logic (IF / ELSE)
-- Goal: Automatically determine the grade based on marks.

CREATE OR REPLACE FUNCTION calculate_grade(marks INT) 
RETURNS VARCHAR(2) AS $$
DECLARE
    calculated_grade VARCHAR(2); -- This is a variable to hold our result
BEGIN
    IF marks >= 90 THEN
        calculated_grade := 'A+';
    ELSIF marks >= 80 THEN
        calculated_grade := 'A';
    ELSIF marks >= 70 THEN
        calculated_grade := 'B';
    ELSE
        calculated_grade := 'C';
    END IF;
    
    RETURN calculated_grade;
END;
$$ LANGUAGE plpgsql;

-- Using the function to test what grades *should* be:
SELECT name, total_marks, grade AS current_grade, calculate_grade(total_marks) AS expected_grade 
FROM students;






-- C. A Table-Returning Function
-- Goal: Return a whole list of students for a specific section.

CREATE OR REPLACE FUNCTION get_students_by_section(sec CHAR) 
RETURNS TABLE (student_name VARCHAR, student_roll VARCHAR, student_marks INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT name, rollno, total_marks 
    FROM students 
    WHERE section = sec;
END;
$$ LANGUAGE plpgsql;

-- Using the function:
SELECT * FROM get_students_by_section('B');










-- 3. STORED PROCEDURES

-- Procedures DO NOT return a value. They are used to execute actions (like 
-- mass updates or complex inserts). Unlike functions, they can manage 
-- transactions (COMMIT / ROLLBACK) inside them.

-- A. A Procedure to execute an action
-- Goal: Deduct 5 marks from a specific student as a penalty.

CREATE OR REPLACE PROCEDURE apply_penalty(p_rollno VARCHAR(20), penalty_amount INT)
AS $$
BEGIN
    UPDATE students 
    SET total_marks = total_marks - penalty_amount 
    WHERE rollno = p_rollno;
    
    -- Optional: We can add a notice to print to the console
    RAISE NOTICE 'Applied penalty of % to student %', penalty_amount, p_rollno;
END;
$$ LANGUAGE plpgsql;


-- Executing the procedure (Notice we use CALL instead of SELECT)
CALL apply_penalty('R005', 5);


-- Check the result for Rohan:
SELECT name, total_marks FROM students WHERE rollno = 'R005';





-- B. A Procedure with a Transaction (COMMIT)
-- Goal: Re-calculate and update ALL grades in the table using our function from earlier.
CREATE OR REPLACE PROCEDURE update_all_grades()
AS $$
BEGIN
    -- Update every row by passing its total_marks into our calculate_grade function
    UPDATE students 
    SET grade = calculate_grade(total_marks);
    
    -- Permanently commit the changes. (If this failed halfway, it would automatically rollback).
    COMMIT;
END;
$$ LANGUAGE plpgsql;


-- Executing the mass update:
CALL update_all_grades();


-- Verify all grades were updated correctly:
SELECT name, total_marks, grade FROM students ORDER BY total_marks DESC;









