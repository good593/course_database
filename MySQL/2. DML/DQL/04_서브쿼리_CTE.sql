-- MySQL DQL 기초 04
-- 서브쿼리와 CTE

USE classicmodels;

-- 평균 MSRP보다 비싼 상품
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

-- Classic Cars 상품을 주문한 고객
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

-- 결제 기록이 있는 고객
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

-- CTE로 고객별 주문 수를 먼저 계산한 뒤 조회
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

-- CTE 여러 단계 사용: 상품 라인별 매출
WITH order_amounts AS (
    SELECT
        p.productLine,
        od.quantityOrdered * od.priceEach AS line_amount
    FROM orderdetails od
    JOIN products p ON od.productCode = p.productCode
),
productline_sales AS (
    SELECT
        productLine,
        COUNT(*) AS line_count,
        SUM(line_amount) AS total_sales
    FROM order_amounts
    GROUP BY productLine
)
SELECT
    productLine,
    line_count,
    total_sales
FROM productline_sales
ORDER BY total_sales DESC;
