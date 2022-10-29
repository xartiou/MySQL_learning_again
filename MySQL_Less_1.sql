-- использовать БД
USE gb;

-- создать таблицу
CREATE TABLE courses (
	id INT,
	name VARCHAR(100)
);

CREATE TABLE students (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	firstname VARCHAR(100) NOT NULL,
	lastname VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	course_id INT
);

-- изменить таблицу 
ALTER TABLE students 
ADD COLUMN birthday DATE;

ALTER TABLE students
RENAME COLUMN birthday TO date_of_birth; 

ALTER TABLE students
DROP COLUMN date_of_birth;

-- insert , update , select, delete 

INSERT INTO courses (name)
VALUES ('Databases'), ('Linux'), ('BigDATA');

INSERT INTO students (firstname, lastname, email, course_id)
VALUES ('Pavel', 'Ivanov', 'gb_ivanov@mail.ru', 1),
		('Roman', 'Semenov', 'gb_semenov@mail.ru', 2),
		('Oleg', 'Stasnov', 'gb_stasov@mail.ru', 3);
		
SELECT id, name FROM courses;
SELECT * FROM students;

UPDATE students 
SET email = 'gb_stasov@yandex.ru'
WHERE lastname = 'Stasnov';


DELETE FROM students 
WHERE id = 3;


