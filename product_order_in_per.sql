-- Create a common table expression (CTE) named 'dat'
WITH dat AS (
    -- Select product_id and sum of units ordered in February 2020
    SELECT 
        product_id,
        SUM(unit) AS unit
    FROM Orders
    -- Filter orders for February 2020
    WHERE order_date >= '2020-02-01'
      AND order_date < '2020-03-01'
    -- Group by product_id to get total units per product
    GROUP BY product_id
)

-- Select product name and total units from the Products table joined with the CTE
SELECT 
    p.product_name,
    d.unit
FROM Products p
-- Join Products with the CTE 'dat' on product_id
JOIN dat d
  ON p.product_id = d.product_id
-- Filter to include only products with at least 100 units sold
WHERE d.unit >= 100;
