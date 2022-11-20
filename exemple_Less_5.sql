-- Less 5 . 
-- Операторы


-- Арифметические операторы

SELECT 3 + 5;

SELECT 3 + 5 AS sum;  -- даем название столбцу

USE example_L_2;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

INSERT catalogs (name) 
VALUES
('Процессоры'),
('Мат. платы'),
('Видеокарты');

SELECT * FROM catalogs;

UPDATE catalogs SET id = id + 10;

SELECT * FROM catalogs;


SELECT 3 + NULL; -- NULL


SELECT '3' + '5'; -- 8 число а не строка

SELECT 'abc' + 'def'; -- 0 так как строки не определены к преведению числа

SELECT  2 * 3; -- главное не выйти за границы типа BIGINT


-- деление может быть как обычное "/" так и целочисленное при помощи DIV
SELECT 5 / 2, 5 DIV 2;

SELECT 5 % 2, 5 MOD 2; -- ОСТАТОК ОТ ДЕЛЕНИЯ


SELECT TRUE, FALSE;  -- ДЛЯ ОБОЗНАЧЕНИЯ ЧИСЕЛ 1 И 0



-- ОПЕРАТОРЫ СРАВНЕНИЯ

/*
 * >
 * >=
 * <
 * <=
 * =
 * !=, <>
 * <=> -- БЕЗОПАСНОЕ СРАВНЕНИЕ С NULL
 * 
 */

SELECT 2 > 3; -- 0
SELECT 3 > 1; -- 1
SELECT 2 != 3, 2 <> 3;
SELECT NOT TRUE, NOT FALSE;
SELECT ! TRUE, ! FALSE;

SELECT 2 = NULL; -- NULL
SELECT 2 <=> NULL; -- 0
SELECT 2 IS NULL, 2 IS NOT NULL; -- 0, 1

INSERT INTO catalogs VALUES();
INSERT INTO catalogs VALUES(NULL, 'СЕТЕВАЯ КАРТА');

SELECT * FROM catalogs;

SELECT * FROM catalogs WHERE name IS NOT NULL;

-- ЛОГИЧЕСКОЕ "И" ЛОГИЧЕСКОЕ "ИЛИ"
SELECT TRUE AND TRUE, TRUE AND FALSE, FALSE AND FALSE;

SELECT TRUE OR TRUE, FALSE OR TRUE, FALSE OR FALSE;


CREATE TABLE tbl (
	x INT,
	y INT,
	`sum` INT AS (x + y)  -- STORED - сохраняет на жесткий диск и дает возможность индексировать
);


INSERT INTO tbl(x, y) VALUES (1, 1), (5, 6), (11, 12);

SELECT * FROM tbl;


-- Ограниченная выборка оператора SELECT
-- WHERE
SELECT * FROM catalogs;
SELECT * FROM catalogs WHERE id > 3;
SELECT * FROM catalogs WHERE id > 2 AND id <= 4;

-- BETWEEN - диапазон 

SELECT 2 BETWEEN 2 AND 4; -- TRUE
SELECT 20 BETWEEN 2 AND 4;  -- FALSE

SELECT * FROM catalogs WHERE id BETWEEN 3 AND 4;

SELECT * FROM catalogs WHERE id NOT BETWEEN 3 AND 4;


-- IN - РАБОТА СОС СПИСКОМ ЗНАЧЕНИЙ

SELECT * FROM catalogs;

SELECT * FROM catalogs WHERE id IN (1, 2, 5);

SELECT 2 IN (2, 0, 5);  -- TRUE
SELECT 20 IN (2, 0, 5);  -- FALSE
SELECT 20 IN (2, NULL, 5);  -- NULL


SELECT * FROM catalogs WHERE id NOT IN (1, 2, 5);


-- LIKE - РАВЕНСТВО
SELECT * FROM catalogs WHERE name = 'Видеокарты';

SELECT * FROM catalogs WHERE name LIKE 'Видеокарты';

-- % 
-- _ 
SELECT 'Видеокарты' LIKE 'Видеок%', 'Видеокасета' LIKE 'Видеок%';

SELECT * FROM catalogs WHERE name LIKE 'Видеок%';


SELECT 'cat' LIKE 'c_t', 'spark' LIKE '_____';


SELECT * FROM catalogs WHERE name NOT LIKE '%ы';



-- заполним таблицу users;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Название раздела',
gender char(1) DEFAULT NULL COMMENT 'пол',
hometown varchar(100) DEFAULT NULL COMMENT 'город пользователя',
birthday_at date DEFAULT NULL COMMENT 'дата рождения',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
SELECT * FROM users;

