/*1.Установите СУБД MySQL.
- установил MySQL8
Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль,
который указывался при установке.
[client]
user=root
password=******
файл my.cnf с расширением * сохранил в папку Windows на диске С:
в командной строке пишу просто mysql - работает без запроса пароля
*/

/*2.	Создайте базу данных example, разместите в ней таблицу users, 
состоящую из двух столбцов, числового id и строкового name.
*/
-- mysql> CREATE DATABASE example_L_2; - создали базу данных example

-- создаем таблицу с указанием , что если она еще не создана
USE example_L_2;
CREATE TABLE IF NOT EXISTS users (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
	name VARCHAR(100) NOT NULL UNIQUE 
)

/*
 3.	Создайте дамп базы данных example_L_2 из предыдущего задания, 
разверните содержимое дампа в новую базу данных sample_L_2.
*/

-- работаю в командной строке
-- для создания дамп нужно выйти из клиента mysql
-- \q

-- заходим в дамп и создаем файлдампа(команда mysqldump)
-- mysqldump example > example.sql

-- чтобы содержимое дампа развернуть в другой базе её нужно создать
-- заходим в mysql
-- CREATE DATABASE sample;
-- и выходим
-- \q

-- для отправки файла работаем прописываем
-- mysql sample < example.sql
-- заходим в mysql
-- выбираем нашу базу USE sample; и проверяем как сработал файл SHOW TABLES
-- \q

/*
4.	(по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. 
Создайте дамп единственной таблицы help_keyword базы данных mysql.
 Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
*/

-- mysqldump --where="1 limit 100" mysql help_keyword > help_keyword.sql
-- где --where='where_condition', -w 'where_condition' Выгружать только строки, выбранные данным WHEREусловием.

