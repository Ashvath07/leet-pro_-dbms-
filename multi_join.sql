/* 
This query finds the number of exams attended by each student
for every subject, including subjects they never attended.
*/

SELECT 
    s.student_id,              -- Select student ID
    s.student_name,            -- Select student name
    su.subject_name,           -- Select subject name
    COUNT(e.student_id) AS attended_exams  -- Count exams attended (NULLs ignored → gives 0)
FROM Students s

-- CROSS JOIN generates all possible combinations of students and subjects
CROSS JOIN Subjects su

-- LEFT JOIN to match exam records (if any) for the student and subject
LEFT JOIN Examinations e
    ON s.student_id = e.student_id      -- Match student
   AND e.subject_name = su.subject_name -- Match subject

-- Group by student and subject to count exams per subject
GROUP BY 
    s.student_id,
    s.student_name,
    su.subject_name

-- Order the output as required
ORDER BY 
    s.student_id,
    s.student_name,
    su.subject_name;