TRUNCATE users;

INSERT INTO users (name, gender, hometown, birthday_at)
VALUES
	('Геннадий', 'М', 'Сочи', '1990-10-05'),
	('Наталья', 'Ж', 'Новгород', '1984-11-12'),
	('Александр', 'М', 'Киев', '1985-05-20'),
	('Сергей', 'М', 'Казань', '1988-02-14'),
	('Иван', 'М', 'Москва', '1998-01-12'),
	('Мария', 'Ж', 'Краснодар', '1992-08-29');


-- извлечем пользователей с ДР 1990-2000
SELECT * FROM users WHERE birthday_at >= '1990-01-01' AND birthday_at < '2000-01-01';
-- ИЛИ
SELECT * FROM users WHERE birthday_at BETWEEN '1990-01-01' AND '2000-01-01';

-- ПРИ ИСПОЛЬЗОВАНИИ LIKE ДАТА ПРИВОДИТСЯ К СТРОКЕ
SELECT * FROM users WHERE birthday_at LIKE '199%';

-- RLIKE ИЛИ REGEXP - ПОИСК С РЕГУЛЯРКАМИ
SELECT 'грамм' RLIKE 'грам', 'граммпластинка' RLIKE 'грам';


SELECT 'программирование' RLIKE '^грам', 'граммпластинка' RLIKE '^грам';

SELECT 'граммпластинка' RLIKE '^граммпластинка$';

SELECT 'abc' RLIKE 'abc|абв', 'абв' RLIKE 'abc|абв';


SELECT 'a' RLIKE '[abc]' AS a,
	'b' RLIKE '[abc]' AS b,
	'w' RLIKE '[abc]' AS w;

-- ВСЕ БУКВЫ РУССКОГО АЛФАВИТА
SELECT 'г' RLIKE '[а-яё]';


SELECT 7 RLIKE '[0123456789]', 7 RLIKE '[0-9]';

SELECT 7 RLIKE '[[:digit:]]', 'hello' RLIKE '[[:alpha:]]';


-- Квантификаторы
-- ?
-- *
-- +

SELECT 
	    '1' RLIKE '^[0-9]+$' AS '1',
	'34234' RLIKE '^[0-9]+$' AS '34234',
	'342.34'RLIKE '^[0-9]+$' AS '342.34',
	     '' RLIKE '^[0-9]+$' AS '';


SELECT '342.34' RLIKE '^[0-9]*\\.[0-9]{2}$' AS '342.34';



-- СОРТИРОВКА
USE example_L_2;

SELECT * FROM catalogs;


UPDATE catalogs
SET 
	name = 'Материнская плата'
WHERE
	id = 2;


-- ORDER BY

SELECT * FROM catalogs ORDER BY name;  -- сортируем имена по алфавиту

SELECT * FROM catalogs ORDER BY name DESC;  -- обратный порядок

-- изменим и дополним таблицы
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название раздела',
	UNIQUE unique_name(name(10))
) COMMENT = 'Разделы магазина';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название',
	description TEXT COMMENT 'Описание',
	price DECIMAL (11,2) COMMENT 'Цена',
	catalog_id INT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	KEY index_of_catalog_id(catalog_id)
) COMMENT = 'Товарные позиции';


INSERT INTO products
	(name, description, price, catalog_id)
VALUES
	('Intel Core i3-8100', 'Процессор для настольных персональных компьютеровб основанных на платформе Intel.', 7890.00, 1),
	('Intel Core i5-7400', 'Процессор для настольных персональных компьютеровб основанных на платформе Intel.', 12700.00, 1),
	('AMD FX-8320E', 'Процессор для настольных персональных компьютеровб основанных на платформе AMD.', 4780.00, 1),
	('AMD FX-8320', 'Процессор для настольных персональных компьютеровб основанных на платформе Intel.', 7120.00, 1),
	('ASUS ROG MAXIMUS X HERO', 'Материнска плата ASUS ROG MAXIMUS X HERO, 2370, Socket 1151-V2, DDR4, ATX.', 19310.00, 2),
	('Gigabyte H310M S2H', 'Материнска плата Gigabyte H310M S2H, H310M, Socket 1151-V2, DDR4, mATX.', 4790.00, 2),
	('MSI 8250M GAMING PRO', 'Материнска плата MSI 8250M GAMING PRO, 8250, Socket 1151-V2, DDR4, mATX.', 5060.00, 2);
	
