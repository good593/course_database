
-- 문제1: 특정 도시의 사무실 찾기
SELECT 
  *
FROM offices
WHERE 1=1
  AND city = 'San Francisco';

-- 문제2: 재고가 부족한 제품 찾기
SELECT 
    productCode
  , productName
  , quantityInStock
FROM products
WHERE 1=1
  AND quantityInStock < 100;

-- 문제3: 주문 상태 확인하기
SELECT 
    orderNumber
  , orderDate
  , status
FROM orders
WHERE 1=1
  AND status = 'Shipped';
