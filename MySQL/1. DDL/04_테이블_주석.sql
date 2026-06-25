-- MySQL DDL 기초 04
-- 테이블과 컬럼 주석

CREATE DATABASE IF NOT EXISTS mysql_ddl_practice
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE mysql_ddl_practice;

DROP TABLE IF EXISTS comment_examples;

CREATE TABLE comment_examples (
    comment_example_id INT AUTO_INCREMENT COMMENT '주석 예제 데이터를 식별하는 자동 증가 기본키',
    title VARCHAR(100) NOT NULL COMMENT '예제 제목',
    description TEXT COMMENT '예제 설명',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '예제 생성 시각',
    PRIMARY KEY (comment_example_id)
) COMMENT = '테이블과 컬럼 주석 작성법을 실습하는 예제 테이블';

-- 테이블 주석 확인
SHOW TABLE STATUS LIKE 'comment_examples';

-- 컬럼 주석 확인
SHOW FULL COLUMNS FROM comment_examples;

-- information_schema로 주석만 조회
SELECT
    COLUMN_NAME,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'comment_examples'
ORDER BY ORDINAL_POSITION;
