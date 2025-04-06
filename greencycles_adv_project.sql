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

-- Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".
-- Question: Which country, city has the least sales?



























































