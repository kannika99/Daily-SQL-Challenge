-- Write a solution to find managers with at least five employees under him without using subqueries.

create table employee(id int,name varchar(200), dept varchar(200),manager_id int);

INSERT INTO employee (id, name, dept, manager_id) VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101),
(107, 'John','B', 101),
(108, 'Sam', 'B', 107),
(109, 'Rex', 'A', 107),
(110, 'Hugh', 'C', 107),
(111, 'Ryan', 'C',107),
(112, 'Connie', 'C',107),
(113, 'Tom', 'C',112),
(114, 'Arnold', 'C',112);

-- Expected Output
-- +------+
-- | name |
-- +------+
-- | John |
-- | John |
-- +------+
--with cte1 as(
--select distinct manager_id, count(*) from employee 
--group by manager_id
--having count(*)>=5
--  )
--  select name from
--  employee e inner join cte1 on
--  e.id = cte1.manager_id



select  e.name from employee e inner join
employee m on e.id = m.manager_id
group by e.manager_id, e.name
having count(*)>=5