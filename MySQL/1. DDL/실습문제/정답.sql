-- MySQL DDL 기초 실습문제 정답

CREATE DATABASE IF NOT EXISTS mysql_ddl_practice
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE mysql_ddl_practice;

DROP TABLE IF EXISTS practice_enrollments;
DROP TABLE IF EXISTS practice_courses;
DROP TABLE IF EXISTS practice_students;

CREATE TABLE practice_students (
    student_id INT AUTO_INCREMENT COMMENT '수강생을 식별하는 자동 증가 기본키',
    name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    email VARCHAR(120) NOT NULL UNIQUE COMMENT '수강생 이메일, 중복 불가',
    birth_date DATE COMMENT '수강생 생년월일',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '수강생 등록 시각',
    PRIMARY KEY (student_id)
) COMMENT = 'DDL 실습용 수강생 정보';

CREATE TABLE practice_courses (
    course_id INT AUTO_INCREMENT COMMENT '강의를 식별하는 자동 증가 기본키',
    title VARCHAR(100) NOT NULL COMMENT '강의명',
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0) COMMENT '강의 가격, 0 이상만 허용',
    level ENUM('beginner', 'intermediate', 'advanced') NOT NULL COMMENT '강의 난이도',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '강의 활성 상태',
    PRIMARY KEY (course_id)
) COMMENT = 'DDL 실습용 강의 정보';

CREATE TABLE practice_enrollments (
    enrollment_id INT AUTO_INCREMENT COMMENT '수강 신청을 식별하는 자동 증가 기본키',
    student_id INT NOT NULL COMMENT '수강 신청한 수강생 ID',
    course_id INT NOT NULL COMMENT '신청한 강의 ID',
    enrolled_at DATE NOT NULL DEFAULT (CURRENT_DATE) COMMENT '수강 신청일',
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY uq_practice_enrollments_student_course (student_id, course_id),
    CONSTRAINT fk_practice_enrollments_student
        FOREIGN KEY (student_id) REFERENCES practice_students(student_id),
    CONSTRAINT fk_practice_enrollments_course
        FOREIGN KEY (course_id) REFERENCES practice_courses(course_id)
) COMMENT = 'DDL 실습용 수강 신청 정보';

INSERT INTO practice_students (name, email, birth_date)
VALUES
    ('김민준', 'minjun.practice@example.com', '2001-03-12'),
    ('이서연', 'seoyeon.practice@example.com', '2000-07-22');

INSERT INTO practice_courses (title, price, level)
VALUES
    ('SQL 기초', 120000, 'beginner'),
    ('Python 기초', 100000, 'beginner');

INSERT INTO practice_enrollments (student_id, course_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 1);

SHOW TABLE STATUS LIKE 'practice_students';
SHOW FULL COLUMNS FROM practice_students;

SELECT *
FROM practice_students;

SELECT *
FROM practice_courses;

SELECT *
FROM practice_enrollments;

-- 오류 확인용 예시입니다. 하나씩 주석을 풀고 실행합니다.

-- INSERT INTO practice_students (email) VALUES ('noname.practice@example.com');
-- INSERT INTO practice_students (name, email) VALUES ('중복', 'minjun.practice@example.com');
-- INSERT INTO practice_courses (title, price, level) VALUES ('오류 강의', -1, 'beginner');
-- INSERT INTO practice_enrollments (student_id, course_id) VALUES (999, 1);
