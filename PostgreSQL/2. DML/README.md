---
marp: true
paginate: true
---

# PostgreSQL DML/DQL 기초

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
- DQL: `DQL 기초/restore.sql`의 `dvdrental` 영화 대여 데이터

CRUD 실습 전에는 샘플 테이블과 데이터를 생성합니다. PowerShell에서는 호스트의
SQL 파일 내용을 컨테이너 안의 `psql`로 전달합니다.

```shell
Get-Content -Raw -Encoding UTF8 "2. PostgreSQL DML\00_setup_sample_data.sql" | docker exec -i postgres-db psql -U admin -d examples_db
```

로컬에 `psql`이 설치되어 있고 직접 접속한 상태라면 `\i` 명령을 사용할 수 있습니다.

```sql
\i '2. PostgreSQL DML/00_setup_sample_data.sql'
```

DQL 실습은 `DQL 기초/restore.sql`을 복원한 `dvdrental` 데이터베이스를 기준으로
합니다. 이 덤프는 `actor`, `film`, `customer`, `rental`, `payment` 같은 영화
대여 서비스 테이블을 포함합니다.

> `restore.sql` 안에는 `$$PATH$$/*.dat` 데이터 파일 참조가 있습니다. 실제 데이터를
> 함께 복원하려면 `.dat` 파일이 있는 경로로 `$$PATH$$`를 바꾸거나, 데이터 파일을
> 컨테이너 안의 같은 경로에 복사해야 합니다.

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

## INSERT 기본 구조

`INSERT`는 테이블에 새로운 행(row)을 추가합니다.

```sql
INSERT INTO 테이블명 (컬럼1, 컬럼2, 컬럼3)
VALUES (값1, 값2, 값3);
```

- 컬럼 목록과 값 목록은 순서와 개수가 같아야 합니다.
- `GENERATED AS IDENTITY`, `DEFAULT` 값이 있는 컬럼은 보통 생략할 수 있습니다.

---

## INSERT 예시

```sql
INSERT INTO students (name, email, birth_date, phone)
VALUES ('오하늘', 'haneul@example.com', '2002-04-03', '010-7777-7777')
RETURNING student_id, name, email;
```

`RETURNING`을 사용하면 추가된 행의 주요 값을 바로 확인할 수 있습니다.

---

## UPDATE 기본 구조

`UPDATE`는 이미 저장된 행의 값을 수정합니다.

```sql
UPDATE 테이블명
SET 컬럼1 = 새값1,
    컬럼2 = 새값2
WHERE 조건;
```

`WHERE`가 없으면 테이블의 모든 행이 수정될 수 있습니다.

---

## UPDATE 전 확인

수정하기 전에 같은 `WHERE` 조건으로 대상 행을 먼저 조회합니다.

```sql
SELECT
    student_id,
    name,
    phone
FROM students
WHERE email = 'haneul@example.com';
```

---

## UPDATE 예시

```sql
UPDATE students
SET phone = '010-7777-0000'
WHERE email = 'haneul@example.com'
RETURNING student_id, name, phone;
```

---

## DELETE 기본 구조

`DELETE`는 조건에 맞는 행을 테이블에서 삭제합니다.

```sql
DELETE FROM 테이블명
WHERE 조건;
```

`WHERE`가 없으면 테이블의 모든 행이 삭제될 수 있습니다.

---

## DELETE 전 확인

삭제하기 전에 같은 `WHERE` 조건으로 대상 행을 먼저 조회합니다.

```sql
SELECT
    student_id,
    name,
    email
FROM students
WHERE email = 'haneul@example.com';
```

---

## DELETE 예시

```sql
DELETE FROM students
WHERE email = 'haneul@example.com'
RETURNING student_id, name, email;
```

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

## 조건 조회

자주 사용하는 조건 표현입니다.

| 표현 | 의미 |
|---|---|
| `=`, `<>`, `>`, `>=` | 비교 |
| `AND`, `OR`, `NOT` | 조건 결합 |
| `IN` | 여러 값 중 하나 |
| `BETWEEN` | 범위 |
| `LIKE`, `ILIKE` | 문자열 패턴 |
| `IS NULL` | NULL 확인 |

---

## 집계

```sql
SELECT
    customer_id,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 30;
```

`WHERE`는 그룹화 전에 행을 걸러내고, `HAVING`은 그룹화 결과를 걸러냅니다.

---

## 조인

```sql
SELECT
    c.first_name,
    c.last_name,
    r.rental_date,
    f.title
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;
```

관계형 데이터베이스에서는 하나의 화면이나 리포트를 만들기 위해 여러 테이블을
함께 조회하는 일이 많습니다.

---

## 서브쿼리와 CTE

서브쿼리는 쿼리 안에 들어가는 또 다른 쿼리입니다.

```sql
SELECT *
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
);
```

CTE는 복잡한 쿼리를 이름 붙인 단계로 나누어 읽기 쉽게 만듭니다.

```sql
WITH customer_rental_stats AS (
    SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
)
SELECT *
FROM customer_rental_stats
WHERE rental_count >= 30;
```

---

## 실습 파일 순서

```text
00_setup_sample_data.sql
01_CRUD.sql
DQL 기초/README.md
DQL 기초/restore.sql
DQL 기초/01_조건조회.sql
DQL 기초/02_집계.sql
DQL 기초/03_조인.sql
DQL 기초/04_서브쿼리_CTE.sql
실습문제/실습문제.md
실습문제/정답.sql
```

`01_CRUD.sql`은 `00_setup_sample_data.sql` 실행 후 사용하는 것을 기준으로 합니다.
`DQL 기초`의 조회 파일은 `restore.sql`로 `dvdrental` 데이터베이스를 복원한 뒤
사용하는 것을 기준으로 합니다.
