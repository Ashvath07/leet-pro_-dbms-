-- Create a SQL function named getNthHighestSalary
-- It takes one input parameter @N (the rank we want)
-- It returns an INT value (the salary)
CREATE FUNCTION getNthHighestSalary(@N INT) 
RETURNS INT 
AS
BEGIN
    -- Return the result of the SELECT query below
    RETURN (

        -- Select the maximum salary from the filtered result
        -- (MAX is used because the function must return a single value)
        SELECT MAX(salary)

        -- Create a temporary derived table 't'
        FROM (
            
            -- Select salary from Employee table
            -- Assign a rank to each salary using DENSE_RANK
            -- Highest salary gets rank 1
            SELECT 
                salary,
                DENSE_RANK() OVER (ORDER BY salary DESC) AS rn
            FROM Employee  

        ) t

        -- Filter the result to get only the salary
        -- whose rank is equal to @N (Nth highest salary)
        WHERE rn = @N
    );
END
