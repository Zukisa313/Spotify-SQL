# Spotify Features SQL Analytics Project

An end-to-end SQL project using the supplied `SpotifyFeatures.csv` dataset.

## Included files
- `spotify_analytics.db` — ready-to-query SQLite database with 232,725 rows.
- `queries.sql` — 22 practical SQL analysis queries.
- `schema.sql` — table and index definitions for recreating the structure.
- `questions_and_answers.md` — dataset overview, example answers, interpretation notes, and further questions.
- `analyze.py` — Python script to print summary statistics and recreate plots.
- `plot_*.png` — five exploratory charts.
- `SpotifyFeatures.csv` — source data used for the project.

## Quick start
1. Open `spotify_analytics.db` in **DB Browser for SQLite**, DBeaver, SQLiteStudio, or another SQLite client.
2. Run queries from `queries.sql`.
3. For example:
   ```sql
   SELECT * FROM genre_summary ORDER BY avg_popularity DESC;
   ```
4. To regenerate plots (Python 3 required):
   ```bash
   pip install pandas matplotlib
   python analyze.py
   ```

## Example questions this project can answer
- Which genres have the highest average popularity?
- Which audio features correlate most with popularity?
- Are high-energy tracks more popular on average?
- Which artists are most represented in the dataset?
- How do danceability, energy, acousticness, valence, tempo, and duration vary by genre?
- Which tracks have long durations or high instrumentalness/speechiness?
- How many track IDs occur under multiple genres?

## Data notes
The source CSV contains 232,725 rows, 176,774 distinct track IDs, 14,564 artists, and 27 genres. There is one missing track name in the source; in the delivered database it is replaced with `Unknown track`. Some track IDs appear in multiple genre-labelled rows, so distinguish row counts from unique track counts.

## Methodology and limitations
This is exploratory analytics. Popularity is the score recorded in the supplied dataset and may not reflect current Spotify popularity. Correlations do not imply causation. Group comparisons are not causal estimates and do not control for artist or genre. SQLite does not include a built-in Pearson correlation function in its standard configuration, so `analyze.py` calculates correlations in Python.
