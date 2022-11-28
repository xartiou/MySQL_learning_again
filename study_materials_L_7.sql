-- Урок 7 Сложные запросы

-- UNION - ОБЪЕДИНЕНИЕ
	-- UNION (+)
	-- EXCEPT (-) NO MYSQL
	-- INTERSECT (X) NO MYSQL


-- для UNION параметры результирующих таблиц должны совпадать
		-- порядок столбцов
		-- число столбцов
		-- тип
USE example_l_2;

SELECT * FROM catalogs
UNION
SELECT id, name FROM products;


CREATE TABLE rubrics (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'НАЗВАНИЕ РАЗДЕЛА'
) COMMENT 'РАЗДЕЛЫ ИНТЕРНЕТ-МАГАЗИНА';

-- СТРУКТУРЫ catalogs и rubrics полностью совпадают

INSERT INTO rubrics VALUES
	(NULL, 'Видеокарты'),
	(NULL, 'Память');
	
-- объеденим в запросе две таблицы
SELECT name FROM catalogs
UNION
SELECT name FROM rubrics;
	-- так в результат запроса попадут только уникальные результаты DISTINCT
-- избежать этого UNION ALL
SELECT name FROM catalogs
UNION ALL
SELECT name FROM rubrics;

-- SORT
SELECT name FROM catalogs
UNION ALL
SELECT name FROM rubrics
ORDER BY name;

SELECT name FROM catalogs
UNION ALL
SELECT name FROM rubrics
ORDER BY name DESC;

-- ОГРАНИЧЕНИЕ
SELECT name FROM catalogs
UNION ALL
SELECT name FROM rubrics
ORDER BY name DESC
LIMIT 2;

(SELECT name FROM catalogs
ORDER BY name DESC
LIMIT 2)
UNION ALL
(SELECT name FROM rubrics
ORDER BY name DESC
LIMIT 2);

-- т.к. объединяем результаты запросов - можем объединять одну и ту же таблицу
SELECT * FROM catalogs
UNION ALL
SELECT * FROM catalogs;

SELECT * FROM catalogs
UNION
SELECT id, name FROM products
UNION 
SELECT id, name FROM users;


-- ВЛОЖЕННЫЕ ЗАПРОСЫ <SUBQUERY>
	SELECT
		id,
		<SUBQUERY>
	FROM 
		<SUBQUERY>
	GROUP BY
		id
	HAVING
		<SUBQUERY>
		
-- ключевые слова
		-- IN
		-- ANY
		-- SOME
		-- ALL
		
SELECT * FROM catalogs;	
		
SELECT id, name, catalog_id FROM products;
		
SELECT id, name, catalog_id FROM products
WHERE catalog_id = 1;
		
SELECT id FROM catalogs WHERE name = 'Процессоры';		
		
SELECT id, name, catalog_id FROM products
WHERE catalog_id = (SELECT id FROM catalogs WHERE name = 'Процессоры');		
		
-- найдем товар с самой высокой ценой
-- 1.
SELECT MAX(price) FROM products;
-- 2.
SELECT id, name, catalog_id FROM products
WHERE price = (SELECT MAX(price) FROM products);
		
-- найдем все товары где цена ниже среднего
SELECT id, name, catalog_id FROM products
WHERE price < (SELECT AVG(price) FROM products);
		
-- для каждого товара выведем название каталога
-- 1.
SELECT id, name, catalog_id FROM products;		
-- 2.
SELECT
	id,
	name,
	(SELECT name FROM catalogs WHERE id = catalog_id) AS 'NAME CATALOG'
FROM
	products;
-- 3.
SELECT
	id,
	name,
	(SELECT name FROM catalogs WHERE catalogs.id = products.catalog_id) AS 'NAME CATALOG'
FROM
	products;

-- не корелиуемый запрос
SELECT
	products.id,
	products.name,
	(SELECT MAX(price) FROM products) AS 'MAX_PRICE'
