# PostgreSQL 입문 강의자료

처음 PostgreSQL을 배우는 학생을 위한 SQL 기초 강의자료입니다. 테이블을
설계하고, 데이터를 조작하고, 마지막에는 Jupyter Notebook에서 Python으로
PostgreSQL을 사용하는 흐름으로 구성했습니다.

## 강의 개요

- 대상: SQL과 관계형 데이터베이스를 처음 배우는 학생
- 권장 시간: 총 12~15시간
- 선수 지식: 터미널 기본 사용법, Python 기초 문법
- 실습 환경: PostgreSQL 16, Docker, Jupyter Notebook, `psycopg`
- 실습 데이터: 교육 서비스 예제와 `dvdrental` 영화 대여 데이터

## 학습 목표

수강 후 학생은 다음을 수행할 수 있습니다.

1. PostgreSQL에서 데이터 타입을 선택하고 테이블을 생성합니다.
2. 기본키, 외래키, UNIQUE, CHECK 같은 제약조건을 설명하고 적용합니다.
3. 1:N, N:M 관계를 테이블로 표현합니다.
4. `INSERT`, `SELECT`, `UPDATE`, `DELETE`로 데이터를 조작합니다.
5. 조건, 집계, 조인, 서브쿼리, CTE를 사용해 필요한 데이터를 조회합니다.
6. Jupyter Notebook에서 `psycopg`로 PostgreSQL에 연결하고 SQL을 실행합니다.

## 실습 환경 준비

`PostgreSQL` 폴더에서 PostgreSQL 컨테이너를 실행합니다.

```shell
docker-compose up -d
```

PostgreSQL 접속 정보는 `docker-compose.yml`에 맞춰 아래 값을 사용합니다.

| 항목 | 값 |
|---|---|
| Host | `localhost` |
| Port | `5432` |
| Database | `deepagent_db` |
| User | `admin` |
| Password | `admin123` |

터미널에서 직접 접속하려면 다음 명령을 사용합니다.

```shell
docker exec -it postgres-db psql -U admin -d deepagent_db
```

강의 실습 SQL 파일은 호스트의 파일 내용을 컨테이너 안의 `psql`로 전달해서
실행합니다. PowerShell에서는 다음처럼 실행합니다.

```shell
Get-Content -Raw -Encoding UTF8 "2. PostgreSQL DML\00_setup_sample_data.sql" | docker exec -i postgres-db psql -U admin -d deepagent_db
```

로컬에 `psql`이 설치되어 있고 직접 접속한 상태라면 `\i` 명령으로 SQL 파일을
실행할 수도 있습니다.

## 차시별 자료

| 차시 | 주제 | 주요 파일 | 핵심 결과물 |
|---|---|---|---|
| 1 | PostgreSQL DDL 기초 | `1. PostgreSQL DDL 기초/README.md` | 데이터 타입, 제약조건, 관계 설계 |
| 2 | PostgreSQL DML/DQL 기초 | `2. PostgreSQL DML/README.md` | CRUD, 조건 조회, 집계, 조인, CTE |
| 3 | Python with PostgreSQL 기초 | `3. Python with PostgreSQL 기초/README.md` | Jupyter에서 PostgreSQL 연결 및 CRUD 실행 |

## 권장 수업 진행

각 차시는 다음 순서로 진행합니다.

1. 개념 도입과 예제 테이블 소개: 15분
2. 핵심 문법 설명: 30분
3. 강사 시연: 25분
4. 개인 실습: 40분
5. 확인 문제와 풀이: 20분
6. 정리 및 다음 차시 예고: 10분

## 파일 구성

```text
PostgreSQL/
├── docker-compose.yml
├── README.md
├── 1. PostgreSQL DDL 기초/
│   ├── README.md
│   ├── 01_테이블과_데이터타입.sql
│   ├── 02_제약조건.sql
│   ├── 03_테이블_관계.sql
│   ├── 04_테이블_주석.sql
│   └── 실습문제/
│       ├── 실습문제.md
│       └── 정답.sql
├── 2. PostgreSQL DML/
│   ├── README.md
│   ├── 00_setup_sample_data.sql
│   ├── 01_CRUD.sql
│   ├── DQL 기초/
│   │   ├── README.md
│   │   ├── restore.sql
│   │   ├── 01_조건조회.sql
│   │   ├── 02_집계.sql
│   │   ├── 03_조인.sql
│   │   └── 04_서브쿼리_CTE.sql
│   └── 실습문제/
│       ├── 실습문제.md
│       └── 정답.sql
└── 3. Python with PostgreSQL 기초/
    ├── README.md
    ├── requirements.txt
    ├── postgresql.py
    ├── .env.example
    └── 01_python_postgresql.ipynb
```
