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
# 8차시. Hash

## 학습 목표

- 하나의 키 안에 여러 필드와 값을 저장할 수 있습니다.
- Hash의 필드를 조회, 수정, 삭제할 수 있습니다.
- Hash와 JSON String의 차이를 설명할 수 있습니다.

## 1. Redis Hash

Hash는 하나의 키 안에 `field-value` 쌍을 저장합니다. 사용자, 상품처럼 여러
속성을 가진 객체를 표현하기 좋습니다.

```text
key: user:7
  name  -> 민수
  email -> minsu@example.com
  level -> 1
```

## 2. 필드 저장과 조회

```redis
HSET user:7 name "민수" email "minsu@example.com" level 1
HGET user:7 name
HMGET user:7 name level
HGETALL user:7
HLEN user:7
```

- `HSET`: 하나 이상의 필드 저장
- `HGET`: 한 필드 조회
- `HMGET`: 여러 필드 조회
- `HGETALL`: 모든 필드와 값 조회
- `HLEN`: 필드 개수 조회

존재하지 않는 필드를 `HGET`하면 `(nil)`이 반환됩니다.

## 3. 필드 수정과 삭제

```redis
HSET user:7 level 2
HINCRBY user:7 points 10
HEXISTS user:7 email
HDEL user:7 email
HGETALL user:7
```

`HINCRBY`는 Hash 안의 정수 필드를 원자적으로 증가시킵니다. 실수는
`HINCRBYFLOAT`을 사용합니다.

## 4. 상품 객체 만들기

```redis
HSET product:1001 name "키보드" price 49000 stock 20 category keyboard
HGET product:1001 price
HINCRBY product:1001 stock -1
HMGET product:1001 name price stock
EXPIRE product:1001 300
```

일반적인 `EXPIRE`는 Hash의 개별 필드가 아니라 `product:1001` 키 전체에
적용됩니다. 강의 실습에서는 객체 전체의 수명을 기준으로 TTL을 설정합니다.

> 재고 차감은 단순 명령 실습입니다. 실제 주문에서는 재고 부족 검사, 결제 실패,
> 원본 DB와의 일관성, 동시성까지 함께 처리해야 합니다.

## 5. Hash와 JSON String 비교

| 구분 | Hash | JSON String |
|---|---|---|
| 일부 필드 조회 | 가능 | 전체 문자열을 읽어 파싱 |
| 일부 필드 수정 | 가능 | 전체 값을 다시 저장 |
| 중첩 객체 표현 | 직접 표현하기 불편 | 자연스럽게 표현 가능 |
| 애플리케이션 전달 | 필드 조립 필요 | JSON 그대로 전달 가능 |
| 숫자 증가 | `HINCRBY` 가능 | 파싱 후 수정 필요 |

항상 한 방식이 더 좋은 것은 아닙니다. 읽기와 수정 패턴, 객체의 중첩 구조,
직렬화 비용을 보고 선택합니다.

## 6. 큰 Hash 탐색

`HGETALL`은 모든 필드를 한 번에 반환합니다. 필드가 매우 많다면 `HSCAN`으로
점진적으로 조회합니다.

```redis
HSCAN large:hash 0 MATCH profile:* COUNT 100
```

## 실습. 사용자 프로필

```redis
HSET user:10 name "지수" level 1 points 0 status active
HINCRBY user:10 points 50
HINCRBY user:10 level 1
HMGET user:10 name level points
HEXISTS user:10 phone
HSET user:10 phone "010-0000-0000"
HDEL user:10 phone
HGETALL user:10
```

### 생각해 보기

주소처럼 시·구·도로명으로 중첩된 정보를 Hash에 저장하는 방법과 JSON으로
저장하는 방법을 비교합니다.

## 확인 문제

1. 여러 필드를 한 번에 조회하는 명령은 무엇인가요?
2. 포인트 필드를 10 증가시키는 명령은 무엇인가요?
3. `EXPIRE user:7 60`은 특정 필드에만 적용되나요?
4. 중첩 객체를 그대로 저장할 때 Hash와 JSON 중 어느 쪽이 더 자연스러운가요?

## 정리

- Hash는 하나의 객체를 여러 필드로 표현합니다.
- 필드 단위 조회와 숫자 증감이 가능하다는 장점이 있습니다.
- 저장 형식은 실제 조회와 수정 패턴을 기준으로 선택합니다.
