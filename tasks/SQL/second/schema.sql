CREATE TABLE
  movies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NO NULL UNIQUE,
    genre TEXT NO NULL
  );

CREATE TABLE
  ratings (
    id_user INTEGER,
    id_movie INTEGER REFERENCES movies (id),
    rating INTEGER NOT NULL,
    timestamp DATE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_user, id_movie)
  );