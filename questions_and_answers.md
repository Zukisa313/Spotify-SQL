# Questions and Answers: Spotify Features Dataset

## Dataset overview
- **Rows:** 232,725
- **Distinct track IDs:** 176,774
- **Artists:** 14,564
- **Genres:** 27
- **Missing track names in source:** 1 (the delivered database replaces this one value with `Unknown track` so it is easier to query).

**Important interpretation:** the CSV has genre-labelled rows, and some `track_id` values appear in more than one row. Therefore, row counts are not always the same as distinct track counts. Use `COUNT(DISTINCT track_id)` when you mean unique tracks.

## Q1. Which genre has the highest average popularity?
**Answer:** Pop, with average popularity **66.59/100** in this dataset. The lowest average is **Children's Music** at **4.25/100**. These are descriptive results for this dataset, not a claim that genre causes popularity.

## Q2. What audio feature is most associated with popularity?
**Answer:** Among the numeric features inspected, **loudness** has the largest positive Pearson correlation with popularity (**0.363**). The strongest negative correlation is **acousticness** (**-0.381**). Correlation is not causation, and the values may be affected by genre, artist, release date, and repeated track IDs.

## Q3. Are high-energy tracks more popular?
Using an explicitly chosen threshold of energy >= 0.7:
- **High energy (>=0.7):** 85,920 rows; mean popularity **43.67**.
- **Lower energy (<0.7):** 146,805 rows; mean popularity **39.64**.

This is a simple group comparison. It does not control for genre or artist.

## Q4. Which artists have the most rows?
The SQL query “Most represented artists” ranks artists by row count. Because one track can have multiple genre rows, interpret this as representation in the dataset rather than a definitive count of unique released songs.

## Q5. How can I compare genres?
Run:
```sql
SELECT * FROM genre_summary ORDER BY avg_popularity DESC;
```
The view reports row counts, distinct track IDs, popularity, danceability, energy, valence, acousticness, tempo, and average duration.

## Q6. Does danceability increase with energy?
Use `plot_danceability_vs_energy.png` and the numeric correlation matrix. A scatterplot shows the relationship and spread; a correlation coefficient gives a compact linear summary. Neither proves a causal relationship.

## Q7. How do popularity scores vary?
See `plot_popularity_distribution.png`, or run:
```sql
SELECT popularity, COUNT(*) AS row_count
FROM spotify_tracks GROUP BY popularity ORDER BY popularity;
```

## Q8. Can SQL calculate correlations?
SQLite does not provide a built-in Pearson correlation aggregate in a standard installation. Use `analyze.py` for the numeric correlation matrix and charts, or use a database with a suitable statistics extension.

## Suggested follow-up questions
- Which genres are most energetic or most acoustic?
- What are the most danceable genres?
- How does average popularity vary by energy band?
- Which artists have at least 10 rows and the highest average popularity?
- Are long tracks less popular on average?
- Which numeric audio features have the strongest correlations with popularity?
- Which track IDs appear in multiple genres?
- What is the distribution of tempo, loudness, or duration?

## Limitations
- This is exploratory analysis, not a recommendation model.
- Popularity is a dataset-provided score and should not be treated as a permanent or current Spotify ranking.
- Correlations can be confounded by genre and artist.
- Duplicate IDs across genre-labelled rows mean row-level analyses may give repeated tracks extra weight.
