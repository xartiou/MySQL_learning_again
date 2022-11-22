USE vk;
-- SELECT ЗАПРОСЫ

-- ЗАПРОСЫ ИЗ НЕСКОЛЬКИХ ТАБЛИЦ
SELECT
	id,
	firstname,
	lastname,
	'city', -- заглушка
	'main_photo' -- заглушка
FROM users; 

-- можно с помощью JOIN, но мы пойдем другим путем. JOIN будет позже

-- SELECT hometown FROM profiles WHERE user_id = users.id - подготовили вставку для выбора города пользователя
SELECT
	id,
	firstname,
	lastname,
	(SELECT hometown FROM profiles WHERE user_id = users.id) AS 'city',
	'main_photo' -- заглушка
FROM users; 

-- SELECT filename FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = users.id) - подготовили вставку для выбора avatar  - photo_id
SELECT
	id,
	firstname,
	lastname,
	(SELECT hometown FROM profiles WHERE user_id = users.id) AS 'city', 
	(SELECT filename FROM media WHERE id IN (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS 'main_photo'
FROM users;
-- Т.К. СОРТИРУЕТ ПО ИМЕНИ ПРИМЕНИМ СОРТИРОВКУ ПО ID
SELECT
	id,
	firstname,
	lastname,
	(SELECT hometown FROM profiles WHERE user_id = users.id) AS 'city', 
	(SELECT filename FROM media WHERE id IN (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS 'main_photo'
FROM users ORDER BY id;

-- для одного рользователя c id = 5
SELECT
	id,
	firstname,
	lastname,
	(SELECT hometown FROM profiles WHERE user_id = 5) AS 'city', 
	(SELECT filename FROM media WHERE id IN (SELECT photo_id FROM profiles WHERE user_id = 5)) AS 'main_photo'
FROM users 
WHERE id = 5;

-- получить все файлы пользователя ID = 1
SELECT * FROM media
WHERE user_id = 1;

SELECT * FROM MEDIA_TYPES; -- PHOTO -> ID = 1
SELECT * FROM media_types WHERE name = 'photo';
SELECT * FROM media_types WHERE name LIKE 'ph%'; -- LIKE не работает с id
SELECT id FROM media_types WHERE name = 'photo'; -- => 1

-- получить все фото пользователя
SELECT id, media_type_id, filename FROM media
WHERE user_id = 1 AND media_type_id IN 
(SELECT id FROM media_types WHERE name = 'photo');

-- можем выбрать пользователя по емейлу
SELECT EMAIL FROM USERS WHERE id = 1; -- => arlo50@example.org

SELECT id, media_type_id, filename FROM media
WHERE user_id = (SELECT id FROM users WHERE email = 'arlo50@example.org') 
AND media_type_id IN 
(SELECT id FROM media_types WHERE name LIKE 'photo');

-- у нас в файлах есть видео, выберем файл по расширению (avi или mp4)
SELECT id, user_id, filename, `size` FROM media 
WHERE user_id = 1 AND (filename LIKE '%.avi' OR filename LIKE '%.mp4');

-- посчитаем количество фотографий USER_ID = 1, 
-- агрегирующие функции (AVG, MAX, MIN, COUNT, SUM)
SELECT COUNT(*) FROM media
WHERE user_id = 1 AND media_type_id = 1;

SELECT COUNT(*) AS ALL_JPG FROM media
WHERE user_id = 1 AND filename LIKE '%.jpg';


-- ПОСЧИТАТЬ КОЛ-ВО ЗАПИСЕЙ MEDIA КАЖДОГО ТИПА
SELECT COUNT(*), 
	media_type_id,
	(SELECT name FROM media_types WHERE id = media.media_type_id) AS 'MEDIA_TYPE'
FROM media
GROUP BY media_type_id;

-- ПОСЧИТАТЬ КОЛ-ВО MEDIA КАЖДОГО МЕСЯЦА
SELECT COUNT(*) AS MEDIA_MONTH,
	MONTH(created_at) AS NUM_MONTH,
	MONTHNAME(created_at) AS MONTH_NAME
FROM media
GROUP BY NUM_MONTH
ORDER BY MEDIA_MONTH;


SELECT COUNT(*) AS MEDIA_MONTH,
	MONTH(created_at) AS NUM_MONTH,
	MONTHNAME(created_at) AS MONTH_NAME
FROM media
GROUP BY NUM_MONTH
ORDER BY MEDIA_MONTH DESC;

-- СКОЛЬКО создано ДОКУМЕНТОВ У КАЖДОГО ПОЛЬЗОВАТЕЛЯ
SELECT COUNT(*) AS COUNT_DOC,
	-- (SELECT email FROM users WHERE id = media.user_id) AS USER_NAME
	user_id
FROM media
GROUP BY user_id;

SELECT COUNT(*) AS COUNT_DOC,
	user_id,
	MONTH(created_at) AS NUM_MONTH
FROM media
GROUP BY user_id, NUM_MONTH;

-- настройка вывода неоднозначных полей
SELECT @@sql_mode; -- => 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION'
SET @@sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

SET @@sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';


-- ВЫВЕДЕМ ДРУЗЕЙ ПОЛЬЗОВАТЕЛЯ С ID=1 (Т.Е. МОИХ ДРУЗЕЙ)
SELECT initiator_user_id, target_user_id FROM friend_requests
WHERE 
	(initiator_user_id = 1 OR target_user_id = 1)
	AND status = 'approved'
	;


-- получить документы моих друзей из таблицы media
SELECT user_id, filename FROM media WHERE user_id IN (3, 4, 10);

SELECT target_user_id FROM friend_requests
WHERE (initiator_user_id = 1) AND status = 'approved';

SELECT initiator_user_id FROM friend_requests
WHERE (target_user_id = 1) AND status = 'approved';


SELECT target_user_id AS FRIEND FROM friend_requests
WHERE (initiator_user_id = 1) AND status = 'approved'
UNION
SELECT initiator_user_id AS FRIEND FROM friend_requests
WHERE (target_user_id = 1) AND status = 'approved';


SELECT user_id, filename FROM media WHERE user_id IN (
	SELECT target_user_id AS FRIEND FROM friend_requests
	WHERE (initiator_user_id = 1) AND status = 'approved'
	UNION
	SELECT initiator_user_id AS FRIEND FROM friend_requests
	WHERE (target_user_id = 1) AND status = 'approved'
);

SELECT user_id, filename FROM media WHERE user_id=1;

SELECT user_id, filename FROM media WHERE user_id=1
UNION
SELECT user_id, filename FROM media WHERE user_id IN (
	SELECT target_user_id AS FRIEND FROM friend_requests
	WHERE (initiator_user_id = 1) AND status = 'approved'
	UNION
	SELECT initiator_user_id AS FRIEND FROM friend_requests
	WHERE (target_user_id = 1) AND status = 'approved'
);

SELECT user_id, filename FROM media WHERE user_id IN (
	SELECT target_user_id AS FRIEND FROM friend_requests
	WHERE (initiator_user_id = 1) AND status = 'approved'
	UNION
	SELECT initiator_user_id AS FRIEND FROM friend_requests
	WHERE (target_user_id = 1) AND status = 'approved'
) OR user_id=1;


-- ПОДСЧИТАЕМ ЛАЙКИ МОИХ ДОКУМЕНТОВ
SELECT * FROM likes;

SELECT id FROM media WHERE user_id = 1;

SELECT * FROM likes
WHERE media_id IN (SELECT id FROM media WHERE user_id = 1);


SELECT 
	media_id,
	COUNT(*) AS COUNT_LIKES
FROM likes
WHERE media_id IN (SELECT id FROM media WHERE user_id = 1)
GROUP BY media_id;


-- ПОЧИТАЕМ СООБЩЕНИЯ мои и ко мне
SELECT * FROM messages;

SELECT * FROM messages
WHERE from_user_id = 1 OR to_user_id = 1
ORDER BY created_at DESC;


-- ДОБАВИМ КОЛОНКУ О ПРОЧТЕНИИ СООБЩЕНИЯ
ALTER TABLE messages
ADD COLUMN is_read BIT DEFAULT b'0';

-- выведем не прочитаные мной сообщения
SELECT * FROM messages
WHERE to_user_id = 1 AND is_read = 0
ORDER BY created_at DESC;


-- 6000 ДНЕЙ НАЗАД Я ПРОЧИТАЛ СООБЩЕНИЯ
UPDATE messages
SET is_read = b'1'
WHERE created_at < DATE_SUB(NOW(), INTERVAL 6000 DAY);




-- Выводим друзей пользователя с преобразованием пола и возраста 
-- (поиграемся со встроенными функциями MYSQL)
SELECT user_id, 
	-- , gender -- сначала выведем так, потом заменим на CASE ниже 
    CASE (gender)
         WHEN 'm' THEN 'мужской'
         WHEN 'f' THEN 'женский'
         ELSE 'НЕ УКАЗАН'
    END AS 'ПОЛ', 
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS ' ВОЗРАСТ' -- функция определяет разницу между датами в выбранных единицах (YEAR)
  FROM profiles
  WHERE user_id IN ( -- 1,2,3 union 4,5,6 -- это мы уже делали сегодня раньше (получали подтвержденных друзей пользователя)
	  SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved' -- ИД друзей, заявку которых я подтвердил
	  UNION
	  SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved' -- ИД друзей, подрвердивших мою заявку
  );



-- Является ли пользователь админом данного сообщества?
-- добавляем поле admin_user_id в таблицу communities
 SELECT * FROM communities;
 
 ALTER TABLE vk.communities ADD 
 	admin_user_id INT DEFAULT 1 NOT NULL;
 
 UPDATE vk.communities
SET name='atque', admin_user_id=2
WHERE id=2;
 
 -- является ли пользователь админом группы?
-- user_id = 1
-- community_id = 5
 
 SELECT * FROM communities
 WHERE id = 5;
 
 SELECT admin_user_id FROM communities
 WHERE id = 5;
 
SELECT 1 = (SELECT admin_user_id FROM communities WHERE id = 5) AS 'is_admin=1';
 
SELECT 1 = (SELECT admin_user_id FROM communities WHERE id = 6) AS 'is_admin=1';



-- добавим ограничение на подружиться сам с собой
ALTER TABLE friend_requests
ADD CHECK (initiator_user_id <> target_user_id);
 
 
 
 
 
 



















