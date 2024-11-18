CREATE TABLE
  devices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sn TEXT NOT NULL UNIQUE
  );

CREATE TABLE
  tests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ts INTEGER NOT NULL,
    device_id INTEGER NOT NULL REFERENCES devices (id),
    result INTEGER --0 - fail, 1 - passed
  );