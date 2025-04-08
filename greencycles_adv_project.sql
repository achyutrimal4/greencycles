-- Create a list of all the different replacement costs of the films.
-- Whats the lowest replacement cost?
SELECT 
	DISTINCT(replacement_cost), title 
	FROM film
ORDER BY 1


-- Write a query that gives an overview of how many films have replacements 
-- costs in the following cost ranges
-- low: 9.99 - 19.99
-- medium: 20.00 - 24.99
-- high: 25.00 - 29.99
-- Question: How many films have a replacement cost in the "low" group?

SELECT title, replacement_cost, 
	CASE
		WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
		WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
		ELSE 'high'
	END as category
FROM film

SELECT COUNT(*),
	CASE
		WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
		WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
		ELSE 'high'
	END as category
FROM film
GROUP BY category


-- Create a list of the film titles including their title, length and category 
-- name ordered descendingly by the length. Filter the results to only the movies 
-- in the category 'Drama' or 'Sports'.
-- Question: In which category is the longest film and how long is it?

SELECT title, length, name FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE name IN ('Drama', 'Sports')
ORDER BY length DESC

-- Task: Create an overview of how many movies (titles) there are in each 
-- category (name).
-- Question: Which category (name) is the most common among the films? 

SELECT name, COUNT(*)
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
GROUP BY name
ORDER BY count(*) DESC


-- Create an overview of the actors first and last names and in  how many 
-- movies they appear.
-- Question: Which actor is part of most movies?? 

SELECT first_name, last_name, COUNT(*)
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY first_name, last_name
ORDER BY COUNT(*) DESC



-- Create an overview of the addresses that are not associated to any customer.
-- Question: How many addresses are that?

SELECT * FROM address a
LEFT JOIN customer c
ON c.address_id = a.address_id
WHERE c.address_id is NULL



-- Create an overview of the cities and how much sales (sum of amount) 
-- have occured there.
-- Question: Which city has the most sales?

SELECT SUM(amount), city FROM payment p
INNER JOIN rental r 
ON p.rental_id = r.rental_id
INNER JOIN customer c 
ON r.customer_id = c.customer_id
INNER JOIN address a 
ON c.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
GROUP BY city
ORDER BY 1 DESC

-- Create an overview of the revenue (sum of amount) grouped by a column in 
-- the format "country, city".
-- Question: Which country, city has the least sales?

SELECT SUM(amount), country||','||' '||city AS city FROM payment p
INNER JOIN customer c 
ON p.customer_id = c.customer_id
INNER JOIN address a 
ON c.address_id = a.address_id
INNER JOIN city ci 
ON a.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id = co.country_id
GROUP BY 2
ORDER BY 1


-- Create a list with the average of the sales amount each staff_id 
-- 	has per customer.
-- Question: Which staff_id makes in average more revenue per customer?

SELECT AVG(total), staff_id FROM(
SELECT SUM(amount) as total, staff_id, customer_id 
FROM payment
GROUP BY customer_id, staff_id)
GROUP BY staff_id

-- Create a query that shows average daily revenue of all Sundays.
-- Question: What is the daily average revenue of all Sundays?

SELECT AVG(total) 
	FROM (
		SELECT SUM(amount) as total,
		EXTRACT(DOW from payment_date) as sunday,
		DATE(payment_date)
		FROM payment
		WHERE EXTRACT(DOW from payment_date) = 0
		GROUP BY DATE(payment_date), sunday
		)




-- Create a list of movies - with their length and their replacement cost - 
-- that are longer than the average length in each replacement cost group.
-- Question: Which two movies are the shortest in that list and how long are they?

SELECT 
title,
length
FROM film f1
WHERE length > (SELECT AVG(length) FROM film f2
			   WHERE f1.replacement_cost=f2.replacement_cost)
ORDER BY length ASC


-- Create a list that shows how much the average customer spent in total 
-- (customer life-time value) grouped by the different districts.
-- Question: Which district has the highest average customer life-time value?

SELECT district, AVG(total) FROM (
SELECT SUM(amount) as total, district FROM payment p
INNER JOIN customer c 
ON p.customer_id = c.customer_id
INNER JOIN address a 
ON c.address_id = a.address_id
GROUP BY district, p.customer_id)
GROUP BY district
ORDER BY 2 DESC



-- Create a list that shows all payments including the payment_id, 
-- amount and the film category (name) plus the total amount that 
-- was made in this category. Order the results ascendingly by the 
-- category (name) and as second order criterion by the payment_id ascendingly.
-- Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?

SELECT payment_id, amount, name, (
	SELECT SUM(amount) FROM payment p 
INNER JOIN rental r
ON p.rental_id = r.rental_id
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film f 
ON i.film_id = f.film_id
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c1
ON c.category_id = fc.category_id
	WHERE c1.name= c.name
) FROM payment p
INNER JOIN rental r
ON p.rental_id = r.rental_id
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film f 
ON i.film_id = f.film_id
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c 
ON c.category_id = fc.category_id


-- Create a list with the top overall revenue of a film title 
-- (sum of amount per title) for each category (name).
-- Question: Which is the top performing film in the animation category?


SELECT title, amount FROM payment p
INNER JOIN rental r 
ON p.rental_id = r.rental_id
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id	
INNER JOIN film f 
ON i.film_id = f.film_id
INNER JOIN film_category fc 
ON f.film_id = fc.category_id

SELECT * FROM inventory


















