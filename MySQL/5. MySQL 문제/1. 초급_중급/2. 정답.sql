
-- 문제 1: 데이터 삽입
INSERT INTO users (username, email, password) VALUES
('kim_coding', 'kim@example.com', 'password123'),
('lee_dev', 'lee@example.com', 'securepass');

-- 문제 2: 데이터 수정
UPDATE users 
SET email = 'kim_new@example.com' 
WHERE username = 'kim_coding';

-- 문제 3: 데이터 삭제
DELETE FROM users 
WHERE 1=1
  and username = 'lee_dev';

