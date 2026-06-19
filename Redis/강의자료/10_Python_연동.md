# 10차시. Python 연동

## 학습 목표

- Python에서 Redis 서버에 연결할 수 있습니다.
- 문자열과 Hash 데이터를 Python 값으로 변환할 수 있습니다.
- Cache-Aside 함수를 구현할 수 있습니다.

## 1. 클라이언트 설치

Python용 Redis 클라이언트를 설치합니다.

```bash
python -m pip install redis
```

Redis 서버가 `localhost:6379`에서 실행 중인지 확인합니다.

## 2. 연결과 기본 명령

```python
import redis

client = redis.Redis(
    host="localhost",
    port=6379,
    db=0,
    decode_responses=True,
)

print(client.ping())
client.set("python:greeting", "Hello Redis", ex=60)
print(client.get("python:greeting"))
```

`decode_responses=True`를 지정하면 응답을 `bytes` 대신 Python 문자열로
받습니다. 이미지나 직렬화된 바이너리를 저장할 때는 이 옵션을 사용하지 않을 수
있습니다.

## 3. 명령어와 메서드 대응

| Redis 명령 | Python 메서드 |
|---|---|
| `SET key value EX 60` | `client.set(key, value, ex=60)` |
| `GET key` | `client.get(key)` |
| `HSET user:7 name 민수` | `client.hset("user:7", "name", "민수")` |
| `LPUSH queue job` | `client.lpush("queue", "job")` |
| `SADD tags redis` | `client.sadd("tags", "redis")` |
| `ZADD rank 100 user:7` | `client.zadd("rank", {"user:7": 100})` |

라이브러리의 인자 순서가 Redis CLI와 완전히 같지 않은 경우가 있습니다. 특히
`zadd`는 멤버와 점수를 Python 딕셔너리로 전달합니다.

## 4. JSON 직렬화

```python
import json

product = {"id": 1001, "name": "키보드", "price": 49000}
client.set("cache:product:1001", json.dumps(product, ensure_ascii=False), ex=60)

cached = client.get("cache:product:1001")
if cached is not None:
    product = json.loads(cached)
    print(product["name"])
```

Redis String에는 Python 딕셔너리를 그대로 저장할 수 없으므로 JSON 문자열로
직렬화합니다. 캐시에서 읽은 뒤에는 역직렬화합니다.

## 5. Cache-Aside 구현

```python
import json


def get_product(product_id: int) -> dict | None:
    key = f"cache:product:{product_id}"
    cached = client.get(key)
    if cached is not None:
        print("cache hit")
        return json.loads(cached)

    print("cache miss")
    product = load_product_from_db(product_id)
    if product is None:
        return None

    client.set(key, json.dumps(product, ensure_ascii=False), ex=60)
    return product
```

데이터를 수정한 뒤에는 관련 캐시를 삭제합니다.

```python
def update_product(product_id: int, changes: dict) -> None:
    update_product_in_db(product_id, changes)
    client.delete(f"cache:product:{product_id}")
```

## 6. Pipeline

여러 명령을 서버에 한 번에 전송하면 네트워크 왕복을 줄일 수 있습니다.

```python
with client.pipeline(transaction=False) as pipe:
    pipe.incr("stats:views")
    pipe.lpush("stats:recent", "article:100")
    pipe.ltrim("stats:recent", 0, 9)
    results = pipe.execute()

print(results)
```

Pipeline은 기본적으로 전송 최적화 도구입니다. 여러 명령을 하나의 트랜잭션으로
묶어야 하는 문제와는 구분합니다. `transaction=True`는 `MULTI/EXEC`을 사용하지만,
업무 조건 검사까지 자동으로 해결해 주지는 않습니다.

## 7. 예외 처리와 운영 설정

```python
try:
    value = client.get("important:key")
except redis.RedisError as error:
    print(f"Redis error: {error}")
    value = None
```

- 연결 제한 시간을 설정합니다.
- 연결 풀을 사용하여 연결을 재사용합니다.
- Redis 장애 시 원본 DB 조회 또는 오류 응답 등 정책을 정합니다.
- 비밀번호와 주소를 소스 코드에 직접 저장하지 않습니다.
- 캐시는 없어도 원본 데이터로 복구할 수 있게 설계합니다.

## 실습

[Python 실습 코드](../실습/redis_python_demo.py)를 실행하고 다음을 확인합니다.

1. 첫 조회는 캐시 실패입니다.
2. 두 번째 조회는 캐시 적중입니다.
3. TTL이 설정되어 있습니다.
4. 상품 수정 후 캐시가 삭제됩니다.

## 확인 문제

1. `decode_responses=True`의 역할은 무엇인가요?
2. Python 딕셔너리를 String에 저장하기 전에 필요한 과정은 무엇인가요?
3. Cache-Aside에서 캐시 실패 시 어떤 순서로 처리하나요?
4. Pipeline을 사용하는 주된 목적은 무엇인가요?

## 정리

- Python에서는 `redis` 패키지로 Redis 명령을 실행합니다.
- 직렬화와 역직렬화, TTL, 캐시 무효화를 함께 구현해야 합니다.
- 애플리케이션은 Redis 연결 실패에 대한 처리 정책을 가져야 합니다.
