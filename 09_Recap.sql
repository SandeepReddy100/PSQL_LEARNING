-- ============================================================================
-- FILE 9: POSTGRESQL MASTER SYNTAX RECAP
-- Purpose: A quick-reference dictionary for all major SQL commands.
-- ============================================================================

-- 1. DDL: DATABASE & TABLE STRUCTURE

CREATE DATABASE db_name;

DROP DATABASE db_name;

CREATE TABLE table_name (
    id SERIAL PRIMARY KEY,
    col_string VARCHAR(50) NOT NULL,
    col_num INT UNIQUE CHECK (col_num > 0),
    col_default BOOLEAN DEFAULT TRUE,
    foreign_id INT REFERENCES other_table(id)
);






ALTER TABLE table_name ADD COLUMN new_col DATE;

ALTER TABLE table_name RENAME COLUMN old_name TO new_name;

ALTER TABLE table_name ALTER COLUMN col_name TYPE TEXT;

ALTER TABLE table_name DROP COLUMN col_name;




DROP TABLE table_name CASCADE; -- CASCADE drops dependent objects (like views)
TRUNCATE TABLE table_name;     -- Wipes data, keeps structure







-- 2. DML: CRUD OPERATIONS

INSERT INTO table_name (col1, col2) VALUES ('val1', 100), ('val2', 200);


SELECT col1, col2 FROM table_name WHERE col1 = 'val1' ORDER BY col2 DESC LIMIT 5;


SELECT * FROM table_name WHERE col_string LIKE 'A%'; -- Starts with A


UPDATE table_name SET col2 = 150 WHERE col1 = 'val1' RETURNING *;


DELETE FROM table_name WHERE col2 < 50;








-- 3. JOINS & RELATIONS


-- INNER: Matches only
SELECT t1.col, t2.col FROM table1 t1 INNER JOIN table2 t2 ON t1.id = t2.fk_id;



-- LEFT: All of t1, plus matches from t2
SELECT t1.col, t2.col FROM table1 t1 LEFT JOIN table2 t2 ON t1.id = t2.fk_id;



-- FULL: Everything from both
SELECT t1.col, t2.col FROM table1 t1 FULL JOIN table2 t2 ON t1.id = t2.fk_id;








-- 4. AGGREGATIONS & GROUPING

SELECT COUNT(*), SUM(col2), AVG(col2), MIN(col2), MAX(col2) FROM table_name;


-- GROUP BY categorizes data, HAVING filters the groups

SELECT category_col, COUNT(*) 
FROM table_name 
WHERE status = 'active'      -- Filters rows
GROUP BY category_col        -- Groups remaining rows
HAVING COUNT(*) > 10;        -- Filters the groups







-- 5. ADVANCED QUERIES (CTEs & WINDOW FUNCTIONS)


-- CTE (Temporary Result Set)
WITH top_users AS (
    SELECT id, name FROM users WHERE score > 90
)
SELECT * FROM top_users WHERE name LIKE 'S%';



-- WINDOW FUNCTION (Calculates across rows without squashing them)
SELECT name, score, 
       RANK() OVER (PARTITION BY department ORDER BY score DESC) as dept_rank 
FROM employees;






-- 6. PERFORMANCE & OBJECTS


-- VIEWS (Saved Queries)
CREATE VIEW active_users AS SELECT * FROM users WHERE active = true;
SELECT * FROM active_users;



-- INDEXES (Speed up lookups)
CREATE INDEX idx_user_email ON users(email);



-- EXPLAIN (Analyze Query Performance)
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@test.com';






-- 7. TRANSACTIONS & JSONB



BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;   -- Or ROLLBACK; if something goes wrong



-- JSONB (Document Storage)
SELECT data->>'city' FROM users WHERE data @> '{"role": "admin"}';
UPDATE users SET data = jsonb_set(data, '{theme}', '"dark"');





-- 8. PL/pgSQL (FUNCTIONS & PROCEDURES)


-- FUNCTION (Returns a value, used in SELECT)

CREATE OR REPLACE FUNCTION get_discount(price INT) RETURNS INT AS $$
BEGIN
    RETURN price - (price * 0.10);
END;
$$ LANGUAGE plpgsql;



-- PROCEDURE (Executes an action, handles transactions, used with CALL)


CREATE OR REPLACE PROCEDURE reset_scores() AS $$
BEGIN
    UPDATE users SET score = 0;
    COMMIT;
END;
$$ LANGUAGE plpgsql;


