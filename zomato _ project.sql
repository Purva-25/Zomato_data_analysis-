create database zomato;
use zomato;

-- 1) find the customer who have never ordered food ?
select name, user_id from users 
where user_id not in ( select user_id from orders);

-- 2) find top restautant in terms of number of orders for a given month ?
SELECT r.r_name, count(*) AS month 
FROM orders o 
JOIN restaurants r ON o.r_id = r.r_id 
WHERE MONTHNAME(date) like 'June' 
GROUP BY o.r_id 
ORDER BY o.r_id DESC 
LIMIT 1;


-- 3) month over month revenue growth of zomato ?
select * from orders;
-- find revenue per month 
select monthname(date) as month , sum(amount) as revenue from orders
group by month 
order by month(date) ;
-- find revenue growth 
with sales as 
	( select monthname(date) as month , sum(amount) as revenue from orders
	  group by month 
      order by month(date)) 
select month , revenue , lag(revenue ,1) over(order by revenue ) as prev from sales;

-- 4) show restaurants with monthly sales > x for 
select o.r_id, r.r_name , sum(amount) as 'revenue' 
from orders o join restaurants r on o.r_id = r.r_id
where monthname(date) like 'June'
group by o.r_id
having revenue > 500;

-- 5) find most loyal customers for all restaurant ?
SELECT r.r_name, COUNT(*) AS 'loyal_customers' 
 FROM (
 SELECT r_id, user_id, COUNT(*) AS 'visits' FROM orders
 GROUP BY r_id, user_id HAVING visits>1
) t
 JOIN restaurants r
 ON r.r_id=t.r_id
 GROUP BY t.r_id 
 ORDER BY loyal_customers DESC LIMIT 1;

-- 6) find sales percentage of orders per month?
SELECT month, ((revenue)/prev)*100 FROM 
 (WITH sales AS
(
SELECT MONTHNAME(date) AS 'month', SUM(amount) AS 'revenue'
FROM orders
GROUP BY month
ORDER BY MONTH(date)
)

SELECT month, revenue, LAG(revenue, 1) OVER(ORDER BY revenue) AS prev FROM sales) t; 

