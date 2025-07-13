-- 1. List the first name and last name of all customers.
SELECT first_name, last_name FROM customer;

-- 2. Find all the movies that are currently rented out.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NULL;

-- 3. Show the titles of all movies in the 'Action' category.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- 4. Count the number of films in each category.
SELECT c.name, COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;

-- 5. What is the total amount spent by each customer?
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

-- 6. Find the top 5 customers who spent the most.
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- 7. Display the rental date and return date for each rental.
SELECT rental_date, return_date FROM rental;

-- 8. List the names of staff members and the stores they manage.
SELECT s.first_name, s.last_name, st.store_id
FROM staff s
JOIN store st ON s.store_id = st.store_id;

-- 9. Find all customers living in 'California'.
SELECT c.first_name, c.last_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
WHERE a.district = 'California';

-- 10. Count how many customers are from each city.
SELECT ci.city, COUNT(*) AS customer_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city;

-- 11. Find the film(s) with the longest duration.
SELECT film_id, title, length
FROM film
ORDER BY length DESC
LIMIT 1;

-- 12. Which actors appear in the film titled 'Alien Center'?
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Alien Center';

-- 13. Find the number of rentals made each month.
SELECT DATE_TRUNC('month', rental_date) AS rental_month, COUNT(*) AS rental_count
FROM rental
GROUP BY rental_month
ORDER BY rental_month;

-- 14. Show all payments made by customer 'Mary Smith'.
SELECT p.*
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
WHERE c.first_name = 'MARY' AND c.last_name = 'SMITH';

-- 15. List all films that have never been rented.
SELECT f.title
FROM film f
WHERE f.film_id NOT IN (
    SELECT DISTINCT i.film_id
    FROM inventory i
    JOIN rental r ON i.inventory_id = r.inventory_id
);

-- 16. What is the average rental duration per category?
SELECT c.name, AVG(f.rental_duration) AS avg_duration
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name;

-- 17. Which films were rented more than 50 times?
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
HAVING COUNT(*) > 50;

-- 18. List all employees hired after the year 2005.
SELECT first_name, last_name, hire_date
FROM staff
WHERE hire_date > '2005-12-31';

-- 19. Show the number of rentals processed by each staff member.
SELECT staff_id, COUNT(*) AS rental_count
FROM rental
GROUP BY staff_id;

-- 20. Display all customers who have not made any payments.
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM payment);

-- 21. What is the most popular film (rented the most)?
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 1;

-- 22. Show all films longer than 2 hours.
SELECT title, length
FROM film
WHERE length > 120;

-- 23. Find all rentals that were returned late.
SELECT *
FROM rental
WHERE return_date > rental_date + INTERVAL '3 days';

-- 24. List customers and the number of films they rented.
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS rentals_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.first_name, c.last_name;

-- 25. Show top 3 rented film categories.
SELECT c.name, COUNT(*) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY rental_count DESC
LIMIT 3;

-- 26. Create a view showing customer names and their payment totals.
CREATE VIEW customer_payment_totals AS
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

-- 27. Update a customer's email address given their ID.
UPDATE customer
SET email = 'new_email@example.com'
WHERE customer_id = 1;

-- 28. Insert a new actor into the actor table.
INSERT INTO actor (first_name, last_name, last_update)
VALUES ('John', 'Doe', NOW());

-- 29. Delete all records from rentals where return_date is NULL.
DELETE FROM rental
WHERE return_date IS NULL;

-- 30. Add a new column 'age' to customer table.
ALTER TABLE customer
ADD COLUMN age INTEGER;

-- 31. Create an index on the title column of film table.
CREATE INDEX idx_film_title
ON film (title);

-- 32. Find total revenue generated by each store.
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 33. What city has highest number of rentals?
SELECT ci.city, COUNT(*) AS rental_count
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY rental_count DESC
LIMIT 1;

-- 34. How many films belong to more than one category?
SELECT COUNT(*) 
FROM (
    SELECT film_id
    FROM film_category
    GROUP BY film_id
    HAVING COUNT(category_id) > 1
) sub;

-- 35. Top 10 actors by number of films.
SELECT a.first_name, a.last_name, COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 10;

-- 36. Email addresses of customers who rented 'Matrix Revolutions'.
SELECT DISTINCT c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Matrix Revolutions';

-- 37. Create a function to return customer payment total.
CREATE OR REPLACE FUNCTION get_customer_payment_total(cust_id INT)
RETURNS NUMERIC AS $$
  SELECT SUM(amount) FROM payment WHERE customer_id = cust_id;
$$ LANGUAGE sql;

-- 38. Begin a transaction updating stock & inserting rental.
BEGIN;

UPDATE inventory
SET last_update = NOW()
WHERE inventory_id = 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (NOW(), 1, 1, NULL, 1, NOW());

COMMIT;

-- 39. Customers who rented both Action and Comedy.
SELECT DISTINCT r1.customer_id
FROM rental r1
JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
JOIN film_category fc1 ON i1.film_id = fc1.film_id
JOIN category c1 ON fc1.category_id = c1.category_id
WHERE c1.name = 'Action'
AND r1.customer_id IN (
    SELECT r2.customer_id
    FROM rental r2
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film_category fc2 ON i2.film_id = fc2.film_id
    JOIN category c2 ON fc2.category_id = c2.category_id
    WHERE c2.name = 'Comedy'
);

-- 40. Actors who never acted in a film.
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (SELECT DISTINCT actor_id FROM film_actor);
