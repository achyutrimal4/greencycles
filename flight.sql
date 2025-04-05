SELECT 
COUNT(*),
CASE
	WHEN actual_departure is null THEN 'No departure information'
	WHEN (actual_departure - scheduled_departure) < '00:05:00' THEN 'On time'
	WHEN (actual_departure - scheduled_departure) < '01:00:00' THEN 'A little late'
	ELSE 'Very late'
END as is_late
FROM flights
GROUP BY is_late


-- categorize the sold tickets into low, mid, and high range
SELECT COUNT(*),
CASE
	WHEN total_amount<20000 THEN 'low price ticket'
	WHEN (total_amount>20000 AND total_amount<150000)THEN 'Mid price ticket'
	ELSE 'High price ticket'
END as tickets
FROM bookings
GROUP BY tickets

-- flights in different seasons
SELECT COUNT(*),
CASE
	WHEN TO_CHAR(actual_departure, 'Mon') IN ('Dec','Jan', 'Feb') THEN 'Winter'
	WHEN TO_CHAR(actual_departure, 'Mon') IN ('Mar','Apr', 'May') THEN 'Spring'
	WHEN TO_CHAR(actual_departure, 'Mon') IN ('Jun','Jul', 'Aug') THEN 'Summer'
	WHEN TO_CHAR(actual_departure, 'Mon') IN ('Sep','Oct', 'Nov') THEN 'Fall'
END as month_of_dep
FROM flights
GROUP BY month_of_dep


-- COALESCE
SELECT
COALESCE(CAST(actual_arrival-scheduled_arrival, 'not arrived'), VARCHAR)
FROM
flights

-- INNER JOIN
SELECT fare_conditions, count(*) FROM seats s
INNER JOIN	boarding_passes bp
ON s.seat_no = bp.seat_no
GROUP BY fare_conditions

-- OUTER JOIN
-- boarding passes not related to tickets
SELECT * FROM boarding_passes b
FULL OUTER JOIN tickets t ON
b.ticket_no = t.ticket_no
WHERE b.ticket_no is NULL

-- LEFT JOIN
-- Aircraft with no flight record
SELECT * FROM aircrafts_data a
LEFT JOIN flights f ON 
a.aircraft_code = f.aircraft_code
WHERE f.flight_id IS NULL


-- Most popular seats
SELECT s.seat_no, COUNT(*) FROM seats s
LEFT JOIN boarding_passes b
ON s.seat_no = b.seat_no
GROUP BY s.seat_no
ORDER BY 2 DESC

-- Average price for different seat_no

SELECT b.seat_no, ROUND(AVG(t.amount), 2) FROM boarding_passes b
LEFT JOIN ticket_flights t 
ON t.ticket_no = b.ticket_no
	AND b.flight_id = t.flight_id
GROUP BY 1 
ORDER BY 2 DESC

-- joining multiple tables
SELECT b.ticket_no, passenger_name, scheduled_arrival FROM tickets t
INNER JOIN boarding_passes b 
ON t.ticket_no = b.ticket_no
INNER JOIN ticket_flights tf 
ON b.flight_id = tf.flight_id
INNER JOIN flights f 
ON tf.flight_id = f.flight_id

























