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
# 4차시. String 활용

## 학습 목표

- String의 여러 저장 및 조회 명령을 사용할 수 있습니다.
- 원자적 증가 명령으로 카운터를 구현할 수 있습니다.
- 문자열, 숫자, JSON 저장 방식의 특징을 설명할 수 있습니다.

## 1. Redis String

String은 Redis의 가장 기본적인 자료형입니다. 텍스트, 정수, 실수, JSON, 직렬화된
데이터 등을 저장할 수 있습니다. 값의 최대 크기는 크지만, 큰 값을 많이 저장하면
네트워크와 메모리 비용이 커지므로 캐시 대상을 적절히 나누어야 합니다.

```redis
SET message "hello"
GET message
STRLEN message
APPEND message " redis"
GET message
GETRANGE message 0 4
```

## 2. 여러 값 처리

```redis
MSET user:1:name "민수" user:2:name "지수" user:3:name "수진"
MGET user:1:name user:2:name user:3:name
```

`MSET`과 `MGET`은 왕복 횟수를 줄일 수 있습니다. 다만 서로 관련 없는 많은 키를
무제한으로 한 번에 요청하면 서버와 네트워크에 부담이 되므로 적절한 크기로
나눕니다.

## 3. 카운터

```redis
SET article:100:views 0
INCR article:100:views
INCRBY article:100:views 10
DECR article:100:views
GET article:100:views
```

- `INCR`: 값을 1 증가
- `INCRBY`: 지정한 정수만큼 증가
- `DECR`, `DECRBY`: 값을 감소
- `INCRBYFLOAT`: 실수만큼 증가

`INCR`는 서버에서 하나의 원자적 명령으로 처리됩니다. 여러 사용자가 동시에
조회수를 증가시켜도 단순한 `GET` 후 `SET`보다 값이 사라질 위험이 작습니다.

## 4. JSON 저장

```redis
SET cache:product:1001 '{"id":1001,"name":"키보드","price":49000}' EX 60
GET cache:product:1001
```

JSON 문자열은 객체 전체를 한 번에 저장하고 읽기 쉽지만, 일부 필드만 수정하려면
전체 값을 읽어 다시 저장해야 합니다. 필드 단위 조회와 수정이 필요하면 8차시의
Hash를 고려합니다.

## 5. 간단한 요청 제한

사용자별 API 호출 횟수를 1분 동안 셉니다.

```redis
SET rate:user:7 1 EX 60 NX
INCR rate:user:7
TTL rate:user:7
```

이 예제는 원리를 이해하기 위한 단순한 형태입니다. 첫 요청에 `SET NX`와 이후
`INCR`을 구분하는 애플리케이션 로직이 필요합니다. 엄격한 요청 제한에서는
경계 시점, 여러 명령의 원자성, 서버 시간, 실패 처리까지 설계해야 합니다.

## 실습. 게시글 조회수

1. 게시글 100과 200의 조회수를 0으로 초기화합니다.
2. 게시글 100의 조회수를 세 번 증가시킵니다.
3. 게시글 200의 조회수를 5만큼 증가시킵니다.
4. 두 값을 한 번에 조회합니다.
5. 게시글 100의 조회수를 1만큼 감소시킵니다.

```redis
MSET article:100:views 0 article:200:views 0
INCR article:100:views
INCR article:100:views
INCR article:100:views
INCRBY article:200:views 5
MGET article:100:views article:200:views
DECR article:100:views
```

### 생각해 보기

상품 정보를 JSON String 하나로 저장하는 방식과 각 속성을 별도의 String 키로
저장하는 방식의 장단점을 비교합니다.

## 확인 문제

1. `MGET`을 사용하는 목적은 무엇인가요?
2. 조회수 증가에 `GET`과 `SET`보다 `INCR`이 적합한 이유는 무엇인가요?
3. JSON String에서 가격만 수정하려면 어떤 과정이 필요한가요?
4. 숫자가 아닌 문자열에 `INCR`을 실행하면 어떻게 되나요?

## 정리

- String은 텍스트, 숫자, 직렬화된 객체에 사용할 수 있습니다.
- `INCR` 계열 명령은 카운터를 원자적으로 변경합니다.
- 저장 방식은 전체 조회와 부분 수정 중 어떤 작업이 많은지 보고 선택합니다.