SELECT * FROM products;	
	
SELECT id, catalog_id, price, name FROM products;	
	
SELECT id, catalog_id, price, name FROM products ORDER BY catalog_id, price;
SELECT id, catalog_id, price, name FROM products ORDER BY catalog_id, price DESC;
SELECT id, catalog_id, price, name FROM products ORDER BY catalog_id DESC, price DESC;

SELECT id, catalog_id, price, name FROM products LIMIT 2;

SELECT id, catalog_id, price, name FROM products LIMIT 2, 2;

SELECT id, catalog_id, price, name FROM products LIMIT 4, 2;
-- или OFFSET
SELECT id, catalog_id, price, name FROM products LIMIT 2 OFFSET 4;

SELECT catalog_id FROM products ORDER BY catalog_id;
SELECT DISTINCT catalog_id FROM products ORDER BY catalog_id; -- вывод без повторений


-- уменьшим цены у id = 2 на 10% где цена больше 5000
SELECT id, catalog_id, price, name FROM products WHERE catalog_id = 2 AND price > 5000;
UPDATE products SET price = price * 0.9 WHERE catalog_id = 2 AND price > 5000;
SELECT id, catalog_id, price, name FROM products;

-- удаляем дорогие
SELECT id, catalog_id, price, name FROM products ORDER BY price DESC LIMIT 2;
DELETE FROM products ORDER BY price DESC LIMIT 2;
SELECT id, catalog_id, price, name FROM products;


-- Предопределенные функции

-- вызов функции
SELECT DATE ('2022-11-11 20:55:00');
SELECT NOW();

DESCRIBE products;
SELECT * FROM products;

INSERT INTO products VALUES (NULL, 'FRX', 'Неизвестный китайский процессор', 1000, 1, NOW(), NOW());
SELECT name, created_at, updated_at FROM products WHERE name = 'FRX';
SELECT name, DATE(created_at), DATE(updated_at) FROM products WHERE name = 'FRX';

SELECT
	id,
	name,
	DATE(created_at) created_at,
	DATE(updated_at) updated_at
FROM 
	products;


-- Форматирование календарных типов
SELECT DATE_FORMAT('2022-11-11 05:05:00', 'Сегодня %Y год');
SELECT DATE_FORMAT(NOW(), 'Сегодня %Y год') as data;

DESCRIBE users;
SELECT name, DATE_FORMAT(birthday_at, '%d.%m.%Y') AS birthday_at FROM users;


-- UNIXSTAMP формат сколько сек прошло с 01-01-1970
-- DATETIME ==> UNIXSTAMP
SELECT UNIX_TIMESTAMP(NOW()) AS TIMESTAMP;

-- UNIXSTAMP ==> DATETIME
SELECT FROM_UNIXTIME(1668191392) AS DATETIME;



-- вычисляем возраст - преобразовываем ДР и NOW
SELECT 
	name, 
	(TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25 AS AGE 
FROM 
	users;

SELECT 
	name, 
	FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25) AS AGE 
FROM 
	users;

SELECT 
	name,
	TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age 
FROM 
	users;

-- вывести записи в случайном порядке
SELECT * FROM users ORDER BY RAND();

SELECT * FROM users ORDER BY RAND() LIMIT 1;

-- VERSION MySQL
SELECT VERSION();

-- узнать id только что добавленого
SELECT LAST_INSERT_ID();



USE example_L_2;
SELECT * FROM catalogs;
SELECT * FROM products;

-- инфо функции
SELECT DATABASE();
SELECT USER();


-- математические функции

-- получение случайных чисел
SELECT RAND();


-- вычисление квадратного корня

CREATE TABLE distances(
	id SERIAL PRIMARY KEY,
	x1 INT NOT NULL,
	x2 INT NOT NULL,
	y1 INT NOT NULL,
	y2 INT NOT NULL,
	distance DOUBLE AS (SQRT(POW(x1 - x2, 2) + POW(y1 - y2, 2)))
) COMMENT = 'РАССТОЯНИЕ МЕЖДУ ДЫУМЯ ТОЧКАМИ';

INSERT INTO distances
	(x1, y1 , x2, y2)
VALUES
	(1, 1, 4, 5),
	(4, -1, 3, 2),
	(-2, 5, 1, 3);

SELECT * FROM distances;

-- вариант с JSON
DROP TABLE IF EXISTS distances;

