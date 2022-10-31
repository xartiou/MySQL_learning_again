/*
Практическое задание по теме “Введение в проектирование БД”
Написать cкрипт, добавляющий в БД vk, которую создали на 3 вебинаре, 3-4 новые таблицы (с перечнем полей, указанием индексов и внешних ключей).
(по желанию: организовать все связи 1-1, 1-М, М-М)
*/

-- создать БД home_task_vk
DROP DATABASE IF EXISTS home_task_vk;
CREATE DATABASE home_task_vk;
USE home_task_vk;

-- создать в БД таблицу пользователей user:
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100) COMMENT 'имя пользователя',
	lastname VARCHAR(100) COMMENT 'фамилия пользователя',
	email VARCHAR(100) UNIQUE,
	password_hash VARCHAR(100),
	is_deleted BIT DEFAULT 0,
	INDEX users_firstname_lastname_idx(firstname, lastname)
);

-- создать в БД таблицу профилей пользователей
DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
	gender CHAR(1) COMMENT 'пол',
	birthday DATE COMMENT 'дата рождения',
	photo_id BIGINT UNSIGNED NULL,
	creatad_at DATETIME DEFAULT NOW() COMMENT 'дата создания профиля',
	hometown VARCHAR(100) COMMENT 'город пользователя',
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (photo_id) REFERENCES photos(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- добавим в таблицу  profiles связь с users
/*ALTER TABLE profiles ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
	ON UPDATE CASCADE ON DELETE CASCADE;*/


-- таблица сообщений messages
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL COMMENT 'отправитель',
	to_user_id BIGINT UNSIGNED NOT NULL COMMENT 'получатель',
	body TEXT COMMENT 'текст сообщения',
	created_at DATETIME DEFAULT NOW() COMMENT 'дата создания сообщения',	
	-- создаем связь один ко многим
	FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- таблица заявок на дружбу
DROP TABLE IF EXISTS `friend_requests`;
CREATE TABLE `friend_requests` (
	initiator_user_id BIGINT UNSIGNED NOT NULL COMMENT 'инициатор заявки',
	target_user_id BIGINT UNSIGNED NOT NULL COMMENT 'получатель заявки',
	`status_requests` ENUM('requsted', 'approved', 'declined', 'unfriended') COMMENT 'статус заявки',
	requested_at DATETIME DEFAULT NOW() COMMENT 'когда подана заявка',
	updated_at DATETIME ON UPDATE NOW(),
	PRIMARY KEY (initiator_user_id, target_user_id),
	
	-- создаем связи по ключам
	FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (target_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE

);

-- таблица групп пользователей
DROP TABLE IF EXISTS `communities`;
CREATE TABLE `communities` (
	id SERIAL PRIMARY KEY,
	name VARCHAR(150) COMMENT 'имя сообщества',
	admin_user_id BIGINT UNSIGNED,
	INDEX communities_name_idx(name),
	FOREIGN KEY (admin_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- таблица связей групп и пользователей
DROP TABLE IF EXISTS `users_comunities`;
CREATE TABLE `users_comunities`(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (user_id, community_id),
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (community_id) REFERENCES communities(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- таблица типов media
DROP TABLE IF EXISTS `media_tipes`;
CREATE TABLE `media_tipes` (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	created_at DATETIME DEFAULT NOW(),
	updeted_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- таблица media
DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
	id SERIAL PRIMARY KEY,
	media_type_id BIGINT UNSIGNED,
	user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	filename VARCHAR(255) COMMENT 'место хранения',
	`size` INT COMMENT 'размер media файла ',
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_type_id) REFERENCES media_tipes(id) ON UPDATE CASCADE ON DELETE CASCADE
);






-- таблица likes
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- таблица photo_albums
DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT NULL,
	user_id BIGINT UNSIGNED DEFAULT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);



-- таблица photos
DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL PRIMARY KEY,
	`albums_id` BIGINT UNSIGNED NOT NULL,
	`media_id` BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (albums_id) REFERENCES photo_albums(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);



-- таблица play_list
DROP TABLE IF EXISTS `play_lists`;
CREATE TABLE `play_lists` (
	id SERIAL PRIMARY KEY,
	`name` VARCHAR(255) DEFAULT NULL COMMENT 'имя плейлиста',
	`user_id` BIGINT UNSIGNED DEFAULT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- таблица муз. ткреков music
DROP TABLE IF EXISTS `music`;
CREATE TABLE `music`(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT NULL COMMENT 'название композиции',
	playlist_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (playlist_id) REFERENCES play_lists(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- таблица video_collection
DROP TABLE IF EXISTS video_colection;
CREATE TABLE video_collection (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT NULL COMMENT 'видео папка',
	user_id BIGINT UNSIGNED DEFAULT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- таблица video
DROP TABLE IF EXISTS video;
CREATE TABLE video (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT NULL COMMENT 'название видео',
	video_collection_id BIGINT UNSIGNED NULL,
	FOREIGN KEY (video_collection_id) REFERENCES video_collection(id) ON UPDATE CASCADE ON DELETE CASCADE
);

















