
--Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.

--Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ≤ Y1.

--Sample Input

USE EIP
-- Create the table
CREATE TABLE dbo.Pairs (
    X INT,
    Y INT
);

-- Insert the sample data
DROP TABLE IF EXISTS dbo.Pairs
INSERT INTO dbo.Pairs (X, Y) VALUES
(20, 20),
(20, 20),
(20, 21),
(21, 20),
(23, 22),
(22, 23);

-- Query to find symmetric pairs where X ≤ Y
SELECT p1.X, p1.Y
FROM Pairs p1
INNER JOIN Pairs p2
  ON p1.X = p2.Y
  AND p1.Y = p2.X
  WHERE p1.X <= p1.Y

-- Query to find symmetric pairs where X ≤ Y
SELECT p1.X, p1.Y
FROM Pairs p1
INNER JOIN Pairs p2
  ON p1.X = p2.Y
  AND p1.Y = p2.X
GROUP BY p1.X, p1.Y HAVING COUNT(p1.X) >1 OR P1.X < P1.Y 
ORDER BY p1.X ASC, p1.Y ASC;

select f1.X, f1.Y from Functions f1 join Functions f2 
on f1.X = f2.Y and f1.Y = f2.X 
group by f1.X, f1.Y having count(f1.X) > 1 or f1.X < f1.Y order by f1.X;




































