---
style: |
  img {
    display: block;
    float: none;
    margin-left: auto;
    margin-right: auto;
  }
marp: true
paginate: true
---
# [MySQL](https://www.mysql.com/)
- MySQL은 오픈소스 관계형 데이터베이스 관리 시스템입니다.
- 사용자는 SQL이라는 구조화된 쿼리 언어를 사용하여 데이터를 정의, 조작, 제어, 쿼리할 수 있습니다.
- MySQL은 오픈소스이므로 25년 이상 사용자와 긴밀히 협력하여 개발한 여러 기능이 포함되어 있습니다.

---
# 설치방법 

---
## 1. Docker를 이용한 설치

---
### 사전준비 
- dbeaver 설치 
- Docker 설치
- mysql 설치 폴더 생성
    - mkdir ./mysql
    - mkdir ./mysql/database 

---
### ./mysql/docker-compose.yml 파일 생성 
```
version: "3"

services:
  db:
    image: mysql
    restart: always
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
    volumes:
      - ./database:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: "root1234"
      MYSQL_DATABASE: "examplesdb"
      MYSQL_USER: "urstory"
      MYSQL_PASSWORD: "u1234"
    ports:
      - "3306:3306"

```

---
### Docker를 이용한 MySQL 설치 
```
> cd ./mysql # docker-compose.yml이 있는 폴더로 이동 
```
![Alt text](./img/mysql/docker/image.png)

---
```
> docker-compose up -d # mysql 생성 및 실행 
```
![Alt text](./img/mysql/docker/image-2.png)

---
```
> docker ps # 생성된 mysql 확인 
```
![Alt text](./img/mysql/docker/image-5.png)
```
> cd database
> ls # database 폴더에 mysql이 잘 설치되어 있는지 확인 
```
![Alt text](./img/mysql/docker/image-4.png)

---
### Docker Desktop에서 mysql 확인 

![Alt text](./img/mysql/docker/image-3.png)



---
## [2. MySQL Community Downloads](https://dev.mysql.com/downloads/mysql/)

![w:900](./img/mysql/installer/image.png)

---
![Alt text](./img/mysql/installer/image-1.png)

---
![Alt text](./img/mysql/installer/image-2.png)

---
![w:800](./img/mysql/installer/image-3.png)

---
![Alt text](./img/mysql/installer/image-4.png)

---
### 관리자 계정의 비번 생성
- 관리자 계정은 Root입니다.

![Alt text](./img/mysql/installer/image-5.png)

---
### 윈도우즈(OS)에 서비스 등록
![Alt text](./img/mysql/installer/image-6.png)

---
### Connect To Server
- 관리자 계정(root)로 접속 

![Alt text](./img/mysql/installer/image-7.png)

---
![Alt text](./img/mysql/installer/image-8.png)

---
### 설치 결과 확인
![Alt text](./img/mysql/installer/image-9.png)


---
# [MySQL Server 구동방법](https://tableplus.com/blog/2018/10/how-to-start-stop-restart-mysql-server.html)

```bash
 > mysql.server start # 서버 시작
 > mysql.server stop # 서버 멈춤
 > mysql.server restart # 서버 재시작
 > mysql.server status # 서버 상태확인
 ```


