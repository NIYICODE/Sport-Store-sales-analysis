CREATE DATABASE Sport_Stores
-- Select all the rows in the customers table
SELECT *
FROM customers
-- Delete empty rows in the customers table
DELETE FROM customers
WHERE customer_id IS NULL;
--select all in the orders table
SELECT *
FROM orders
--Delete empty rows in the orders table
DELETE FROM orders
WHERE date IS NULL;

-- KPIS for total revenue, profit, number of orders, profit margin

SELECT
		SUM(revenue) AS total_revenue,
		SUM(profit) AS total_profit,
		COUNT(*) AS number_of_orders,
		ROUND((SUM(profit)/SUM(revenue)),2) * 100 AS profit_margin
FROM
		orders;

-- total revenue, profit, number of orders, profit margin for each sport

SELECT
		sport,
		ROUND(SUM(revenue),2) AS total_revenue,
		ROUND(SUM(profit),2) AS total_profit,
		COUNT(*) AS number_of_orders,
		ROUND((SUM(profit)/SUM(revenue)),2) * 100 AS profit_margin
FROM
		orders
GROUP BY
		sport
ORDER BY
		profit_margin;

-- Number of ratings and average ratings
SELECT COUNT(*) AS number_of_reviews, 
ROUND(AVG(rating),2) AS average_rating
FROM orders
WHERE rating IS NOT NULL

-- Number of people for each rating and its revenue, profit and profit margin

SELECT 
		rating,
		SUM(revenue) AS total_revenue,
		SUM(profit) AS total_profit,
		ROUND((SUM(profit)/SUM(revenue)),2) * 100 AS profit_margin
FROM
		orders
WHERE rating IS NOT NULL
GROUP BY 
		rating
ORDER BY
		rating DESC;

-- total revenue, profit, number of orders, profit margin for each state

SELECT 
		c.State,
		SUM(o.revenue) AS total_revenue,
		SUM(o.profit) AS total_profit,
		ROUND((SUM(o.profit)/SUM(o.revenue))*100,2) AS profit_margin
FROM
		customers c
INNER JOIN
		orders o
ON		c.customer_id=o.customer_id

GROUP BY
		State
ORDER BY
		total_profit DESC;

--rank each state according to revenue, profit and profit margin


SELECT 
		c.State,
		ROW_NUMBER() OVER(ORDER BY SUM(o.revenue)DESC) AS revenue_rank,
		SUM(o.revenue) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(o.profit)DESC) AS profit_rank,
		SUM(o.profit) AS total_profit,
		ROW_NUMBER() OVER(ORDER BY (SUM(o.profit)/SUM(o.revenue))*100 DESC) AS margin_rank,
		ROUND((SUM(o.profit)/SUM(o.revenue))*100,2) AS profit_margin
FROM
		customers c
INNER JOIN
		orders o
ON		c.customer_id=o.customer_id

GROUP BY
		State
ORDER BY
		margin_rank;

-- Monthly Profit
WITH monthly_profit AS (
SELECT
		MONTH(date) AS month,
		SUM(profit) AS total_profit
FROM
		orders
GROUP BY MONTH(date) 
)
SELECT 
		month,
		total_profit,
		LAG(total_profit) OVER (ORDER BY month) AS previous_month_profit,
		total_profit -LAG(total_profit) OVER (ORDER BY month) AS profit_difference
FROM
		monthly_profit
ORDER BY
		month;