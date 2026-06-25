---
marp: true
paginate: true
---

# MySQL DML/DQL 기초

DDL이 테이블의 구조를 정의한다면, DML과 DQL은 테이블 안의 데이터를 다룹니다.

- DML: `INSERT`, `UPDATE`, `DELETE`
- DQL: `SELECT`

---

## 이번 차시의 목표

1. 샘플 데이터를 준비하고 CRUD를 실행합니다.
2. `WHERE`, `ORDER BY`, `LIMIT`으로 필요한 행을 조회합니다.
3. `GROUP BY`, `HAVING`으로 데이터를 집계합니다.
4. `JOIN`으로 여러 테이블의 데이터를 함께 조회합니다.
5. 서브쿼리와 CTE로 복잡한 조회를 단계적으로 작성합니다.

---

## 실습 데이터 준비

이번 장에서는 실습 데이터를 두 가지로 나누어 사용합니다.

- CRUD: `00_setup_sample_data.sql`의 작은 교육 서비스 데이터
- DQL: `DQL/mysqlsampledatabase.sql`의 `classicmodels` 주문/상품 데이터

CRUD 실습 전에는 샘플 테이블과 데이터를 생성합니다.

```shell
Get-Content -Raw -Encoding UTF8 "2. DML\00_setup_sample_data.sql" | docker-compose exec -T db mysql -u root -proot1234
```

DQL 실습 전에는 `classicmodels` 샘플 데이터베이스를 복원합니다.

```shell
Get-Content -Raw -Encoding UTF8 "2. DML\DQL\mysqlsampledatabase.sql" | docker-compose exec -T db mysql -u root -proot1234
```

---

## CRUD

| 작업 | SQL |
|---|---|
| 생성 | `INSERT` |
| 조회 | `SELECT` |
| 수정 | `UPDATE` |
| 삭제 | `DELETE` |

CRUD 실습은 `01_CRUD.sql`에서 확인합니다.

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

MySQL 8 이상에서는 CTE를 사용할 수 있습니다.

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

---

## 실습 파일 순서

```text
00_setup_sample_data.sql
01_CRUD.sql
DQL/README.md
DQL/mysqlsampledatabase.sql
DQL/01_조건조회.sql
DQL/02_집계.sql
DQL/03_조인.sql
DQL/04_서브쿼리_CTE.sql
실습문제/실습문제.md
실습문제/정답.sql
```

`01_CRUD.sql`은 `00_setup_sample_data.sql` 실행 후 사용하는 것을 기준으로 합니다.
`DQL`의 조회 파일은 `mysqlsampledatabase.sql`로 `classicmodels` 데이터베이스를
복원한 뒤 사용하는 것을 기준으로 합니다.
