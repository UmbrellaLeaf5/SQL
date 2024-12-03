--------- Теперь надо ответить на несколько вопросов по бизнесу:
---------
--------- a. Сколько раз человеку надо прийти, чтобы сделать ставку?
-- 4.67
WITH
  FIRST_BET AS (
    SELECT
      user_id,
      MIN(time) AS primary_bet
    FROM
      LOG
    WHERE
      bet > 0
    GROUP BY
      user_id
  ),
  VISITS AS (
    SELECT
      LOG.user_id,
      COUNT(*) AS count
    FROM
      LOG
      JOIN FIRST_BET ON LOG.user_id = FIRST_BET.user_id
    WHERE
      LOG.time < FIRST_BET.primary_bet
    GROUP BY
      LOG.user_id
  )
SELECT
  ROUND(AVG(count), 2)
FROM
  VISITS;

--------- b. Каков средний выигрыш в процентах?
-- 1289.47%
SELECT
  CAST(ROUND(AVG((win - bet) / bet) * 100, 2) AS TEXT) || '%'
FROM
  LOG;

--------- c. Каков баланс по каждому пользователю?
-- [огромный список]
SELECT
  user_id,
  COALESCE(SUM(win), 0) - COALESCE(SUM(bet), 0)
FROM
  LOG
GROUP BY
  user_id;

--------- d. Какие города самые выгодные?
-- (я понял, что это топ 5)
-- Москва
-- Воронеж
-- Казань
-- Санкт-Петербург
-- Ярославль
SELECT
  geo
FROM
  USERS
  JOIN LOG ON USERS.user_id = LOG.user_id
GROUP BY
  geo
ORDER BY
  COALESCE(SUM(win), 0) - COALESCE(SUM(bet), 0) DESC
LIMIT
  5;

--------- e. В каких городах самая высокая ставка?
-- (тут только в одном городе самая высокая)
-- Москва
SELECT
  geo
FROM
  USERS
  JOIN LOG ON USERS.user_id = LOG.user_id
GROUP BY
  geo
ORDER BY
  MAX(bet) DESC
LIMIT
  1;

--------- f. Сколько в среднем проходит от первого посещения сайта до первой попытки?
-- 48.27 days
WITH
  FIRST_BET AS (
    SELECT
      user_id,
      MIN(time) AS primary_bet
    FROM
      LOG
    WHERE
      bet > 0
    GROUP BY
      user_id
  ),
  FIRST_VISIT AS (
    SELECT
      user_id,
      MIN(time) AS primary_visit
    FROM
      LOG
    GROUP BY
      user_id
  )
SELECT
  CAST(
    ROUND(
      AVG(
        JULIANDAY(FIRST_BET.primary_bet) - JULIANDAY(FIRST_VISIT.primary_visit)
      ),
      2
    ) AS TEXT
  ) || ' days'
FROM
  FIRST_BET
  JOIN FIRST_VISIT ON FIRST_BET.user_id = FIRST_VISIT.user_id;