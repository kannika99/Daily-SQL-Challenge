--Amazon Data Engineer Practice Set

USE EIP

--Consider the below Orders table

--Write a SQL to get all the products that got sold both the days and the number of times product is sold:

DROP TABLE IF EXISTS dbo.orders
create table dbo.orders
(
ORDER_DAY DATE,
ORDER_ID VARCHAR(2),
PRODUCT_ID VARCHAR(2),
QUANTITY INT,
PRICE INT
);



insert into dbo.orders values('01-JUL-11','O1','P1',5,5);
insert into dbo.orders values('01-JUL-11','O2','P2',2,10);
insert into dbo.orders values('01-JUL-11','O3','P3',10,25);
insert into dbo.orders values('01-JUL-11','O4','P1',20,5);
insert into dbo.orders values('02-JUL-11','O5','P3',5,25);
insert into dbo.orders values('02-JUL-11','O6','P4',5,20);
insert into dbo.orders values('02-JUL-11','O7','P1',2,5);
insert into dbo.orders values('02-JUL-11','O8','P5',1,50);
insert into dbo.orders values('02-JUL-11','O9','P6',2,50);
insert into dbo.orders values('02-JUL-11','10','P2',4,10);



SELECT * FROM dbo.orders



;WITH CTE1 AS (
SELECT * 
, RANK() OVER (PARTITION BY Product_ID, ORDER_DAY ORDER BY ORDER_DAY) Rank_VAL
FROM dbo.orders

), CTE2 AS 
( SELECT ORDER_DAY ,PRODUCT_ID, COUNT(*) COUNT_VAL FROM  CTE1
GROUP BY ORDER_DAY ,PRODUCT_ID --HAVING COUNT(*)>1
)
SELECT PRODUCT_ID,SUM(COUNT_VAL) COUNT FROM CTE2
GROUP BY PRODUCT_ID HAVING COUNT(*)>1


;WITH  CTE2 AS 
(
	--Number of times sold - per order, per day
	SELECT ORDER_DAY ,PRODUCT_ID, COUNT(*) COUNT_VAL FROM  dbo.orders
	GROUP BY ORDER_DAY ,PRODUCT_ID 
)
SELECT PRODUCT_ID,SUM(COUNT_VAL) COUNT FROM CTE2
GROUP BY PRODUCT_ID HAVING COUNT(*)>1 --Multiple records only if product sold on multiple days




--Question2:

--Give me products that was ordered on 2-Jul-11 but not on 1-Jul-11
SELECT PRODUCT_ID FROM dbo.orders
WHERE ORDER_DAY = '2011-07-02'
AND 
PRODUCT_ID not in (SELECT DISTINCT PRODUCT_ID FROM dbo.orders
	WHERE ORDER_DAY = '2011-07-01'
)



--Question3

--Get me highest sold Products (Qty*Price) on both days

SELECT ORDER_DAY, max(PRODUCT_ID), MAX(Price) FROM (
	SELECT ORDER_DAY,PRODUCT_ID, SUM(QUANTITY*PRICE) Price FROM dbo.orders
	GROUP BY ORDER_DAY, PRODUCT_ID
	ORDER BY ORDER_DAY, Price desc

) A
GROUP BY ORDER_DAY

;WITH CTE1 AS
(
	SELECT *, 
	RANK() OVER (PARTITION BY ORDER_DAY ORDER BY Price DESC) MaxPriceRank
	FROM 
	(
		SELECT ORDER_DAY,PRODUCT_ID, SUM(QUANTITY*PRICE) Price FROM dbo.orders
		GROUP BY ORDER_DAY, PRODUCT_ID
	)A
)
SELECT ORDER_DAY AS [DATE],  PRODUCT_ID, Price AS SOLD_AMOUNT
FROM CTE1
WHERE MaxPriceRank = 1






--5. Give me all products day vis, that was ordered more than once
SELECT * FROM dbo.orders



SELECT ORDER_DAY,PRODUCT_ID FROM dbo.orders
GROUP BY ORDER_DAY,PRODUCT_ID
HAVING COUNT(*)>1



--6. Lets consider the below order table
DROP TABLE IF EXISTS dbo.orders1
create table dbo.orders1
(
ORDER_ID VARCHAR(2),
ITEM VARCHAR(2),
QTY INT
);



insert into dbo.orders1 values('O1','A1',5);
insert into dbo.orders1 values('O2','A2',1);
insert into dbo.orders1 values('O3','A3',3);

SELECT * FROM dbo.orders1 

--Please provide SQL which will explode the above data into single unit level records 
--HINT: USE RECURSIVE CTE

