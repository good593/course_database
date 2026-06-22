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
# 7차시. Sorted Set

## 학습 목표

- 멤버와 점수를 Sorted Set에 저장할 수 있습니다.
- 순위와 점수 범위로 데이터를 조회할 수 있습니다.
- 실시간 랭킹 기능을 설계할 수 있습니다.

## 1. Sorted Set

Sorted Set은 Set처럼 멤버의 중복을 허용하지 않지만, 각 멤버에 `score`라는
숫자를 연결합니다. Redis는 점수 순서대로 멤버를 정렬합니다.

```text
member: user:7   score: 120
member: user:3   score: 250
member: user:9   score: 410
```

같은 멤버를 다시 추가하면 새 항목이 생기는 대신 점수가 변경됩니다.

## 2. 점수 저장과 조회

```redis
DEL game:ranking
ZADD game:ranking 120 user:7
ZADD game:ranking 250 user:3 410 user:9
ZRANGE game:ranking 0 -1 WITHSCORES
ZRANGE game:ranking 0 -1 REV WITHSCORES
```

- `ZADD`: 멤버와 점수 추가 또는 변경
- `ZRANGE`: 낮은 점수부터 범위 조회
- `REV`: 높은 점수부터 역순 조회
- `WITHSCORES`: 결과에 점수 포함

점수가 같으면 멤버의 문자열 순서로 정렬됩니다. 공동 순위 규칙이 중요한
서비스라면 동점 처리 기준을 별도로 정해야 합니다.

## 3. 점수 변경과 순위 확인

```redis
ZINCRBY game:ranking 50 user:7
ZSCORE game:ranking user:7
ZRANK game:ranking user:7
ZREVRANK game:ranking user:7
```

순위 인덱스는 `0`부터 시작합니다. 사용자에게 1등부터 보여 주려면 반환값에
1을 더합니다. `ZRANK`는 오름차순, `ZREVRANK`는 내림차순 순위입니다.

## 4. 범위 조회

상위 세 명을 조회합니다.

```redis
ZRANGE game:ranking 0 2 REV WITHSCORES
```

점수가 200 이상 500 이하인 사용자를 조회합니다.

```redis
ZRANGE game:ranking 200 500 BYSCORE WITHSCORES
```

점수나 순위 범위로 항목을 삭제할 수도 있습니다.

```redis
ZREM game:ranking user:7
ZREMRANGEBYSCORE game:ranking -inf 99
```

## 5. 실시간 인기 게시글

게시글을 조회하거나 좋아요를 누르면 점수를 높입니다.

```redis
ZINCRBY ranking:articles:daily 1 article:100
ZINCRBY ranking:articles:daily 1 article:100
ZINCRBY ranking:articles:daily 5 article:200
ZRANGE ranking:articles:daily 0 9 REV WITHSCORES
```

일별 랭킹 키에 TTL을 설정하면 오래된 랭킹을 자동으로 정리할 수 있습니다.

```redis
EXPIRE ranking:articles:daily 172800
```

운영 서비스에서는 날짜를 키에 포함해 일별 랭킹을 분리하는 방법도 사용합니다.

```text
ranking:articles:2026-06-19
```

## 6. List, Set, Sorted Set 비교

| 질문 | 적합한 자료구조 |
|---|---|
| 입력된 순서가 중요한가? | List |
| 중복 없이 포함 여부만 필요한가? | Set |
| 중복 없이 점수와 순위가 필요한가? | Sorted Set |

## 실습. 반 성적 순위

```redis
ZADD class:score 88 student:1 95 student:2 76 student:3 88 student:4
ZRANGE class:score 0 -1 REV WITHSCORES
ZREVRANK class:score student:1
ZINCRBY class:score 5 student:3
ZRANGE class:score 80 +inf BYSCORE WITHSCORES
ZCARD class:score
```

### 도전 과제

게임 시즌별 랭킹 키를 설계하고 상위 3명, 특정 사용자의 점수와 순위를 조회하는
명령을 작성합니다.

## 확인 문제

1. Set과 Sorted Set의 가장 큰 차이는 무엇인가요?
2. 높은 점수부터 상위 10명을 조회하는 명령은 무엇인가요?
3. `ZREVRANK`가 `0`을 반환하면 사용자에게는 몇 등으로 표시해야 하나요?
4. 같은 멤버에 `ZADD`를 다시 실행하면 어떻게 되나요?

## 정리

- Sorted Set은 고유한 멤버를 점수 순서로 관리합니다.
- 순위표, 우선순위 목록, 시간순 데이터에 활용할 수 있습니다.
- 동점 규칙, 기간별 키, 오래된 데이터 정리 정책을 함께 설계합니다.
