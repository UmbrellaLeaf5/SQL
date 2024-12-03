---- 7. Данные грязные, их надо почистить. Например, надо удалить строки с ошибками в user_id, оставить только значения вида user_N, где № - значение идентификатора.
-- LOG
-- переименование строк
UPDATE LOG
SET
  user_id = REPLACE(user_id, 'Запись пользователя № - ', ''),
  time = REPLACE(time, '[', '');

-- удаление грязи
DELETE FROM LOG
WHERE
  time IS NULL
  OR user_id IS NULL
  -- 
  OR user_id IS '#error';

-- удаление дубликатов
DELETE FROM LOG
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
-- 
-- переименование строк
UPDATE USERS
SET
  user_id = REPLACE(user_id, 'U', 'u'),
  geo = REPLACE(geo, 'Арзангелтск', 'Архангельск');

-- удаление грязи
DELETE FROM USERS
WHERE
  user_id IS 'Юзверь'
  OR mail NOT LIKE '%@%.%'
  -- 
  OR geo IS NULL
  OR mail IS NULL
  OR user_id IS NULL;

-- удаление дубликатов
DELETE FROM USERS
WHERE
  rowid NOT IN (
    SELECT
      MIN(rowid)
    FROM
      USERS
    GROUP BY
      user_id
  );