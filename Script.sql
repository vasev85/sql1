SELECT  CONCAT(s.first_name, ' ' ,s.last_name) AS  ФИО, c.city, COUNT( c2.customer_id)  AS Число_Покупателей  
FROM staff s 
JOIN address a ON s.address_id  = a.address_id 
JOIN city c ON a.city_id = c.city_id 
JOIN store s2  ON s2.store_id = s.store_id 
JOIN customer c2 ON s2.store_id = c2.store_id  
GROUP BY s.first_name, s.last_name, c.city 
HAVING Число_Покупателей > 300
;

SELECT  COUNT(f.`length`) AS Число_фильмов
FROM film f 
WHERE    f.length  >  (SELECT AVG( f2.`length`)  FROM film f2) 
;


SELECT  f.`length` 
FROM film f 
WHERE f.`length` = 170 ;

SELECT MAX(  (SELECT SUM(p.amount)
       FROM payment p 
        group by EXTRACT(YEAR_MONTH  FROM p.payment_date) ) )  
FROM (SELECT SUM(p2.amount)
       FROM payment p2 
        group by EXTRACT(YEAR_MONTH  FROM p2.payment_date))  
;

SELECT *
FROM (SELECT SUM(p.amount) AS pp, EXTRACT(YEAR_MONTH  FROM p.payment_date) AS Месяц
FROM payment p GROUP BY Месяц 
)  gio
WHERE gio.pp = (SELECT MAX(pp) from gio)
;

SELECT SUM(p.amount), EXTRACT(YEAR_MONTH  FROM p.payment_date) AS Месяц
FROM payment p 
GROUP BY Месяц

SELECT CAST( EXTRACT(YEAR_MONTH  FROM p.payment_date) AS CHAR) AS Месяц,
(SUM(p.amount)) AS Сумма_в_месяц, COUNT((p.rental_id)) AS Колво 
FROM payment p 
group by Месяц
ORDER BY Сумма_в_месяц   DESC  
LIMIT 1;


SELECT  COUNT((p.rental_id)) AS Месяц, EXTRACT(YEAR_MONTH  FROM p.payment_date)
FROM payment p 
group by EXTRACT(YEAR_MONTH  FROM p.payment_date)
ORDER BY Месяц   DESC;  

SELECT  COUNT((p.rental_id)) AS Месяц, CAST( EXTRACT(YEAR_MONTH  FROM p.payment_date) AS CHAR)
FROM payment p 
group by CAST( EXTRACT(YEAR_MONTH  FROM p.payment_date) AS CHAR)
ORDER BY Месяц   DESC;  

SELECT *
FROM payment p  
WHERE p.payment_date >='2005-07-01' and   p.payment_date < '2005-08-01'
;

SELECT CONCAT(s.first_name, ' ' ,s.last_name) AS  ФИО,
 COUNT(p.amount) as Продажи ,
CASE
	WHEN COUNT(p.amount) > 8000 THEN 'ДА'
	WHEN COUNT(p.amount) < 8000 THEN 'НЕТ'
END AS Премия,
SUM(p.amount) AS Выручка 
FROM payment p 
JOIN staff s ON s.staff_id = p.staff_id 
WHERE p.amount > 0
GROUP BY ФИО
ORDER BY Продажи DESC
;

SELECT f.title, f.release_year,  p.amount, p.payment_date, r.return_date
from payment p 
JOIN rental r ON r.rental_id = p.rental_id 
JOIN inventory i ON i.inventory_id = r.inventory_id 
JOIN film f ON f.film_id = i.film_id 
WHERE p.amount = 0
ORDER BY f.title 
;