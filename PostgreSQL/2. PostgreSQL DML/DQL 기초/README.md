# PostgreSQL DQL 기초

이 폴더의 DQL 실습은 `restore.sql`에 들어 있는 `dvdrental` 샘플 데이터베이스를
기준으로 합니다. `dvdrental`은 DVD 대여점 도메인을 다루며, 조건 조회, 집계,
조인, 서브쿼리, CTE를 연습하기 좋은 관계형 데이터 구조를 갖고 있습니다.

## restore.sql 사용 안내

`restore.sql`은 PostgreSQL 덤프 파일입니다. 주요 테이블은 다음과 같습니다.

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
| `store`, `staff` | 매장과 직원 정보 |
| `address`, `city`, `country` | 주소 정보 |

덤프 파일 안에는 다음과 같은 외부 데이터 파일 경로가 포함되어 있습니다.

```sql
COPY public.actor (...) FROM '$$PATH$$/3057.dat';
```

실제 데이터를 복원하려면 `$$PATH$$`를 `.dat` 파일이 있는 경로로 바꾸거나, 해당
데이터 파일들을 컨테이너 안에 복사해야 합니다. 데이터 파일 없이 실행하면 테이블
구조는 확인할 수 있지만, 조회 실습 결과가 비어 있거나 `COPY` 단계에서 오류가 날 수
있습니다.

또한 이 덤프는 Windows 환경에서 만들어진 파일이라 `CREATE DATABASE` 줄의
`LC_COLLATE`, `LC_CTYPE` 값이 현재 PostgreSQL 컨테이너의 locale과 맞지 않을 수
있습니다. 그 경우 수업 환경에 맞는 locale로 바꾸거나 해당 옵션을 제거한 뒤
실행합니다.

## 실행 예시

PowerShell에서 `restore.sql`을 컨테이너로 복사한 뒤 실행합니다.

```shell
docker cp "DQL 기초\restore.sql" postgres-db:/tmp/restore.sql
docker exec -it postgres-db psql -U admin -d postgres -f /tmp/restore.sql
```

복원 후에는 `dvdrental` 데이터베이스에 접속합니다.

```shell
docker exec -it postgres-db psql -U admin -d dvdrental
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

`dvdrental`은 조회 실습에서 조인이 왜 필요한지 보여주기에 좋습니다. 예를 들어
고객이 빌린 영화 제목을 보려면 `customer -> rental -> inventory -> film` 순서로
테이블을 연결해야 합니다.
