-- Delete duplicate records from the Person table
DELETE p1
FROM Person p1

-- Self join the Person table
JOIN Person p2
    ON p1.email = p2.email     -- Match rows having the same email (duplicates)
   AND p1.id > p2.id           -- Keep the row with the smaller id, delete the larger id
