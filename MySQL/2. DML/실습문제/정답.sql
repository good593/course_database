-- MySQL DML/DQL 기초 실습문제 정답

-- 문제 1. CRUD
USE examplesdb;

INSERT INTO students (name, email, birth_date, phone)
VALUES ('실습학생', 'practice@example.com', '2001-01-01', NULL);

UPDATE students
SET phone = '010-9999-9999'
WHERE email = 'practice@example.com';

SELECT
    student_id,
    name,
    email,
    phone
FROM students
WHERE email = 'practice@example.com';

DELETE FROM students
WHERE email = 'practice@example.com';

-- 문제 2. 조건 조회
USE classicmodels;

SELECT
    productCode,
    productName,
    MSRP
FROM products
WHERE MSRP >= 150
ORDER BY MSRP DESC, productName;

SELECT
    productCode,
    productName,
    productLine
FROM products
WHERE productLine IN ('Motorcycles', 'Classic Cars')
ORDER BY productLine, productName;

SELECT
    productName,
    buyPrice
FROM products
WHERE buyPrice BETWEEN 50 AND 100
ORDER BY buyPrice, productName;

SELECT
    productName,
    productLine
FROM products
WHERE productName LIKE '%Ford%'
ORDER BY productName;

-- 문제 3. 집계
SELECT
    productLine,
    COUNT(*) AS product_count
FROM products
GROUP BY productLine
ORDER BY product_count DESC, productLine;

SELECT
    productLine,
    ROUND(AVG(buyPrice), 2) AS average_buy_price
FROM products
GROUP BY productLine
ORDER BY average_buy_price DESC;

SELECT
    customerNumber,
    SUM(amount) AS total_amount
FROM payments
GROUP BY customerNumber
ORDER BY total_amount DESC;

SELECT
    customerNumber,
    COUNT(*) AS order_count
FROM orders
GROUP BY customerNumber
HAVING COUNT(*) >= 5
ORDER BY order_count DESC, customerNumber;

-- 문제 4. 조인
SELECT
    o.orderNumber,
    c.customerName,
    o.orderDate,
    o.status
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
ORDER BY o.orderDate DESC;

SELECT
    c.customerName,
    o.orderNumber,
    p.productName,
    od.quantityOrdered,
    od.priceEach
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
ORDER BY o.orderNumber, od.orderLineNumber;

SELECT
    pl.productLine,
    COUNT(p.productCode) AS product_count
FROM productlines pl
LEFT JOIN products p ON pl.productLine = p.productLine
GROUP BY pl.productLine
ORDER BY product_count DESC, pl.productLine;

SELECT
    c.customerName,
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name,
    o.city AS office_city
FROM customers c
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o ON e.officeCode = o.officeCode
ORDER BY c.customerName;

-- 문제 5. 서브쿼리와 CTE
SELECT
    productCode,
    productName,
    MSRP
FROM products
WHERE MSRP > (
    SELECT AVG(MSRP)
    FROM products
)
ORDER BY MSRP DESC, productName;

SELECT
    customerNumber,
    customerName,
    country
FROM customers
WHERE customerNumber IN (
    SELECT DISTINCT o.customerNumber
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN products p ON od.productCode = p.productCode
    WHERE p.productLine = 'Classic Cars'
)
ORDER BY customerName;

SELECT
    customerNumber,
    customerName
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM payments p
    WHERE p.customerNumber = c.customerNumber
)
ORDER BY customerName;

WITH customer_order_stats AS (
    SELECT
        c.customerNumber,
        c.customerName,
        COUNT(o.orderNumber) AS order_count
    FROM customers c
    LEFT JOIN orders o ON c.customerNumber = o.customerNumber
    GROUP BY c.customerNumber, c.customerName
)
SELECT
    customerNumber,
    customerName,
    order_count
FROM customer_order_stats
WHERE order_count >= 5
ORDER BY order_count DESC, customerName;
