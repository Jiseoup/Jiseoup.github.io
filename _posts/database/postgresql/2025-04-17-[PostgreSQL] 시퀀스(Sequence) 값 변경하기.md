---
title: "[PostgreSQL] 시퀀스(Sequence) 값 변경하기"
date: 2025-04-17 19:07:00 +09:00
last_modified_at: 2025-04-17 19:07:00 +09:00
categories: [Database, PostgreSQL]
tags:
  [
    postgresql,
    포스트그레스,
    database,
    데이터베이스,
    sequence,
    시퀀스,
  ]
image: "/assets/img/title/database/postgresql/postgresql_logo_white.png"
---

## 1. 시퀀스(Sequence)란?
---
PostgreSQL에서 `SERIAL`, `BIGSERIAL`, 혹은 `GENERATED`와 같은 컬럼 타입을 사용하면 자동으로 **시퀀스(Sequence)**가 생성됩니다.  

시퀀스는 **고유한 숫자 값을 자동으로 생성해주는 객체**로, 주로 `id` 컬럼과 같은 기본 키(Primary Key)에 사용됩니다.  
이는 **INSERT 쿼리 수행 시 자동으로 증가하는 값을 제공**합니다.  
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT
);
```
예를 들어, 위와 같이 테이블을 생성하면 `id` 컬럼은 1부터 시작하여 자동 증가하며, 내부적으로는 `users_id_seq`라는 시퀀스가 함께 생성됩니다.  

> 시퀀스는 **트랜잭션 실패나 INSERT 오류가 발생하더라도 값이 증가**합니다.  
> 즉, 중간에 INSERT가 롤백되더라도 시퀀스 값은 복원되지 않으므로, 예상보다 빠르게 값이 커질 수 있습니다.  
{: .prompt-tip }

## 2. 자주 발생하는 문제
---
시퀀스와 관련된 대표적인 문제 상황은 바로 **중복 키 오류** 입니다.  

예를 들어, 테이블에 수동으로 데이터를 삽입하거나 외부에서 덤프 데이터를 복원한 경우, 시퀀스의 현재 값이 테이블에 이미 존재하는 값보다 작아질 수 있습니다.  

이러한 상황에서 INSERT 쿼리를 실행하면 다음과 같은 에러가 발생합니다.  
```bash
ERROR:  duplicate key value violates unique constraint "users_pkey"
DETAIL:  Key (id)=(3) already exists.
```
이는 시퀀스가 여전히 `id = 3`을 다음 값으로 사용하려 시도하기 때문입니다.  
하지만 해당 `id`는 이미 테이블에 존재하므로, 기본 키 제약 조건에 의해 오류가 발생하게 되는 것입니다.  

## 3. 시퀀스 값 변경
---
위와 같은 중복 키 오류를 해결하려면, 시퀀스의 현재 값을 수동으로 조정해야 합니다.  
이를 위한 대표적인 방법은 두 가지가 있습니다.  

### 3-1. ALTER SEQUENCE 사용
가장 직접적인 방법은 **`ALTER SEQUENCE` 명령어**를 사용하여 시퀀스의 다음 값을 변경하는 방법입니다.  

예를 들어, 아래의 명령은 `users_id_seq` 시퀀스를 4로 초기화하여, 다음 INSERT 시 `id=4`부터 값이 할당되도록 합니다.  
```sql
ALTER SEQUENCE users_id_seq RESTART WITH 4;
```
여기서 `RESTART WITH`는 다음 호출 시 사용될 시퀀스 값을 설정합니다.  
**이미 존재하는 값보다 큰 수를 지정**해야 중복 오류를 방지할 수 있습니다.  

### 3-2. setval() 함수 사용
또 다른 방법은 PostgreSQL의 **내장 함수인 `setval()`을 사용**하는 것입니다.  

아래 예시는 현재 테이블의 최대 `id` 값에 맞춰 시퀀스를 조정합니다.  
```sql
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
```
만약 `users` 테이블의 최대 `id` 값이 5라면, 다음 INSERT 시 `id=6`부터 값이 할당되도록 시퀀스를 조정합니다.  

특히 PostgreSQL에서는 이 방법이 더 안정적이고 효율적인 선택이 될 수 있습니다.  
