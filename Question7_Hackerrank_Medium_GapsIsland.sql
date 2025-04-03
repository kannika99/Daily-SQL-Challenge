--SQL Project Planning

--You are given a table, Projects, containing three columns: 
--Task_ID, Start_Date and End_Date. 
--It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.



--If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.

--Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project.

--Sample Input

USE EIP
-- Create the table
DROP TABLE IF EXISTS dbo.Projects

CREATE TABLE dbo.Projects (
 Task_ID INT, Start_Date DATE, End_Date DATE
 );

-- Insert the sample data
INSERT INTO dbo.Projects (Task_ID, Start_Date , End_Date) VALUES
(1,'2015-10-01', '2015-10-02'),
(2,'2015-10-02', '2015-10-03'),
(3,'2015-10-03', '2015-10-04'), --3 DAYS
(4,'2015-10-13', '2015-10-14'),
(5,'2015-10-14', '2015-10-15'), --2 DAYS
(6,'2015-10-28', '2015-10-29'),	--1 DAY
(7,'2015-10-30', '2015-10-31'); --1 DAY



SELECT * FROM dbo.Projects 


;WITH CTE1 AS
(
	SELECT * 
	,LAG(End_Date) OVER ( order by End_Date) LagEnd_DATE
	--,ROW_NUMBER() OVER ( order by End_Date) Rnum
	FROM dbo.Projects 
)
,CTE2 AS (
	SELECT * , 
	CASE WHEN Start_Date=LagEnd_DATE THEN 0 ELSE 1 END AS IsNewProject FROM CTE1
)
,CTE3 AS (
	SELECT * ,
	SUM(IsNewProject) OVER ( ORDER BY  Start_Date  ROWS UNBOUNDED PRECEDING) CumlSum
	FROM CTE2 
)
--select * from cte3
SELECT min(Start_Date), max(End_Date)--, DATEDIFF(DAY,  min(Start_Date), max(End_Date)) Duration
FROM CTE3
GROUP BY CumlSum
order by DATEDIFF(DAY,  min(Start_Date), max(End_Date)) , MAX(Start_Date)



;WITH CTE1 AS
(
	SELECT * 
	,CASE WHEN Start_Date= LAG(End_Date) OVER ( order by End_Date) THEN 0 ELSE 1 END AS IsNewProject
	FROM dbo.Projects 
)
,CTE2 AS (
	SELECT * ,
	SUM(IsNewProject) OVER ( ORDER BY  Start_Date  ROWS UNBOUNDED PRECEDING) CumlSum
	FROM CTE1
)
SELECT min(Start_Date) StartDate , max(End_Date) EndDate
FROM CTE2
GROUP BY CumlSum
order by DATEDIFF(DAY,  min(Start_Date), max(End_Date)) , MAX(Start_Date)




--Sample Output

--2015-10-28 2015-10-29
--2015-10-30 2015-10-31
--2015-10-13 2015-10-15
--2015-10-01 2015-10-04




;WITH CTE1 AS
(
	SELECT * 
	,CASE WHEN Start_Date= LAG(End_Date) OVER ( order by End_Date) THEN 0 ELSE 1 END AS IsNewProject
	FROM dbo.Projects 
)

	SELECT * ,
	SUM(IsNewProject) OVER ( ORDER BY  Start_Date  ROWS UNBOUNDED PRECEDING) CumlSum
	,SUM(IsNewProject) OVER ( ORDER BY  Start_Date  ) CumlSum1
	FROM CTE1










select STRING_AGG(Task_ID, '\') from dbo.Projects












