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
# DQL(Data Query Language)
> DQL(Data Query Language)은 데이터베이스에서 원하는 데이터를 조회하는 SQL 명령어

---
## 조건 조회 (Filtering)
- 조건 조회는 원하는 조건에 맞는 데이터만 조회하는 방법

```sql
SELECT
  컬럼
FROM 테이블
WHERE 1=1
  and 조건;
```

---
### 자주 사용하는 비교 연산자
| 연산자      | 의미     |
| -------- | ------ |
| =        | 같다     |
| != 또는 <> | 같지 않다  |
| >        | 크다     |
| >=       | 크거나 같다 |
| <        | 작다     |
| <=       | 작거나 같다 |

---
### 논리 연산자
| 연산자 | 의미       |
| --- | -------- |
| AND | 모두 만족    |
| OR  | 하나 이상 만족 |
| NOT | 조건 부정    |

---
### 자주 사용하는 조건
| 조건      | 설명         |
| ------- | ---------- |
| BETWEEN | 범위 조회      |
| IN      | 여러 값 중 하나  |
| LIKE    | 문자열 패턴 검색  |
| IS NULL | NULL 여부 확인 |

---
### 실행 순서 
> 먼저 테이블을 선택하고 → 조건을 적용한 후 → 필요한 컬럼을 조회합니다.

```
FROM
 ↓
WHERE
 ↓
SELECT
```

---
## 집계 (Aggregation)
- 집계 함수는 여러 행을 하나의 결과로 계산하는 함수

---
### 대표적인 집계 함수
| 함수      | 설명   |
| ------- | ---- |
| COUNT() | 행 개수 |
| SUM()   | 합계   |
| AVG()   | 평균   |
| MAX()   | 최대값  |
| MIN()   | 최소값  |

---
### GROUP BY
> 같은 값을 가진 데이터를 하나의 그룹으로 묶습니다.

```sql
SELECT
    그룹컬럼,
    집계함수()
FROM 테이블
GROUP BY 그룹컬럼;
```

---
### HAVING
> 집계 결과에 조건을 적용합니다.

```
WHERE
   ↓
GROUP BY
   ↓
HAVING
```
- WHERE
  - 그룹화 이전 필터링
- HAVING
  - 그룹화 이후 필터링

---
### 실행 순서 

```
FROM
 ↓
WHERE
 ↓
GROUP BY
 ↓
HAVING
 ↓
SELECT
```

---
## 조인 (JOIN)
- 조인은 여러 테이블의 데이터를 연결하여 조회하는 기능입니다.
- 관계형 데이터베이스에서 가장 중요한 기능 중 하나입니다.

---
### INNER JOIN
> 양쪽 테이블에 모두 존재하는 데이터만 조회합니다.






---
## 서브쿼리 & CTE