CREATE TABLE distances (
	id SERIAL PRIMARY KEY,
	a JSON NOT NULL,
	b JSON NOT NULL,
	distanse DOUBLE AS (SQRT(POW(a->>'$.x' - b->>'$.x', 2) + POW(a->>'$.y' - b->>'$.y', 2)))
) COMMENT = 'РАССТОЯНИЕ МЕЖДУ ДВУМЯ ТОЧКАМИ';

INSERT INTO distances
	(a, b)
VALUES
	('{"x": 1, "y": 1}', '{"x": 4, "y": 5}'),
	('{"x": 4, "y": -1}', '{"x": 3, "y": 2}'),
	('{"x": -2, "y": 5}', '{"x": 1, "y": 3}');

SELECT * FROM distances;



-- вычисление площади треугольника S = a * b * syn(angle) / 2
DROP TABLE IF EXISTS triangles;
CREATE TABLE triangles (
	id SERIAL PRIMARY KEY,
	a DOUBLE NOT NULL COMMENT 'СТОРОНА ТРЕУГОЛЬНИКА',
	b DOUBLE NOT NULL COMMENT 'СТОРОНА ТРЕУГОЛЬНИКА',
	angle INT NOT NULL COMMENT 'УГОЛ ТРЕУГОЛЬНИКА В ГРАДУСАХ',
	square DOUBLE AS (a * b * SIN(RADIANS(angle)) / 2.0)
) COMMENT 'ПЛОЩАДЬ ТРЕУГОЛЬНИКА';

INSERT INTO
	triangles (a, b, angle)
VALUES
	(1.414, 1, 45),
	(2.707, 2.104, 60),
	(2.088, 2.112, 56),
	(5.014, 2.304, 23),
	(3.482, 4.708, 38);


SELECT * FROM triangles;

-- ROUND к целому цислу
SELECT ROUND(2.4), ROUND(2.5), ROUND(3.6);

-- CEILING в большую сторону
SELECT CEILING(-2.9), CEILING(-2.1), CEILING(2.1), CEILING(2.9);

-- FLO0R в меньшую сторону
SELECT FLOOR(-2.9), FLOOR(-2.1), FLOOR(2.1), FLOOR(2.9);


-- т.к. вычисление с множеством знаков после запятой вставим округление
ALTER TABLE triangles CHANGE square square DOUBLE AS (ROUND(a * b * SIN(RADIANS(angle)) / 2.0, 2));

SELECT * FROM triangles;

-- СТРОКИ
SELECT id, name FROM users;

-- выбираем из строки первые символы SUBSTRING
SELECT id, SUBSTRING(name, 1, 5) AS name FROM users;