;WITH CTE1 AS
(
	--Anchor Part
	SELECT ORDER_ID,ITEM,QTY,1 AS CNT FROM dbo.orders1
	UNION ALL
	--Recursive Part
	SELECT ORDER_ID,ITEM,QTY, cnt+1 AS CNT FROM CTE1 WHERE CNT <QTY


)
SELECT ORDER_ID,ITEM,1 AS QTY FROM CTE1
ORDER BY ORDER_ID



--7.



create table dbo.product_dim
(
product_id varchar(2),
product_group varchar(50),
product_name varchar(100)
);



insert into dbo.product_dim values('P1','Book','Harry Potter 1');
insert into dbo.product_dim values('P2','Book','Harry Potter 2');
insert into dbo.product_dim values('P3','Electronics','Nikon 10 MPS');
insert into dbo.product_dim values('P4','Electronics','Cannon 8 MPS');
insert into dbo.product_dim values('P5','Electronics','Cannon 10 MPS');
insert into dbo.product_dim values('P6','Video DVD','Pirates 1');
insert into dbo.product_dim values('P7','Video DVD','Pirates 2');
insert into dbo.product_dim values('P8','Video DVD','HP 1');
insert into dbo.product_dim values('P9','Video DVD','HP 2');
insert into dbo.product_dim values('P10','Shoes','Nike 10');
insert into dbo.product_dim values('P11','Shoes','Nike 11');
insert into dbo.product_dim values('P12','Shoes','Adidas 10');
insert into dbo.product_dim values('P13','Shoes','Adidas 09');
insert into dbo.product_dim values('P14','Book','God Father 1');
insert into dbo.product_dim values('P15','Book','God Father 2');


create table dbo.Sales_fact 
(
snapshot_day date,
product_id varchar(2),
sales_amt int
);



insert into dbo.Sales_fact values('20-JUL-11','P1',10);
insert into dbo.Sales_fact values('20-JUL-11','P2',5);
insert into dbo.Sales_fact values('20-JUL-11','P8',100);
insert into dbo.Sales_fact values('20-JUL-11','P3',5);
insert into dbo.Sales_fact values('20-JUL-11','P4',25);
insert into dbo.Sales_fact values('20-JUL-11','P5',15);
insert into dbo.Sales_fact values('20-JUL-11','P6',35);
insert into dbo.Sales_fact values('20-JUL-11','P7',5);
insert into dbo.Sales_fact values('20-JUL-11','P9',30);
insert into dbo.Sales_fact values('20-JUL-11','P10',8);
insert into dbo.Sales_fact values('20-JUL-11','P11',45);



create table dbo.glance_fact
(
snapshot_day date,
product_id varchar(2),
glance_views int
);



insert into dbo.glance_fact values('20-JUL-11','P1',1000);
insert into dbo.glance_fact values('20-JUL-11','P2',800);
insert into dbo.glance_fact values('20-JUL-11','P8',700);
insert into dbo.glance_fact values('20-JUL-11','P3',800);
insert into dbo.glance_fact values('20-JUL-11','P4',500);
insert into dbo.glance_fact values('20-JUL-11','P5',250);
insert into dbo.glance_fact values('20-JUL-11','P6',10);
insert into dbo.glance_fact values('20-JUL-11','P7',1000);
insert into dbo.glance_fact values('20-JUL-11','P9',1500);
insert into dbo.glance_fact values('20-JUL-11','P10',600);
insert into dbo.glance_fact values('20-JUL-11','P12',670);
insert into dbo.glance_fact values('20-JUL-11','P13',300);
insert into dbo.glance_fact values('20-JUL-11','P14',230);



create table dbo.inventory_fact
(
snapshot_day date,
product_id varchar(2),
on_hand_quantity int
);



insert into dbo.inventory_fact values('20-JUL-11','P1',100);
insert into dbo.inventory_fact values('20-JUL-11','P2',70);
insert into dbo.inventory_fact values('20-JUL-11','P8',90);
insert into dbo.inventory_fact values('20-JUL-11','P3',10);
insert into dbo.inventory_fact values('20-JUL-11','P4',30);
insert into dbo.inventory_fact values('20-JUL-11','P5',100);
insert into dbo.inventory_fact values('20-JUL-11','P6',120);
insert into dbo.inventory_fact values('20-JUL-11','P7',70);
insert into dbo.inventory_fact values('20-JUL-11','P9',90);


create table dbo.ad_spend_fact
(
snapshot_day date,
product_id varchar(2),
glance_views int
);



