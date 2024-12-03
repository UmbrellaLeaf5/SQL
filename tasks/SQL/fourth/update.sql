-- LOG
UPDATE LOG
SET
  user_id = REPLACE(user_id, 'Запись пользователя № - ', ''),
  time = REPLACE(time, '[', '');

DELETE FROM LOG
WHERE
  time IS NULL
  OR user_id IS NULL
  OR user_id IS '#error';

DELETE FROM LOG -- удаление дубликатов
WHERE
  rowid NOT IN (
    SELECT
      MIN(rowid)
    FROM
      LOG
    GROUP BY
      user_id,
      time
  );

-- 
-- USERS
UPDATE USERS
SET
  user_id = REPLACE(user_id, 'U', 'u'),
  geo = REPLACE(geo, 'Арзангелтск', 'Архангельск');

DELETE FROM USERS
WHERE
  user_id IS 'Юзверь'
  OR mail NOT LIKE '%@%.%'
  OR geo IS NULL
  OR mail IS NULL
  OR user_id IS NULL;

DELETE FROM USERS -- удаление дубликатов
WHERE
  rowid NOT IN (
    SELECT
      MIN(rowid)
    FROM
      USERS
    GROUP BY
      user_id
  );