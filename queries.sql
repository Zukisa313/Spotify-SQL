-- Spotify Features SQL Analytics Project
-- Database: SQLite 3
-- Importing the supplied CSV creates the spotify_tracks table.
-- Note: the source contains genre-labelled rows; a track_id may occur more than once.
-- Use COUNT(DISTINCT track_id) when asking for unique tracks.

-- 1. Dataset size and coverage
SELECT COUNT(*) AS rows,
       COUNT(DISTINCT track_id) AS unique_track_ids,
       COUNT(DISTINCT artist_name) AS artists,
       COUNT(DISTINCT genre) AS genres
FROM spotify_tracks;

-- 2. Missing values in key descriptive fields
SELECT
  SUM(CASE WHEN track_name IS NULL OR TRIM(track_name) = '' THEN 1 ELSE 0 END) AS missing_track_names,
  SUM(CASE WHEN artist_name IS NULL OR TRIM(artist_name) = '' THEN 1 ELSE 0 END) AS missing_artists,
  SUM(CASE WHEN track_id IS NULL OR TRIM(track_id) = '' THEN 1 ELSE 0 END) AS missing_track_ids
FROM spotify_tracks;

-- 3. Number of rows and unique tracks per genre
SELECT genre, COUNT(*) AS rows, COUNT(DISTINCT track_id) AS unique_tracks
FROM spotify_tracks GROUP BY genre ORDER BY rows DESC;

-- 4. Genres ranked by average popularity
SELECT genre, COUNT(*) AS rows, ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks GROUP BY genre ORDER BY avg_popularity DESC;

-- 5. Most popular tracks (rows; same track may have multiple genre rows)
SELECT track_name, artist_name, popularity, genre
FROM spotify_tracks ORDER BY popularity DESC, track_name LIMIT 25;

-- 6. Artists with the highest average popularity (minimum 10 rows)
SELECT artist_name, COUNT(*) AS rows, ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks GROUP BY artist_name
HAVING COUNT(*) >= 10 ORDER BY avg_popularity DESC LIMIT 25;

-- 7. Most represented artists
SELECT artist_name, COUNT(*) AS rows, COUNT(DISTINCT track_id) AS unique_tracks
FROM spotify_tracks GROUP BY artist_name ORDER BY rows DESC LIMIT 25;

-- 8. Danceability and energy by genre
SELECT genre, ROUND(AVG(danceability), 3) AS danceability,
       ROUND(AVG(energy), 3) AS energy
FROM spotify_tracks GROUP BY genre ORDER BY danceability DESC;

-- 9. Audio features vs popularity (popularity bands)
SELECT CASE WHEN popularity < 20 THEN '0-19'
            WHEN popularity < 40 THEN '20-39'
            WHEN popularity < 60 THEN '40-59'
            WHEN popularity < 80 THEN '60-79'
            ELSE '80-100' END AS popularity_band,
       COUNT(*) AS rows, ROUND(AVG(energy), 3) AS energy,
       ROUND(AVG(danceability), 3) AS danceability,
       ROUND(AVG(valence), 3) AS valence,
       ROUND(AVG(acousticness), 3) AS acousticness
FROM spotify_tracks GROUP BY popularity_band
ORDER BY MIN(popularity);

-- 10. Duration outliers: tracks longer than 10 minutes
SELECT track_name, artist_name, genre, ROUND(duration_ms / 60000.0, 2) AS duration_minutes,
       popularity
FROM spotify_tracks WHERE duration_ms > 600000
ORDER BY duration_ms DESC LIMIT 50;

-- 11. Explicitly inspect extremely quiet/loud tracks
SELECT track_name, artist_name, genre, loudness, popularity
FROM spotify_tracks ORDER BY loudness ASC LIMIT 20;

-- 12. Tempo distribution by genre
SELECT genre, ROUND(AVG(tempo), 2) AS avg_tempo,
       ROUND(MIN(tempo), 2) AS min_tempo, ROUND(MAX(tempo), 2) AS max_tempo
FROM spotify_tracks GROUP BY genre ORDER BY avg_tempo;

-- 13. Acousticness by genre
SELECT genre, ROUND(AVG(acousticness), 3) AS avg_acousticness
FROM spotify_tracks GROUP BY genre ORDER BY avg_acousticness DESC;

-- 14. Instrumental tracks (threshold is an analytical choice)
SELECT track_name, artist_name, genre, instrumentalness, popularity
FROM spotify_tracks WHERE instrumentalness >= 0.8
ORDER BY instrumentalness DESC LIMIT 50;

-- 15. Speech-heavy tracks (threshold is an analytical choice)
SELECT track_name, artist_name, genre, speechiness, popularity
FROM spotify_tracks WHERE speechiness >= 0.66
ORDER BY speechiness DESC LIMIT 50;

-- 16. Popularity distribution
SELECT popularity, COUNT(*) AS row_count
FROM spotify_tracks GROUP BY popularity ORDER BY popularity;

-- 17. Correlations are not built into SQLite. Export the numeric columns and calculate
--     Pearson correlations in Python; see analyze.py.
-- 18. Genre view (created in schema)
SELECT * FROM genre_summary ORDER BY avg_popularity DESC;

-- 19. Artist view (created in schema)
SELECT * FROM artist_summary WHERE row_count >= 10 ORDER BY avg_popularity DESC LIMIT 50;

-- 20. Compare average popularity of high- and low-energy tracks
SELECT CASE WHEN energy >= 0.7 THEN 'High energy (>=0.7)'
            ELSE 'Lower energy (<0.7)' END AS energy_group,
       COUNT(*) AS rows, ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks GROUP BY energy_group;

-- 21. Valence (musical positivity) bands
SELECT CASE WHEN valence < 0.25 THEN 'Low'
            WHEN valence < 0.5 THEN 'Medium-low'
            WHEN valence < 0.75 THEN 'Medium-high'
            ELSE 'High' END AS valence_band,
       COUNT(*) AS rows, ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks GROUP BY valence_band ORDER BY MIN(valence);

-- 22. Duplicate track IDs (IDs with multiple genre-labelled rows)
SELECT track_id, COUNT(*) AS rows, GROUP_CONCAT(DISTINCT genre) AS genres
FROM spotify_tracks GROUP BY track_id HAVING COUNT(*) > 1
ORDER BY rows DESC LIMIT 50;
