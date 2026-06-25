-- MySQL DQL 기초 03
-- 조인: INNER JOIN, LEFT JOIN, SELF JOIN

USE classicmodels;

-- 주문 목록: 고객 + 주문
SELECT
    o.orderNumber,
    c.customerName,
    o.orderDate,
    o.status
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
ORDER BY o.orderDate DESC
LIMIT 20;

-- 주문 상세: 고객 + 주문 + 상품
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
ORDER BY o.orderNumber, od.orderLineNumber
LIMIT 30;

-- 상품 라인별 상품 수: 상품이 없는 라인도 확인할 수 있도록 LEFT JOIN 사용
SELECT
    pl.productLine,
    COUNT(p.productCode) AS product_count
FROM productlines pl
LEFT JOIN products p ON pl.productLine = p.productLine
GROUP BY pl.productLine
ORDER BY product_count DESC, pl.productLine;

-- 고객 담당 직원과 사무실
SELECT
    c.customerName,
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name,
    e.jobTitle,
    o.city AS office_city,
    o.country AS office_country
FROM customers c
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o ON e.officeCode = o.officeCode
ORDER BY c.customerName
LIMIT 30;

-- SELF JOIN: 직원과 상급자
SELECT
    CONCAT(e.firstName, ' ', e.lastName) AS employee_name,
    e.jobTitle,
    CONCAT(m.firstName, ' ', m.lastName) AS manager_name
FROM employees e
LEFT JOIN employees m ON e.reportsTo = m.employeeNumber
ORDER BY manager_name, employee_name;
