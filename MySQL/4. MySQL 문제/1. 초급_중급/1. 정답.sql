
-- 문제1: 데이터베이스 생성
CREATE DATABASE  IF NOT EXISTS online_shop;

/* Switch to the online_shop database */
USE online_shop;


-- 문제2: 테이블 생성
DROP TABLE IF EXISTS users;

/* Create the tables */
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

