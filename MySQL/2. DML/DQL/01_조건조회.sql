-- MySQL DQL 기초 01
-- 조건 조회: WHERE, ORDER BY, LIMIT

USE classicmodels;

-- 상품 목록 확인
SELECT
    productCode,
    productName,
    productLine,
    buyPrice,
    MSRP
FROM products
ORDER BY productCode
LIMIT 10;

-- 필요한 컬럼만 선택하기
SELECT
    customerNumber,
    customerName,
    country,
    creditLimit
FROM customers
ORDER BY customerNumber
LIMIT 10;

-- 비교 조건: MSRP가 150 이상인 상품
SELECT
    productCode,
    productName,
    MSRP
FROM products
WHERE MSRP >= 150
ORDER BY MSRP DESC, productName
LIMIT 20;

-- AND, OR 조건
SELECT
    productName,
    productLine,
    quantityInStock,
    buyPrice
FROM products
WHERE productLine = 'Motorcycles'
   OR buyPrice >= 100
ORDER BY buyPrice DESC
LIMIT 20;

-- IN 조건
SELECT
    customerName,
    country
FROM customers
WHERE country IN ('USA', 'France', 'Japan')
ORDER BY country, customerName
LIMIT 30;

-- BETWEEN 조건
SELECT
    productName,
    buyPrice
FROM products
WHERE buyPrice BETWEEN 50 AND 100
ORDER BY buyPrice, productName
LIMIT 20;

-- 문자열 패턴 검색
SELECT
    productName,
    productLine
FROM products
WHERE productName LIKE '%Ford%'
ORDER BY productName;

-- NULL 조회
SELECT
    orderNumber,
    orderDate,
    shippedDate,
    status
FROM orders
WHERE shippedDate IS NULL
ORDER BY orderDate;

-- LIMIT으로 일부만 조회
SELECT
    checkNumber,
    customerNumber,
    amount,
    paymentDate
FROM payments
ORDER BY amount DESC, paymentDate
LIMIT 10;
