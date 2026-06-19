"""10차시 Cache-Aside 실습 예제."""

import json
import os

import redis


FAKE_DATABASE = {
    1001: {"id": 1001, "name": "키보드", "price": 49000},
    1002: {"id": 1002, "name": "마우스", "price": 29000},
}


def create_client() -> redis.Redis:
    return redis.Redis(
        host=os.getenv("REDIS_HOST", "localhost"),
        port=int(os.getenv("REDIS_PORT", "6379")),
        db=int(os.getenv("REDIS_DB", "0")),
        password=os.getenv("REDIS_PASSWORD"),
        decode_responses=True,
        socket_connect_timeout=2,
        socket_timeout=2,
    )


def load_product_from_db(product_id: int) -> dict | None:
    print(f"DB 조회: product_id={product_id}")
    product = FAKE_DATABASE.get(product_id)
    return product.copy() if product is not None else None


def get_product(client: redis.Redis, product_id: int) -> dict | None:
    key = f"class:cache:product:{product_id}"
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


def update_product(client: redis.Redis, product_id: int, changes: dict) -> None:
    product = FAKE_DATABASE.get(product_id)
    if product is None:
        raise KeyError(f"상품이 없습니다: {product_id}")

    product.update(changes)
    client.delete(f"class:cache:product:{product_id}")
    print("DB 수정 및 캐시 삭제 완료")


def main() -> None:
    client = create_client()
    print("Redis 연결:", client.ping())

    cache_key = "class:cache:product:1001"
    client.delete(cache_key)

    print("첫 번째 조회:", get_product(client, 1001))
    print("두 번째 조회:", get_product(client, 1001))
    print("남은 TTL:", client.ttl(cache_key))

    update_product(client, 1001, {"price": 45000})
    print("수정 후 조회:", get_product(client, 1001))


if __name__ == "__main__":
    try:
        main()
    except redis.RedisError as error:
        print(f"Redis 실행 또는 연결 상태를 확인하세요: {error}")
