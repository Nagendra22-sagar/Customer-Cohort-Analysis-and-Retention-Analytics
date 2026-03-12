create database cohort_project;
use cohort_project;

SELECT * 
FROM customer_orders
LIMIT 10;

select count(*) as Count
from customer_orders;

-- Find First Purchase of Each Customer --
select Customer_ID,
min(Order_Date) as First_Purchase_Date
from customer_orders
group by Customer_ID;

-- Convert First Purchase to Cohort Month --
select Customer_ID,
date_format(min(Order_Date), '%Y-%%m') as Cohort_Month
from customer_orders
group by Customer_ID;

DESCRIBE customer_orders;
DROP TABLE IF EXISTS customer_cohort;

CREATE TABLE customer_cohort AS
SELECT 
Customer_ID,
DATE_FORMAT(
MIN(STR_TO_DATE(Order_Date,'%d-%m-%Y')),
'%Y-%m'
) AS Cohort_Month
FROM customer_orders
GROUP BY Customer_ID;

SELECT *
FROM customer_cohort
LIMIT 10;

-- Join Orders with Cohort Table --
SELECT 
o.Customer_ID,
c.Cohort_Month,
o.Order_Month
FROM customer_orders o
JOIN customer_cohort c
ON o.Customer_ID = c.Customer_ID
LIMIT 10;

SELECT 
o.Customer_ID,
c.Cohort_Month,
o.Order_Month,

PERIOD_DIFF(
REPLACE(o.Order_Month,'-',''),
REPLACE(c.Cohort_Month,'-','')
) AS Month_Index

FROM customer_orders o
JOIN customer_cohort c
ON o.Customer_ID = c.Customer_ID
LIMIT 20;

-- The Retention Table --
CREATE TABLE cohort_retention AS
SELECT 
    o.Customer_ID,
    c.Cohort_Month,
    o.Order_Month,
    PERIOD_DIFF(
        REPLACE(o.Order_Month,'-',''),
        REPLACE(c.Cohort_Month,'-','')
    ) AS Month_Index
FROM customer_orders o
JOIN customer_cohort c
ON o.Customer_ID = c.Customer_ID;

SELECT *
FROM cohort_retention
LIMIT 20;

SELECT 
    Cohort_Month,
    Month_Index,
    COUNT(DISTINCT Customer_ID) AS Customers
FROM cohort_retention
GROUP BY Cohort_Month, Month_Index
ORDER BY Cohort_Month, Month_Index;

SELECT 
    Cohort_Month,
    Month_Index,
    COUNT(DISTINCT Customer_ID) AS Customers
FROM cohort_retention
GROUP BY Cohort_Month, Month_Index
ORDER BY Cohort_Month, Month_Index;