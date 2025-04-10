CREATE TABLE director(
	director_id SERIAL PRIMARY KEY, 
	director_account_name VARCHAR (20) UNIQUE,
	first_name VARCHAR(50),
	last_name VARCHAR(50) DEFAULT 'Not Specified',
	date_of_birth DATE,
	address_id INT REFERENCES address(address_id)
)


/* ALTER TABLE Exercises
1. director_account_name to VARCHAR(30)
2. Drop the default on last_name
3. add the constraint not null to last name
4. add email column varchar(60)
5. rename director_account_name to account_name
6. rename table director to directors
*/

ALTER TABLE director
ALTER COLUMN director_account_name TYPE VARchar(30),
ALTER COLUMN last_name DROP DEFAULT,
ALTER COLUMN last_name SET NOT NULL,
ADD COLUMN email VARCHAR(60)

ALTER TABLE director
RENAME COLUMN director_account_name to account_name

ALTER TABLE director
RENAME TO directors



-- Create a table called songs
	
CREATE TABLE songs(
	song_id SERIAL PRIMARY KEY,
	song_name VARCHAR(30) NOT NULL,
	genre VARCHAR(30) DEFAULT 'Not Defined',
	price DECIMAL(4,2) CHECK (price>=1.99),
	release_date DATE CHECK (
		release_date >=DATE'01-01-1950' AND release_date<= CURRENT_DATE)
) 

SELECT * FROM songs

INSERT INTO songs (song_name, price, release_date)
VALUES('SQL SONG', 0.99, '2022-01-07')

ALTER TABLE songs
DROP CONSTRAINT songs_price_check


ALTER TABLE songs
ADD CONSTRAINT price_check CHECK (price>=0.99)


/*
Update all the rental prices from 0.99 to 1.99
For customer table
	Add column Initials Varchar(10)
	Update the values to the actual initials
*/

UPDATE film
SET rental_rate = 1.99 
WHERE rental_rate = 0.99

ALTER TABLE customer
ADD COLUMN initials VARCHAR(10)

UPDATE customer
SET initials = LEFT(first_name, 1)||'.'||LEFT(last_name, 1)

SELECT initials, first_name, last_name FROM customer
ORDER BY customer_id ASC


DELETE FROM payment
WHERE payment_id IN (17064, 17067)


-- CREATE TABLE AS
CREATE VIEW customer_spendings AS
SELECT first_name||last_name , SUM(amount)
FROM payment p 
LEFT JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY 1


/*
Create a view called films_category that shows a list of the film 
titles including their title, length and category name ordered 
descendingly by the length.

Filter the results to only the movies in the category 'Action' and 'Comedy'.
*/


CREATE VIEW films_category 
AS
SELECT title, length, name FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id

SELECT * FROM films_category
WHERE name in ('Action', 'Comedy')






CREATE VIEW v_customer_info
AS
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id

ALTER VIEW v_customer_info
RENAME TO v_customer_information

ALTER VIEW v_customer_information
RENAME COLUMN customer_id to c_id

CREATE OR REPLACE VIEW v_customer_information
AS
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    cu.initials,
	a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id






























