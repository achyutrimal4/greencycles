-- Aggregate functions - min, max, average, sum of the cost of replacement
-- of the films

SELECT MAX(replacement_cost),
	MIN(replacement_cost),
	ROUND(AVG(replacement_cost),2),
	SUM(replacement_cost)
FROM film


-- GROUP BY function
-- Which 2 employees are responsible for more payment and higher payment amount
SELECT 
	staff_id, 
	SUM(amount), 
	COUNT(*)
	FROM payment
		WHERE amount <> 0
	GROUP BY staff_id
	ORDER BY sum DESC


-- Which employee had the highest sales amount in a single day
SELECT 
staff_id, SUM(amount), DATE(payment_date)
FROM 
payment
GROUP BY staff_id, date
ORDER BY sum DESC

-- having and group by
SELECT
customer_id, 
ROUND(AVG(amount),2) AS average, 
DATE(payment_date),
COUNT(*) as no_of_payment
FROM payment
WHERE DATE(payment_date) IN ('2020-04-28', '2020-04-28', '2020-04-28') 
GROUP BY customer_id, date
HAVING COUNT(*)>1
ORDER BY average DESC


-- Intermediate Functions
-- String
-- find customers whose first name or last name is longer than 10 characters

SELECT 
LOWER(first_name),
LOWER(last_name),
LOWER(email)
FROM customer
WHERE LENGTH(first_name) >10 OR LENGTH(last_name)>10



-- extract last 5 characters from the email address and extract just the dot
SELECT
email,
RIGHT(email,5),
LEFT(RIGHT(email, 4), 1)
FROM customer

-- anonymize the email address
SELECT
email,
LEFT(email, 1)||'***'||RIGHT(email, 19) as anonymized_email
FROM customer


-- extract first and last names from email and concatenate in the format 
-- last_name, LEFT(email, POSITION('@' IN email)-1)

SELECT
email,
RIGHT(LEFT(email, POSITION('@' IN email)-1), LENGTH(last_name))
|| ', ' || LEFT(email, POSITION('.' IN email)-1) 
FROM customer

-- anonymized email in different formats
SELECT 
email,
LEFT(email, 1)||'***' ||'.'||
LEFT(RIGHT(LEFT(email, POSITION('@' IN email)-1), LENGTH(last_name)),1) || '***'||
RIGHT(email, 19)
FROM 
customer
-- RESULT (M***.S***@sakilacustomer.org)

-- 2nd format
SELECT 
email,
'***'||
RIGHT(LEFT(email, POSITION('.' IN email)-1),1)||'.'||
LEFT(RIGHT(LEFT(email, POSITION('@' IN email)-1), LENGTH(last_name)),1) || '***'||
RIGHT(email, 19)
FROM 
customer
-- RESULT(***Y.S***@sakilacustomer.org)

-- USING SUBSTRING
SELECT email, 
LEFT(email, 1) ||'***'
||SUBSTRING(email FROM POSITION('.' in email) for 2)
||'***'
||SUBSTRING(email FROM POSITION('@' IN email))
FROM customer


-- What is the month with the highest total payment amount
-- What day of the week with the highest total payment amount
-- What is the highest amount a customer has spent in a week

SELECT EXTRACT(month from payment_date), SUM(amount)
FROM
payment
GROUP BY EXTRACT(month from payment_date)
ORDER BY sum DESC


SELECT EXTRACT(DOW from payment_date),
SUM(amount)
FROM 
payment
GROUP BY EXTRACT(DOW from payment_date)
ORDER BY SUM(amount) DESC

SELECT EXTRACT(week from payment_date),
SUM(amount),
customer_id
FROM payment
GROUP BY customer_id, EXTRACT(week from payment_date)
ORDER BY SUM(amount) DESC


-- SUM of payment in different formats
SELECT TO_CHAR(payment_date, 'Dy, DD/MM/YYYY') as day,
SUM(amount)
FROM payment
GROUP BY day
ORDER BY sum


SELECT TO_CHAR(payment_date, 'Mon, YYYY') as day,
SUM(amount)
FROM payment
GROUP BY day
ORDER BY sum

SELECT TO_CHAR(payment_date, 'Dy, HH:MI') as day,
SUM(amount)
FROM payment
GROUP BY day
ORDER BY sum DESC


