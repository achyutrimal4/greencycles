--User defined functions


CREATE FUNCTION movie_rental_rates(min_rate INT, max_rate INT)
RETURNS INT
LANGUAGE plpgsql
AS
$$
DECLARE movie_count INT;
BEGIN
SELECT COUNT(*)
INTO movie_count
FROM film
WHERE rental_rate BETWEEN min_rate AND max_rate;
END;
$$;



/*
Create a function that expects the customer's firt_name and last_name
and returns the total amount of payments this customer has made
*/

DROP FUNCTION total_payment(f_name VARCHAR(20), l_name VARCHAR(20))

CREATE OR REPLACE FUNCTION total_payment(f_name VARCHAR(20), l_name VARCHAR(20))
RETURNS decimal(6,2)
LANGUAGE plpgsql
AS
$$
DECLARE 
	total_amount decimal(6,2);
BEGIN
	SELECT SUM(amount)
	INTO total_amount	
	FROM payment p
	NATURAL LEFT JOIN customer c
	WHERE c.first_name = f_name AND c.last_name = l_name;
	 RETURN COALESCE(total_amount, 0.00);
END;
$$;


SELECT total_payment('JARED','ELY' )

SELECT * FROM customer



CREATE TABLE acc_balance(
	id SERIAL PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	amount DECIMAL(9,2) NOT NULL
);

INSERT INTO acc_balance
VALUES
(1, 'Tim', 'Brown', 2500),
(2, 'Lucy', 'Fen', 5200)

SELECT * FROM acc_balance

BEGIN;
UPDATE acc_balance
SET amount = amount-100
WHERE id=1

COMMIT;


/*
The two employees Miller McQuarter and Christalle McKenny have agreed to swap their
positions including their salary
*/
	
SELECT first_name, last_name, position_title, salary FROM employees
WHERE first_name IN ('Miller', 'Christalle')

BEGIN;

UPDATE employees
SET position_title = 'Head of Sales' WHERE first_name = 'Miller';
UPDATE employees
SET position_title='Head of BI'
WHERE first_name = 'Christalle'

UPDATE employees
SET salary = '12587' WHERE first_name = 'Miller';

UPDATE employees
SET salary='14614'
WHERE first_name = 'Christalle'

COMMIT


-- STORED PROCEDURE
CREATE PROCEDURE sp_transfer(tr_amount INT, sender INT, recipent INT)
LANGUAGE plpgsql
AS
$$
BEGIN
-- substract from sender's balance
UPDATE acc_balance
SET amount = amount-tr_amount
WHERE id = sender;

-- add to recipient's balance
UPDATE acc_balance
SET amount = amount+tr_amount
where id = recipent;

COMMIT;
END;
$$;


CALL sp_transfer(100,1,2)

SELECT * FROM acc_balance


/*
CREATE A STORED PROCEDURE CALLED emp_swap that accepts two parameters emp1 and
emp2 as input and swaps the two employees position and salary.
Test it with id 2 and 3
*/

CREATE OR REPLACE PROCEDURE emp_swap(emp1 INT, emp2 INT)
LANGUAGE plpgsql
AS 
$$

DECLARE
salary1 DECIMAL(8,2);
salary2 DECIMAL(8,2);
position1 TEXT;
position2 TEXT;

BEGIN
SELECT salary INTO salary1
FROM employees WHERE emp_id = emp1;

SELECT salary INTO salary2
FROM employees WHERE emp_id = emp2;

SELECT position_title INTO position1
FROM employees WHERE emp_id = emp1;

SELECT position_title INTO position2
FROM employees WHERE emp_id = emp2;

UPDATE employees
SET position_title = position2
WHERE emp_id = emp1;

UPDATE employees
SET position_title = position1
WHERE emp_id = emp2;

UPDATE employees
SET salary = salary1
WHERE emp_id = emp1;

UPDATE employees
SET salary = salary2
WHERE emp_id = emp2;

COMMIT;
END;
$$;

CALL emp_swap(2,3)


SELECT * FROM employees
ORDER BY 1









