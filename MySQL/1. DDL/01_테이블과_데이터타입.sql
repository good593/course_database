-- MySQL DDL 기초 01
-- 테이블 생성과 데이터 타입

CREATE DATABASE IF NOT EXISTS mysql_ddl_practice
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE mysql_ddl_practice;

DROP TABLE IF EXISTS datatype_examples;

CREATE TABLE datatype_examples (
    example_id INT AUTO_INCREMENT COMMENT '예제 데이터를 식별하는 자동 증가 기본키',
    student_name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    age SMALLINT COMMENT '수강생 나이',
    tuition DECIMAL(10, 2) COMMENT '수강료 금액',
    is_active BOOLEAN DEFAULT TRUE COMMENT '활성 상태 여부',
    joined_on DATE DEFAULT (CURRENT_DATE) COMMENT '가입일',
    last_login_at DATETIME COMMENT '마지막 로그인 시각',
    profile JSON COMMENT 'JSON 형식의 추가 프로필 정보',
    memo TEXT COMMENT '메모',
    PRIMARY KEY (example_id)
) COMMENT = 'MySQL 데이터 타입 실습 예제 테이블';

INSERT INTO datatype_examples (
    student_name,
    age,
    tuition,
    last_login_at,
    profile,
    memo
) VALUES (
    '김민준',
    24,
    120000.00,
    NOW(),
    JSON_OBJECT('track', 'backend', 'level', 'beginner'),
    'MySQL 데이터 타입 실습'
);

SELECT
    example_id,
    student_name,
    age,
    tuition,
    is_active,
    joined_on,
    last_login_at,
    profile,
    memo
FROM datatype_examples;

-- 테이블 구조와 주석 확인
DESCRIBE datatype_examples;
SHOW FULL COLUMNS FROM datatype_examples;

ALTER TABLE datatype_examples
ADD COLUMN email VARCHAR(120) COMMENT '수강생 이메일';

ALTER TABLE datatype_examples
MODIFY COLUMN memo VARCHAR(500) COMMENT '메모';

ALTER TABLE datatype_examples
DROP COLUMN email;

SELECT *
FROM datatype_examples;
