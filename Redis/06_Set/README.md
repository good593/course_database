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
# 6차시. Set

## 학습 목표

- 중복 없는 값을 Set에 저장할 수 있습니다.
- 합집합, 교집합, 차집합을 구할 수 있습니다.
- 좋아요와 관심사 기능을 Set으로 모델링할 수 있습니다.

## 1. Redis Set

Set은 순서 없이 중복되지 않는 문자열을 저장합니다. 특정 값의 포함 여부를
빠르게 확인하거나 여러 집합의 관계를 계산할 때 사용합니다.

```redis
DEL demo:set
SADD demo:set apple banana apple
SMEMBERS demo:set
SCARD demo:set
SISMEMBER demo:set apple
```

`SADD`의 결과는 실제로 새로 추가된 값의 개수입니다. 위 예에서 `apple`은
두 번 전달되지만 한 번만 저장됩니다.

## 2. 추가, 삭제, 무작위 선택

```redis
SADD event:participants user1 user2 user3
SREM event:participants user2
SISMEMBER event:participants user2
SRANDMEMBER event:participants
SPOP event:participants
```

- `SRANDMEMBER`: 무작위 값을 반환하지만 삭제하지 않음
- `SPOP`: 무작위 값을 반환하고 집합에서 삭제

경품 추첨에서 후보를 유지하려면 `SRANDMEMBER`, 한 번 뽑힌 사람을 제외하려면
`SPOP`을 사용할 수 있습니다.

## 3. 집합 연산

```redis
SADD user:1:interests redis python database
SADD user:2:interests redis java database
SINTER user:1:interests user:2:interests
SUNION user:1:interests user:2:interests
SDIFF user:1:interests user:2:interests
```

- `SINTER`: 모든 집합에 공통으로 있는 값
- `SUNION`: 어느 한 집합에라도 있는 값
- `SDIFF`: 첫 번째 집합에만 있는 값

결과를 새 Set에 저장하려면 `SINTERSTORE`, `SUNIONSTORE`, `SDIFFSTORE`를
사용합니다.

## 4. 게시글 좋아요

게시글마다 좋아요를 누른 사용자 번호를 Set으로 저장합니다.

```redis
SADD article:100:likes 7
SADD article:100:likes 8
SADD article:100:likes 7
SCARD article:100:likes
SISMEMBER article:100:likes 7
SREM article:100:likes 7
```

사용자 7이 여러 번 요청해도 한 번만 저장됩니다. `SCARD`는 좋아요 수,
`SISMEMBER`는 현재 사용자의 좋아요 여부를 알려 줍니다.

## 5. Set을 선택하는 기준

Set이 적합한 질문은 다음과 같습니다.

- 이 사용자가 이미 참여했는가?
- 고유 방문자는 누구인가?
- 두 사용자의 공통 관심사는 무엇인가?
- 중복 없이 태그를 관리하려면 어떻게 할까?

순위나 점수가 필요하면 Sorted Set, 필드와 값이 필요하면 Hash를 사용합니다.

## 실습. 스터디 관심사 추천

```redis
SADD student:1:skills python redis sql
SADD student:2:skills java redis spring
SADD student:3:skills python django sql
SINTER student:1:skills student:2:skills
SINTER student:1:skills student:3:skills
SUNION student:1:skills student:2:skills student:3:skills
SDIFF student:1:skills student:2:skills
```

### 도전 과제

게시글 100과 200을 모두 좋아한 사용자를 찾는 키와 명령을 작성합니다.

## 주의할 점

`SMEMBERS`는 전체 값을 반환합니다. 매우 큰 Set에서는 `SSCAN`으로 나누어
조회합니다.

```redis
SSCAN article:100:likes 0 COUNT 100
```

집합 연산도 입력 집합이 매우 크면 서버에 부담을 줄 수 있습니다. 데이터 크기와
호출 빈도를 확인하고 필요하면 결과를 미리 계산하거나 범위를 나눕니다.

## 확인 문제

1. `SADD`로 같은 값을 두 번 추가하면 어떻게 되나요?
2. 좋아요 수를 구하는 명령은 무엇인가요?
3. 두 사용자의 공통 관심사를 구하는 명령은 무엇인가요?
4. `SRANDMEMBER`와 `SPOP`의 차이는 무엇인가요?

## 정리

- Set은 중복 없는 값과 포함 여부 확인에 적합합니다.
- 집합 연산으로 공통점과 차이점을 구할 수 있습니다.
- 큰 Set 전체를 조회할 때는 `SMEMBERS` 대신 `SSCAN`을 고려합니다.
