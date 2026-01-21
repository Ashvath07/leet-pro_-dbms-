-- Select only one record (the top result)
-- customer_number is the column to be displayed
SELECT TOP 1 customer_number

-- Specify the table from which data is retrieved
FROM orders

-- Group rows by customer_number
-- This allows counting how many orders each customer has
GROUP BY customer_number

-- Count the number of orders for each customer
-- Sort the result in descending order so the highest count comes first
ORDER BY COUNT(order_number) DESC;
