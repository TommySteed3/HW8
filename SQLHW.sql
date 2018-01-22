SHOW DATABASES;

USE mysql;
SHOW TABLES;

USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`. 

SELECT first_name, last_name
FROM actor;



-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 

SELECT first_name AS 'Actor Name'
FROM actor
UNION
SELECT last_name
FROM actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
  	
   SELECT first_name, last_name
   FROM actor
   WHERE first_name = 'Joe';
    
    
-- 2b. Find all actors whose last name contain the letters `GEN`:
  	
    SELECT first_name, last_name
    FROM actor
    WHERE last_name LIKE '%GEN%';
    
    
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

    SELECT first_name, last_name
    FROM actor
    WHERE last_name LIKE '%LI%' 
    ORDER BY last_name, first_name;
    
    
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM country
WHERE country IN 
(
SELECT country
FROM country
WHERE country = 'Afghanistan' OR country = 'Bangladesh' OR country = 'China' 
);


-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.

DROP TABLE new_actor;

CREATE TABLE new_actor (

actor_id INTEGER(11), 
first_name VARCHAR(100),
middle_name VARCHAR(100),
last_name VARCHAR(100),
last_update DATETIME

);

INSERT INTO new_actor (actor_id, first_name, middle_name, last_name, last_update)
SELECT actor_id, first_name, middle_name, last_name, last_update
FROM actor;

SELECT * FROM new_actor;

  	
-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

ALTER TABLE new_actor
MODIFY middle_name BLOB;


-- 3c. Now delete the `middle_name` column.

ALTER TABLE new_actor
DROP COLUMN middle_name;


-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*)
FROM new_actor
GROUP BY last_name;

  	
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
  	
SELECT last_name, COUNT(*)
FROM new_actor
GROUP BY last_name
HAVING Count(*) > 1;
    
-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's
-- husband's yoga teacher. Write a query to fix the record.

SELECT actor_id, first_name, last_name
FROM new_actor
WHERE first_name = 'Groucho' AND last_name = 'Williams';
  	
 UPDATE new_actor
 SET first_name = 'Harpo'
 WHERE actor_id = 172;
 
 SELECT * FROM new_actor
 WHERE last_name = 'Williams';
    
    
-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query,
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly
-- what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER!
-- (Hint: update the record using a unique identifier.)


UPDATE new_actor
SET first_name =
CASE WHEN actor_id = 172 AND first_name = 'Harpo'
THEN 'Groucho'
ELSE 
CASE WHEN actor_id = 172 AND first_name <> 'Harpo'
THEN 'Mucho Grouch'
ELSE first_name
END
END;


SELECT * FROM new_actor
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'address';


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;



-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

SELECT staff.staff_id, sum(amount) AS total_payments
FROM staff INNER Join payment ON staff.staff_id = payment.staff_id
WHERE month(payment_date) = 8 AND year(payment_date) = 2005
GROUP BY staff_id;


  	
-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
  	
SELECT film.title, COUNT(film_actor.actor_id) AS number_of_actors
FROM film INNER Join film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;
    
    
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT film.title, COUNT(inventory.store_id) AS number_of_copies
FROM film INNER Join inventory ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible'
GROUP BY film.title;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer.
-- List the customers alphabetically by last name:

SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_paid
FROM payment INNER Join customer ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY customer.last_name, customer.first_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with
-- the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` 
-- whose language is English. 

SELECT * FROM film

WHERE title IN (
	SELECT title FROM film
	WHERE title LIKE 'Q%' OR title LIKE 'K%'
    )

AND language_id = 1;


-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
   
   SELECT first_name, last_name FROM actor
		WHERE actor_id IN (
				SELECT actor_id FROM film_actor
						WHERE film_id IN (
								SELECT film_id FROM film
        WHERE title = "Alone Trip"
	)
);
   
   
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
-- Use joins to retrieve this information.


SELECT customer.last_name, customer.first_name, customer.email
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy 
-- films.


SELECT film.title 
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';



-- 7e. Display the most frequently rented movies in descending order.
  	
SELECT film.title, COUNT(film.title) AS rentals
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON inventory.inventory_id = rental.rental_id
GROUP BY film.title;

    
-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, SUM(payment.amount) as total_business
FROM store
INNER JOIN inventory ON inventory.store_id = store.store_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.
  	
    SELECT store.store_id, city.city, country.country
    FROM store
    INNER JOIN address ON store.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    GROUP BY store.store_id;
    
    
-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)
  	

    SELECT SUM(payment.amount) as gross_revenue, category.name
    FROM payment
    INNER JOIN rental ON payment.rental_id = rental.rental_id
    INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN film_category ON inventory.film_id = film_category.film_id
    INNER JOIN category ON film_category.category_id = category.category_id
    GROUP BY (category.name)
    ORDER BY gross_revenue DESC LIMIT 5;
    
    
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_5 AS

    SELECT SUM(payment.amount) as gross_revenue, category.name
    FROM payment
    INNER JOIN rental ON payment.rental_id = rental.rental_id
    INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN film_category ON inventory.film_id = film_category.film_id
    INNER JOIN category ON film_category.category_id = category.category_id
    GROUP BY (category.name)
    ORDER BY gross_revenue DESC LIMIT 5;




-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_5;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW top_5;
