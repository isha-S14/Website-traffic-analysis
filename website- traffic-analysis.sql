/* TOTAL PAGE VIEWS OVER TIME */

   /*  THIS RETRIEVES THE TOTAL NUMBER OF PAGE VIEWS PER DAY */

SELECT DATE(timestamp) AS visit_date, COUNT(*) AS Total_page_views 
FROM web_traffic
GROUP BY visit_date 
ORDER BY visit_date;


/* TRAFFIC SOURCE BREAKDOWN */

   /* IDENTIFIES WHICH SOURCES ORGANIC, DIRECT, REFERRAL, SOCIAL BRINK IN THE MOST TRAFFIC */

SELECT traffic_source, COUNT(*) AS total_visit
FROM web_traffic
GROUP BY traffic_source 
ORDER BY total_visit DESC

/*  AVERAGE SESSION  DURATION */
 
  /* THE AVERAGE SESSION DURATION PER USER  */

SELECT user_id, AVG(session_duration) AS avg_session_duration
FROM user_sessions
GROUP BY  user_id
ORDER BY avg_session_duration DESC

/* BOUNCE RATE CALCULATION */

  /* BOUNCE RATE IS CALCULATED AS SINGLE PAGE SESSION DIVIDED BY TOTAL SESSIONS */

SELECT
      COUNT(CASE WHEN pages_visited = 1 THEN 1 END) *100.0 / COUNT(*) AS bounce_rate 
FROM user_sessions;

/* EXIT PAGES ANALYSIS */

/* the pages where users most frequently leave the site */

SELECT exit_page, COUNT(*) AS exit_count
FROM web_traffic
WHERE exit_page IS NOT NULL
GROUP BY exit_page
ORDER BY exit_count DESC
LIMIT 10

/*TOP PERFORMING PAGES */

   /* The pages where users most frequently leave the site */

SELECT exit_page, count(*) AS exity_count
FROM web_traffic
GROUP BY page_url
ORDER BY views DESC
limit 10


/* CONVERSION RATE BY TRAFFIC SOURCE */

      /* How well each traffic source converts */

SELECT traffic_source,
    count ( case when goal_completed = 1 THEN 1 END) * 100.0 / COUNT(*) AS conersion_rate 
FROM user_sesssions 
GROUP BY traffic_source 
ORDER BY conversion_rate DESC

/* PEAK TRAFFIC HOURS */

   /* Which hours of the day see the highest website traffic */

SELECT HOURS (TIMESTAMP) AS hour_of_day, COUNT(*) AS total_visit 
FROM web_traffic
GROUP BY hour_of_day
order by total_visit DESC

/* NEW VS. RETURNING USERS */ 

    /* the number of new visitors against returning ones */

SELECT user_type, COUNT(*) AS user_count
FROM user_sessions
GROUP BY user_type

/* PREDICTING FUTURE TRAFFIC USING MOVING AVERAGES */

   /* Uses a rolling 7-day average to identify trends in web traffic */


SELECT visit_date,
      AVG(total_page_views) OVER (ORDER BY visit_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg 
FROM (
      SELECT DATE(timestamp) as visit date,count(*) AS total_page_views 
      FROM web_traffic
      GROUP BY visit_date 
     ) subquery
ORDER BY visit_date

/* LINEAR REGRESSION FOR TREND ANALYSIS */

   /* helps predict future website traffic based on historical data (forecasting future) */

WITH trend AS (
     SELECT regr_slope(total_visit, EXTRACT(EPOCH FROM visit_date)) AS slope,
            regr_intercept(total_visit, EXTRACT(EPOCH FROM visit_date)) AS intercept
FROM (
       SELECT DATE(timestamp) AS visit_date, COUNT(*) AS total_visits
        FROM web_traffic
        GROUP BY visit_date
) subquery
)
SELECT visit_date, total_visits, 
       (slope * EXTRACT(EPOCH FROM visit_date) + intercept) AS predicted_traffic
FROM (
    SELECT DATE(timestamp) AS visit_date, COUNT(*) AS total_visits
    FROM web_traffic
    GROUP BY visit_date
) subquery, trend



























