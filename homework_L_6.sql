-- HOMEWORK LESS 6
-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
USE vk;

-- 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
SELECT * FROM users WHERE id = 1; -- пользователь

	-- ВЫВЕДЕМ ДРУЗЕЙ ПОЛЬЗОВАТЕЛЯ С ID=1 
SELECT target_user_id AS FRIEND FROM friend_requests
WHERE (initiator_user_id = 1) AND status = 'approved'
UNION
SELECT initiator_user_id AS FRIEND FROM friend_requests
WHERE (target_user_id = 1) AND status = 'approved';


	-- общался -  это тот кто писал пользователю from_user_id(друг) => to_user_id=1
SELECT from_user_id FROM messages 
WHERE 
from_user_id IN (SELECT target_user_id AS FRIEND FROM friend_requests
WHERE (initiator_user_id = 1) AND status = 'approved'
UNION
SELECT initiator_user_id AS FRIEND FROM friend_requests
WHERE (target_user_id = 1) AND status = 'approved') AND to_user_id = 1;


	-- Решение
SELECT m.from_user_id,
	(SELECT CONCAT (firstname, ' ', lastname) FROM users WHERE id = m.from_user_id) AS MY_FRIEND, 
	COUNT(*) AS CNT
FROM messages m
WHERE 
	m.to_user_id = 1
	AND 
	m.from_user_id IN
	(SELECT target_user_id AS FRIEND FROM friend_requests
	WHERE (initiator_user_id = 1) AND status = 'approved'
	UNION
	SELECT initiator_user_id AS FRIEND FROM friend_requests
	WHERE (target_user_id = 1) AND status = 'approved')
GROUP BY m.from_user_id -- группируем
ORDER BY CNT DESC -- сортируем
LIMIT 1; -- отсекаем


-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.

-- выбираем пользователей и их возраст
SELECT user_id,  
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS 'AGE' -- функция определяет разницу между датами в выбранных единицах (YEAR)
FROM profiles;
-- выбираем пользователей младше 10 лет										
SELECT user_id FROM profiles
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10;	

-- сколько всего лайков
SELECT COUNT(*)
FROM likes;

-- получили лайки - значит отметили в media
SELECT id FROM media;

SELECT COUNT(*)
FROM likes
WHERE media_id IN (
SELECT id FROM media);

-- выберем в media пользователей младше 10 лет
-- решение
SELECT COUNT(*) 
FROM vk.likes
WHERE media_id IN (
	SELECT id 
	FROM vk.media
	WHERE user_id IN (
	SELECT user_id 
	FROM vk.profiles
	WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10)
);

-- 3.Определить кто больше поставил лайков (всего): мужчины или женщины.
-- выводим пользователей и их пол
SELECT gender FROM vk.profiles AS GENDER ;

-- выводим пользователей и их пол которые лайкали
SELECT user_id AS USER, (
SELECT gender 
FROM vk.profiles
WHERE user_id = USER)
AS GENDER
FROM likes;

-- подсчитываем лайки по полам
SELECT GENDER, COUNT(*)
FROM
	(SELECT user_id AS USER, (
		SELECT gender 
		FROM vk.profiles
		WHERE user_id = USER)
		AS GENDER
		FROM likes
) AS F_M
GROUP BY GENDER;



SELECT * FROM profiles WHERE user_id=7;








										
										