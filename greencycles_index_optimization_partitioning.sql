-- USER MANAGEMENT

CREATE USER achyut
WITH password 'admin123'


CREATE USER mike
WITH PASSWORD 'mike123';


CREATE ROLE read_only;
CREATE ROLE read_update;


GRANT USAGE 
ON SCHEMA public
TO read_only;


-- Grant select on tables
GRANT SELECT
ON ALL TABLES IN SCHEMA public
TO read_only; 


GRANT read_only to mike;

-- INDEXES
SELECT(
	SELECT AVG(amount)
	FROM payment p2
	WHERE p2.rental_id = p1.rental_id
)
FROM payment p1




CREATE INDEX index_rental_id_payment
ON payment
(rental_id)













































