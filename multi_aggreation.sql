-- CTE 1: Extract month from sale_date to identify the season later
WITH sale AS (
    SELECT *,
           MONTH(sale_date) AS weather      -- Extracts month (1–12) from sale_date
    FROM sales                            -- Reads all rows from sales table
),

-- CTE 2: Assign season and calculate revenue for each sale row
weathersales AS (
    SELECT *,
           CASE                            -- Maps month number to season
               WHEN weather BETWEEN 3 AND 5 THEN 'Spring'
               WHEN weather BETWEEN 6 AND 8 THEN 'Summer'
               WHEN weather BETWEEN 9 AND 11 THEN 'Fall'
               ELSE 'Winter'
           END AS season,                  -- Creates season column
           quantity * price AS revenue     -- Calculates revenue per sale
    FROM sale                             -- Uses month-enhanced sales data
),

-- CTE 3: Aggregate total quantity and revenue per season and category
category_totals AS (
    SELECT
        w.season,                          -- Season of sale
        p.category,                        -- Product category
        SUM(w.quantity) AS total_quantity,-- Total items sold per category per season
        SUM(w.revenue) AS total_revenue   -- Total revenue per category per season
    FROM weathersales w
    JOIN products p
        ON w.product_id = p.product_id    -- Joins to get category information
    GROUP BY
        w.season,
        p.category                        -- Groups data by season and category
),

-- CTE 4: Rank categories within each season based on problem rules
ranked_categories AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY season            -- Resets ranking for each season
            ORDER BY
                total_quantity DESC,       -- Higher quantity ranked first
                total_revenue DESC,        -- Higher revenue breaks quantity ties
                category ASC               -- Lexicographically smallest category as final tie-breaker
        ) AS rn                            -- Assigns rank number
    FROM category_totals
)

-- Final query: Select the most popular category for each season
SELECT
    season,                               -- Season name
    category,                             -- Most popular category
    total_quantity,                      -- Total quantity sold
    total_revenue                        -- Total revenue generated
FROM ranked_categories
WHERE rn = 1                             -- Keeps only top-ranked category per season
ORDER BY season ASC;                    -- Orders result by season
