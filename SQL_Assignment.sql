-- SQL ASSIGNMENT

create table Employees
(Emp_ID int primary key,
Emp_Name char(200) not null,
Age int check (Age>= 18),
Email varchar(200) unique,
Salary decimal(10,2) default 30000
);

/*2. 
Purpose of Constraints
Constraints help maintain data integrity by enforcing rules at the database level. 
Examples include:-

PRIMARY KEY: Ensures uniqueness and prevents NULL values.
FOREIGN KEY: Enforces referential integrity between tables.
NOT NULL: Prevents missing values in a column.
CHECK: Ensures specific conditions (e.g., age ≥ 18).
UNIQUE: Prevents duplicate values in a column.
NOT NULL & Primary Key Constraints
*/

/*3
NOT NULL constraint ensures that a column cannot store NULL values.
A PRIMARY KEY cannot contain NULL values because it uniquely identifies each record. 
A NULL value would mean an undefined identity, violating uniqueness.*/

/*4*/
alter table employees add constraint chk_salary check (salary >=30000);
alter table employees drop constraint chk_salary;

/*5*/
alter table products add primary key (product_id);
alter table products alter column price set default 50;

/*6*/
select student_name , class_name 
from Students as a
inner join Classes as b
on a.Class_id = b.Class_id;

/*7*/
select order_id , customer_name, product_name 
from Products as a
left join Orders as b
on a.order_id = b.order_id
inner join Customers as c
on b.customer_id = c.customer_id;

/*7*/
select product_name, sum(b.amount) as Total_Sales
from Products as a
inner join Sales as b
on a.product_id = b.product_id
group by product_name;

/*8*/
select order_id, customer_name, quantity
from orders as a 
inner join Order_Details as b
on a.order_id = b.order_id
inner join Customers as c
on a.customer_id = c.customer_id
group by Customer_name;

/* Basic Aggregate Functions*/
/* 1.*/
select count(rental_id) from sakila.rental;

/* 2.*/
select avg(rental_date) from sakila.rental;

/* 3.*/
select upper(first_name), upper(last_name) from sakila.customer;

/* 4.*/
select month(rental_date),rental_id from sakila.rental;

/* 5.*/
SELECT customer_id, COUNT(*) FROM rental GROUP BY customer_id;

/* 6.*/
SELECT store_id, SUM(amount) FROM payment GROUP BY store_id;

/* 7.*/
SELECT category.name, COUNT(*)  
FROM rental  
JOIN inventory ON rental.inventory_id = inventory.inventory_id  
JOIN film ON inventory.film_id = film.film_id  
JOIN film_category ON film.film_id = film_category.film_id  
JOIN category ON film_category.category_id = category.category_id  
GROUP BY category.name;

/* 8.*/
SELECT language.name, AVG(film.rental_rate)  
FROM film  
JOIN language ON film.language_id = language.language_id  
GROUP BY language.name;

/* Joins */

/* 9.*/
SELECT film.title, customer.first_name, customer.last_name
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN customer ON rental.customer_id = customer.customer_id;

/* 10.*/
SELECT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Gone with the Wind';

/* 11.*/
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_spent
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id;

/* 12.*/
SELECT film.title, customer.first_name, customer.last_name, city.city
FROM rental
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE city.city = 'London';

/* 13.*/
SELECT customer.customer_id, customer.first_name, customer.last_name
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE store.store_id IN (1, 2)
GROUP BY customer.customer_id
HAVING COUNT(DISTINCT store.store_id) = 2;

/* 14.*/
SELECT customer.customer_id, customer.first_name, customer.last_name
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE store.store_id IN (1, 2)
GROUP BY customer.customer_id
HAVING COUNT(DISTINCT store.store_id) = 2;

/* Window Functions.*/
select customer_id, sum(amount) as Total_Sales,
rank() over (order by Total_Sales) as Ranking
from payment
group by customer_id;


-- Cumulative revenue per film

SELECT film_id, SUM(amount) OVER (PARTITION BY film_id ORDER BY rental_date) AS cumulative_revenue  
FROM payment  
JOIN rental ON payment.rental_id = rental.rental_id;

-- Top 3 films in each category by rental count

SELECT category.name, film.title, COUNT(*) AS rental_count,  
RANK() OVER (PARTITION BY category.name ORDER BY COUNT(*) DESC) AS ranking  
FROM rental  
JOIN inventory ON rental.inventory_id = inventory.inventory_id  
JOIN film ON inventory.film_id = film.film_id  
JOIN film_category ON film.film_id = film_category.film_id  
JOIN category ON film_category.category_id = category.category_id  
GROUP BY category.name, film.title;


-- Common Table Expressions (CTEs)

-- CTE to get actors and movie count

WITH ActorMovies AS (
    SELECT actor_id, COUNT(film_id) AS movie_count
    FROM film_actor GROUP BY actor_id
)
SELECT actor.first_name, actor.last_name, movie_count
FROM actor
JOIN ActorMovies ON actor.actor_id = ActorMovies.actor_id;

-- CTE to list customers with more than 2 rentals

WITH FrequentRenters AS (
    SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > 2
)
SELECT customer.* FROM customer
JOIN FrequentRenters ON customer.customer_id = FrequentRenters.customer_id;

