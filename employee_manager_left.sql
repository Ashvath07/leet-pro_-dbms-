/* Select the employee_id of employees who meet the criteria */
SELECT e.employee_id 
FROM Employees e

-- Perform a LEFT JOIN to match each employee with their manager
LEFT JOIN Employees m 
ON e.manager_id = m.employee_id

-- Filter employees with salary less than 30000
WHERE e.salary < 30000

-- Ensure the employee actually had a manager
AND e.manager_id IS NOT NULL

-- Check that the manager no longer exists in the Employees table
AND m.employee_id IS NULL 

-- Order the results by employee_id
ORDER BY e.employee_id;
