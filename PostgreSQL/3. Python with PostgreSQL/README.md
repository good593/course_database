# Jupyter Notebook으로 PostgreSQL 사용하기

이번 차시는 Python 코드에서 PostgreSQL에 연결하고 SQL을 실행하는 기초 실습입니다.
첫 번째 노트북에서는 `psycopg`로 SQL을 직접 실행하고, 두 번째 노트북에서는
SQLAlchemy로 같은 작업을 더 구조화해서 다룹니다.

## 학습 목표

1. Jupyter Notebook 실습 환경을 준비합니다.
2. Python에서 PostgreSQL 연결 정보를 설정합니다.
3. `psycopg`로 `SELECT`, `INSERT`, `UPDATE`, `DELETE`를 실행합니다.
4. 조회 결과를 Python 객체와 pandas DataFrame으로 확인합니다.
5. SQLAlchemy의 `Engine`, `Connection`, Core 문법, ORM 기초 흐름을 설명합니다.

## 실습 환경 준비

PostgreSQL 서버는 상위 폴더의 `docker-compose.yml`로 실행합니다.

```shell
cd PostgreSQL
docker-compose up -d
```

Python 실습 폴더로 이동한 뒤 패키지를 설치합니다.

```shell
cd "3. Python with PostgreSQL 기초"
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
```

환경 변수 파일을 사용할 경우 `.env.example`을 참고해 `.env` 파일을 만듭니다.
기본값은 `docker-compose.yml`의 설정과 동일합니다.

```text
DB_HOST=localhost
DB_PORT=5432
DB_NAME=deepagent_db
DB_USER=admin
DB_PASSWORD=admin123
```

Jupyter Notebook을 실행합니다.

```shell
jupyter notebook
```

## 강의 흐름

### 3-1. 개발 환경 준비

- Jupyter Notebook 실행
- `requirements.txt` 설치
- PostgreSQL 컨테이너 실행 확인
- 접속 정보 확인

### 3-2. Python에서 PostgreSQL 연결하기

- `psycopg.connect()` 사용
- 연결 문자열 만들기
- `SELECT version()`으로 연결 확인
- `postgresql.py`의 `PostgreDB` 연결 클래스 살펴보기

### 3-3. Python에서 SQL 실행하기

- 테이블 생성
- 파라미터 바인딩으로 데이터 추가
- `fetchone()`, `fetchall()`로 조회 결과 가져오기
- pandas DataFrame으로 결과 확인
- 조건을 사용한 수정과 삭제

### 3-4. SQLAlchemy로 PostgreSQL 사용하기

- `create_engine()`으로 연결 엔진 생성
- `text()`로 SQL 실행
- SQLAlchemy Core로 테이블 정의와 CRUD 실행
- ORM 모델과 `Session` 기초 맛보기

## 실습 파일

| 파일 | 설명 |
|---|---|
| `requirements.txt` | Jupyter, pandas, python-dotenv, psycopg, SQLAlchemy 설치 목록 |
| `postgresql.py` | PostgreSQL 연결을 재사용하기 위한 간단한 클래스 |
| `.env.example` | 데이터베이스 접속 정보 예시 |
| `01_python_postgresql.ipynb` | Jupyter 실습 노트북 |
| `02_sqlalchemy_postgresql.ipynb` | SQLAlchemy 기반 PostgreSQL 실습 노트북 |

## 수업 포인트

- SQL을 Python 문자열로 직접 조합하지 않습니다.
- 값은 `%s` 자리표시자와 파라미터로 전달합니다.
- 조회 쿼리와 변경 쿼리의 차이를 구분합니다.
- 처음에는 SQL을 직접 작성하는 감각을 익히는 것이 중요합니다.
- SQLAlchemy는 SQL을 몰라도 되는 도구가 아니라, SQL 실행과 객체 매핑을 체계화하는 도구입니다.
