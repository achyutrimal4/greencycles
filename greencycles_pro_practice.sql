/*
In your company, there hasn't been a database table with all 
the employee information yet.
You need to set up the table called employees in the following way:
emp_id-PK, first_name, last_name, job_position, salary, start_date, birth_date, 
store_id, department_id, manager_id, 
There should be NOT NULL constraints for the following columns:
first_name,
last_name ,
job_position,
start_date DATE,
birth_date DATE 
*/

CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	job_position VARCHAR(50) NOT NULL, 
	salary DECIMAL(8,2),
	start_date DATE,
	birth_date DATE,
	store_id INT,
	department_id INT, 
	manager_id INT
)

SELECT * FROM employees

/*
Set up an additional table called departments in the following way:
department_id PK, department-text, division-text
Additionally no column should allow nulls.
*/
CREATE TABLE departments(
	department_id SERIAL PRIMARY KEY,
	department VARCHAR(50),
	division VARCHAR(50)
)

ALTER TABLE departments
ALTER COLUMN department SET NOT NULL,
ALTER COLUMN division SET NOT NULL

/*
Alter the employees table in the following way:
- Set the column department_id to not null.
- Add a default value of CURRENT_DATE to the column start_date.
- Add the column end_date with an appropriate data type 
(one that you think makes sense).
- Add a constraint called birth_check that doesn't allow birth dates
that are in the future birth dates and change job_position to position_title.
*/

ALTER TABLE employees
ALTER COLUMN department_id SET NOT NULL,
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE

ALTER TABLE employees
ADD CONSTRAINT birth_check CHECK (birth_date<CURRENT_DATE)

ALTER TABLE employees
ADD COLUMN end_date DATE

ALTER TABLE employees
RENAME COLUMN job_position TO position_title

/*
Insert the following values into the employees table.
There will be most likely an error when you try to insert the values.
So, try to insert the values and then fix the error.
*/

