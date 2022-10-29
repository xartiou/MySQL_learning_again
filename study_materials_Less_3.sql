-- Изменение имени таблицы
-- ALTER TABLE NAME_TABLE RENAME TO NEW_NAME_TABLE;

USE example_L_2;
SHOW TABLES;  -- у нас таблица с именем users
-- переименуем users в new_users
ALTER TABLE users RENAME TO new_users;
SHOW TABLES; -- теперь у нас таблица с именем new_users

-- Изменение имени столбца
-- ALTER TABLE ИМЯ_ТАБЛИЦЫ RENAME COLUMN СТАРОЕ_ИМЯ_СТОЛБЦА TO НОВОЕ_ИМЯ_СТОЛБЦА;
DESCRIBE new_users;  -- у нас один столбец с именем name
ALTER TABLE new_users RENAME COLUMN name TO user_name;
DESCRIBE new_users;  -- теперь у нас один столбец с именем user_name


-- Добавление столбца в таблицу
-- Добавим в таблицу new_users адрес эл.почты email типа TEXT

ALTER TABLE new_users ADD COLUMN email TEXT;
DESCRIBE new_users;


-- Удаление таблицы
-- DROP TABLE NAME_TABLE;

-- Простая выборка данных
-- SELECT COLOMN_1, COLOMN_2, COLOMN_N FROM NAME_TABLE;
-- SELECT * FROM NAME_TABLE;

-- Добавление новых данных в таблицу
INSERT INTO new_users (id, user_name, email) VALUES (1, 'SEMEN', 'semen@mail.ru');
-- т.к. у нас id autoincrement
INSERT INTO new_users (user_name, email) VALUES ('EGOR', 'egor@mail.com');
-- вставка нескольких строк
INSERT INTO new_users (user_name, email) VALUES 
	('NAZAR', 'nazarr@mail.com'),
	('PAVEL', 'pavel@mail.com');
SELECT * FROM new_users;


-- Обновление существующих данных
/*UPDATE NAME_TABLE
SET COLUMN_1 = VALUE_1
WHERE [УСЛОВИЕ];*/

UPDATE new_users SET user_name = 'Victor' WHERE id = 1;
UPDATE new_users SET email = 'victor@mail.com' WHERE user_name = 'Victor';

-- Удаление данных
-- DELETE FROM NAME_TABLE WHERE [УСЛОВИЕ];

DELETE FROM new_users WHERE user_name = 'PAVEL';























