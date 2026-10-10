-- Run this only if creating an empty database from scratch.
-- For convenience, the delivered spotify_analytics.db is already populated.
CREATE TABLE spotify_tracks (
    genre TEXT,
    artist_name TEXT,
    track_name TEXT,
    track_id TEXT,
    popularity INTEGER,
    acousticness REAL,
    danceability REAL,
    duration_ms INTEGER,
    energy REAL,
    instrumentalness REAL,
    key TEXT,
    liveness REAL,
    loudness REAL,
    mode TEXT,
    speechiness REAL,
    tempo REAL,
    time_signature TEXT,
    valence REAL
);
CREATE INDEX idx_tracks_genre ON spotify_tracks(genre);
CREATE INDEX idx_tracks_artist ON spotify_tracks(artist_name);
CREATE INDEX idx_tracks_popularity ON spotify_tracks(popularity);
CREATE INDEX idx_tracks_track_id ON spotify_tracks(track_id);
