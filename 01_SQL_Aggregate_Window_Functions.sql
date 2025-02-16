USE EIP
/*
=========================================================================================
Title: SQL Window Functions - Hands-on Guide  
Author: Kannika   
Date: 2025-02-16 (Update with the current date)  
Database:   
Description:  
    - This script provides a comprehensive hands-on guide to SQL Window Functions.  
    - It covers aggregate functions, ranking functions, and analytical functions.  
    - The script also includes practical examples of SUM, COUNT, RANK, DENSE_RANK, ROW_NUMBER,  
      FIRST_VALUE, LAST_VALUE, PERCENT_RANK, LAG, and LEAD functions.  

Instructions:  
    - Run the script sequentially in SQL Server.  
    - The script creates a sample `SalesData` table and inserts sample records.  
    - Each query includes detailed explanations for better understanding.  

Topics Covered:  
    1. Creating a sample dataset  
    2. Aggregate Functions (SUM, COUNT, etc.)  
    3. Ranking Functions (RANK, DENSE_RANK, ROW_NUMBER)  
    4. Window Functions with OVER()  
    5. Analytical Functions (FIRST_VALUE, LAST_VALUE, PERCENT_RANK, LAG, LEAD)  
    6. Practical scenarios and business use cases  

GitHub Repository:  

=========================================================================================
*/


--By the end of this session, you'll be a pro in Window functions!! :)


--Lets 1st create Sample Data:
CREATE TABLE dbo.SalesData (
    SalesID INT PRIMARY KEY,
    SalesPerson VARCHAR(50),
    [Product] VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalAmount DECIMAL(12,2),
    SaleDate DATE,
    Region VARCHAR(50)
);

SELECT * FROM dbo.SalesData

INSERT INTO dbo.SalesData (SalesID, SalesPerson, Product, Quantity, UnitPrice, TotalAmount, SaleDate, Region) VALUES
(1, 'Alice', 'Laptop', 2, 50000, 100000, '2024-01-10', 'North'),
(2, 'Bob', 'Mobile', 5, 20000, 100000, '2024-01-12', 'South'),
(3, 'Alice', 'Tablet', 3, 15000, 45000, '2024-02-15', 'North'),
(4, 'Charlie', 'Laptop', 1, 52000, 52000, '2024-02-18', 'West'),
(5, 'Bob', 'Tablet', 4, 14000, 56000, '2024-03-05', 'South'),
(6, 'Alice', 'Mobile', 2, 21000, 42000, '2024-03-08', 'North'),
(7, 'Charlie', 'Mobile', 3, 19000, 57000, '2024-03-12', 'West'),
(8, 'Alice', 'Laptop', 1, 48000, 48000, '2024-04-10', 'North'),
(9, 'Bob', 'Laptop', 2, 51000, 102000, '2024-04-12', 'South'),
(10, 'Charlie', 'Tablet', 5, 13500, 67500, '2024-05-01', 'West');


--Before starting, take a look at the table and understand the data :)

-------------------------------------------------------------------------
--AGGREGATE FUNCTIONS:
-------------------------------------------------------------------------

SELECT * FROM dbo.SalesData

--1. Total products Sold:
SELECT SUM(Quantity) FROM dbo.SalesData


--2. Total Quantity of each Product  Sold:
SELECT Product ,SUM(Quantity) Total_Quantity FROM dbo.SalesData
GROUP BY Product

--3. What are the DISTINCT NUMBER OF Products Types sold 
SELECT COUNT(DISTINCT [PRODUCT]) NumberOfProducts FROM dbo.SalesData

--4. Which Product was sold the most?
SELECT TOP 1 WITH TIES Product, SUM( Quantity) NumberOfProducts FROM dbo.SalesData
GROUP BY Product 
ORDER BY SUM( Quantity) DESC


SELECT TOP 1 Product FROM dbo.SalesData
GROUP BY Product 
ORDER BY SUM( Quantity) DESC


--5. 2nd most sold product?
SELECT Product, SUM( Quantity) NumberOfProducts FROM dbo.SalesData
GROUP BY Product 
ORDER BY SUM( Quantity) DESC

--5.1 Using Offset
SELECT Product, SUM( Quantity) NumberOfProducts FROM dbo.SalesData
GROUP BY Product 
ORDER BY SUM( Quantity) DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

----Syntax:
--OFFSET number_of_rows_to_skip ROWS
--FETCH NEXT number_of_rows_to_fetch ROWS ONLY;


-------------------------------------------------------------------------
-------------------------------------------------------------------------
--WINDOW FUNCTIONS:
-------------------------------------------------------------------------
--SQL Server Window Functions calculate an aggregate value based on a group of rows 
--But unlike Aggregare functions(returns single value for each grp), they return multiple rows while maintaining the individual row-level details.

--Feature						Aggregate Functions			Window Functions
--Output						Single value per group		Multiple rows with aggregated values
--Grouping						Uses GROUP BY				Uses OVER()
--Maintains Row-Level Details?	No (collapses data)			Yes (each row is preserved)

--5.2 Using RANK()
SELECT * FROM dbo.SalesData

--1. Based on TotalAmount, give Ranking for SalesPerson

SELECT SalesPerson, 
       SUM(TotalAmount), 
       RANK() OVER (ORDER BY SUM(TotalAmount) DESC) AS Ranking
FROM dbo.SalesData
GROUP BY SalesPerson;

--RANK() 
--If 2 rec has same value, then gives same rank for both, but continues from the next number

