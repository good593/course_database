---
style: |
  img {
    display: block;
    float: none;
    margin-left: auto;
    margin-right: auto;
  }
marp: true
paginate: true
---
# DML(Data Manipulation Language)
> DML은 데이터를  삽입(`INSERT`), 수정(`UPDATE`),  삭제(`DELETE`), 조회(`SELECT`)하는 구문  

하지만 실무 및 교육 관점에서는 보통 아래와 같이 구분함 
- DML(데이터를 변경): `INSERT`, `UPDATE`, `DELETE`
- DQL(데이터를 조회): `SELECT`

---
## SELECT 기본 구조

```sql
SELECT 컬럼명
FROM 테이블명
WHERE 조건
ORDER BY 정렬기준
LIMIT 개수;
```

`SELECT *`는 학습 단계에서는 편리하지만, 실무에서는 필요한 컬럼을 명시하는
습관이 좋습니다.

---
## 집계 예시

```sql
SELECT
    customerNumber,
    COUNT(*) AS order_count
FROM orders
GROUP BY customerNumber
HAVING COUNT(*) >= 5;
```

`WHERE`는 그룹화 전에 행을 걸러내고, `HAVING`은 그룹화 결과를 걸러냅니다.

---
## 조인 예시

```sql
SELECT
    c.customerName,
    o.orderNumber,
    o.orderDate,
    o.status
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber;
```

관계형 데이터베이스에서는 하나의 화면이나 리포트를 만들기 위해 여러 테이블을
함께 조회하는 일이 많습니다.

---
## 서브쿼리와 CTE

```sql
SELECT *
FROM products
WHERE MSRP > (
    SELECT AVG(MSRP)
    FROM products
);
```

---
> MySQL 8 이상에서는 CTE를 사용할 수 있습니다.
> `CTE(Common Table Expression)`는 WITH 문을 사용하여 임시 테이블처럼 사용할 수 있는 결과 집합을 정의하는 기능

```sql
WITH customer_order_stats AS (
    SELECT customerNumber, COUNT(*) AS order_count
    FROM orders
    GROUP BY customerNumber
)
SELECT *
FROM customer_order_stats
WHERE order_count >= 5;
```
