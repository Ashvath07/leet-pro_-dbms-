-- Select the activity date and rename it as day
SELECT 
    activity_date AS day,

-- Count the number of distinct users active on each day
    COUNT(DISTINCT user_id) AS active_users

-- Specify the table from which data is retrieved
FROM Activity

-- Filter records to include only activities in the last 30 days
-- Starting from 29 days before 2019-07-27 up to 2019-07-27
WHERE DATE(activity_date) BETWEEN 
      DATE_SUB('2019-07-27', INTERVAL 29 DAY)
      AND '2019-07-27'

-- Group the results by date to get daily active users
GROUP BY DATE(activity_date);
