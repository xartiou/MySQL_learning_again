-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
UPDATE users SET created_at = NOW(), updated_at = NOW();

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
ALTER TABLE users CHANGE created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users CHANGE updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
--       0, если товар закончился и выше нуля, если на складе имеются запасы. 
--       Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
--       Однако нулевые запасы должны выводиться в конце, после всех 

-- создадим таблицу

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
	id serial PRIMARY KEY,
	value INT UNSIGNED
);

SELECT * FROM storehouses_products;
-- ЗАПОЛНИМ 
INSERT INTO storehouses_products(value)
VALUES 
	(354),
	(96),
	(0),
	(183),
	(0),
	(15),
	(38),
	(0)
	;
-- сортировка
SELECT * FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;



-- Практическое задание теме «Агрегация данных»


USE example_l_2;

SELECT * FROM users;

-- 1. Подсчитайте средний возраст пользователей в таблице users.

-- вычислим возраст из дня рождения
SELECT TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS AVG_AGE FROM users;

-- Функция AVG() возвращает среднее значение аргумента.
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS AVG_AGE FROM users;

-- округлим до целого числа при помощи функции ROUND()
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())),0) AS AVG_AGE FROM users;



-- 2. Задание 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
--    * Следует учесть, что необходимы дни недели текущего года, а не года рождения.
-- DATE_FORMAT(date,format)
SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS WHAT_DAY_WEEK,
COUNT(*) AS TOTAL_DAYS FROM users GROUP BY WHAT_DAY_WEEK ORDER BY TOTAL_DAYS;


-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.

-- CREATE TABLE
DROP TABLE IF EXISTS table_task_3;
CREATE TABLE table_task_3(
	id serial PRIMARY KEY,
	value INT
);

-- ЗАПОЛНИМ 
INSERT INTO table_task_3(value) VALUES (1), (2), (3), (4), (5);


-- логарифм произведения равен сумме логарифмов
SELECT EXP(SUM(LN(value))) AS EXP_INT FROM table_task_3;




























