-- PostgreSQL DDL 기초 실습문제 정답

DROP TABLE IF EXISTS practice_enrollments;
DROP TABLE IF EXISTS practice_courses;
DROP TABLE IF EXISTS practice_students;

CREATE TABLE practice_students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    birth_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE practice_students IS 'DDL 실습용 수강생 정보';
COMMENT ON COLUMN practice_students.student_id IS '수강생을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN practice_students.name IS '수강생 이름';
COMMENT ON COLUMN practice_students.email IS '수강생 이메일, 중복 불가';
COMMENT ON COLUMN practice_students.birth_date IS '수강생 생년월일';
COMMENT ON COLUMN practice_students.created_at IS '수강생 등록 시각';

CREATE TABLE practice_courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    level VARCHAR(20) NOT NULL CHECK (
        level IN ('beginner', 'intermediate', 'advanced')
    ),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE practice_courses IS 'DDL 실습용 강의 정보';
COMMENT ON COLUMN practice_courses.course_id IS '강의를 식별하는 자동 증가 기본키';
COMMENT ON COLUMN practice_courses.title IS '강의명';
COMMENT ON COLUMN practice_courses.price IS '강의 가격, 0 이상만 허용';
COMMENT ON COLUMN practice_courses.level IS '강의 난이도';
COMMENT ON COLUMN practice_courses.is_active IS '강의 활성 상태';

CREATE TABLE practice_enrollments (
    enrollment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES practice_students(student_id),
    course_id INTEGER NOT NULL REFERENCES practice_courses(course_id),
    enrolled_at DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (student_id, course_id)
);

COMMENT ON TABLE practice_enrollments IS 'DDL 실습용 수강 신청 정보';
COMMENT ON COLUMN practice_enrollments.enrollment_id IS '수강 신청을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN practice_enrollments.student_id IS '수강 신청한 수강생 ID';
COMMENT ON COLUMN practice_enrollments.course_id IS '신청한 강의 ID';
COMMENT ON COLUMN practice_enrollments.enrolled_at IS '수강 신청일';

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
