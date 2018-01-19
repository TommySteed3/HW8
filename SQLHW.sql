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


  	
-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
  	
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
