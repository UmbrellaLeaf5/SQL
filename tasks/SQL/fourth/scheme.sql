CREATE TABLE
  LOG(
    user_id TEXT REFERENCES USERS (user_id),
    time DATETIME,
    bet FLOAT,
    win FLOAT,
    PRIMARY KEY (user_id, time)
  );

CREATE TABLE
  USERS (
    user_id TEXT,
    mail TEXT,
    geo TEXT,
    PRIMARY KEY (user_id)
  );