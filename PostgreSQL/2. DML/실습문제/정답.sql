-- PostgreSQL DML/DQL 기초 실습문제 정답

-- 문제 1. CRUD
INSERT INTO students (name, email, birth_date, phone)
VALUES ('실습학생', 'practice@example.com', '2001-01-01', NULL)
RETURNING student_id, name, email;

UPDATE students
SET phone = '010-9999-9999'
WHERE email = 'practice@example.com'
RETURNING student_id, name, phone;

SELECT
    student_id,
    name,
    email,
    phone
FROM students
WHERE email = 'practice@example.com';

DELETE FROM students
WHERE email = 'practice@example.com'
RETURNING student_id, name, email;

-- 문제 2. 조건 조회
SELECT
    title,
    rental_rate
FROM film
WHERE rental_rate >= 4.99
ORDER BY rental_rate DESC, title;

SELECT
    title,
    rating
FROM film
WHERE rating IN ('PG', 'PG-13')
ORDER BY rating, title;

SELECT
    title,
    length
FROM film
WHERE length BETWEEN 60 AND 90
ORDER BY length, title;

SELECT
    first_name,
    last_name,
    email
FROM customer
WHERE first_name ILIKE 'ann%'
ORDER BY first_name, last_name;

-- 문제 3. 집계
SELECT
    rating,
    COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC, rating;

SELECT
    rating,
    ROUND(AVG(length), 2) AS average_length
FROM film
WHERE length IS NOT NULL
GROUP BY rating
ORDER BY average_length DESC;

SELECT
    customer_id,
    SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC;

SELECT
    customer_id,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 30
ORDER BY rental_count DESC, customer_id;

-- 문제 4. 조인
SELECT
    r.rental_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    f.title AS film_title,
    r.rental_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY r.rental_date DESC;

SELECT
    p.payment_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    s.first_name || ' ' || s.last_name AS staff_name,
    p.amount,
    p.payment_date
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN staff s ON p.staff_id = s.staff_id
ORDER BY p.payment_date DESC;

SELECT
    c.name AS category_name,
    COUNT(f.film_id) AS film_count
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name
ORDER BY film_count DESC, category_name;

SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    a.address,
    ci.city,
    co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY c.customer_id;

-- 문제 5. 서브쿼리와 CTE
SELECT
    title,
    rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
)
ORDER BY rental_rate DESC, title;

SELECT
    title,
    rating,
    rental_rate
FROM film
WHERE film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
)
ORDER BY title;

SELECT
    rental_id,
    customer_id,
    rental_date,
    return_date
FROM rental r
WHERE EXISTS (
    SELECT 1
    FROM payment p
    WHERE p.rental_id = r.rental_id
)
ORDER BY rental_date DESC;

WITH customer_rental_stats AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(r.rental_id) AS rental_count
    FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    rental_count
FROM customer_rental_stats
WHERE rental_count >= 30
ORDER BY rental_count DESC, customer_name;
