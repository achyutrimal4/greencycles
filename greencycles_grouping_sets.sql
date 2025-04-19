SELECT  
TO_CHAR(payment_date, 'Month')as month,
staff_id,
SUM(amount)
FROM payment
GROUP BY
GROUPING SETS(
	(staff_id),
	(month),
	(staff_id, month)	
)
ORDER BY 1



/*
Write a query that returns the sum of the amount for each customer (firstname and 
lastname) and each staff_id. Also add the overall revenue per customer
*/


SELECT first_name, last_name, SUM(amount), staff_id FROM customer c
LEFT JOIN payment p on c.customer_id = p.customer_id
GROUP BY
GROUPING SETS(
	(first_name, last_name, staff_id),
	(first_name, last_name)
)
ORDER BY 1,2


-- ROLLUP

SELECT 'Q'||TO_CHAR(payment_date, 'Q') as quarter,
EXTRACT(month FROM payment_date) as month,
DATE(payment_date),
SUM(amount)
FROM payment
GROUP BY
ROLLUP(
'Q'||TO_CHAR(payment_date, 'Q'),
EXTRACT(month FROM payment_date),
DATE(payment_date)
)
ORDER BY 1,2,3


-- CUBE
SELECT customer_id,
staff_id, 
DATE(payment_date),
SUM(amount)
FROM payment
GROUP BY
CUBE(
customer_id,
staff_id, 
DATE(payment_date) 
)
ORDER BY 1,2,3


-- 
SELECT c.customer_id, DATE(payment_date),title, SUM(amount)
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
LEFT JOIN rental r 
ON p.rental_id = r.rental_id
LEFT JOIN inventory i 
ON r.inventory_id = i.inventory_id 
LEFT JOIN film f
ON i.film_id = f.film_id
GROUP BY
CUBE(c.customer_id, DATE(payment_date), title)
ORDER BY 1,2,3

-- SELF JOIN

SELECT f1.title, f2.title, f1.length FROM film f1
LEFT JOIN film f2
ON f1.length = f2.length
AND f1.title <> f2.title
ORDER BY length DESC


-- CROSS JOIN
SELECT staff_id,
	store.store_id,
	last_name
	FROM staff
CROSS JOIN store

-- Natural join
SELECT first_name, last_name, amount FROM customer
NATURAL JOIN payment



















































