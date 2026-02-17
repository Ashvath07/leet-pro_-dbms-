SELECT
    ip,
    COUNT(*) AS invalid_count   -- Count how many times each invalid IP appears
FROM logs
WHERE
    -- Condition 1: Check if IP does NOT have exactly 3 dots (means not 4 octets)
    LEN(ip) - LEN(REPLACE(ip, '.', '')) <> 3 
    
    OR
    
    -- Condition 2: Check for leading zeros (example: 01, 002)
    -- This pattern catches cases like .01 , .002 etc.
    ip LIKE '%.0[0-9]%' 
    
    OR
    
    -- Condition 3: Check if any octet is greater than 255
    -- PARSENAME(ip, 4) → first octet
    -- PARSENAME(ip, 3) → second octet
    -- PARSENAME(ip, 2) → third octet
    -- PARSENAME(ip, 1) → fourth octet
    -- TRY_CAST avoids conversion errors
    TRY_CAST(PARSENAME(ip, 4) AS INT) > 255 OR
    TRY_CAST(PARSENAME(ip, 3) AS INT) > 255 OR
    TRY_CAST(PARSENAME(ip, 2) AS INT) > 255 OR
    TRY_CAST(PARSENAME(ip, 1) AS INT) > 255

-- Group by IP to count occurrences
GROUP BY ip

-- Order by:
-- 1️⃣ Highest invalid count first
-- 2️⃣ If tie → IP in descending order
ORDER BY invalid_count DESC, ip DESC;
