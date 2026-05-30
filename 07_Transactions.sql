-- ============================================================================
-- FILE 7: TRANSACTIONS & JSONB
-- Focus: BEGIN, COMMIT, ROLLBACK, and querying unstructured JSON data
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
    cgpa DECIMAL(3,2),
    metadata JSONB -- Storing dynamic/unstructured data (like MongoDB)
);

INSERT INTO students (name, rollno, total_marks, section, grade, cgpa, metadata) VALUES 
('Aarav Mehta', 'R001', 85, 'A', 'A', 8.50, '{"skills": ["React", "Node.js"], "has_laptop": true}'),
('Isha Singh', 'R002', 92, 'A', 'A+', 9.20, '{"skills": ["Python", "SQL"], "has_laptop": false}'),
('Kabir Das', 'R003', 76, 'B', 'B', 7.60, '{"skills": ["Java"], "has_laptop": true}');







-- 2. TRANSACTIONS 

-- Transactions ensure that a series of queries either ALL succeed, or ALL fail.

-- This prevents corrupted/partial data if a server crashes mid-query.





-- Scenario A: A successful transaction

BEGIN; -- Starts the transaction

UPDATE students SET total_marks = 88 WHERE rollno = 'R001';
UPDATE students SET grade = 'A+' WHERE rollno = 'R001';

COMMIT; -- Saves the changes permanently to the database






-- Scenario B: A failed transaction (Rolling back)
BEGIN;

-- Let's say we accidentally delete a student
DELETE FROM students WHERE rollno = 'R002';

-- Oh wait, that was a mistake! We can undo everything since the last BEGIN.
ROLLBACK; 

-- Isha Singh (R002) is fully restored.






-- 3. QUERYING JSONB DATA

-- Postgres lets you dig inside JSON objects using special operators (-> and ->>).


-- A. Extract a specific JSON value as text (using ->>)

-- Find whether Aarav has a laptop.

SELECT name, metadata->>'has_laptop' AS has_laptop 
FROM students 
WHERE name = 'Aarav Mehta';


-- B. Filter rows based on a value inside the JSON object
-- Find all students who have 'React' in their skills array
-- The @> operator checks if the JSON on the left contains the JSON on the right

SELECT name, metadata 
FROM students 
WHERE metadata @> '{"skills": ["React"]}';



-- C. Update a specific key inside the JSON object
-- Add a new 'github' key to Isha's metadata without deleting her existing skills

UPDATE students 
SET metadata = jsonb_set(metadata, '{github}', '"isha_codes"') 
WHERE rollno = 'R002';