insert into dbo.ad_spend_fact values('20-JUL-11','P1',10);
insert into dbo.ad_spend_fact values('20-JUL-11','P2',5);
insert into dbo.ad_spend_fact values('20-JUL-11','P8',100);
insert into dbo.ad_spend_fact values('20-JUL-11','P3',5);
insert into dbo.ad_spend_fact values('20-JUL-11','P4',25);
insert into dbo.ad_spend_fact values('20-JUL-11','P5',15);
insert into dbo.ad_spend_fact values('20-JUL-11','P6',35);
insert into dbo.ad_spend_fact values('20-JUL-11','P7',5);
insert into dbo.ad_spend_fact values('20-JUL-11','P9',30);
insert into dbo.ad_spend_fact values('20-JUL-11','P10',8);
insert into dbo.ad_spend_fact values('20-JUL-11','P11',45);


SELECT * FROM dbo.product_dim 
SELECT * FROM dbo.Sales_fact 
SELECT * FROM dbo.glance_fact 
SELECT * FROM dbo.inventory_fact 
SELECT * FROM dbo.ad_spend_fact 

select product_group,product_id,sales_amt,coalesce(glance_views,0),coalesce(on_hand_quantity,0),coalesce((sales_amt-glance_ad_views),0) as ad_spend
from (select K.*,RANK() OVER(partition by product_group order by sales_amt desc) as rnk from
(select a.product_id,a.product_group,b.sales_amt,c.glance_views,d.on_hand_quantity,e.glance_views as glance_ad_views from product_dim a
inner join sales_fact b on a.product_id=b.product_id
left join glance_fact c on a.product_id=c.product_id
left join inventory_fact d on a.product_id=d.product_id
left join ad_spend_fact e on a.product_id=e.product_id)K) where rnk=1;



select distinct a.product_id from glance_fact a left join sales_fact b
on a.product_id=b.product_id where coalesce(b.sales_amt,0)=0;



select((select sum(coalesce(b.sales_amt,0)) as elec_sales from product_dim a left join sales_fact b
on a.product_id=b.product_id where a.product_group in ('Electronics') group by a.product_group)/
(select sum(coalesce(b.sales_amt,0)) as bk_sales from product_dim a left join sales_fact b
on a.product_id=b.product_id where a.product_group in ('Book') group by a.product_group))*100 as profit;


--10 
create table dbo.phone_log
(
source_phone_number int,
destination_phone_number int,
call_start_datetime datetime
);

--Contains teh phone numbers we dial in a day:

insert into dbo.phone_log values(1234,4567,'01/07/2011 10:00');
insert into dbo.phone_log values(1234,2345,'01/07/2011 11:00');
insert into dbo.phone_log values(1234,3456,'01/07/2011 12:00');
insert into dbo.phone_log values(1234,3456,'01/07/2011 13:00');
insert into dbo.phone_log values(1234,4567,'01/07/2011 15:00');
insert into dbo.phone_log values(1222,7890,'01/07/2011 10:00');
insert into dbo.phone_log values(1222,7680,'01/07/2011 12:00');
insert into dbo.phone_log values(1222,2345,'01/07/2011 13:00');

SELECT * FROM dbo.phone_log order by call_start_datetime

select source_phone_number,case when first_call=last_call then 'Y' else 'N' end as flag from
(
select source_phone_number,
max(case when start_rnk=1 then destination_phone_number end) as first_call,
max(case when last_rnk=1 then destination_phone_number end) as last_call from
(select source_phone_number,destination_phone_number,call_start_datetime,rank() over(partition by source_phone_number order by call_start_datetime) start_rnk,
rank() over(partition by source_phone_number order by call_start_datetime desc) last_rnk from phone_log) group by source_phone_number) order by source_phone_number;







----12. AmazonQuestion
CREATE TABLE dbo.EmployeeAttendance (
    EmployeeID VARCHAR(10),
    Dates DATE,
    Status VARCHAR(10)
);



INSERT INTO dbo.EmployeeAttendance (EmployeeID, Dates, Status) VALUES
('A1', '2024-01-01', 'PRESENT'),
('A1', '2024-01-02', 'PRESENT'),
('A1', '2024-01-03', 'PRESENT'),
('A1', '2024-01-04', 'ABSENT'),
('A1', '2024-01-05', 'PRESENT'),
('A2', '2024-01-02', 'PRESENT'),
('A2', '2024-01-03', 'PRESENT');



SELECT * FROM  dbo.EmployeeAttendance 



;WITH CTE1 AS
(
	SELECT * ,
	ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY Dates) RowNUm
	,DENSE_RANK() OVER (PARTITION BY EmployeeID, Status ORDER BY Dates) GRP
	,ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY Dates) 
	- DENSE_RANK() OVER (PARTITION BY EmployeeID, Status ORDER BY Dates) GroupIdentifier
	FROM  dbo.EmployeeAttendance 
	
)
SELECT 
EmployeeID, MIN(Dates )as Start_Date,  MAX(Dates )as End_Date,
MAX(Status)
FROM CTE1
GROUP BY EmployeeID, GroupIdentifier
order by EmployeeID, Start_Date


