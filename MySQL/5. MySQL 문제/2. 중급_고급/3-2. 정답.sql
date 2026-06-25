
-- 문제 1: 고객별 총 결제 금액
SELECT 
    c.customerName,
    SUM(p.amount) AS totalAmount
FROM customers AS c
JOIN payments AS p
  ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
HAVING SUM(p.amount) >= 50000
ORDER BY c.customerName ASC;

-- 문제 2: 제품 라인별 총 판매 수량
SELECT 
    pl.productLine,
    SUM(od.quantityOrdered) AS totalQuantity
FROM orderdetails AS od
JOIN orders AS o
  ON od.orderNumber = o.orderNumber
JOIN products AS p
  ON od.productCode = p.productCode
JOIN productlines AS pl
  ON p.productLine = pl.productLine
GROUP BY pl.productLine
HAVING SUM(od.quantityOrdered) >= 1000
ORDER BY totalQuantity DESC;

-- 문제 3: 영업사원별 고객 수와 평균 결제 금액
SELECT 
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    COUNT(DISTINCT c.customerNumber) AS customerCount,
    AVG(p.amount) AS avgPayment
FROM employees AS e
JOIN customers AS c
  ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments AS p
  ON c.customerNumber = p.customerNumber
GROUP BY e.employeeNumber
HAVING AVG(p.amount) >= 5000
ORDER BY avgPayment DESC;
