"""Recreate charts and print useful data answers from spotify_analytics.db."""
import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DB = ROOT / "spotify_analytics.db"
OUT = ROOT

with sqlite3.connect(DB) as con:
    df = pd.read_sql_query("SELECT * FROM spotify_tracks", con)

print("Rows:", len(df))
print("Unique track IDs:", df["track_id"].nunique())
print("Artists:", df["artist_name"].nunique())
print("Genres:", df["genre"].nunique())
print("\nTop genres by mean popularity:")
print(df.groupby("genre")["popularity"].mean().sort_values(ascending=False).head(10).round(2))
print("\nNumeric feature correlations with popularity:")
numeric = df.select_dtypes(include="number")
print(numeric.corr(numeric_only=True)["popularity"].drop("popularity").sort_values(ascending=False).round(3))

plots = [
    ("plot_popularity_by_genre.png", "barh",
     df.groupby("genre")["popularity"].mean().sort_values(),
     "Average Spotify Track Popularity by Genre", "Average popularity (0–100)", "Genre"),
]
for filename, kind, series, title, xlabel, ylabel in plots:
    plt.figure(figsize=(11, 6))
    series.plot(kind=kind)
    plt.title(title); plt.xlabel(xlabel); plt.ylabel(ylabel); plt.tight_layout()
    plt.savefig(OUT / filename, dpi=160); plt.close()

plt.figure(figsize=(9, 6))
plt.scatter(df["danceability"], df["energy"], alpha=0.12, s=8)
plt.title("Danceability vs Energy"); plt.xlabel("Danceability"); plt.ylabel("Energy")
plt.tight_layout(); plt.savefig(OUT / "plot_danceability_vs_energy.png", dpi=160); plt.close()

plt.figure(figsize=(9, 6))
plt.scatter(df["energy"], df["popularity"], alpha=0.12, s=8)
plt.title("Energy vs Popularity"); plt.xlabel("Energy"); plt.ylabel("Popularity")
plt.tight_layout(); plt.savefig(OUT / "plot_energy_vs_popularity.png", dpi=160); plt.close()

plt.figure(figsize=(9, 6))
df["popularity"].plot(kind="hist", bins=30)
plt.title("Distribution of Track Popularity"); plt.xlabel("Popularity"); plt.ylabel("Number of rows")
plt.tight_layout(); plt.savefig(OUT / "plot_popularity_distribution.png", dpi=160); plt.close()

corr = numeric.corr(numeric_only=True)
plt.figure(figsize=(10, 8))
plt.imshow(corr, aspect="auto")
plt.xticks(range(len(corr.columns)), corr.columns, rotation=70, ha="right")
plt.yticks(range(len(corr.columns)), corr.columns)
plt.colorbar(label="Pearson correlation")
plt.title("Correlation Matrix of Numeric Spotify Features")
plt.tight_layout(); plt.savefig(OUT / "plot_feature_correlations.png", dpi=160); plt.close()
print("\nCharts saved in", OUT)
