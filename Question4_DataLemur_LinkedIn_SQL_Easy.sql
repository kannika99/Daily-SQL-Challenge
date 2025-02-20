-- -----------------------------------------------------------------------------
-- Data Science Skills - LinkedIn SQL Interview Question
-- -----------------------------------------------------------------------------
-- This SQL script solves a common interview question where we need to find
-- candidates who possess all the required skills for a Data Science job.
-- The required skills are: Python, Tableau, and PostgreSQL.
-- The solutions include different SQL approaches such as CTEs and GROUP BY.
-- -----------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------
--Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. 
--You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.
--Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

--Assumption:
--There are no duplicates in the candidates table.
---------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------
-- candidates Table:
-- Column Name        Type
---------------------------------------------------
-- candidate_id       integer
-- skill              varchar
---------------------------------------------------

---------------------------------------------------
-- candidates Example Input:
-- candidate_id    skill
---------------------------------------------------
-- 123    Python
-- 123    Tableau
-- 123    PostgreSQL
-- 234    R
-- 234    PowerBI
-- 234    SQL Server
-- 345    Python
-- 345    Tableau
---------------------------------------------------



---------------------------------------------------
--Example Output:
--candidate_id
--123
---------------------------------------------------

--Explanation
--Candidate 123 is displayed because they have Python, Tableau, and PostgreSQL skills. 345 isn't included in the output because they're missing one of the required skills: PostgreSQL.
--The dataset you are querying against may have different input & output - this is just an example!
--p.s. give the hints below a try if you're stuck and don't know where to start!
--p.p.s if you find this problem too tricky, even after the hints, check out my 30-day SQL learning roadmap, which features my favorite free resources to learn SQL! 
--After you strengthen your SQL foundations, I'm sure you'll be more than ready to tackle this question!


---------------------------------------------------
--Solutions:

--1. Using CTE
WITH CTE1 AS (
SELECT *
,
ROW_NUMBER() OVER (PARTITION BY candidate_id ORDER BY candidate_id) Rownum
FROM candidates WHERE skill in ('Python','Tableau','PostgreSQL')
)
SELECT DISTINCT candidate_id FROM CTE1 WHERE Rownum = 3;


--2. Using Group by

SELECT candidate_id FROM 
candidates
WHERE skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(*)=3
ORDER BY candidate_id


---------------------------------------------------
