SELECT *, 
	SUM(amount) OVER (PARTITION BY customer_id)
	FROM payment


/*
Write a query to return the list of movies including film_id, title, length, 
category, the average length of movies in that category.
Order the results by film_id
*/

SELECT f.film_id, 
	title, 
	length, 
	name, 
	ROUND(AVG(length) OVER (PARTITION BY name),2) as avg_length_in_category
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
ORDER BY 1


/*
Write a query that returns all payment details, including the number of payments 
that were made by this customer
Order the results by payment_id
*/

SELECT *,
	COUNT(*) OVER (PARTITION BY customer_id, amount)
	FROM payment
ORDER BY 1


/*
RANK
*/

SELECT title, 
length, 
name,
DENSE_RANK() OVER(PARTITION BY name ORDER BY length DESC)
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id


SELECT * FROM (
SELECT title, 
length, 
name,
DENSE_RANK() OVER(PARTITION BY name ORDER BY length DESC) as rank
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id)
WHERE rank =1


/*
Write a query that returns the customers' name, country and how many payments they
have. (Use customer-list view if possible)
*/
SELECT name, country, COUNT(*)
FROM customer_list cl 
LEFT JOIN payment p
ON cl.id = p.customer_id
GROUP BY name, country

/*
Create a ranking of the top customers with the most sales for each country. Filter
the results  only for the top 3 customers per country
*/

SELECT name, country, payment_count,
RANK() OVER(PARTITION BY country ORDER BY payment_count DESC)
FROM (
SELECT cl.name, cl.country, COUNT(p.payment_id) as payment_count
FROM customer_list cl 
LEFT JOIN payment p
ON cl.id = p.customer_id
GROUP BY cl.name, cl.country
) AS subquery


SELECT *,
	SUM(amount) OVER (PARTITION BY customer_id, staff_id)
	FROM payment



/*
Write a query to return the list of movies including film_id, title, length, 
category, the average length of movies in that category.
Order the results by film_id
*/

SELECT 
	f.film_id,
	title, 
	length, 
	name as category,
	ROUND(AVG(length) OVER(PARTITION BY name), 2)
FROM film f
LEFT JOIN film_category fc 
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
ORDER BY 1 



/*
Write a query that returns all the payment details including the number of payments
that were made by this customer and that amount
Order the results by payment_id
*/

SELECT *,
	COUNT(*) OVER(PARTITION BY customer_id, amount)	
	FROM payment
ORDER BY payment_id


-- OVER() with ORDER BY

SELECT *, 
SUM(amount) OVER (ORDER BY payment_date)
FROM payment


-- RANK()
SELECT f.film_id, title, length, name,
	DENSE_RANK() OVER(PARTITION BY name ORDER BY length)
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id


-- 	
SELECT * FROM (SELECT name, country,
COUNT(*),
RANK() OVER(PARTITION BY country ORDER BY COUNT(*)) as rank
FROM customer_list cl
LEFT JOIN payment p 
ON cl.sid = p.customer_id
GROUP BY name, country)
WHERE rank IN (1,2,3)

-- FIRST_VALUE()
SELECT name, country,
COUNT(*),
FIRST_VALUE(COUNT(*)) OVER(PARTITION BY country ORDER BY COUNT(*)) as rank
FROM customer_list cl
LEFT JOIN payment p 
ON cl.sid = p.customer_id
GROUP BY name, country



-- LEAD AND LAG

SELECT name, country,
COUNT(*),
LEAD(name) OVER(PARTITION BY country ORDER BY COUNT(*)) as rank
FROM customer_list cl
LEFT JOIN payment p 
ON cl.sid = p.customer_id
GROUP BY name, country


-- 

SELECT SUM(amount), DATE(payment_date),
LAG(SUM(amount)) OVER(ORDER BY DATE(payment_date)) as previous_day,
SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY DATE(payment_date)) as difference
FROM payment
GROUP BY DATE(payment_date)
ORDER BY 2 ASC

	-- 
SELECT first_name, last_name, staff_id,
	SUM(amount)
	FROM customer c
	LEFT JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY
GROUPING SETS((first_name, last_name), staff_id)














