INSERT INTO employees (emp_id,first_name,last_name,position_title,salary,start_date,birth_date,store_id,department_id,manager_id,end_date)
VALUES
(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
(6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
(7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
(8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
(9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
(10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,'2013-04-14'),
(11,'Carlyn','Stripp','Customer Support',3060.00,'2013-09-06','1981-09-05',1,5,3,NULL),
(12,'Reuben','McRorie','Software Engineer',7119.00,'1995-12-31','1958-08-15',1,5,6,NULL),
(13,'Gates','Raison','Marketing Specialist',3910.00,'2013-07-18','1986-06-24',1,3,3,NULL),
(14,'Jordanna','Raitt','Marketing Specialist',5844.00,'2011-10-23','1993-03-16',2,3,3,NULL),
(15,'Guendolen','Motton','BI Consultant',8330.00,'2011-01-10','1980-10-22',2,3,6,NULL),
(16,'Doria','Turbat','Senior SQL Analyst',9278.00,'2010-08-15','1983-01-11',1,1,6,NULL),
(17,'Cort','Bewlie','Project Manager',5463.00,'2013-05-26','1986-10-05',1,5,3,NULL),
(18,'Margarita','Eaden','SQL Analyst',5977.00,'2014-09-24','1978-10-08',2,1,6,'2020-03-16'),
(19,'Hetty','Kingaby','SQL Analyst',7541.00,'2009-08-17','1999-04-25',1,2,6,NULL),
(20,'Lief','Robardley','SQL Analyst',8981.00,'2002-10-23','1971-01-25',2,3,6,'2016-07-01'),
(21,'Zaneta','Carlozzi','Working Student',1525.00,'2006-08-29','1995-04-16',1,3,6,'2012-02-19'),
(22,'Giana','Matz','Working Student',1036.00,'2016-03-18','1987-09-25',1,3,6,NULL),
(23,'Hamil','Evershed','Web Developper',3088.00,'2022-02-03','2012-03-30',1,4,2,NULL),
(24,'Lowe','Diamant','Web Developper',6418.00,'2018-12-31','2002-09-07',1,4,2,NULL),
(25,'Jack','Franklin','SQL Analyst',6771.00,'2013-05-18','2005-10-04',1,2,2,NULL),
(26,'Jessica','Brown','SQL Analyst',8566.00,'2003-10-23','1965-01-29',1,1,2,NULL)


/*
Insert the following values into the departments table.
*/
INSERT INTO departments(department_id, department, division)
VALUES
(1, 'Analytics', 'IT'),
(2, 'Finance', 'Administration'),
(3, 'Sales', 'Sales'),
(4, 'Website', 'IT'),
(5, 'Back Office', 'Administration')



/*
Jack Franklin gets promoted to 'Senior SQL Analyst' and the salary raises to 7200.
Update the values accordingly.
*/
UPDATE employees
SET position_title = 'Senior SQL Analyst',
	salary = 7200
WHERE first_name = 'Jack' AND last_name = 'Franklin'


/*
The responsible people decided to rename the position_title 
Customer Support to Customer Specialist.
Update the values accordingly.
*/

UPDATE employees
SET position_title = 'Customer Specialist'
WHERE position_title = 'Customer Support'

SELECT * FROM employees


/*
All SQL Analysts including Senior SQL Analysts get a raise of 6%.
Update the salaries accordingly.
*/

UPDATE employees
SET salary = salary+(0.06*salary)
WHERE position_title = 'SQL Analyst' OR position_title = 'Senior SQL Analyst'


SELECT * FROM employees


/*
What is the average salary of a SQL Analyst in the company 
(excluding Senior SQL Analyst)?
*/

SELECT ROUND(AVG(salary),2) FROM employees
WHERE position_title = 'SQL Analyst'


/*
Write a query that adds a column called manager that contains  first_name and 
last_name (in one column) in the data output.
Secondly, add a column called is_active with 'false' if the employee has left 
the company already, otherwise the value is 'true'.
*/

SELECT emp.*,
CASE
WHEN emp.end_date is NULL THEN 'True'
ELSE 'False'
END as is_active,
mng.first_name||' '||mng.last_name as manager_name
FROM employees emp
LEFT JOIN employees mng
ON emp.manager_id = mng.emp_id

/*
Create a view called v_employees_info from that previous query.
*/
CREATE VIEW v_employees_info AS SELECT emp.*,
CASE
WHEN emp.end_date is NULL THEN 'True'
ELSE 'False'
END as is_active,
mng.first_name||' '||mng.last_name as manager_name
FROM employees emp
LEFT JOIN employees mng
ON emp.manager_id = mng.emp_id



/*
Write a query that returns the average salaries for each positions with 
appropriate roundings.
*/

SELECT * , ROUND(AVG(salary) OVER(PARTITION BY position_title),2)
FROM employees



/*
What is the average salary for a Software Engineer in the company.
*/

SELECT ROUND(AVG(salary),2) FROM employees
WHERE position_title = 'Software Engineer'

/*
Write a query that returns the average salaries per division.
*/
SELECT salary, division,
	ROUND(AVG(salary) OVER(PARTITION BY division),2)
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id


/*
Write a query that returns the following:
emp_id,
first_name,
last_name,
position_title,
salary
and a column that returns the average salary for every job_position.
Order the results by the emp_id.
*/

SELECT emp_id,
first_name, 
last_name, 
position_title,
salary,
ROUND(AVG(salary) OVER(PARTITION BY position_title), 2)
FROM employees
ORDER BY 1



/*
How many people earn less than their avg_position_salary?
Write a query that answers that question.
Ideally the output just shows that number directly.
*/


SELECT first_name, last_name, salary
FROM employees e1
WHERE salary <(
	SELECT AVG(salary) FROM employees e2
	WHERE e1.position_title = e2.position_title
)


/*
Write a query that returns a running total of the salary development 
ordered by the start_date.
In your calculation, disregard that fact that people have left the 
company (write the query as if they were still working for the company).
*/


SELECT emp_id, salary, start_date, 
SUM(salary) OVER(ORDER BY start_date)
FROM employees

/*
Create the same running total but now also considder the fact that people 
were leaving the company.
*/

SELECT 
start_date,
SUM(salary) OVER(ORDER BY start_date)
FROM (
SELECT 
emp_id,
salary,
start_date
FROM employees
UNION 
SELECT 
emp_id,
-salary,
end_date
FROM v_employees_info
WHERE is_active ='false'
ORDER BY start_date) a 


/*
Write a query that outputs only the top earner per position_title including 
first_name and position_title and their salary.
*/

SELECT first_name, position_title, salary FROM 
employees e1
WHERE salary = (
	SELECT MAX(salary) FROM employees e2
	WHERE
	e1.position_title = e2.position_title
)

/*
Add also the average salary per position_title.
*/
SELECT first_name, position_title, salary,
ROUND(AVG(salary) OVER(PARTITION BY position_title),2)
FROM 
employees e1
WHERE salary = (
	SELECT MAX(salary) FROM employees e2
	WHERE
	e1.position_title = e2.position_title
)
































