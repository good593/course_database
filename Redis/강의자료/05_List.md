# 5차시. List

## 학습 목표

- List의 양쪽에 값을 추가하고 제거할 수 있습니다.
- 최근 목록과 간단한 작업 큐를 구현할 수 있습니다.
- List 사용 시 중복과 실패 처리 문제를 설명할 수 있습니다.

## 1. Redis List

List는 문자열 값을 순서대로 저장하는 자료구조입니다. 왼쪽과 오른쪽에서 값을
빠르게 넣거나 뺄 수 있어 최근 기록, 대기열, 간단한 큐에 적합합니다.

```text
왼쪽 <- [A] [B] [C] -> 오른쪽
```

## 2. 값 추가와 조회

```redis
DEL demo:list
LPUSH demo:list B
LPUSH demo:list A
RPUSH demo:list C
LRANGE demo:list 0 -1
LLEN demo:list
```

- `LPUSH`: 왼쪽에 추가
- `RPUSH`: 오른쪽에 추가
- `LRANGE key start stop`: 범위 조회
- `LLEN`: 목록 길이

인덱스 `0`은 첫 번째 값이고 `-1`은 마지막 값입니다. 따라서
`LRANGE key 0 -1`은 전체 목록을 조회합니다. 운영 환경에서는 목록이 매우 길 수
있으므로 전체 대신 필요한 범위만 조회합니다.

## 3. 값 꺼내기

```redis
LPOP demo:list
RPOP demo:list
LRANGE demo:list 0 -1
```

`LPOP`과 `RPOP`은 값을 반환하면서 목록에서 제거합니다. 조회만 하려면
`LINDEX`, 범위를 자르려면 `LTRIM`을 사용합니다.

```redis
LINDEX demo:list 0
LTRIM demo:list 0 9
```

## 4. 최근 조회 상품

사용자 7이 상품 1001, 1002, 1003을 차례로 봤다고 가정합니다.

```redis
LPUSH user:7:recent-products 1001
LPUSH user:7:recent-products 1002
LPUSH user:7:recent-products 1003
LTRIM user:7:recent-products 0 4
LRANGE user:7:recent-products 0 -1
```

새 값을 왼쪽에 넣고 최근 5개만 남깁니다. List는 중복을 허용하므로 같은 상품을
다시 보면 목록에 다시 들어갑니다. 중복 없는 최근 목록이 필요하면 애플리케이션
로직이나 Sorted Set을 고려합니다.

## 5. 작업 큐

생산자는 오른쪽에 작업을 추가하고 소비자는 왼쪽에서 꺼냅니다.

```redis
RPUSH queue:email '{"to":"user@example.com","template":"welcome"}'
LPOP queue:email
```

작업이 없을 때 계속 확인하는 대신 블로킹 명령을 사용할 수 있습니다.

```redis
BLPOP queue:email 10
```

마지막 숫자는 대기할 초입니다. `0`이면 작업이 들어올 때까지 계속 기다립니다.

단순 `LPOP`은 작업을 꺼낸 직후 소비자가 실패하면 작업을 잃을 수 있습니다.
실무에서는 대기 큐에서 처리 중 큐로 원자적으로 이동하거나, 재처리와 확인 응답이
필요한 메시징 시스템을 사용합니다. Redis Streams는 9차시에서 다룹니다.

## 실습. 주문 처리 대기열

터미널을 두 개 준비합니다.

### 터미널 A: 소비자

```redis
BLPOP queue:orders 0
```

### 터미널 B: 생산자

```redis
RPUSH queue:orders order-1001
RPUSH queue:orders order-1002
RPUSH queue:orders order-1003
```

터미널 A에서 작업이 들어올 때마다 결과가 반환되는지 확인합니다. 명령이 끝나면
다시 `BLPOP queue:orders 0`을 실행합니다.

## 확인 문제

1. `LPUSH` 후 `LRANGE key 0 -1`을 하면 새 값은 어느 쪽에 보이나요?
2. 최근 10개 항목만 유지할 때 사용할 명령은 무엇인가요?
3. `LPOP` 기반 작업 큐에서 소비자 장애 시 작업을 잃을 수 있는 이유는 무엇인가요?
4. `BLPOP`의 마지막 인자 `0`은 무엇을 의미하나요?

## 정리

- List는 순서와 양쪽 삽입·삭제가 필요한 데이터에 적합합니다.
- `LPUSH`와 `LTRIM`으로 크기가 제한된 최근 목록을 만들 수 있습니다.
- 간단한 큐는 구현하기 쉽지만 작업 유실과 재처리를 별도로 설계해야 합니다.
