-- MySQL DQL 기초 02
-- 집계: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING

USE classicmodels;

-- 전체 상품 수
SELECT COUNT(*) AS product_count
FROM products;

-- 상품 라인별 상품 수
SELECT
    productLine,
    COUNT(*) AS product_count
FROM products
GROUP BY productLine
ORDER BY product_count DESC, productLine;

-- 상품 라인별 가격 통계
SELECT
    productLine,
    COUNT(*) AS product_count,
    ROUND(AVG(buyPrice), 2) AS average_buy_price,
    MIN(buyPrice) AS min_buy_price,
    MAX(buyPrice) AS max_buy_price
FROM products
GROUP BY productLine
ORDER BY average_buy_price DESC;

-- 고객별 결제 금액
SELECT
    customerNumber,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM payments
GROUP BY customerNumber
ORDER BY total_amount DESC
LIMIT 20;

-- HAVING: 집계 결과에 조건 적용
SELECT
    customerNumber,
    COUNT(*) AS order_count
FROM orders
GROUP BY customerNumber
HAVING COUNT(*) >= 5
ORDER BY order_count DESC, customerNumber;

-- 월별 매출
SELECT
    DATE_FORMAT(paymentDate, '%Y-%m-01') AS payment_month,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_amount
FROM payments
GROUP BY DATE_FORMAT(paymentDate, '%Y-%m-01')
ORDER BY payment_month;
