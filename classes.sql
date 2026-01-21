-- Select the class column to display
SELECT class

-- Specify the table from which data is retrieved
FROM Courses

-- Group rows by class
-- This allows counting how many students are enrolled in each class
GROUP BY class

-- Filter groups where the number of students in a class is at least 5
HAVING COUNT(class) >= 5

-- Sort the result in ascending order of class
ORDER BY class;
