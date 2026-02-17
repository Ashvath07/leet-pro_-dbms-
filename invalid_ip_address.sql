/* Write your T-SQL query statement below */

-- First CTE: Extract IP parts and calculate dot count
WITH ip_ch AS (
    SELECT 
        ip,

        -- Count number of dots in IP
        -- Valid IPv4 must have exactly 3 dots
        LEN(ip) - LEN(REPLACE(ip,'.','')) AS dot_col,

        -- Extract each octet using PARSENAME
        -- PARSENAME reads from right to left
        -- 4 = first octet, 1 = last octet
        PARSENAME(ip,4) AS o1,
        PARSENAME(ip,3) AS o2,
        PARSENAME(ip,2) AS o3,
        PARSENAME(ip,1) AS o4
    FROM logs
),

-- Second CTE: Filter invalid IPs
vaild AS (
    SELECT ip 
    FROM ip_ch
    WHERE 
        
        -- Condition 1: Not exactly 4 octets
        dot_col <> 3

        OR

        -- Condition 2: Any octet greater than 255
        TRY_CAST(o1 AS INT) > 255 OR
        TRY_CAST(o2 AS INT) > 255 OR
        TRY_CAST(o3 AS INT) > 255 OR
        TRY_CAST(o4 AS INT) > 255

        OR

        -- Condition 3: Leading zero check
        -- If length > 1 and starts with '0', it is invalid
        (LEN(o1) > 1 AND LEFT(o1,1) = '0') OR
        (LEN(o2) > 1 AND LEFT(o2,1) = '0') OR
        (LEN(o3) > 1 AND LEFT(o3,1) = '0') OR
        (LEN(o4) > 1 AND LEFT(o4,1) = '0')
)

-- Final result: Count invalid IP occurrences
SELECT 
    ip,
    COUNT(*) AS invalid_count
FROM vaild
GROUP BY ip

-- Order by highest invalid count first
-- If tie, order by IP in descending order
ORDER BY invalid_count DESC, ip DESC;
