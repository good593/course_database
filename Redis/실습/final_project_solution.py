"""12차시 종합 프로젝트 강사용 해답."""

import json
import os

import redis


def create_client() -> redis.Redis:
    return redis.Redis(
        host=os.getenv("REDIS_HOST", "localhost"),
        port=int(os.getenv("REDIS_PORT", "6379")),
        db=int(os.getenv("REDIS_DB", "0")),
        password=os.getenv("REDIS_PASSWORD"),
        decode_responses=True,
    )


def article_key(article_id: int) -> str:
    return f"article:{article_id}"


def seed_articles(client: redis.Redis) -> None:
    client.hset(
        article_key(100),
        mapping={"title": "Redis 입문", "author": "민수", "content": "Redis를 배워 봅시다."},
    )
    client.hset(
        article_key(200),
        mapping={"title": "자료구조 선택", "author": "지수", "content": "요구사항부터 읽어 봅시다."},
    )


def get_article(client: redis.Redis, article_id: int) -> dict | None:
    cache_key = f"cache:article:{article_id}"
    cached = client.get(cache_key)
    if cached is not None:
        return json.loads(cached)

    article = client.hgetall(article_key(article_id))
    if not article:
        return None

    article["id"] = article_id
    client.set(cache_key, json.dumps(article, ensure_ascii=False), ex=60)
    return article


def view_article(client: redis.Redis, article_id: int, user_id: int) -> dict | None:
    article = get_article(client, article_id)
    if article is None:
        return None

    recent_key = f"user:{user_id}:recent-articles"
    with client.pipeline(transaction=False) as pipe:
        pipe.incr(f"article:{article_id}:views")
        pipe.zincrby("ranking:articles", 1, f"article:{article_id}")
        pipe.lpush(recent_key, article_id)
        pipe.ltrim(recent_key, 0, 4)
        views, _, _, _ = pipe.execute()

    article["views"] = int(views)
    return article


def like_article(client: redis.Redis, article_id: int, user_id: int) -> bool:
    if not client.exists(article_key(article_id)):
        return False

    added = client.sadd(f"article:{article_id}:likes", user_id)
    if added == 1:
        client.zincrby("ranking:articles", 5, f"article:{article_id}")
        return True
    return False


def get_top_articles(client: redis.Redis, limit: int = 10) -> list[tuple[str, float]]:
    if limit <= 0:
        return []
    return client.zrange("ranking:articles", 0, limit - 1, desc=True, withscores=True)


def update_article(client: redis.Redis, article_id: int, changes: dict) -> bool:
    if not client.exists(article_key(article_id)):
        return False
    client.hset(article_key(article_id), mapping=changes)
    client.delete(f"cache:article:{article_id}")
    return True


def reset_demo_data(client: redis.Redis) -> None:
    keys = ["ranking:articles", "user:7:recent-articles"]
    for article_id in (100, 200):
        keys.extend(
            [
                article_key(article_id),
                f"article:{article_id}:views",
                f"article:{article_id}:likes",
                f"cache:article:{article_id}",
            ]
        )
    client.delete(*keys)


def main() -> None:
    client = create_client()
    print("Redis 연결:", client.ping())
    reset_demo_data(client)
    seed_articles(client)

    print("첫 조회:", view_article(client, article_id=100, user_id=7))
    print("두 번째 조회:", view_article(client, article_id=100, user_id=7))
    print("첫 좋아요:", like_article(client, article_id=100, user_id=7))
    print("중복 좋아요:", like_article(client, article_id=100, user_id=7))
    print("좋아요 수:", client.scard("article:100:likes"))
    print("최근 조회:", client.lrange("user:7:recent-articles", 0, -1))
    print("인기 게시글:", get_top_articles(client))

    update_article(client, 100, {"title": "Redis 입문 개정판"})
    print("수정 후 조회:", get_article(client, 100))


if __name__ == "__main__":
    try:
        main()
    except redis.RedisError as error:
        print(f"Redis 실행 또는 연결 상태를 확인하세요: {error}")
