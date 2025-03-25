-- 1. How many movies and TV shows are there in the dataset? 
SELECT count(*), type 
FROM netflix 
GROUP BY type;

-- 2. What percentage of content doesn't have a country associated with it?
SELECT ROUND((A.total * 100) / B.total, 2) AS 'Titles with no country'
FROM (SELECT COUNT(*) AS total FROM netflix WHERE country = '') A, 
(SELECT COUNT(*) AS total FROM netflix) B;

-- 3. Find the top 3 directors with the most content on Netflix. 
-- Display the director's name, the count of their titles, and the year of their most recent content. 
SELECT director, count(show_id) AS total_titles, MAX(release_year) AS recent_year 
FROM netflix WHERE director != '' GROUP BY director
ORDER BY total_titles DESC 
LIMIT 3;

-- 4. For each year from 2015 to 2021, calculate the percentage of movies vs TV shows added to Netflix
WITH shows_type_per_year AS (
	SELECT YEAR(date_added) AS year, count(show_id) AS shows, type 
	FROM netflix 
	WHERE date_added != '' AND date_added between '2015-01-01' AND '2021-12-31'
	GROUP BY 3, 1
)
SELECT 
ROUND((SUM(CASE WHEN type = 'Movie' THEN shows ELSE 0 END) * 100) / SUM(shows),2) AS Movies,
ROUND((SUM(CASE WHEN type = 'TV Show' THEN shows ELSE 0 END) * 100) / SUM(shows),2) AS 'TV Shows',
year
FROM shows_type_per_year
GROUP BY year;


-- 5. Calculate the AVG month-over-month growth rate of content added to Netflix for each genre. 
-- What are the top 5 fastest growing genres? 

-- UNNEST WITH MYSQL!
WITH genre_added AS (
	SELECT TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) as genre, date_added FROM netflix where category >= 1
	UNION ALL
	SELECT TRIM(SUBSTRING_INDEX(listed_in, ',', -1)) as genre, date_added FROM netflix where category > 1
	UNION ALL
	SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', 2), ',',-1)) as genre, date_added FROM netflix where category = 3
), 
-- Calculate count added by month and previous month
monthly_added AS(
	SELECT genre, month_added, total_added,
		LAG(total_added, 1, NULL) OVER(PARTITION BY genre ORDER BY month_added) as previous_month
	FROM (SELECT count(*) AS total_added, genre, MONTH(date_added) AS month_added
		FROM genre_added 
		WHERE date_added != ''
		GROUP BY 2, 3) A
), 
-- Calculate growth percentage 
percent_growth AS (
	SELECT genre, 
		CASE WHEN previous_month IS NULL THEN NULL
   		ELSE (total_added - previous_month) * 100.0 / previous_month
    	END AS month_over_month_growth_rate
    FROM monthly_added 
)
-- Calculate the AVG growth rate and the 5 fastest
SELECT genre, ROUND(AVG(month_over_month_growth_rate),2) as avg_growth
FROM percent_growth
GROUP BY genre 
ORDER BY avg_growth DESC LIMIT 5;