-- rental durations of customer with id 35
SELECT 
customer_id, 
return_date - rental_date
FROM rental
WHERE customer_id = 35


-- list of films where the rental rate is less than 4% of the replacement cost
SELECT
film_id,
ROUND(((rental_rate * 100)/replacement_cost), 2)as percentage
FROM film
WHERE ((rental_rate * 100)/replacement_cost)<4
ORDER BY 2

--Grouping movies into different tiers

SELECT title,
CASE
	WHEN (rating IN ('PG', 'PG-13')) OR length>210 THEN 'Great rating or very long (tier 1)'
	WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long tier drama (tier 2)'
	WHEN description LIKE '%Drama%' AND length < 90 THEN 'Short tier drama (tier 3)'
	WHEN rental_rate<1 THEN 'Very Cheap tier 4 (tier 4)' 
END
FROM film

-- CASE WHEN and SUM
SELECT
SUM(CASE
	WHEN rating in ('PG','G') THEN 1
	ELSE 0
END)
FROM film

-- CAST AND COALESCE
SELECT 
COALESCE(CAST(return_date AS VARCHAR), 'Not returned yet')
FROM rental
ORDER BY rental_date DESC


--INNER JOIN
SELECT c.customer_id, first_name, last_name, amount
FROM customer c
INNER JOIN payment p
ON 
c.customer_id = p.customer_id

-- Customers from texas
SELECT first_name, last_name, phone , district FROM customer c
FULL OUTER JOIN address a ON
c.address_id = a.address_id
WHERE district = 'Texas'


SELECT address FROM customer c
FULL OUTER JOIN address a ON
c.address_id = a.address_id
WHERE c.address_id is NULL


-- Joining multiple tables
SELECT first_name, last_name, country
FROM customer c
INNER JOIN address a 
ON c.address_id = a.address_id
INNER JOIN city ci 
ON a.city_id = ci.city_id
INNER JOIN country co 
ON ci.country_id = co.country_id
WHERE country = 'Brazil'

-- Subqueries
SELECT length, title FROM film
WHERE length > (SELECT AVG(length) FROM film)


SELECT film_id, title FROM FILM WHERE film_id IN (
SELECT film_id FROM inventory
WHERE store_id = 2
GROUP BY film_id
HAVING COUNT(*) > 3)

SELECT first_name, last_name 
FROM customer 
WHERE customer_id IN (
SELECT customer_id FROM payment
WHERE DATE(payment_date) = '2020-01-25')


SELECT first_name, email 
FROM customer 
WHERE customer_id IN (
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 30
)


SELECT first_name, last_name FROM customer
WHERE customer_id IN (SELECT customer_id FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100) 
AND address_id IN
(SELECT address_id FROM address
WHERE district = 'California')


-- SUBQUERIES IN FROM

SELECT ROUND(AVG(total), 2) FROM ( 
SELECT SUM(amount) as total FROM payment
GROUP BY DATE(payment_date)) as subquery


-- SUBQUERIES IN SELECT
SELECT *,
	(SELECT MAX(amount) FROM payment) - amount as difference FROM payment


-- Correlated subqueries
SELECT title, film_id, replacement_cost, rating FROM film f1
WHERE replacement_cost = (
	SELECT MIN(replacement_cost) FROM film f2
	WHERE f1.rating = f2.rating
)


SELECT title, film_id, replacement_cost, rating FROM film f1
WHERE length = (
	SELECT MAX(length) FROM film f2
	WHERE f1.rating = f2.rating
)

-- correlated subquery in select
SELECT *, 
	(SELECT SUM(amount) FROM payment p1
	WHERE p1.customer_id = p2.customer_id),
	(SELECT COUNT(*) FROM payment p3
	WHERE p2.customer_id = p3.customer_id) as num_of_payment
	FROM payment p2
ORDER BY customer_id



SELECT film_id, title, replacement_cost, rating, 
	(SELECT AVG(replacement_cost) FROM film f3
	WHERE f3.rating = f1.rating)
	FROM film f1
WHERE
replacement_cost  = (SELECT MAX(replacement_cost)
	FROM film f2 WHERE 
	f1.rating = f2.rating)

-- Show only those payments with the highest payment for each customer's first
-- name including the payment_id of that payment

SELECT payment_id,  first_name, amount FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
WHERE amount = (SELECT MAX(amount) FROM payment p2
	WHERE p.customer_id = p2.customer_id)











