-- -- create table
-- DROP TABLE IF EXISTS spotify;
-- CREATE TABLE spotify (
--     artist VARCHAR(255),
--     track VARCHAR(255),
--     album VARCHAR(255),
--     album_type VARCHAR(50),
--     danceability FLOAT,
--     energy FLOAT,
--     loudness FLOAT,
--     speechiness FLOAT,
--     acousticness FLOAT,
--     instrumentalness FLOAT,
--     liveness FLOAT,
--     valence FLOAT,
--     tempo FLOAT,
--     duration_min FLOAT,
--     title VARCHAR(255),
--     channel VARCHAR(255),
--     views FLOAT,
--     likes BIGINT,
--     comments BIGINT,
--     licensed BOOLEAN,
--     official_video BOOLEAN,
--     stream BIGINT,
--     energy_liveness FLOAT,
--     most_played_on VARCHAR(50)
-- );

select * from spotify where duration_min = 0;

Select * from spotify;
-- delete from spotify where duration_min = 0;
----------------------------------------------------------------------------------------
-- q1. Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify
where stream >= 1000000000

-- Q2. List all albums along with their respective artists.

select distinct (album) , artist from spotify

-- 	Q3. Get the total number of comments for tracks where licensed = TRUE.

select sum(comments)as total_commect from spotify where 
licensed = TRUE;


-- Q4. Find all tracks that belong to the album type single.
select * from spotify where album_type ilike 'single';

-- Q5. Count the total number of tracks by each artist.

select artist, count(*) from spotify
group by artist order by 2 desc

-- Q6 Calculate the average danceability of tracks in each album.
select album , avg(danceability) from spotify 
group by album 
order by 2 desc;

--	Q7. Find the top 5 tracks with the highest energy values.

select track, max(energy) from
spotify group by 1
order by  2 desc
limit 5


-- Q8. List all tracks along with their views and likes where official_video = TRUE.

select track , sum(views),
sum(likes)
from spotify
where official_video ilike 'TRUE\'
group by 1
order by 2 desc
limit 5

-- 	Q9. For each album, calculate the total views of all associated tracks.

select sum(views),track, album from spotify
group by 3,2
order by 3 desc;


-- Q10 Retrieve the track names that have been streamed on Spotify more than YouTube.

-- select track , stream, most_played_on


--Q11. Find the top 3 most-viewed tracks for each artist using window functions.
with ranking_artist as
(select artist, track, sum(views),
dense_rank() over(partition by artist order by sum(views) desc )as rank 
from spotify
group by 1, 2 
order by 1, 3 desc
)

select * from ranking_artist
where rank <= 3

-- Q12. Write a query to find tracks where the liveness score is above the average.

select track, artist, liveness from spotify 
where liveness > (select avg(liveness ) from spotify)

-- Q13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte AS (
    SELECT 
        album, 
        MAX(energy) AS highest_energy,
        MIN(energy) AS lowest_energy
    FROM spotify
    GROUP BY album
)
SELECT 
    album, 
    highest_energy - lowest_energy AS energy_diff
FROM cte;

--Q14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT 
    track, 
    artist,
    energy,
    liveness,
    views,
    likes
FROM spotify
WHERE energy / liveness > 1.2
ORDER BY energy / liveness DESC;
)

--Q15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT 
    track, 
    artist,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes
FROM spotify
ORDER BY views DESC;

