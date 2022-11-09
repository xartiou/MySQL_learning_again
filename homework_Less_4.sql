-- Практическое задание по теме “CRUD - операции”
-- 1.Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице). +
-- 2.Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке.
USE vk;

SELECT DISTINCT firstname FROM users ORDER BY firstname;

-- 3.Первые пять пользователей пометить как удаленные.
SELECT id, is_deleted FROM users WHERE id LIMIT 5;
UPDATE users SET is_deleted = 1 WHERE id LIMIT 5;

-- 4.Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней).
-- из таблицы messages если создание(created_at) больше чем сегодняшняя дата (CURRENT_TIMESTAMP)
select created_at from messages;
DELETE FROM messages WHERE created_at > current_timestamp; 
-- Написать название темы курсового проекта.


USE home_task_vk;

-- пакетная вставка
INSERT users (firstname, lastname, email, phone, is_deleted) 
VALUES
('Reuben', 'Nienow1', 'arlo500@example.org', NULL, 0),
('Reuben', 'Nienow2', 'arlo501@example.org', '911234456', 1),
('Reuben', 'Nienow3', 'arlo502@example.org', '911234457', 1),
('Reuben', 'Nienow4', 'arlo503@example.org', NULL, 0);
-- вставить по одному
INSERT INTO users
SET
	firstname = 'Иван',
	lastname = 'Диванов',
	email = 'ivan@mail.ru',
	password_hash = '9876dfKJdka<v543k:jljf21',
	is_deleted = 1;
	

-- SELECT - получать данные из таблиц
-- FROM откуда
SELECT * FROM users;
-- DISTINCT - уникальные
SELECT DISTINCT firstname, lastname
FROM users;
-- WHERE - с условием
SELECT * FROM users
WHERE id >= 3 AND id <= 9; 

-- LIMIT - сколько записей вывести
-- offset - с какого начать
SELECT * FROM users
LIMIT 5 offset 7;

-- выбрать в таблице users значения 
SELECT * FROM users WHERE email  IS NOT NULL;

SELECT * FROM users WHERE id = 5 OR firstname = 'Иван';

SELECT * FROM users WHERE id IN (1,2,30,4);


-- update
-- отправка запроса в друзья
INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`, status_requests)
VALUES ('1', '2', 'requested');

INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`, status_requests)
VALUES ('1', '3', 'requested');

-- лучше это делать пакетной вставкой
INSERT INTO friend_requests (initiator_user_id, target_user_id, status_requests) VALUES
	('3', '2', 'requested'),
	('4', '3', 'requested'),
	('1', '4', 'requested'),
	('1', '5', 'requested');

-- изменить значение status_requests по умолчанию на 'requested' и тогда запрос будет

ALTER TABLE home_task_vk.friend_requests MODIFY COLUMN status_requests 
ENUM('requested','approved','declined','unfriended') 
CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci 
DEFAULT 'requested' NULL;

INSERT INTO friend_requests (`initiator_user_id`, `target_user_id`) VALUES
	('3', '6'),
	('5', '7');

/* UPDATE friend_requests
SET 
	status = 'approved';

UPDATE friend_requests
SET 
	status = 'requested';
*/	
-- принять запрос о дружбе
UPDATE friend_requests SET 
	status_requests = 'approved'
WHERE
	initiator_user_id = 1 and target_user_id = 2;


UPDATE friend_requests SET 
	status_requests = 'approved',
	updated_at = requested_at 
WHERE
	initiator_user_id = 4 and target_user_id = 3;


-- отклонить запрос в друзья
UPDATE friend_requests
SET 
	status_requests = 'declined'
WHERE
	initiator_user_id = 4 and target_user_id = 3;


-- DELETE

-- добавим несколько сообщений
INSERT INTO messages (from_user_id, to_user_id, body) VALUES 
(1, 2, 'Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.'),
(2, 1,'Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.'),
('3','1','Sed mollitia quo sequi nisi est tenetur at rerum. Sed quibusdam illo ea facilis nemo sequi. Et tempora repudiandae saepe quo.'),
('1','3','Quod dicta omnis placeat id et officiis et. Beatae enim aut aliquid neque occaecati odit. Facere eum distinctio assumenda omnis est delectus magnam.'),
('1','5','Voluptas omnis enim quia porro debitis facilis eaque ut. Id inventore non corrupti doloremque consequuntur. Molestiae molestiae deleniti exercitationem sunt qui ea accusamus deserunt.');


-- delete from messages;

DELETE FROM messages
WHERE from_user_id = 1;

DELETE FROM messages
WHERE from_user_id IN (SELECT id FROM users WHERE lastname='Madridova');

DELETE FROM users;

-- TRUNCATE - очищает данные из таблицы даже ID (равносильно DROP TABLE; CREATE TABLE;)
TRUNCATE messages;
TRUNCATE friend_requests;

TRUNCATE users; 


































