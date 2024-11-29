------------------ 1. Посчитайте общую сумму продаж в США в 1 квартале 2012 года? Решить 2-мя способами джойнами и подзапросами.
-- Способ 1:
SELECT
  SUM(Quantity * UnitPrice)
FROM
  sales
  JOIN sales_items ON sales.SalesId = sales_items.SalesId
  JOIN customers customers ON sales.CustomerId = customers.CustomerId
WHERE
  customers.Country = 'USA'
  AND strftime('%Y', SalesDate) = '2012'
  AND strftime('%m', SalesDate) BETWEEN '01' AND '03';

-- 
-- Способ 2:
SELECT
  SUM(Quantity * UnitPrice)
FROM
  sales_items
WHERE
  sales_items.SalesId IN (
    SELECT
      SalesId
    FROM
      sales
      JOIN customers customers ON sales.CustomerId = customers.CustomerId
    WHERE
      customers.Country = 'USA'
      AND strftime('%Y', SalesDate) = '2012'
      AND strftime('%m', SalesDate) BETWEEN '01' AND '03'
  );

------------------ 2. Покажите имена клиентов, которых нет среди работников. Решить 3-мя способами: подзапросами, джойнами и логическим вычитанием.
-- Способ 1:
SELECT
  FirstName
FROM
  customers
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      employees
    WHERE
      customers.FirstName = employees.FirstName
  );

-- 
-- Способ 2:
SELECT
  customers.FirstName
FROM
  customers
  LEFT JOIN employees ON customers.FirstName = employees.FirstName
WHERE
  employees.FirstName IS NULL;

--
-- Способ 3:
SELECT
  FirstName
FROM
  customers
EXCEPT
SELECT
  FirstName
FROM
  employees;

------------------ 3. Теоретический вопрос. Вернут ли данные запросы одинаковый результат? Да или НЕТ. Объяснить почему. Какой запрос вернет больше строк?
-- Ответ: НЕТ. Запросы вернут разное количество строк.
-- 
-- Запрос 1 сначала выполняет LEFT JOIN между таблицами t1 и t2 на основе column1. LEFT JOIN включает все строки из левой таблицы (t1), даже если нет соответствия в правой таблице (t2). Затем условие WHERE фильтрует результаты, оставляя только строки, где t1.column1 равно 0.
-- Запрос 2 также выполняет LEFT JOIN, но условие t1.column1=0 является частью самого условия JOIN. Т.е. соединение происходит только для строк в t1, где column1 равно 0. Он не будет включать строки из t1, где column1 не равно 0, даже несмотря на использование LEFT JOIN.
-- 
--  Запрос 1, как правило, вернет больше строк, или, возможно, равное количество, если нет совпадений в t2. Если нет строк в t1, где column1 равно 0, оба запроса вернут ноль строк. Запрос 1 сначала соединяет все строки из t1, а затем фильтрует по t1.column1 = 0. Это потенциально приводит к включению большего количества строк из t2 на этапе LEFT JOIN, которые затем отбрасываются фильтром.
------------------ 4. Посчитайте количество треков в каждом альбоме. В результате должно быть: имя альбома и кол-во треков. Решить 2-мя способами: подзапросом и джойнами.
-- Способ 1:
SELECT
  Title,
  (
    SELECT
      COUNT(*)
    FROM
      tracks
    WHERE
      tracks.AlbumId = albums.AlbumId
  ) AS TrackCount
FROM
  albums;

-- 
-- Способ 2:
SELECT
  Title,
  COUNT(TrackId) AS TrackCount
FROM
  albums
  LEFT JOIN tracks ON albums.AlbumId = tracks.AlbumId
GROUP BY
  albums.AlbumId,
  Title;

------------------ 5. Покажите фамилию и имя покупателей немцев сделавших заказы в 2009 году, товары которых были отгружены в город Берлин.
SELECT
  FirstName,
  LastName
FROM
  customers
  JOIN sales ON customers.CustomerId = sales.CustomerId
WHERE
  Country = 'Germany'
  AND strftime('%Y', SalesDate) = '2009'
  AND ShipCity = 'Berlin';

------------------ 6. Покажите фамилии клиентов которые купили больше 30 музыкальных треков. Решить задачу 2-мя способами: джойнами и подзапросами.
-- Способ 1:
SELECT
  LastName
FROM
  customers
  JOIN sales ON customers.CustomerId = sales.CustomerId
  JOIN sales_items ON sales.SalesId = sales_items.SalesId
GROUP BY
  customers.CustomerId
HAVING
  SUM(sales_items.Quantity) > 30;

-- 
-- Способ 2:
SELECT
  LastName
FROM
  customers
WHERE
  CustomerId IN (
    SELECT
      CustomerId
    FROM
      sales
      JOIN sales_items ON sales.SalesId = sales_items.SalesId
    GROUP BY
      sales.CustomerId
    HAVING
      SUM(sales_items.Quantity) > 30
  );

------------------ 7. В базе есть таблица музыкальных треков и жанров. Какова средняя стоимость музыкального трека в каждом жанре?
SELECT
  Name,
  (
    SELECT
      ROUND(AVG(UnitPrice), 2)
    FROM
      tracks
    WHERE
      tracks.GenreId = genres.GenreId
  )
FROM
  genres;

------------------ 8. В базе есть таблица музыкальных треков и жанров. Покажите жанры, у которых средняя стоимость одного трека больше одного.
SELECT
  Name
FROM
  genres
WHERE
  GenreId IN (
    SELECT
      GenreId
    FROM
      tracks
    GROUP BY
      GenreId
    HAVING
      AVG(UnitPrice) > 1
  );

------------------ 8. В базе есть таблица музыкальных треков и жанров. Покажите жанры, у которых средняя стоимость одного трека больше первого (по id).
SELECT
  genres.Name
FROM
  genres
  JOIN tracks ON genres.GenreId = tracks.GenreId
GROUP BY
  genres.GenreId,
  genres.Name
HAVING
  AVG(tracks.UnitPrice) > (
    SELECT
      UnitPrice
    FROM
      tracks
    WHERE
      TrackId = 1
  );