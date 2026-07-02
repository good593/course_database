# PostgreSQL DQL 기초

이 폴더의 DQL 실습은 `restore.sql`에 들어 있는 DVD 대여점 샘플 데이터를
기준으로 합니다. `restore.sql`은 `film`, `customer`, `rental`, `payment` 같은
테이블을 만들고 실습 데이터를 직접 넣어 줍니다.

## restore.sql 사용 안내

`restore.sql`은 DBeaver와 `psql`에서 바로 실행할 수 있는 자기완결형 SQL 파일입니다.
외부 `.dat` 파일, `\connect` 같은 psql 전용 명령, OS별 locale 설정을 사용하지
않습니다.

주요 테이블은 다음과 같습니다.

| 테이블 | 설명 |
|---|---|
| `film` | 영화 기본 정보 |
| `actor` | 배우 정보 |
| `category` | 영화 카테고리 |
| `film_actor` | 영화와 배우의 N:M 관계 |
| `film_category` | 영화와 카테고리의 N:M 관계 |
| `customer` | 고객 정보 |
| `rental` | 대여 기록 |
| `payment` | 결제 기록 |
| `inventory` | 매장별 영화 재고 |
| `staff`, `store` | 직원과 매장 정보 |
| `address`, `city`, `country` | 주소 정보 |

## 실행 예시

DBeaver에서는 `examples_db` 연결을 선택한 상태에서 `restore.sql` 파일 전체를
실행합니다. 실행이 끝나면 같은 데이터베이스의 `public` 스키마에 실습 테이블이
생성됩니다.

PowerShell에서 실행할 때는 SQL 파일 내용을 컨테이너 안의 `psql`로 전달합니다.

```shell
Get-Content -Raw -Encoding UTF8 "PostgreSQL\2. DML\2. DQL\restore.sql" | docker exec -i postgres-db psql -U admin -d examples_db
```

복원 후에는 간단한 조회로 데이터를 확인합니다.

```sql
SELECT COUNT(*) AS film_count FROM film;
SELECT COUNT(*) AS rental_count FROM rental;
```

## 강의 순서

1. `01_조건조회.sql`: `film`, `customer`, `payment`에서 필요한 행 찾기
2. `02_집계.sql`: 대여 수, 결제 금액, 영화 길이 등을 집계
3. `03_조인.sql`: 고객, 대여, 영화, 카테고리, 결제 테이블 연결
4. `04_서브쿼리_CTE.sql`: 평균보다 비싼 영화, 고객별 대여 통계, 단계적 분석

## 핵심 관계

```text
customer 1 ─ N rental N ─ 1 inventory N ─ 1 film
film N ─ N actor    via film_actor
film N ─ N category via film_category
rental 1 ─ N payment
store 1 ─ N inventory
address N ─ 1 city N ─ 1 country
```

DVD 대여점 데이터는 조회 실습에서 조인이 왜 필요한지 보여주기에 좋습니다. 예를
들어 고객이 빌린 영화 제목을 보려면 `customer -> rental -> inventory -> film`
순서로 테이블을 연결해야 합니다.
