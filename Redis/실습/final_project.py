"""12차시 종합 프로젝트 시작 코드.

TODO가 표시된 함수를 구현한 뒤 이 파일을 실행하세요.
"""

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
    """Cache-Aside로 게시글을 조회하고 60초 동안 캐시한다."""
    # TODO: cache:article:{id} 조회, Hash 조회, JSON 캐시 저장
    raise NotImplementedError


def view_article(client: redis.Redis, article_id: int, user_id: int) -> dict | None:
    """게시글 조회와 함께 조회수, 랭킹, 최근 목록을 갱신한다."""
    # TODO: 존재 확인 후 INCR, ZINCRBY, LPUSH, LTRIM 실행
    raise NotImplementedError


def like_article(client: redis.Redis, article_id: int, user_id: int) -> bool:
    """새 좋아요일 때만 인기 점수를 5 증가시킨다."""
    # TODO: SADD 반환값을 조건으로 사용
    raise NotImplementedError


def get_top_articles(client: redis.Redis, limit: int = 10) -> list[tuple[str, float]]:
    """인기 점수가 높은 게시글을 반환한다."""
    # TODO: Sorted Set을 내림차순으로 조회
    raise NotImplementedError


def main() -> None:
    client = create_client()
    print("Redis 연결:", client.ping())
    seed_articles(client)

    print(view_article(client, article_id=100, user_id=7))
    print("첫 좋아요:", like_article(client, article_id=100, user_id=7))
    print("중복 좋아요:", like_article(client, article_id=100, user_id=7))
    print("인기 게시글:", get_top_articles(client))


if __name__ == "__main__":
    try:
        main()
    except redis.RedisError as error:
        print(f"Redis 실행 또는 연결 상태를 확인하세요: {error}")
    except NotImplementedError:
        print("TODO 함수를 먼저 구현하세요.")
