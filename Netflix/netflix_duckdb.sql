-- Run DuckDB on terminal
-- .duckdb/cli/latest/duckdb

-- Create table from csv
CREATE TABLE netflix AS SELECT * FROM read_csv('netflix_title.csv', header = true, ignore_errors = true);

-- Show the columns and types
DESCRIBE netflix;

-- Drop columns 'description' and 'duration'
ALTER TABLE netflix DROP description;
ALTER TABLE netflix DROP duration;

/* Transform date_added from "Month day, year" to YYYY-MM-DD */
-- Check the function
SELECT strptime(date_added, '%B %d, %Y') FROM netflix limit 5;

-- Update the column and change the type from VARCHAR to DATE
UPDATE netflix SET date_added = strptime(date_added, '%B %d, %Y');
ALTER TABLE netflix ALTER date_added TYPE DATE;


-- Calculate the number of genres for each title
select title, listed_in, len(string_split(listed_in, ',')) as genres from netflix;

-- Create column genres as list
ALTER TABLE netflix ADD COLUMN genres VARCHAR[];

UPDATE netflix SET genres = string_split(listed_in, ',');

SELECT trim(unnest(genres)), title FROM netflix limit 30;


--UNNEST MYSQL VERSION

-- Create a function that receive the listed_in value as p_listedin
-- and return the total genres listed
DROP FUNCTION IF EXISTS lenght_genre;

CREATE FUNCTION lenght_genre(p_listedin varchar(128))
RETURNS INT DETERMINISTIC
BEGIN
DECLARE counter INT;
DECLARE colon_pos INT;
SET counter = 1;
	
SET colon_pos = instr(p_listedin, ',');
WHILE colon_pos > 0 DO 
	SET counter = counter + 1;
	SET p_listedin = SUBSTRING(p_listedin, colon_pos +1);
	SET colon_pos = instr(p_listedin, ',');
END WHILE;
RETURN (counter);
END

-- Checking the function lenght_genre
SELECT title, lenght_genre(listed_in) as total_genres FROM netflix limit 5;

-- Update column genres
UPDATE netflix SET genres = lenght_genre(listed_in);

-- Calculate the max number of genres in listed_in
SELECT max(genres) FROM netflix;

-- Check UNNESTING listed_in
SELECT count(*) FROM (
	SELECT title, TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) as genres, date_added FROM netflix where genres >= 1
	UNION ALL
	SELECT title, TRIM(SUBSTRING_INDEX(listed_in, ',', -1)) as genres, date_added FROM netflix where genres > 1
	UNION ALL
	SELECT title, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', 2), ',',-1)) as genres, date_added 
    FROM netflix where genres = 3) 
U;