-- объединение строк CONCAT
SELECT id, CONCAT(name, ' ', TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS name FROM users;

-- логические функции
SELECT IF(TRUE, 'истина', 'ложь'), IF(FALSE, 'истина', 'ложь');

SELECT name, IF(
	TIMESTAMPDIFF(YEAR, birthday_at, NOW()) >= 33,
	'взрослый',
	'невзрослый'
) AS status FROM users;


-- проверка нескольких условий
CREATE TABLE rainbow (
	id SERIAL PRIMARY KEY,
	color VARCHAR(255)
) COMMENT = 'ЦВЕТА РАДУГИ';

INSERT INTO rainbow (color) VALUES
	('RED'),
	('ORANGE'),
	('YELLOW'),
	('GREEN'),
	('BLUE'),
	('INDIGO'),
	('VIOLET');

SELECT * FROM rainbow;

-- изменяем при выводе англ. названия на русские 
SELECT CASE
		WHEN color = 'RED' THEN 'КРАСНЫЙ'
		WHEN color = 'ORANGE' THEN 'ОРАНЖЕВЫЙ'
		WHEN color = 'YELLOW' THEN 'ЖЕЛТЫЙ'
		WHEN color = 'GREEN' THEN 'ЗЕЛЁНЫЙ'
		WHEN color = 'BLUE' THEN 'ГОЛУБОЙ'
		WHEN color = 'INDIGO' THEN 'СИНИЙ'
		ELSE 'ФИОЛЕТОВЫЙ'
END AS russian FROM rainbow;



-- INET_ATON IP-адрес представляем в виде целого числа
SELECT INET_ATON('62.145.69.10'), INET_ATON('127.0.0.1');

-- INET_NTOA ЦЕЛОЕ ЧИСЛО В IP-ADRES

SELECT INET_NTOA('1049707786'), INET_NTOA('2130706433');


-- UUID() возвращает универсальный уникальный идентификатор
SELECT UUID();


-- ГРУППИРОВКА ДАННЫХ
USE example_L_2; 

SELECT catalog_id FROM products; -- все значения
SELECT DISTINCT catalog_id FROM products; -- уникальные значения

SELECT id, name, id % 3 FROM products ORDER BY id % 3; -- сортируем по заданию

-- уникальные можем получить путём группировки
SELECT catalog_id FROM products GROUP BY catalog_id;

-- -------
SELECT id, name, birthday_at FROM users;
-- разобьём пользователей по годам рождения 80-е и 90-е
-- выберем первые три цифры года
SELECT id, name, SUBSTRING(birthday_at, 1, 3) FROM users; 
-- назначим этому полю псевдоним
SELECT id, name, SUBSTRING(birthday_at, 1, 3) AS decade FROM users;
-- отортируем таблицу по декадам
SELECT id, name, SUBSTRING(birthday_at, 1, 3) AS decade FROM users ORDER BY decade;
-- выведем уникальные декады
SELECT SUBSTRING(birthday_at, 1, 3) AS decade FROM users GROUP BY decade;
-- подсчитаем пользователей в декадах 
SELECT COUNT(*), SUBSTRING(birthday_at, 1, 3) AS decade FROM users GROUP BY decade;
-- отсортируем посчитаные по декадам
SELECT
	COUNT(*),
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
	users
GROUP BY
	decade
ORDER BY 
	decade DESC;
-- отсортируем по подсчетам назначив полю имя
SELECT
	COUNT(*) AS total,
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
	users
GROUP BY
	decade
ORDER BY
	total DESC;

-- если на используем группировку значений вся таблица это одна группа
SELECT COUNT(*) FROM users;

-- задачи группировки
-- GROUP_CONCAT содержимое группы
SELECT
	GROUP_CONCAT(name),
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
    users
GROUP BY
	decade;
-- зададим разделитель пробел при помощи SEPARATOR
SELECT
	GROUP_CONCAT(name SEPARATOR ' '),
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
    users
GROUP BY
	decade;
-- отсортируем имена 
SELECT
	GROUP_CONCAT(name ORDER BY name SEPARATOR ' '),
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
	users
GROUP BY
	decade;
-- отсортируем имена в обратном DESC
SELECT
	GROUP_CONCAT(name ORDER BY name DESC SEPARATOR ' '),
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
	users
GROUP BY
	decade;

-- АГРЕГАЦИОННЫЕ ФУНКЦИИ

SELECT COUNT(id) FROM catalogs;

-- целая таблица
SELECT catalog_id FROM products;

-- разобъем на две группы
SELECT catalog_id FROM products GROUP BY catalog_id;

-- вернем результаты для каждой группы
SELECT catalog_id, COUNT(*) AS total FROM products GROUP BY catalog_id;


-- реакция агрегационных функций на NULL
-- создадим таблицу sampl_tbl
CREATE TABLE sampl_tbl (
	id INT NOT NULL,
	value INT DEFAULT NULL
);
-- заполним sampl_tbl
INSERT INTO sampl_tbl(id, value)
	VALUES (1, 230),
		(2, NULL),
		(3, 405),
		(4, NULL);
SELECT * FROM sampl_tbl;

-- ПРИМЕНИМ COUNT К ОБОИМ СТОЛБЦАМ
SELECT COUNT(id), COUNT(value) FROM sampl_tbl; -- COUNT ignore NULL


SELECT id, catalog_id FROM products;

SELECT
	COUNT(id) AS total_ids,
	COUNT(catalog_id) AS total_catalog_ids
FROM
	products;

-- with DISTINCT only unique
SELECT
	COUNT(DISTINCT id) AS total_ids,
	COUNT(DISTINCT catalog_id) AS total_catalog_ids
FROM
	products;


-- functions MIN & MAX
SELECT
	MIN(price) AS min,
	MAX(price) AS max
FROM
	products;

SELECT
	catalog_id,
	MIN(price) AS min,
	MAX(price) AS max
FROM
	products
GROUP BY
	catalog_id;


SELECT id, name, price FROM products ORDER BY price DESC LIMIT 1; -- MAX price

-- function  AVG
SELECT AVG(price) FROM products;
SELECT ROUND(AVG(price), 2) FROM products;

SELECT
	catalog_id,
	ROUND(AVG(price), 2) AS price
FROM
	products
GROUP BY
	catalog_id;

-- увеличим цены внутри функции

SELECT
	catalog_id,
	ROUND(AVG(price * 1.2), 2) AS price
FROM
	products
GROUP BY
	catalog_id;

-- function SUM
SELECT SUM(price) FROM products;  -- не считает NULL

SELECT
	catalog_id,
	SUM(price)
FROM
	products
GROUP BY
	catalog_id;

-- SPECIAL POSSIBILITIES GROUP BY
SELECT
	GROUP_CONCAT(name SEPARATOR ', '),
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
	users
GROUP BY
	decade;

SELECT
	COUNT(*) AS total,
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
	users
GROUP BY
	decade;

SELECT
	COUNT(*) AS total,
	SUBSTRING(birthday_at, 1, 3) AS decade
FROM
	users
GROUP BY
	decade
HAVING
	total >= 2;


SELECT * FROM users
HAVING
	birthday_at >= '1990-01-01';



-- GROUP BY помогает добиться уникальности

TRUNCATE products;

SELECT * FROM products;

INSERT INTO products
	(name, description, price, catalog_id)
VALUES
	('Intel Core i3-8100', 'Процессор Intel', 7890.00, 1),
	('Intel Core i5-7400', 'Процессор Intel', 12700.00, 1),
	('AMD FX-8320E', 'Процессор AMD', 4780.00, 1),
	('AMD FX-8320', 'Процессор AMD', 7120.00, 1),
	('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
	('Gigabite H310M S2H', 'H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
	('MSI B250M GAMING PRO', 'B250, Socket 1151-V2, DDR4, mATX', 5060.00, 2);

INSERT INTO products
	(name, description, price, catalog_id)
VALUES
	('Intel Core i3-8100', 'Процессор Intel', 7890.00, 1),
	('Intel Core i5-7400', 'Процессор Intel', 12700.00, 1),
	('AMD FX-8320E', 'Процессор AMD', 4780.00, 1),
	('AMD FX-8320', 'Процессор AMD', 7120.00, 1),
	('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
	('Gigabite H310M S2H', 'H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
	('MSI B250M GAMING PRO', 'B250, Socket 1151-V2, DDR4, mATX', 5060.00, 2);

SELECT
	id, name, catalog_id
FROM
	products;

SELECT
	name, description, price, catalog_id
FROM
	products
GROUP BY
	name, description, price, catalog_id;



-- СОЗДАДИМ ДУБЛЬ ТАБЛ products
CREATE TABLE products_dubl (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'НАЗВАНИЕ',
	description TEXT COMMENT 'ОПИСАНИЕ',
	price DECIMAL(11, 2) COMMENT 'ЦЕНА',
	catalog_id INT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	KEY index_of_catallog_id(catalog_id)
) COMMENT 'ТОВАРНЫЕ ПОЗИЦИИ';


-- вставим в таблицу products_dubl только уникальные значения из products

INSERT INTO
	products_dubl
SELECT
	NULL, name, description, price, catalog_id, NOW(), NOW()
FROM
	products
GROUP BY
	name, description, price, catalog_id;


SELECT id, name, description, catalog_id FROM products_dubl;

SHOW TABLES;

DROP TABLE products;


SHOW TABLES;

ALTER TABLE products_dubl RENAME products;

SHOW TABLES;

SELECT id, name, catalog_id FROM products;


-- вычисляемые значения для групировки
SELECT name, birthday_at FROM users;

INSERT INTO users (name, birthday_at) VALUES
	('Светлана', '1988-02-04'),
	('Олег', '1998-03-20'),
	('Юлия', '1992-07-15');

SELECT name, birthday_at FROM users ORDER BY birthday_at;

SELECT YEAR(birthday_at) FROM users ORDER BY birthday_at;

SELECT 
	YEAR(birthday_at) AS birthday_YEAR
FROM
	users
GROUP BY
	birthday_YEAR
ORDER BY 
	birthday_YEAR;

SELECT 
	MAX(name),
	YEAR(birthday_at) AS birthday_YEAR
FROM
	users
GROUP BY
	birthday_YEAR
ORDER BY 
	birthday_YEAR;

SELECT
	ANY_VALUE(name),
	YEAR(birthday_at) AS birthday_YEAR
FROM
	users
GROUP BY
	birthday_YEAR
ORDER BY 
	birthday_YEAR;


SELECT
	SUBSTRING(birthday_at, 1, 3) AS decade,
	COUNT(*)
FROM
	users
GROUP BY
	decade;


SELECT
	SUBSTRING(birthday_at, 1, 3) AS decade,
	COUNT(*)
FROM
	users
GROUP BY
	decade
WITH ROLLUP;






