FROM
	products;
		
-- IN
SELECT id, name, catalog_id FROM products
WHERE catalog_id IN (1, 2);

-- ANY
SELECT id, name, price, catalog_id FROM products
ORDER BY catalog_id, price;

SELECT id, name, price, catalog_id FROM products
WHERE
	catalog_id = 2 AND
	price < ANY (SELECT price FROM products WHERE catalog_id = 1);

-- SOME
SELECT id, name, price, catalog_id FROM products
WHERE
	catalog_id = 2 AND
	price < SOME (SELECT price FROM products WHERE catalog_id = 1);

-- ALL
SELECT id, name, price, catalog_id FROM products
WHERE
	catalog_id = 2 AND
	price > ALL (SELECT price FROM products WHERE catalog_id = 1);

-- результирующий запрос может быть пустым, чтобы проверить используем EXISTS, NOT EXISTS

SELECT * FROM catalogs
WHERE EXISTS (SELECT * FROM products WHERE catalog_id = catalogs.id);

SELECT * FROM catalogs
WHERE EXISTS (SELECT 169 FROM products WHERE catalog_id = catalogs.id);

SELECT * FROM catalogs
WHERE NOT EXISTS (SELECT 1 FROM products WHERE catalog_id = catalogs.id);


-- КОНСТРУКТОР СТРОКИ
SELECT id, name, price, catalog_id FROM products
WHERE (catalog_id, 5060.00) IN (SELECT id, price FROM catalogs);

SELECT id, name, price, catalog_id FROM products
WHERE ROW(catalog_id, 5060.00) IN (SELECT id, price FROM catalogs);

-- влож запрос в FROM
SELECT id, name, price, catalog_id FROM products WHERE catalog_id = 1;

SELECT 
	AVG(price)
FROM
	(SELECT * FROM products WHERE catalog_id = 1) AS PROD; -- обязательно псевдоним
	
SELECT
	AVG(price)
FROM
	products
WHERE
	catalog_id = 1;

-- ВЫЧИСЛЯЕМ МИН ЦЕНЫ
SELECT
	name,
	catalog_id, 
	MIN(price)
FROM
	products
GROUP BY catalog_id;

-- получим среднюю минимальную цену
SELECT
	AVG(price)
FROM
	(SELECT	MIN(price) AS price
	FROM products
	GROUP BY catalog_id) AS prod;	



-- JOIN - СОЕДИНЕНИЕ
-- декартово произведение
-- создадим несколько таблиц
CREATE TABLE tbl1 (value VARCHAR(255));

CREATE TABLE tbl2 (value VARCHAR(255));

-- заполним их значениями
INSERT INTO tbl1 VALUES ('FRST1'), ('FRST2'), ('FRST3');

INSERT INTO tbl2 VALUES ('SCND1'), ('SCND2'), ('SCND3');

SELECT * FROM tbl1;
SELECT * FROM tbl2;

-- объеденим вывод
SELECT * FROM tbl1, tbl2;
	-- или
SELECT * FROM tbl1 JOIN tbl2;

SELECT tbl1.value, tbl2.value FROM tbl1, tbl2;

SELECT tbl1.*, tbl2.* FROM tbl1, tbl2;

SELECT T1.value, T2.value FROM tbl1 AS T1, tbl2 AS T2;

-- фильтруем промежуточную таблицу

SELECT
	p.name, p.price, c.name
FROM 
	catalogs AS c
JOIN
	products AS p;

SELECT
	p.name, p.price, c.name
FROM 
	catalogs AS c
JOIN
	products AS p
WHERE
	c.id = p.catalog_id;

-- ON 
SELECT
	p.name, p.price, c.name
FROM 
	catalogs AS c
JOIN
	products AS p
ON
	c.id = p.catalog_id;

-- самообъединение таблиц
SELECT
	*
FROM
	catalogs AS FST
JOIN
	catalogs AS SND;

SELECT
	*
