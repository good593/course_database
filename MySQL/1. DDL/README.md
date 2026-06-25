---
marp: true
paginate: true
---

# MySQL DDL 기초

DDL은 **Data Definition Language**의 줄임말입니다. 데이터베이스 안에 어떤
테이블을 만들지, 각 컬럼은 어떤 값을 저장할지, 데이터가 지켜야 할 규칙은
무엇인지 정의합니다.

---

## 이번 차시의 목표

1. MySQL에서 자주 쓰는 데이터 타입을 구분합니다.
2. `CREATE TABLE` 문법으로 테이블을 생성합니다.
3. 테이블과 컬럼 주석을 작성합니다.
4. 제약조건으로 잘못된 데이터 입력을 막습니다.
5. 외래키를 사용해 테이블 사이의 관계를 표현합니다.

---

## DDL에서 자주 쓰는 명령

| 명령 | 역할 |
|---|---|
| `CREATE` | 데이터베이스 객체를 생성 |
| `ALTER` | 기존 객체의 구조를 변경 |
| `DROP` | 객체를 삭제 |
| `TRUNCATE` | 테이블 구조는 유지하고 데이터만 전체 삭제 |

> 이번 강의에서는 `CREATE DATABASE`, `CREATE TABLE`을 중심으로 다룹니다.

---

## MySQL 데이터 타입

| 분류 | 대표 타입 | 예시 |
|---|---|---|
| 정수 | `TINYINT`, `INT`, `BIGINT` | 나이, 수량 |
| 실수/금액 | `DECIMAL(10,2)`, `FLOAT`, `DOUBLE` | 가격, 점수 |
| 문자 | `CHAR(n)`, `VARCHAR(n)`, `TEXT` | 이름, 설명 |
| 날짜/시간 | `DATE`, `TIME`, `DATETIME`, `TIMESTAMP` | 가입일, 생성 시각 |
| 참/거짓 | `BOOLEAN` | 활성 상태 |
| JSON | `JSON` | 유연한 추가 정보 |

---

## 기본 테이블 생성

```sql
CREATE TABLE students (
    student_id INT AUTO_INCREMENT COMMENT '수강생을 식별하는 자동 증가 기본키',
    name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    email VARCHAR(120) NOT NULL UNIQUE COMMENT '수강생 이메일, 중복 불가',
    birth_date DATE COMMENT '수강생 생년월일',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '수강생 등록 시각',
    PRIMARY KEY (student_id)
) COMMENT = '수강생 기본 정보';
```

MySQL에서는 자동 증가 번호를 만들 때 `AUTO_INCREMENT`를 사용합니다.

---

## 테이블과 컬럼 주석

MySQL은 `CREATE TABLE` 문 안에서 컬럼 주석과 테이블 주석을 함께 작성할 수 있습니다.

```sql
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT COMMENT '강의를 식별하는 자동 증가 기본키',
    title VARCHAR(100) NOT NULL COMMENT '강의명',
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0) COMMENT '강의 가격',
    PRIMARY KEY (course_id)
) COMMENT = '강의 기본 정보';
```

주석은 `SHOW FULL COLUMNS` 또는 `information_schema`에서 확인할 수 있습니다.

---

## 주석 확인하기

```sql
SHOW TABLE STATUS LIKE 'students';
SHOW FULL COLUMNS FROM students;
```

`information_schema`를 사용하면 필요한 컬럼만 골라 조회할 수 있습니다.

```sql
SELECT
    COLUMN_NAME,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'students'
ORDER BY ORDINAL_POSITION;
```

---

## 제약조건

| 제약조건 | 의미 |
|---|---|
| `PRIMARY KEY` | 행을 식별하는 대표 값 |
| `NOT NULL` | 반드시 값이 있어야 함 |
| `UNIQUE` | 같은 값을 중복 저장할 수 없음 |
| `CHECK` | 지정한 조건을 만족해야 함 |
| `DEFAULT` | 값을 생략했을 때 기본값 사용 |
| `FOREIGN KEY` | 다른 테이블의 값을 참조 |

MySQL 8.0.16 이상에서는 `CHECK` 제약조건이 실제로 적용됩니다.

---

## 관계형 데이터베이스의 관계

| 관계 | 예시 | 표현 방법 |
|---|---|---|
| 1:1 | 사용자와 사용자 상세 정보 | 한쪽 테이블의 PK를 다른 테이블 FK로 사용 |
| 1:N | 수강생과 수강 신청 | N쪽 테이블에 FK 저장 |
| N:M | 수강생과 강의 | 중간 테이블을 만들어 1:N + 1:N으로 분해 |

수강생은 여러 강의를 신청할 수 있고, 강의도 여러 수강생을 가질 수 있습니다.
따라서 `enrollments` 같은 중간 테이블이 필요합니다.

---

## 실습 파일 순서

```text
01_테이블과_데이터타입.sql
02_제약조건.sql
03_테이블_관계.sql
04_테이블_주석.sql
```

각 파일은 독립적으로 실행할 수 있도록 데이터베이스와 테이블을 다시 생성합니다.

---

## 확인 질문

1. `VARCHAR(50)`과 `TEXT`는 어떤 차이가 있나요?
2. MySQL에서 자동 증가 기본키를 만들 때 어떤 키워드를 사용하나요?
3. 테이블 주석과 컬럼 주석은 각각 어떤 정보를 남기는 데 적합한가요?
4. `PRIMARY KEY`와 `UNIQUE`의 공통점과 차이점은 무엇인가요?
5. N:M 관계를 테이블로 표현할 때 중간 테이블이 필요한 이유는 무엇인가요?
