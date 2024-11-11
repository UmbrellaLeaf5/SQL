------------------ 1. Покажите фамилию и имя клиентов из города Прага ?
SELECT
  FirstName,
  LastName
FROM
  customers
WHERE
  City = 'Prague';

------------------ 2. Покажите фамилию и имя клиентов у которых имя начинается букву M ?
SELECT
  FirstName,
  LastName
FROM
  customers
WHERE
  FirstName LIKE 'M%';

------------------ 2. Покажите фамилию и имя клиентов у которых имя cодержит символ "ch"?
SELECT
  FirstName,
  LastName
FROM
  customers
WHERE
  FirstName LIKE '%ch%';

------------------ 3. Покажите название и размер музыкальных треков в Мегабайтах ?
SELECT
  Name,
  ROUND(CAST(Bytes AS REAL) / POWER(1024, 2), 2) AS SizeMB
FROM
  tracks;

------------------ 4. Покажите фамилию и имя сотрудников кампании нанятых в 2002 году из города Калгари ?
SELECT
  FirstName,
  LastName
FROM
  employees
WHERE
  strftime('%Y', HireDate) = '2002'
  AND City = 'Calgary';

------------------ 5. Покажите фамилию и имя сотрудников кампании нанятых в возрасте 40 лет и выше ?
SELECT
  FirstName,
  LastName
FROM
  employees
WHERE
  strftime('%Y', 'now') - strftime('%Y', BirthDate) >= 40;

------------------ 6. Покажите покупателей-американцев без факса ?
SELECT
  FirstName,
  LastName
FROM
  customers
WHERE
  Country = 'USA'
  AND Fax IS NULL;

------------------ 7. Покажите канадские города в которые сделаны продажи в августе и сентябре месяце?
SELECT DISTINCT
  ShipCity
FROM
  sales
WHERE
  strftime('%m', SalesDate) IN ('08', '09')
  AND ShipCountry = 'Canada';

------------------ 8. Покажите почтовые адреса клиентов из домена gmail.com ?
SELECT DISTINCT
  Email
FROM
  customers
WHERE
  Email LIKE '%@gmail.com';

------------------ 9. Покажите сотрудников которые работают в кампании уже 18 лет и более ?
SELECT
  FirstName,
  LastName
FROM
  employees
WHERE
  strftime('%Y', 'now') - strftime('%Y', HireDate) >= 18
  OR (
    strftime('%Y', 'now') - strftime('%Y', HireDate) = 18
    AND strftime('%m', 'now') >= strftime('%m', HireDate)
  );

------------------ 10. Покажите в алфавитном порядке все должности в кампании ?
SELECT DISTINCT
  Title
FROM
  employees
ORDER BY
  Title ASC;

------------------ 11. Покажите в алфавитном порядке Фамилию, Имя и год рождения покупателей ?
SELECT
  LastName,
  FirstName,
  strftime('%Y', 'now') - Age AS BirthYear
FROM
  customers
ORDER BY
  LastName ASC,
  FirstName ASC,
  BirthYear ASC;

------------------ 12. Сколько секунд длится самая короткая песня ?
SELECT
  ROUND(CAST(MIN(Milliseconds) AS REAL) / 1000, 2) AS DurationInSeconds
FROM
  tracks;

------------------ 13. Покажите название и длительность в секундах самой короткой песни ?
SELECT
  Name,
  ROUND(CAST(MIN(Milliseconds) AS REAL) / 1000, 2) AS DurationInSeconds
FROM
  tracks
WHERE
  Milliseconds = (
    SELECT
      MIN(Milliseconds)
    FROM
      tracks
  );

------------------ 14. Покажите средний возраст клиента для каждой страны ?
SELECT
  Country,
  ROUND(AVG(Age), 2) AS AverageAge
FROM
  customers
GROUP BY
  Country
ORDER BY
  AverageAge DESC;

------------------ 15. Покажите Фамилии работников нанятых в октябре?
SELECT
  LastName
FROM
  employees
WHERE
  strftime('%m', HireDate) = '10';

------------------ 16. Покажите фамилию самого старого по стажу сотрудника в кампании ?
SELECT
  LastName
FROM
  employees
ORDER BY
  HireDate ASC
LIMIT
  1;