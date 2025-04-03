-- Write a SQL query to display the valid emails from email column as output

create table input(id int, email varchar(50), comment varchar(50));

INSERT INTO input (id, email, comment) VALUES
(1, 'dan@gmail.com', NULL),
(2, 'john@gmail.com', NULL),
(3, 'james@hotmail.com', NULL),
(4, 'ann@yahoo.com', NULL),
(5, 'rex123.com', 'Not valid'),
(6, 'sam@yahoo.com', NULL),
(7, 'hughgdaseegeeasssgmail.com', 'Exceeding characters'),
(8, 'connie@gmail.com', NULL),
(9, 'Harvey34@gmail', 'Not valid'),
(10, 't@yahoo.com', 'Not enough characters');



-- Expected Output
-- +---------------------+
-- | Output 		     |
-- +---------------------+		
-- |dan@gmail.com	     |
-- |john@gmail.com	     |
-- |james@hotmail.com    |
-- |ann@yahoo.com        |
-- |Not valid		     |
-- |sam@yahoo.com	     |	
-- |̌Exceeding characters |
-- |connie@gmail.com     |
-- |Not valid            |
-- |Not enough characters|
-- +---------------------+


select coalesce(comment,email) from input;