--DENSE_RANK()
--Assign a rank value to each row within a partition of a result, with no gaps in rank values.

--Q1. Give me a simple Rank based on TotalAmount on each sale:
SELECT *
,RANK() OVER(ORDER BY TotalAmount DESC) Ranking
FROM dbo.SalesData


--Q2. Ranking SalesPersons Based on Total Sales (Aggregated)
------Finding total sales for each SalesPerson
SELECT SalesPerson, SUM(TotalAmount) FROM dbo.SalesData
GROUP BY SalesPerson

------Include Rank 
SELECT SalesPerson, SUM(TotalAmount) TotalSalesAmount,
RANK() OVER(ORDER BY SUM(TotalAmount) DESC) Ranking
FROM dbo.SalesData
GROUP BY SalesPerson

--Q3. 2nd most sold product? --I need Product and Quantity
;WITH MostSold_CTE AS
(
	SELECT  
		Product, 
		SUM(Quantity) Sum_Of_Quantity, 
		RANK() OVER( ORDER BY SUM(Quantity) DESC ) Ranking
	FROM dbo.SalesData
	GROUP BY Product
)
SELECT * FROM MostSold_CTE WHERE Ranking = 2



--Q4. 
--Point to note: Im not agregating here, all 10 recs are present
SELECT SalesPerson, Product,Quantity, Region, 
RANK() OVER (PARTITION BY Region ORDER BY Quantity DESC) RegionQuant_Ranking ,
DENSE_RANK() OVER (PARTITION BY Region ORDER BY Quantity DESC) RegionQuant_DenseRanking 
FROM dbo.SalesData

-------------------------------------------------------------------------
--ROW_NUMBER()
--Assignes a sequential number for the data in the partition
SELECT SalesPerson, Product,Quantity, Region, 
RANK() OVER (PARTITION BY Region ORDER BY Quantity DESC) RegionQuant_Ranking ,
DENSE_RANK() OVER (PARTITION BY Region ORDER BY Quantity DESC) RegionQuant_DenseRanking ,
ROW_NUMBER() OVER (PARTITION BY Region ORDER BY Quantity DESC) RegionQuant_RowNumber
FROM dbo.SalesData

-------------------------------------------------------------------------
--Q5. total of sales per salesperson
SELECT SalesPerson, SUM(TotalAmount) TotalSales FROM dbo.SalesData
GROUP BY SalesPerson

SELECT DISTINCT SalesPerson ,
SUM(TotalAmount) OVER (PARTITION BY SalesPerson) TotalSales
FROM dbo.SalesData

--6Q. Running total of sales per salesperson
SELECT SalesID, SalesPerson, TotalAmount,SaleDate,
       SUM(TotalAmount) OVER (PARTITION BY SalesPerson ORDER BY SaleDate) AS RunningTotal
FROM SalesData;


-------------------------------------------------------------------------
--FIRST_VALUE() function to get the first value in an ordered partition of a result set.
--same value will be printed for each record.

--FIRST_VALUE ( scalar_expression )  
--OVER ( 
--    [PARTITION BY partition_expression, ... ]
--    ORDER BY sort_expression [ASC | DESC], ...
--)

--7Q. Lets say, I want to compare Max Quantity VS quantity
SELECT * FROM dbo.SalesData

SELECT SalesPerson, Product, Quantity, 
FIRST_VALUE(Quantity) OVER( PARTITION BY Product ORDER BY Product,Quantity DESC) MaxQuantitySoldAtOnce
FROM dbo.SalesData


SELECT SalesPerson, Product, Quantity, 
LAST_VALUE(Quantity) OVER( PARTITION BY Product ORDER BY Quantity DESC         
			RANGE BETWEEN 
            UNBOUNDED PRECEDING AND 
            UNBOUNDED FOLLOWING
		                 ) MinQuantitySoldAtOnce
FROM dbo.SalesData
--Note:
--When using LAST_VALUE() in SQL Server, the default frame for window functions is:
--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--By this,
--You extend the frame to include all rows within the partition


-------------------------------------------------------------------------
--PERCENT_RANK() function evaluates the relative standing of a value within a partition of a result set.
--Partition by Products to see what percent each sales person has sold

--Formula for PERCENT_RANK():

----rank − 1
----------------------------------
----total rows in partition − 1

​

SELECT * FROM dbo.SalesData

SELECT Product,SalesPerson ,Quantity,
PERCENT_RANK() OVER (PARTITION BY Product  ORDER BY  Quantity desc) PercentSales_Product
FROM dbo.SalesData

-------------------------------------------------------------------------
--LAG AND LEAD

SELECT * FROM dbo.SalesData

--Total Sales permonth
SELECT MONTH(SaleDate) SaleMonth , SUM(TotalAmount) TotalSales FROM dbo.SalesData
GROUP BY MONTH(SaleDate)
ORDER BY MONTH(SaleDate)

--Apply LAG and LEAD
SELECT MONTH(SaleDate) SaleMonth , SUM(TotalAmount) TotalSales,
	LAG(SUM(TotalAmount),1) OVER (ORDER BY MONTH(SaleDate)) PrevMonth_TotalSales,
	SUM(TotalAmount) ThisMonth_TotalSales,
	LEAD(SUM(TotalAmount),1) OVER (ORDER BY MONTH(SaleDate)) NextMonth_TotalSales
FROM dbo.SalesData
GROUP BY MONTH(SaleDate)
ORDER BY MONTH(SaleDate)


--HAPPY LEARNING!