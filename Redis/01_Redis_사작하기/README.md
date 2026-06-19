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
# [Redis](https://redis.io/)

- Redis는 데이터를 주로 메모리에 저장하는 키-값 기반 데이터 저장소입니다.
- 디스크보다 빠른 메모리에서 데이터를 읽고 쓰기 때문에 빠른 응답이 필요한
캐시, 세션, 카운터, 랭킹, 메시지 처리 등에 자주 사용합니다.
- Redis의 이름은 **Remote Dictionary Server**에서 왔습니다. 단순한 문자열뿐 아니라 List, Set, Sorted Set, Hash 같은 여러 자료구조를 제공합니다.

---
## 관계형 데이터베이스와 비교

| 구분 | 관계형 데이터베이스 | Redis |
|---|---|---|
| 데이터 위치 | 주로 디스크 | 주로 메모리 |
| 데이터 표현 | 테이블, 행, 열 | 키와 자료구조 |
| 조회 방식 | SQL | Redis 명령어 |
| 강점 | 복잡한 조회, 관계, 영구 보관 | 빠른 조회, 만료, 실시간 처리 |
| 대표 용도 | 주문·결제 원본 데이터 | 캐시·세션·랭킹·카운터 |

> Redis가 빠르다고 해서 관계형 데이터베이스를 모두 대체하는 것은 아닙니다.
> 주문과 결제 같은 중요한 원본 데이터는 관계형 데이터베이스에 저장하고, 자주 조회하는 결과를 Redis에 캐시하는 방식으로 함께 사용하는 경우가 많습니다.

---
## Redis의 주요 특징

1. 메모리 기반이라 읽기와 쓰기가 빠릅니다.
2. 키마다 만료 시간을 설정할 수 있습니다.
3. 다양한 자료구조와 원자적 명령을 제공합니다.
4. RDB 또는 AOF 방식으로 데이터를 디스크에 남길 수 있습니다.
5. 복제와 클러스터를 통해 가용성과 확장성을 높일 수 있습니다.

> 메모리는 유한하며 프로세스 종료이나 장애도 발생할 수 있습니다. 
> Redis를 사용할 때는 데이터의 중요도, 메모리 한도, 영속성 정책을 함께 결정해야 합니다.

---
## Redis 설치 및 접속 

---
### Redis 설치 with Docker
> Redis 폴더 이동 후 명령어 실행 

```shell
docker-compose up -d
```
![alt text](image.png)

---
### [Redis 접속](http://localhost:5540/) 

![bg right w:600](image-1.png)

---
![alt text](image-2.png)

---
## 첫 번째 명령

`redis-cli`를 실행한 뒤 다음 명령을 입력합니다.

```redis
PING
SET greeting "Hello Redis"
GET greeting
DEL greeting
GET greeting
```

> 예상 결과는 차례로 `PONG`, `OK`, `Hello Redis`, `1`, `(nil)`입니다.

---
### 명령 구조 읽기

```text
명령어 키 값 또는 옵션
SET    greeting    "Hello Redis"
```

- `SET`: 수행할 작업
- `greeting`: 데이터를 찾기 위한 키
- `"Hello Redis"`: 저장할 값

---
## 5. 서버 정보 확인

```redis
INFO server
INFO memory
DBSIZE
```

`INFO`는 서버 상태를 영역별로 보여 줍니다. 처음에는 모든 항목을 해석하기보다
Redis 버전, 실행 모드, 사용 메모리 정도만 찾아봅니다.

---
## 실습. 나의 첫 Redis 데이터

1. `student:name` 키에 자신의 이름을 저장합니다.
2. 저장한 이름을 조회합니다.
3. `student:course` 키에 `redis`를 저장합니다.
4. 현재 키 개수를 확인합니다.
5. 두 키를 삭제하고 다시 키 개수를 확인합니다.

```redis
SET student:name "민수"
GET student:name
SET student:course redis
DBSIZE
DEL student:name student:course
DBSIZE
```

---
## 확인 문제

1. Redis가 빠른 가장 큰 이유는 무엇인가요?
2. Redis가 관계형 데이터베이스를 항상 대체할 수 없는 이유는 무엇인가요?
3. 서버 연결 상태를 확인하는 명령은 무엇인가요?
4. 존재하지 않는 키를 `GET`하면 어떤 결과가 나오나요?

---
## 정리

- Redis는 메모리를 중심으로 동작하는 키-값 데이터 저장소입니다.
- 관계형 데이터베이스와 경쟁하기보다 서로 다른 역할로 함께 사용합니다.
- `PING`, `SET`, `GET`, `DEL`은 가장 기본적인 Redis 명령입니다.
