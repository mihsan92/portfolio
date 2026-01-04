-- Creating a staging table

CREATE TABLE IF NOT EXISTS netflix_raw (
    show_id VARCHAR,
    type VARCHAR,
    title VARCHAR,
    director VARCHAR,
    country VARCHAR,
    date_added VARCHAR,
    release_year VARCHAR,
    rating VARCHAR,
    duration VARCHAR,
    listed_in VARCHAR
);

--Inserting data from the imported file. Removing 
INSERT INTO netflix_raw (SELECT * FROM netflix WHERE show_id <> 'show_id');


-- View first 5 rows
SELECT * FROM netflix_raw LIMIT 5;

-- Get row count
SELECT COUNT(*) FROM netflix_raw;

-- check duplicate on show_id column
SELECT show_id, COUNT(*)
FROM netflix_raw
GROUP BY show_id
HAVING COUNT(*) > 1;


-- Check missing values in each column
SELECT
    SUM(CASE WHEN show_id IS NULL THEN 1 ELSE 0 END) AS show_id_na,
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS type_na,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_na,
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS director_na,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_na,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS date_added_na,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS release_year_na,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_na,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_na,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS listed_in_na
FROM netflix_raw;



-- Get data type of each column
SELECT column_name, data_type, table_name FROM information_schema.columns
WHERE table_name = 'netflix_raw';

