-- Creating database
CREATE DATABASE IF NOT EXISTS WalmartSales;

-- Using database 
USE WalmartSales;

-- Creating empty table with columns
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Feature Engineering

-- Fetching time of day
SELECT time, 
( CASE
WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(10);

UPDATE sales SET time_of_day = ( CASE
WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END );

-- Fetching day name of date
SELECT date, DAYNAME(date) AS day_name FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales SET day_name = (
DAYNAME(date)
);

-- Fetching month of date
SELECT date, MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales SET month_name = (
MONTHNAME(date)
);

-- Unique cities in the data

SELECT DISTINCT city FROM sales;

-- Fetching cities for each branch

SELECT DISTINCT city, branch FROM sales;

-- Count of unique product lines in the data

SELECT product_line, COUNT(DISTINCT product_line) AS count_of_product_line FROM sales GROUP BY product_line;

-- Most common payment method

SELECT payment, COUNT(payment) AS count_of_payment FROM sales
GROUP BY payment
ORDER BY count_of_payment DESC;

-- Most selling product line

SELECT product_line, COUNT(product_line) AS count_of_product_line FROM sales
GROUP BY product_line
ORDER BY count_of_product_line DESC;

-- Total revenue by month

SELECT month_name, SUM(total) AS total_revenue FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Month with largest COGS

SELECT DISTINCT month_name, SUM(cogs) AS total_cogs FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC;

-- Product line with largest revenue

SELECT product_line, SUM(total) AS total_revenue FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- City with largest revenue

SELECT city, SUM(total) AS total_revenue FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- Product line with largest VAT

SELECT product_line, SUM((5/100)*cogs) AS vat FROM sales
GROUP BY product_line
ORDER BY vat DESC;

-- Filtering product line by average sales

SELECT product_line, AVG(unit_price*quantity+tax_pct) FROM sales
GROUP BY product_line;

-- Branch which sold more products than average products sold

SELECT branch, SUM(quantity) AS total_quantity FROM sales
GROUP BY branch
HAVING total_quantity > (SELECT AVG(quantity) FROM sales);

-- Most common product line by gender

SELECT gender, product_line, COUNT(product_line) AS total_product_line FROM sales
GROUP BY gender, product_line
ORDER BY total_product_line desc;

-- Average rating of each product line

SELECT product_line, ROUND(AVG(rating), 2) AS avg_rating FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;