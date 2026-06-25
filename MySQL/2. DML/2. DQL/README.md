# MySQL DQL 기초

이 폴더의 DQL 실습은 `mysqlsampledatabase.sql`에 들어 있는 `classicmodels` 샘플
데이터베이스를 기준으로 합니다. `classicmodels`는 미니어처 상품 판매 회사를
다루며, 조건 조회, 집계, 조인, 서브쿼리, CTE를 연습하기 좋은 관계형 데이터
구조를 갖고 있습니다.

## mysqlsampledatabase.sql 사용 안내

`mysqlsampledatabase.sql`은 데이터베이스 생성, 테이블 생성, 샘플 데이터 입력을
모두 포함합니다. 주요 테이블은 다음과 같습니다.

| 테이블 | 설명 |
|---|---|
| `productlines` | 상품 라인 |
| `products` | 상품 정보 |
| `customers` | 고객 정보 |
| `orders` | 주문 |
| `orderdetails` | 주문 상세 |
| `payments` | 결제 |
| `employees` | 직원 |
| `offices` | 사무실 |

## 실행 예시

PowerShell에서 다음 명령으로 샘플 DB를 복원합니다.

```shell
Get-Content -Raw -Encoding UTF8 "2. DML\DQL\mysqlsampledatabase.sql" | docker-compose exec -T db mysql -u root -proot1234
```

복원 후에는 `classicmodels` 데이터베이스에 접속합니다.

```shell
docker-compose exec db mysql -u root -p classicmodels
```

## 강의 순서

1. `01_조건조회.sql`: `products`, `customers`, `orders`에서 필요한 행 찾기
2. `02_집계.sql`: 상품 수, 결제 금액, 주문 수 등을 집계
3. `03_조인.sql`: 고객, 주문, 상품, 결제, 직원 테이블 연결
4. `04_서브쿼리_CTE.sql`: 평균보다 비싼 상품, 특정 상품 주문 고객, 단계적 분석

## 핵심 관계

```text
customers 1 ─ N orders 1 ─ N orderdetails N ─ 1 products
products N ─ 1 productlines
customers 1 ─ N payments
employees 1 ─ N customers
offices 1 ─ N employees
employees 1 ─ N employees via reportsTo
```

`classicmodels`는 조회 실습에서 조인이 왜 필요한지 보여주기에 좋습니다. 예를 들어
고객이 주문한 상품명을 보려면 `customers -> orders -> orderdetails -> products`
순서로 테이블을 연결해야 합니다.
