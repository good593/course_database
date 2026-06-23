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
# 고급 자료구조

---
## 특징 

| 자료구조 | 특징 | 대표 명령어 | 활용 예시 |
|----------|------|-------------|-----------|
| Bitmap | 0/1 비트로 데이터 저장, 메모리 매우 적게 사용 | `SETBIT`, `GETBIT`, `BITCOUNT` | 출석 체크, 읽음 여부 |
| HyperLogLog | 중복 제거된 개수 근사치 추정, 오차 약 0.81% | `PFADD`, `PFCOUNT` | 순 방문자 수(UV) 집계 |
| Geospatial | 위도/경도 저장 후 거리 계산 및 반경 검색 | `GEOADD`, `GEODIST`, `GEOSEARCH` | 주변 매장 찾기 |
| Stream | 시간 순서대로 데이터 저장, 메시지 큐 | `XADD`, `XREAD`, `XLEN` | 로그 수집, 이벤트 처리 |

---
## 선택 기준

| 요구사항 | 자료구조 |
|---|---|
| 사용자별 출석 여부와 출석자 수 | Bitmap |
| 아주 많은 고유 방문자의 대략적인 수 | HyperLogLog |
| 반경 안의 가까운 매장 | Geospatial |
| 시간 순 이벤트와 소비자 처리 | Stream |

---
## 1. Bitmap: 예/아니오 기록

- `SETBIT`: 특정 offset 위치의 비트를 0 또는 1로 설정
- `GETBIT`: 특정 offset 위치의 비트 값을 조회 (1=켜짐, 0=꺼짐)
- `BITCOUNT`: 비트 값이 1인 개수를 반환
```redis
SETBIT attendance:2026-06-19 1 1  # user1 출석 처리 (offset 1 → 1)
SETBIT attendance:2026-06-19 3 1  # user3 출석 처리 (offset 3 → 1)
SETBIT attendance:2026-06-19 7 1  # user7 출석 처리 (offset 7 → 1)
GETBIT attendance:2026-06-19 3    # user3 출석 여부 확인 → 1 (출석)
GETBIT attendance:2026-06-19 4    # user4 출석 여부 확인 → 0 (미출석)
BITCOUNT attendance:2026-06-19    # 전체 출석 인원 수 조회 → 3
```


---
- `BITOP`: 여러 Bitmap 간의 비트 연산을 수행
```redis
# 6/19와 6/20 둘 다 출석한 유저 계산 → attendance:both에 저장
BITOP AND attendance:both attendance:2026-06-19 attendance:2026-06-20  

# 이틀 연속 출석 인원 수 조회
BITCOUNT attendance:both                                                
```
| 연산 | 의미 | 활용 예시 |
|------|------|-----------|
| `AND` | 둘 다 1인 것만 | 이틀 **모두** 출석한 유저 |
| `OR` | 하나라도 1인 것 | 이틀 중 **한 번이라도** 출석한 유저 |
| `XOR` | 둘 중 하나만 1인 것 | **한 날만** 출석한 유저 |
| `NOT` | 0 <-> 1 반전 | **미출석** 유저 |

---
## 2. HyperLogLog: 고유 개수 추정

HyperLogLog는 실제 방문자 목록을 보관하는 대신 고유한 값의 개수를 매우 적은
메모리로 추정합니다.

```redis
PFADD visitors:2026-06-19 user1 user2 user3 user1
PFCOUNT visitors:2026-06-19
PFADD visitors:2026-06-20 user2 user4
PFMERGE visitors:two-days visitors:2026-06-19 visitors:2026-06-20
PFCOUNT visitors:two-days
```

결과는 근사치입니다. 정확한 사용자 목록이나 정확한 과금 인원이 필요하면 Set이나
원본 데이터베이스를 사용합니다. 대규모 페이지의 대략적인 고유 방문자 수처럼
작은 오차를 허용할 수 있는 통계에 적합합니다.

---
## 3. Geospatial: 위치 기반 검색

경도, 위도, 멤버 순서로 위치를 저장합니다.

```redis
GEOADD stores 126.9780 37.5665 seoul-store
GEOADD stores 129.0756 35.1796 busan-store
GEODIST stores seoul-store busan-store km
GEOSEARCH stores FROMLONLAT 127.0 37.5 BYRADIUS 10 km ASC
```

주변 매장, 배달 가능 지점, 가까운 시설 검색에 활용할 수 있습니다. Redis의
위치 검색은 지구 표면상의 근거리 검색에 유용하지만 복잡한 지도 도형과 공간
분석은 전문 공간 데이터베이스가 더 적합합니다.

---
## 4. Stream: 이벤트 기록

Stream은 시간 순서가 있는 이벤트 로그를 저장합니다. 각 항목은 고유 ID와
필드-값 쌍을 가집니다.

```redis
XADD stream:orders * order_id 1001 status created
XADD stream:orders * order_id 1002 status created
XRANGE stream:orders - +
XLEN stream:orders
```

`*`를 사용하면 Redis가 ID를 생성합니다. 새 이벤트를 기다려 읽을 수 있습니다.

```redis
XREAD BLOCK 10000 STREAMS stream:orders $
```

`$`는 명령 실행 뒤에 들어오는 새 항목부터 읽겠다는 뜻입니다.

### 소비자 그룹 맛보기

```redis
XGROUP CREATE stream:orders order-workers 0 MKSTREAM
XREADGROUP GROUP order-workers worker-1 COUNT 1 STREAMS stream:orders >
XACK stream:orders order-workers 1680000000000-0
```

그룹 생성 시 `0`을 사용했으므로 기존 항목부터 읽습니다. `XACK`의 마지막 값에는
실제로 읽은 메시지 ID를 넣습니다. 소비자 그룹은 여러
작업자에게 메시지를 나누고 처리 확인 상태를 관리합니다. 재처리, 보관 길이,
중복 처리 방지는 애플리케이션에서 추가로 설계해야 합니다.

## 5. 선택 기준

| 요구사항 | 자료구조 |
|---|---|
| 사용자별 출석 여부와 출석자 수 | Bitmap |
| 아주 많은 고유 방문자의 대략적인 수 | HyperLogLog |
| 반경 안의 가까운 매장 | Geospatial |
| 시간 순 이벤트와 소비자 처리 | Stream |

## 실습. 서비스 활동 기록

1. Bitmap에 사용자 2, 5, 8의 오늘 로그인 여부를 기록합니다.
2. 오늘 로그인한 사용자 수를 구합니다.
3. HyperLogLog에 페이지 방문자 5명을 추가하되 한 명은 중복 입력합니다.
4. 고유 방문자 추정값을 조회합니다.
5. Stream에 로그인 이벤트 두 건을 추가하고 전체 이벤트를 조회합니다.

## 확인 문제

1. 정확한 방문자 목록이 필요할 때 HyperLogLog가 적합하지 않은 이유는 무엇인가요?
2. Bitmap이 효율적이려면 비트 위치로 어떤 값이 필요하나요?
3. Stream 항목의 `*`는 무엇을 의미하나요?
4. 주변 매장 검색에 사용할 수 있는 자료구조는 무엇인가요?

## 정리

- Bitmap은 작은 공간으로 참·거짓 상태를 기록합니다.
- HyperLogLog는 고유 개수를 근사하여 메모리를 절약합니다.
- Geospatial은 근거리 위치 검색, Stream은 이벤트 처리에 사용합니다.
