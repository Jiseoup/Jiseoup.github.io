---
title: "[Redis] KEYS 대신 SCAN을 써야 하는 이유"
slug: redis-scan-vs-keys
date: 2025-11-17 22:27:00 +09:00
last_modified_at: 2025-11-17 22:27:00 +09:00
categories: [Database, Redis]
tags: [redis, performance]
image: "/assets/img/title/database/redis/logo_designed_1.png"
---

Redis를 사용하다 보면 특정 패턴의 키를 찾아야 하는 상황이 자주 발생합니다.  
예를 들어 `user:*` 형태의 모든 사용자 키를 찾거나, `session:*` 패턴의 세션 키들을 정리해야 할 때가 있죠.  
이럴 때 가장 먼저 떠오르는 명령어가 바로 **`KEYS`**입니다.  

하지만, **프로덕션 환경에서 KEYS 명령어를 사용하면 서비스 장애**로 이어질 수 있습니다.  
[Redis 공식 문서](https://redis.io/docs/latest/commands/keys/)에도 프로덕션 환경에서 KEYS 사용을 피하라는 경고가 명시되어 있습니다.  

이번 포스팅에서는 **KEYS 명령어의 위험성**과 대안인 **SCAN 명령어를 사용해야 하는 이유**를 알아보겠습니다.  

## 1. KEYS 명령어란?
---
KEYS 명령어는 **패턴과 일치하는 모든 키를 반환**하는 명령어입니다.  
```bash
# 모든 키 조회
KEYS *

# 특정 패턴의 키 조회 1: user로 시작하는 모든 키
KEYS user:*

# 특정 패턴의 키 조회 2: created_at이 2025년 11월인 모든 키
KEYS created_at:2025-11-*
```
사용법도 간단하고 한 번의 명령으로 원하는 모든 키를 가져올 수 있어 편리해 보입니다.  
하지만 여기에 **치명적인 문제**가 숨어있습니다.  

## 2. KEYS 명령어의 위험성
---
KEYS 명령어는 프로덕션 환경에서 사용하면 서비스 전체를 마비시킬 수 있습니다.  
아래는 KEYS 명령어가 위험한 이유입니다.  

### 2-1. O(N) 시간 복잡도와 블로킹

KEYS 명령어의 가장 큰 문제는 **시간 복잡도가 O(N)**이라는 점입니다.  
즉, Redis에 **저장된 키의 개수가 많을수록 KEYS 명령어의 성능은 떨어집니다.**  

또한, Redis는 **싱글 스레드**로 동작하기 때문에 **KEYS 명령어가 실행되는 동안 다른 모든 명령은 대기**해야 합니다.  
만약 Redis에 100만 개의 키가 있다면, KEYS 명령어는 100만 개의 키를 모두 검사할 때까지 **Redis를 블로킹**합니다.  

```python
# 위험한 예시 ❌
import redis

client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

# Redis에 유저 키가 100만 개 있다면? → ⚠️ 수 초 동안 Redis 블로킹
keys = client.keys('user:*')
for key in keys:
    user_id = client.hget(key, 'id')
    ...
```

특히 **트래픽이 많은 프로덕션 환경**에서 위 예시와 같은 코드를 배포하면 심각한 문제가 발생합니다.  
KEYS 명령어가 실행되는 동안 Redis는 응답 불가 상태가 되고, 이 시간 동안 **Redis를 사용하는 모든 API 요청과 캐시 조회 등의 작업이 블로킹**됩니다.  
결과적으로 **서비스 전체가 일시적으로 장애 상태**에 빠질 수 있습니다.  

### 2-2. 메모리 문제

KEYS 명령어는 **매칭되는 모든 키를 메모리에 올린 후 한 번에 반환**합니다.  
패턴에 매칭되는 키가 수십만 개라면 **메모리 사용량이 급증**할 수 있습니다.  

```bash
# 100만 개의 키가 매칭된다면? → ⚠️ 엄청난 메모리 사용과 네트워크 대역폭 낭비
KEYS user:*
```

## 3. SCAN 명령어란?
---
SCAN 명령어는 **커서 기반 반복자(Cursor-Based Iterator)**를 사용합니다.  
KEYS 명령어가 전체 키를 한 번에 검사하는 방식과 달리, **일정량씩 나눠서 검사**합니다.  

즉, 한 번의 명령 호출마다 적은 수의 요소만 반환하기 때문에, Redis가 중간중간 다른 명령을 처리할 수 있어 **프로덕션 환경에서도 안전하게 사용**할 수 있습니다.  

아래는 SCAN 명령어의 기본적인 사용법입니다.  
```bash
SCAN {$cursor} MATCH {$pattern} COUNT {$count}
```
* **cursor**: 스캔을 시작할 커서 위치 (처음 시작할 때는 0)
* **pattern**: 검색할 키의 패턴 (예시: `user:*`)
* **count**: 한 번에 스캔할 대략적인 키의 개수

여기서 `COUNT`는 옵션 값으로 생략 가능하지만, 효율적으로 스캔하기 위해 상황에 맞게 설정하는 것을 권장합니다.  
또한, `COUNT`는 **정확한 반환 개수를 보장하는 것이 아니라 Redis에게 주는 힌트 값**이기 때문에, 실제로 반환되는 키의 개수는 **`COUNT` 값보다 많거나 적을 수 있습니다.**  

## 4. SCAN 명령어 동작 원리
---
아래는 SCAN 명령어로 `user:*` 패턴에 일치하는 Redis 키를 조회하는 예시입니다.  
```bash
redis-cli> SCAN 0 MATCH user:* COUNT 3
1) "12"
2) 1) "user:5"
   2) "user:8"
   3) "user:4"

redis-cli> SCAN 12 MATCH user:* COUNT 3
1) "2"
2) 1) "user:7"
   2) "user:6"
   3) "user:3"

redis-cli> SCAN 2 MATCH user:* COUNT 3
1) "5"
2) 1) "user:1"

redis-cli> SCAN 5 MATCH user:* COUNT 3
1) "0"
2) 1) "user:9"
   2) "user:2"
```
위와 같이 SCAN 명령은 **두 가지 값을 반환**합니다.  
1. **다음 커서 위치** (첫 번째 값)  
2. **패턴에 매칭되는 키 목록** (두 번째 값)  

**동작 원리:**
* 처음에는 커서 `0`으로 시작합니다.  
* 각 호출마다 반환된 다음 커서 값을 사용하여 스캔을 이어갑니다.  
* 커서가 다시 `0`으로 돌아오면 **전체 스캔이 완료**된 것입니다.  

이 방식을 통해 Redis는 한 번에 소량의 키만 처리하므로, 중간에 다른 명령어들을 처리할 수 있습니다.  

아래는 위 과정을 Python 코드로 구현한 예시입니다.  
```python
import redis

client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

for key in client.scan_iter(match='user:*', count=3):
    print(key)
```

**실행 결과:**
```bash
b'user:5'
b'user:8'
b'user:4'
b'user:7'
b'user:6'
b'user:3'
b'user:1'
b'user:9'
b'user:2'
```

이처럼 SCAN을 사용하면 **프로덕션 환경에서도 Redis를 블로킹하지 않고 안전하게 키를 탐색**할 수 있습니다.  

## 5. SCAN 사용 시 주의사항
---
SCAN 명령은 KEYS와 달리 메모리 효율적이고 블로킹이 없어 안전하지만, 몇 가지 주의해야 할 특성이 있습니다.  

### 5-1. 중복 가능성

SCAN은 **재해싱(Rehashing) 과정에서 같은 키를 여러 번 반환할 수 있습니다.**  
중복 제거가 필요하다면 애플리케이션 레벨에서 처리해야 합니다.  

```python
import redis

client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

cursor = 0
seen_keys = set() # 중복 제거를 위해 SET 자료구조 사용

while True:
    cursor, keys = client.scan(cursor, match='user:*', count=3)
    seen_keys.update(keys)

    # 전체 스캔을 완료하면 반복문 종료
    if cursor == 0:
        break
```

### 5-2. 키 추가/삭제 시 누락 가능성

SCAN 도중 키가 추가되거나 삭제되면, 해당 키가 **스캔 결과에 포함될 수도, 누락될 수도 있습니다.**  
아래 예시에서 `user:10` 키는 SCAN 결과에 포함될 수도, 누락될 수도 있습니다.  
```python
import redis

client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

# 1. SCAN 시작
cursor = 0
cursor, keys = client.scan(cursor, match='user:*', count=3)

# 2. SCAN 도중 새로운 키 추가
client.set('user:10', 0)

# 3. SCAN 이어서 진행
cursor, keys = client.scan(cursor, match='user:*', count=3)
...
```

### 5-3. COUNT 옵션은 힌트 값

앞서 설명드린 바와 같이, `COUNT` 옵션은 **정확한 반환 개수가 아니라 Redis에게 주는 힌트 값**입니다.  
실제 반환되는 키의 개수는 **`COUNT` 값보다 많거나 적을 수 있기 때문에 사용에 주의**가 필요합니다.  

```python
# 잘못된 예시 ❌ - COUNT를 정확한 개수로 가정
import redis

client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

cursor = 0
all_keys = []

while True:
    cursor, keys = client.scan(cursor, match='user:*', count=3)

    # ⚠️ 항상 len(keys)가 3인것은 아니므로 키가 누락될 수 있음 !
    if len(keys) == 3:
        all_keys.extend(keys)

    # 전체 스캔을 완료하면 반복문 종료
    if cursor == 0:
        break
```

## 마무리
---
Redis는 빠르고 강력한 인메모리 데이터베이스이지만, 잘못 사용하면 서비스 장애로 이어질 수 있습니다.  
특히 KEYS 명령어는 편리해 보이지만 프로덕션 환경에서는 재앙이 될 수 있습니다.  

SCAN 명령어는 약간 복잡해 보일 수 있지만, 안정적인 서비스 운영을 위해서는 필수적입니다.  
처음에는 불편할 수 있지만, 한 번 익숙해지면 훨씬 더 안전하고 효율적인 코드를 작성할 수 있습니다.  

**📌 기억하세요: KEYS는 디버깅 도구, SCAN은 프로덕션 도구입니다!**  

감사합니다.  
