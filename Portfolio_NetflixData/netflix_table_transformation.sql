-- Creating a new table to import raw table with desired data types and in order to perform data transformation

CREATE TABLE IF NOT EXISTS netflix_clean (
    show_id VARCHAR PRIMARY KEY,
    type VARCHAR,
    title VARCHAR,
    director VARCHAR,
    country VARCHAR,
    date_added DATE,
    release_year INTEGER,
    rating VARCHAR,
    duration INTEGER,
    duration_unit VARCHAR,
    listed_in VARCHAR
);

-- Inserting data from raw table. Transformed column formats and types. 
INSERT INTO netflix_clean (
	SELECT
		show_id,
		type,
		title,
		NULLIF(director,''),
		NULLIF(country,''),
		TO_DATE(date_added, 'MM/DD/YYYY') AS date_added,
		release_year::INT,
		rating,
		SPLIT_PART(duration,' ', 1)::INT AS duration,
		SPLIT_PART(duration, ' ', 2) AS duration_unit,
		listed_in
	FROM netflix_raw
	);


-- Making sure that values with have same format
UPDATE netflix_clean
SET type = INITCAP(type);


-- Trimming whitespaces
UPDATE netflix_clean
SET
    title = TRIM(title),
    director = TRIM(director),
    country = TRIM(country),
    rating = TRIM(rating);


-- Listed_in column contains multiple categories. Creating a new table to store them separately
CREATE TABLE IF NOT EXISTS netflix_genres (
    show_id VARCHAR,
    genre VARCHAR
);

INSERT INTO netflix_genres (show_id, genre)
SELECT
    show_id,
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ',')))
FROM netflix_clean;


-- directors column contains multiple director. Creating a new table to store them separately
CREATE TABLE IF NOT EXISTS netflix_directors (
    show_id VARCHAR,
    director VARCHAR
);

INSERT INTO netflix_directors (show_id, director)
SELECT
    show_id,
    TRIM(UNNEST(STRING_TO_ARRAY(director, ',')))
FROM netflix_clean;



-- Calculating content age (years since they were released)
ALTER TABLE netflix_clean
ADD COLUMN content_age INT;

UPDATE netflix_clean
SET content_age = (SELECT MAX(release_year) FROM netflix_clean) - release_year;

-- Calculating decade of release year

ALTER TABLE netflix_clean
ADD COLUMN release_decade VARCHAR;

UPDATE netflix_clean
SET release_decade = (release_year / 10) * 10 || 's';


SELECT * FROM netflix_clean LIMIT 5;

