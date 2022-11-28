-- Тема “Сложные запросы”

-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
USE example_l_2;
-- создадим таблицу покупателей shop_users
DROP TABLE IF EXISTS `shop_users`;
CREATE TABLE `shop_users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT 'Имя покупателя',
  `surname` varchar(255) DEFAULT NULL COMMENT 'Фамилия покупателя',
  `gender` char(1) DEFAULT NULL COMMENT 'пол',
  `birthday_at` DATE COMMENT 'Дата рождения',
  `hometown` varchar(100) DEFAULT NULL COMMENT 'город пользователя',
  `email` varchar(120) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id` (`id`)
)COMMENT = 'Покупатели';

-- создадим таблицу заказов
DROP TABLE IF EXISTS orders;
CREATE TABLE `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `shop_user_id` bigint unsigned NOT NULL,
  `status` enum('inbasket','paid','sent','delivered') DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'СОЗДАН',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `inbasket_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'В корзине',
  `paid_at` datetime DEFAULT NULL COMMENT 'Оплачен',
  `sent_at` datetime DEFAULT NULL COMMENT 'Отправлен',
  `delivered_at` datetime DEFAULT NULL COMMENT 'Доставлен',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_shop_user_id` (`shop_user_id`),
  CONSTRAINT `fk_shop_user_id` FOREIGN KEY (`shop_user_id`) REFERENCES `shop_users` (`id`) ON DELETE NO ACTION
)COMMENT = 'Заказы';


-- заполним таблицы
INSERT INTO shop_users(name, surname, gender, birthday_at, hometown, email, created_at, updated_at) VALUES
	('Козьма', 'Прутков', 'М', '1982-10-11', 'Москва', 'lkjl@dklj.rt', NOW(), NOW()),
	('Фрося', 'Бурлакова', 'Ж', '1987-11-21', 'Курск', 'asdafjl@dklj.ft', NOW(), NOW()),
	('Дима', 'Маленький', 'М', '1996-08-25', 'Самара', 'sdfggss@dklj.rt', NOW(), NOW()),
	('Жанна', 'Арбузова', 'Ж', '2001-01-01', 'Череповец', 'sjdfhskh@dklj.rt', NOW(), NOW()),
	('Максим', 'Жданов', 'М', '1999-12-30', 'Москва', 'lsksln@dklj.rt', NOW(), NOW());

INSERT INTO orders(shop_user_id, status) VALUES
	(1, 'inbasket'),
	(3, 'inbasket'),
	(5, 'inbasket'),
	(2, 'inbasket'),
	(1, 'inbasket'),
	(3, 'inbasket'),
	(1, 'inbasket'),
	(5, 'inbasket'),
	(1, 'inbasket'),
	(1, 'inbasket');

SELECT * FROM shop_users;
SELECT * FROM orders;

-- решение
SELECT shoper.name, shoper.surname, shoper.gender FROM shop_users AS shoper
INNER JOIN orders AS o ON (o.shop_user_id = shoper.id)
GROUP BY shoper.name
HAVING COUNT(o.id) > 0;



-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
-- заполним таблицы

INSERT INTO catalogs VALUES (1, 'Процессор'),
	(2, 'Материнска плата'),
	(3, 'Видеокарта');


INSERT INTO products
	(name, description, price, catalog_id)
VALUES
	('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров основанных на платформе Intel.', 7890.00, 1),
	('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров основанных на платформе Intel.', 12700.00, 1),
	('AMD FX-8320E', 'Процессор для настольных персональных компьютеров основанных на платформе AMD.', 4780.00, 1),
	('AMD FX-8320', 'Процессор для настольных персональных компьютеров основанных на платформе Intel.', 7120.00, 1),
	('ASUS ROG MAXIMUS X HERO', 'Материнска плата ASUS ROG MAXIMUS X HERO, 2370, Socket 1151-V2, DDR4, ATX.', 19310.00, 2),
	('Gigabyte H310M S2H', 'Материнска плата Gigabyte H310M S2H, H310M, Socket 1151-V2, DDR4, mATX.', 4790.00, 2),
	('MSI 8250M GAMING PRO', 'Материнска плата MSI 8250M GAMING PRO, 8250, Socket 1151-V2, DDR4, mATX.', 5060.00, 2);

-- решение
SELECT c.name AS 'Каталог', p.name AS 'Товар' FROM products AS p
INNER JOIN catalogs AS c ON (p.catalog_id = c.id)
GROUP BY p.id;


-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS `flights`;
CREATE TABLE `flights` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`from` VARCHAR(255),
	`to` VARCHAR(255),
	PRIMARY KEY (`id`),
  	UNIQUE KEY `id` (`id`)
)COMMENT'таблица рейсов';

DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities`(
	label VARCHAR(255) COMMENT'ENG',
	name VARCHAR(255) COMMENT'RU'
)COMMENT'таблица городов';

-- ЗАПОЛНИМ ТАБЛИЦЫ
INSERT INTO cities VALUES
	('Moskow', 'Москва'),
	('Sochi', 'Сочи'),
	('Orel', 'Орёл'),
	('Omsk', 'Омск'),
	('Tula', 'Тула'),
	('Samara', 'Самара');

SELECT * FROM cities;

INSERT INTO flights(`from`, `to`) VALUES
	('Moskow', 'Sochi'),
	('Sochi', 'Omsk'),
	('Orel', 'Samara'),
	('Omsk', 'Tula'),
	('Tula', 'Sochi'),
	('Samara', 'Moskow');

SELECT * FROM flights;

-- решения

SELECT id, 
	(SELECT name FROM cities WHERE label = `from`) AS departure,
	(SELECT name FROM cities WHERE label = `to`) AS arrival 
FROM flights;

-- join
SELECT f.id, cities_from.name as departure, cities_to.name as arrival FROM flights AS f
LEFT JOIN cities AS cities_from
ON f.from = cities_from.label
LEFT JOIN cities AS cities_to
ON f.to = cities_to.label;


