WITH cte AS (
    SELECT 
        id,
        visit_date,
        people,
        -- Create a group identifier by subtracting row number from id
        -- This helps identify consecutive rows
        id - ROW_NUMBER() OVER (ORDER BY id) AS grp
    FROM Stadium
    -- Consider only rows where people count is at least 100
    WHERE people >= 100
),

Groups AS (
    SELECT 
        grp,
        -- Count how many consecutive rows exist in each group
        COUNT(*) AS cnt
    FROM cte
    GROUP BY grp
    -- Keep only groups that have at least 3 consecutive rows
    HAVING COUNT(*) >= 3
)

SELECT 
    c.id,
    c.visit_date,
    c.people
FROM cte c
-- Join with valid groups having 3 or more consecutive records
JOIN Groups g
    ON c.grp = g.grp
-- Order the final result by visit date
ORDER BY c.visit_date;
