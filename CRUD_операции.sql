/*
 CRUD
 C - создание
 R - чтение
 U - обновление
 D - удаление
 
 INSERT - вставка данных
 	INSERT INTO catalogs VALUES(NULL, 'Процессоры');
 SELECT - извлечение данных
 UPDATE - обновление данных
 DELETE - удаление данных
 
 INSERT...SELECT - перегон данных из одной таблицы в другую
 */

INSERT INTO catalog (name_section) VALUES ('Автотовары');

INSERT INTO goods (name, description, purchasing_price, selling_prise) VALUES ('Свечи зажигания','NGK 1578', '100','350');


SELECT id, name FROM goods;

DELETE FROM catalog; -- не сбрасывает счетчики при удалении

DELETE FROM catalog WHERE id > 1 LIMIT 1; -- удалить с id > 1 в количистве 1

TRUNCATE catalog; -- сбрасывает счетчики при удалении нет условий

SELECT * from catalog;

SELECT * from goods;

TRUNCATE goods;


UPDATE 
	goods 
SET 
	name = 'Свечи зажигания(ferum)'
WHERE 
	name = 'Свечи зажигания';

-- переместить все данные из одной таблицы в другую

INSERT INTO
	cat 
SELECT
	*
FROM
	catalog;























