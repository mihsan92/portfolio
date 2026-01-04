-- Netflix’s content library grown year over year
WITH yearly_additions AS (
    SELECT
        EXTRACT(YEAR FROM date_added) AS year_added,
        COUNT(*) AS titles_added
    FROM netflix_clean
    GROUP BY year_added
)
SELECT *
FROM yearly_additions
ORDER BY year_added;


-- trend analysis partitioned by category
WITH type_counts AS (
    SELECT
        EXTRACT(YEAR FROM date_added) AS year_added,
        type,
        COUNT(*) AS count
    FROM netflix_clean
    GROUP BY year_added, type
)
SELECT
    year_added,
    type,
    count,
    SUM(count) OVER (PARTITION BY type ORDER BY year_added) AS cumulative_count
FROM type_counts
ORDER BY year_added;


-- the most popular genres each year
WITH genre_counts AS (
    SELECT
        EXTRACT(YEAR FROM nc.date_added) AS year_added,
        ng.genre,
        COUNT(*) AS genre_count
    FROM netflix_clean nc
    JOIN netflix_genres ng
        ON nc.show_id = ng.show_id
    GROUP BY year_added, ng.genre
),
ranked_genres AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY year_added ORDER BY genre_count DESC) AS genre_rank
    FROM genre_counts
)
SELECT *
FROM ranked_genres
WHERE genre_rank <= 5
ORDER BY year_added, genre_rank;



-- Most popular Directors with more than 5 content
SELECT
	nd.director,
	n.country,
	COUNT(DISTINCT nd.show_id) AS num_of_content
FROM netflix_clean AS n
FULL JOIN netflix_directors AS nd
	ON n.show_id = nd.show_id
WHERE n.director <> 'Not Given'
GROUP BY nd.director,n.country
HAVING COUNT(DISTINCT nd.show_id) > 5
ORDER BY num_of_content DESC;


-- Number of Movies and TV Shows

SELECT
    EXTRACT(YEAR FROM date_added) AS year_added,
    COUNT(CASE WHEN type = 'Movie' THEN show_id END) AS movie_count,
    COUNT(CASE WHEN type = 'Tv Show' THEN show_id END) AS tv_show_count
FROM netflix_clean
GROUP BY EXTRACT(YEAR FROM date_added)
ORDER BY year_added;




