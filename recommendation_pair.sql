-- First CTE: Generate all product pairs purchased by the same user
WITH pro AS (
    SELECT 
        p.user_id,                        -- Customer who made the purchase
        p.product_id AS product1_id,      -- First product in the pair
        p2.product_id AS product2_id      -- Second product in the pair
    FROM ProductPurchases p

    -- Self join to find products bought together by the same user
    JOIN ProductPurchases p2
        ON p.user_id = p2.user_id         -- Same user purchased both products
       AND p.product_id < p2.product_id  -- Ensure unique ordered pairs
),

-- Second CTE: Count how many distinct users bought each product pair
cou AS (
    SELECT 
        product1_id,                      -- First product in the pair
        product2_id,                      -- Second product in the pair
        COUNT(DISTINCT user_id) 
            AS customer_count             -- Number of different users
    FROM pro

    -- Group by product pair to aggregate customer counts
    GROUP BY product1_id, product2_id

    -- Keep only pairs bought by at least 3 different users
    HAVING COUNT(DISTINCT user_id) >= 3
)

-- Final query: Fetch categories and display the result
SELECT
    c.product1_id,                        -- First product ID
    c.product2_id,                        -- Second product ID
    p.category AS product1_category,      -- Category of first product
    p2.category AS product2_category,     -- Category of second product
    c.customer_count                      -- Number of common customers
FROM cou c

-- Join ProductInfo to get category of product1
JOIN ProductInfo p
    ON c.product1_id = p.product_id

-- Join ProductInfo again to get category of product2
JOIN ProductInfo p2 
    ON c.product2_id = p2.product_id

-- Order results as required by the problem statement
ORDER BY
    c.customer_count DESC,                -- Highest co-purchase first
    c.product1_id ASC,                    -- Tie-breaker 1
    c.product2_id ASC;                    -- Tie-breaker 2
