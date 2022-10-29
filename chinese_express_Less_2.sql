-- Мы создали БД
-- использовать БД
USE chinese_express;

-- создадим таблицу с разделами БД chinese_express
-- если она уже создана мы её удалим
DROP TABLE IF EXISTS catalog;
CREATE TABLE catalog (
	id SERIAL PRIMARY KEY,
	name_section VARCHAR(255) COMMENT 'НАЗВАНИЕ РАЗДЕЛА КАТАЛОГА'
) COMMENT = 'РАЗДЕЛЫ КАТАЛОГА';

-- добавим раздел каталога
INSERT INTO catalog (name_section) VALUES ('автотовары');
SELECT * FROM catalog;

-- создадим таблицу товаров БД chinese_express
DROP TABLE IF EXISTS goods;
CREATE TABLE goods (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название товара',
	description TEXT COMMENT 'Описание товара',
	purchasing_price DECIMAL (11, 2) COMMENT 'Закупочная цена',
	selling_prise DECIMAL (11,2) COMMENT 'Цена продажи',
	catalog_id INT UNSIGNED,
	KEY index_of_catalog_id(catalog_id)
) COMMENT = 'Товары';

-- добавим товар
INSERT INTO goods (name, description, purchasing_price, selling_prise)
VALUES ('свечи зажигания', 'NGK 1578', 100, 350);
SELECT * FROM goods;

-- создадим таблицу поставщиков БД chinese_express
DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя поставщика'
) COMMENT = 'Поставщики';

-- создадим таблицу грузоотправителей БД chinese_express
DROP TABLE IF EXISTS shippers;
CREATE TABLE shippers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя грузоотправителей'
) COMMENT =  'Грузоотправитель';


-- создадим таблицу закупки товара БД chinese_express
DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
	id SERIAL PRIMARY KEY,
	suppliers_id INT UNSIGNED,
	shipers_id INT UNSIGNED,
	purchases_at DATE COMMENT 'Дата закупки',
	arrival_purchases DATE COMMENT 'Дата прибытия закупки',
	KEY index_of_suppliers_id(suppliers_id),
	KEY index_of_shipers_id(shipers_id)
) COMMENT =  'Закупки';


-- создадим таблицу товары в закупке товара БД chinese_express
DROP TABLE IF EXISTS purchases_goods;
CREATE TABLE purchases_goods (
	id SERIAL PRIMARY KEY,
	goods_id INT UNSIGNED,
	purchases_id INT UNSIGNED,
	quantity_goods INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказаного товара',
	KEY index_of_goods_id(goods_id),
	KEY index_of_purchases_id(purchases_id)
) COMMENT =  'Товары в закупке';


-- создадим таблицу склад БД chinese_express
DROP TABLE IF EXISTS storehouse;
CREATE TABLE storehouse (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT 'ОСНОВНОЙ СКЛАД' COMMENT 'Название склада'
) COMMENT =  'СКЛАД';

-- создадим таблицу склада (ЗАПАСЫ-ОСТАТКИ) товара БД chinese_express
DROP TABLE IF EXISTS storehouse_goods;
CREATE TABLE storehouse_goods (
	id SERIAL PRIMARY KEY,
	storehouse_id INT UNSIGNED,
	goods_id INT UNSIGNED,
	quantity_goods INT UNSIGNED COMMENT 'Количество товара на складе',
	KEY index_of_storehouse_id(storehouse_id),
	KEY index_of_goods_id(goods_id)
) COMMENT =  'Товары на складе.';






















