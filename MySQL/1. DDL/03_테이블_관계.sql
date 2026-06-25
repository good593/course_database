-- MySQL DDL 기초 03
-- 테이블 관계: 1:N, N:M, FOREIGN KEY

CREATE DATABASE IF NOT EXISTS mysql_ddl_practice
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE mysql_ddl_practice;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT COMMENT '수강생을 식별하는 자동 증가 기본키',
    name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    email VARCHAR(120) NOT NULL UNIQUE COMMENT '수강생 이메일, 중복 불가',
    PRIMARY KEY (student_id)
) COMMENT = '수강생 기본 정보';

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT COMMENT '강의를 식별하는 자동 증가 기본키',
    title VARCHAR(100) NOT NULL COMMENT '강의명',
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0) COMMENT '강의 가격, 0 이상만 허용',
    PRIMARY KEY (course_id)
) COMMENT = '강의 기본 정보';

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT COMMENT '수강 신청을 식별하는 자동 증가 기본키',
    student_id INT NOT NULL COMMENT '수강 신청한 수강생 ID',
    course_id INT NOT NULL COMMENT '신청한 강의 ID',
    enrolled_at DATE NOT NULL DEFAULT (CURRENT_DATE) COMMENT '수강 신청일',
    status ENUM('enrolled', 'completed', 'canceled') NOT NULL DEFAULT 'enrolled' COMMENT '수강 신청 상태',
    score DECIMAL(5, 2) CHECK (score BETWEEN 0 AND 100) COMMENT '수료 또는 평가 점수',
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY uq_enrollments_student_course (student_id, course_id),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE RESTRICT
) COMMENT = '수강생과 강의의 수강 신청 관계';

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT COMMENT '결제 기록을 식별하는 자동 증가 기본키',
    enrollment_id INT NOT NULL COMMENT '결제 대상 수강 신청 ID',
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0) COMMENT '결제 금액',
    paid_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '결제 시각',
    method ENUM('card', 'bank_transfer', 'cash') NOT NULL COMMENT '결제 수단',
    PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_enrollment
        FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
) COMMENT = '수강 신청별 결제 기록';

INSERT INTO students (name, email)
VALUES
    ('김민준', 'minjun@example.com'),
    ('이서연', 'seoyeon@example.com'),
    ('박도윤', 'doyun@example.com');

INSERT INTO courses (title, price)
VALUES
    ('SQL 기초', 120000),
    ('Python 기초', 100000);

INSERT INTO enrollments (student_id, course_id, status, score)
VALUES
    (1, 1, 'completed', 92.5),
    (1, 2, 'enrolled', NULL),
    (2, 1, 'completed', 85.0);

INSERT INTO payments (enrollment_id, amount, method)
VALUES
    (1, 120000, 'card'),
    (2, 100000, 'bank_transfer'),
    (3, 120000, 'card');

SELECT
    s.name AS student_name,
    c.title AS course_title,
    e.status,
    e.score,
    p.amount,
    p.method
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN payments p ON e.enrollment_id = p.enrollment_id
ORDER BY s.name, c.title;