FROM
	catalogs AS FST
JOIN
	catalogs AS SND
ON
	FST.id = SND.id ;

SELECT
	*
FROM
	catalogs AS FST
JOIN
	catalogs AS SND
USING(id);

-- Типы JOIN соединений
	-- JOIN(INNERT JOIN)
	-- LEFT JOIN
	-- RIGHT JOIN
	-- OUTER JOIN -- нет в MySQL

SELECT
	p.name, p.price, c.name
FROM 
	catalogs AS c
JOIN
	products AS p
ON
	c.id = p.catalog_id;



SELECT
	p.name, p.price, c.name
FROM 
	catalogs AS c LEFT JOIN	products AS p
ON
	c.id = p.catalog_id;

SELECT
	p.name, p.price, c.name
FROM 
	products AS p RIGHT JOIN catalogs AS c
ON
	c.id = p.catalog_id;

-- снизим цену для Мат. плат
UPDATE
	catalogs AS C
JOIN
	products AS P
ON
	C.id = P.catalog_id 
SET
	price = price * 0.9
WHERE
	C.name = 'Мат. платы';
	
SELECT
	p.name, p.price, c.name
FROM 
	catalogs AS c
JOIN
	products AS p
ON
	c.id = p.catalog_id;
	
-- многотабличное удаление
	-- обязательно указывать из каких таблиц

DELETE
	C, P
FROM
	catalogs AS C 
JOIN
	products AS P
ON
	C.id = P.catalog_id
WHERE
	C.name = 'Мат. платы';

SELECT * FROM catalogs;
SELECT * FROM products;

DELETE
	P
FROM
	catalogs AS C 
JOIN
	products AS P
ON
	C.id = P.catalog_id
WHERE
	C.name = 'Процессоры';

SELECT * FROM catalogs; -- не тронули
SELECT * FROM products; -- очистили


-- ВНЕШНИЕ КЛЮЧИ FOREIGN KEY

-- ON DELETE
-- ON UPDATE
	-- CASCADE
	-- SET NULL
	-- NO ACTION
	-- RESTRICT
	-- SET DEFAULT
SHOW CREATE TABLE catalogs;
SHOW CREATE TABLE products;

ALTER TABLE products
ADD FOREIGN KEY (catalog_id)
REFERENCES catalogs(id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;  -- ОШИБКА ИЗ ЗА ТИПА

ALTER TABLE products
CHANGE catalog_id catalog_id BIGINT UNSIGNED DEFAULT NULL;


ALTER TABLE products
ADD FOREIGN KEY (catalog_id)
REFERENCES catalogs(id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- удалим ограничение для внешнего ключа
ALTER TABLE products
DROP FOREIGN KEY products_ibfk_1;


-- создадим ограничение для внешнего ключа с явным указанием имени
ALTER TABLE products
ADD 
	CONSTRAINT fk_catalog_id
	FOREIGN KEY (catalog_id)
REFERENCES catalogs(id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


-- удалим ограничение для внешнего ключа
ALTER TABLE products
DROP FOREIGN KEY fk_catalog_id;
-- создадим ограничение для внешнего ключа с CASCADE
ALTER TABLE products
ADD 
	CONSTRAINT fk_catalog_id
	FOREIGN KEY (catalog_id)
REFERENCES catalogs(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

SELECT * FROM catalogs;
SELECT * FROM products;


UPDATE catalogs SET id = 4 WHERE name = 'Процессоры';

DELETE FROM catalogs WHERE name ='Процессоры';

-- set null
ALTER TABLE products DROP FOREIGN KEY fk_catalog_id;

ALTER TABLE products
ADD 
	CONSTRAINT fk_catalog_id
	FOREIGN KEY (catalog_id)
REFERENCES catalogs(id)
ON DELETE SET NULL;

DELETE FROM catalogs WHERE name = 'Видеокарты';


SELECT * FROM catalogs;
SELECT * FROM products;














