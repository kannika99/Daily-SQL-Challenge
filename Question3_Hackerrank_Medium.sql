-- Author: Kannika Manjunath

--Prepare > SQL > Advanced Join > Placements

--Problem Statement: You are given three tables: Students, Friends and Packages. 
--Students contains two columns: ID and Name. 
--Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). 
--Packages contains two columns: ID and Salary (offered salary in $ thousands per month).


-- Creating Students Table
CREATE TABLE Students (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50)
);

-- Creating Friends Table
CREATE TABLE Friends (
    ID INT PRIMARY KEY,
    Friend_ID INT
);

-- Creating Packages Table
CREATE TABLE Packages (
    ID INT PRIMARY KEY,
    Salary DECIMAL(10,2)
);

-- Inserting Sample Data
INSERT INTO Students (ID, NAME) VALUES (1, 'Ashley'), (2, 'Samantha'), (3, 'Julia'), (4, 'Scarlet');

INSERT INTO Friends (ID, Friend_ID) VALUES (1, 2), (2, 3), (3, 4), (4, 1);

INSERT INTO Packages (ID, Salary) VALUES (1, 15.20), (2, 10.06), (3, 11.55), (4, 12.12);



-- Solution Query
WITH CTE1 AS (
    SELECT F.ID, P_Self.Salary, F.Friend_ID, P_Friend.Salary AS F_Salary
    FROM Friends F 
    LEFT JOIN Packages P_Self ON F.ID = P_Self.ID
    LEFT JOIN Packages P_Friend ON F.Friend_ID = P_Friend.ID
)
SELECT S.Name 
FROM CTE1 
INNER JOIN Students S ON CTE1.ID = S.ID
WHERE CTE1.Salary < CTE1.F_Salary
ORDER BY CTE1.F_Salary;

