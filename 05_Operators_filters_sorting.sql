--Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
--Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

update users 
set created_at = (case created_at when created_at is null then now() end),
	updated_at = (case updated_at when created_at  is null then now() end);
	
--Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

alter table users 
add created_at_new datetime;
alter table users 
add updated_at_new datetime;
update users
set created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
    updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
alter table users 
    drop created_at, drop updated_at, 
    rename column created_at_new to created_at, rename column updated_at_new to updated_at;

--В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

 select 
	* 
 from storehouses_products
 order by when value = 0 then 2147483647 else value end;


--(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august) 

 select 
	* 
 from users 
 where monthname(birthday) in (‘may’,’august’); 
 
--(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

select 
	* 
from catalogs 
where  id  in  (5, 1, 2) 
order by field (5, 1, 2);

--Практическое задание теме «Агрегация данных»
--Подсчитайте средний возраст пользователей в таблице users.

select 
	round(avg(timestampdiff(year, birthday, now())),0) as avg_age  
from users;

--Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

select 
    dayname(date_format(birthday, '2021-%m-%d')) as day_of_week,
    count(*) as birthdays_count
from users
group by day_of_week
order by birthdays_count;


