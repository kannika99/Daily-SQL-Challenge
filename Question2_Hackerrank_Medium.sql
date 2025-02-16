-- HackerRank SQL Challenge: DifficultyMedium - Max Score
---------------------------------------------------------------------------------------------- 
-- Problem Statement:

-- Julia asked her students to create some coding challenges. Write a query to print the hacker_id, 
-- name, and the total number of challenges created by each student.
-- Sort by the total number of challenges in descending order. 
-- If more than one student has the same number of challenges, sort by hacker_id.
-- If the count is less than the maximum challenges created and has duplicates, exclude those students.
---------------------------------------------------------------------------------------------- 
--Sample Input 0
CREATE TABLE dbo.Challenges (
    challenge_id INT PRIMARY KEY,
    hacker_id INT
);

INSERT INTO dbo.Challenges (challenge_id, hacker_id) VALUES
(63963, 81041),
(63117, 79345),
(28225, 34856),
(21989, 12299),
(4653, 12299),
(70070, 79345),
(36905, 34856),
(61136, 80491),
(17234, 12299),
(80308, 79345),
(40510, 34856),
(79820, 80491),
(22720, 12299),
(21394, 12299),
(36261, 34856),
(15334, 12299),
(71435, 79345),
(23157, 34856),
(54102, 34856),
(69065, 80491);

SELECT * FROM dbo.Challenges;

 
drop table  if exists dbo.Hackers
CREATE TABLE dbo.Hackers (
    hacker_id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO dbo.Hackers (hacker_id, name) VALUES
(12299, 'Rose'),
(34856, 'Angela'),
(79345, 'Frank'),
(80491, 'Patrick'),
(81041, 'Lisa');

SELECT * FROM dbo.Hackers;
---------------------------------------------------------------------------------------------- 
---------------------------------------------------------------------------------------------- 
SELECT * FROM dbo.Challenges;
SELECT * FROM Hackers;

SELECT * FROM dbo.Hackers H LEFT JOIN dbo.Challenges C ON H.hacker_id = C.hacker_id

--Tricky Part ;)
--If more than one student created the same number of challenges 
--and the count is less than the maximum number of challenges created, then exclude those students from the result.


;WITH CTE_1 AS
(
	SELECT
	H.hacker_id,H.name,  COUNT(challenge_id) ChalengesCount
	FROM Hackers H LEFT JOIN Challenges C ON H.hacker_id = C.hacker_id
	GROUP BY H.hacker_id,H.name
),
CTE_2 AS
(
	SELECT * 
	,FIRST_VALUE(ChalengesCount) OVER (ORDER BY ChalengesCount DESC) MaxValue
	,count(*) OVER (PARTITION BY ChalengesCount ORDER BY ChalengesCount) RowNum
	FROM CTE_1
)
SELECT hacker_id,name,ChalengesCount FROM CTE_2 
WHERE RowNum <2
UNION
SELECT hacker_id,name,ChalengesCount FROM CTE_2 
WHERE RowNum >1 AND ChalengesCount=MaxValue
ORDER BY ChalengesCount DESC,hacker_id ASC

--YESSS!!!!
