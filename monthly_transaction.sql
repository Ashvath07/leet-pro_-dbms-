-- Format the transaction date to Year-Month and name it as month
SELECT FORMAT(trans_date, 'yyyy-MM') AS month,

-- Select the country column
country,

-- Count the total number of transactions
COUNT(*) AS trans_count,

-- Count only the approved transactions
SUM(CASE 
        WHEN state = 'approved' THEN 1 
        ELSE 0 
    END) AS approved_count,

-- Calculate the total transaction amount (all states)
SUM(amount) AS trans_total_amount,

-- Calculate the total amount of approved transactions only
SUM(CASE 
        WHEN state = 'approved' THEN amount 
        ELSE 0 
    END) AS approved_total_amount

-- Specify the table from which data is retrieved
FROM Transactions 

-- Group data by formatted month and country
GROUP BY FORMAT(trans_date, 'yyyy-MM'), country;
