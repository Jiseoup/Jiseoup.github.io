---
title: "[PostgreSQL] 유저 생성 및 권한 부여"
date: 2024-11-06 01:42:00 +09:00
last_modified_at: 2024-11-06 01:42:00 +09:00
categories: [Database, PostgreSQL]
tags:
  [
    database,
    postgresql,
    psql,
    db,
    rdb,
    rdbms,
    dbms,
    postgres,
    pgadmin,
    포스트그레스,
    포스트그레에스큐엘,
    포스트그레스큐엘,
    포스그레,
    데이터베이스,
    디비,
    관계형데이터베이스,
    관계형디비,
  ]
---

이번 포스팅에서는 PostgreSQL 데이터베이스에서 유저 생성과 권한 부여 방법에 대해 알아보겠습니다.  
이 글을 읽기 전에, [PSQL 사용법 정리](https://devpro.kr/posts/PSQL-%EC%82%AC%EC%9A%A9%EB%B2%95-%EC%A0%95%EB%A6%AC/) 포스팅을 참고하시면 더욱 쉽게 이해하실 수 있습니다.  

## 1. 유저 및 권한 조회
데이터베이스 유저와 권한을 조회하는 방법은 매우 간단합니다.  
**`\du`** 커맨드를 통해 유저와 권한을 확인할 수 있습니다.  

![user](https://github.com/user-attachments/assets/08b1e94e-a5fc-48a3-841e-fb6462592fac)  

## 2. 권한의 종류
아래 테이블은 PostgreSQL에서 주로 사용하는 기본적인 ROLE을 정리한 테이블입니다.  
더욱 자세한 내용은 아래 링크를 참고해주세요.  
* [PostgreSQL CREATE ROLE (국문)](https://postgresql.kr/docs/11/sql-createrole.html)  
* [PostgreSQL ALTER ROLE (국문)](https://postgresql.kr/docs/11/sql-alterrole.html) 

|Role|Description|
|------|------|
|SUPERUSER \| NOSUPERUSER|슈퍼유저 권한 여부|
|CREATEDB \| NOCREATEDB|데이터베이스 생성 가능 여부|
|CREATEROLE \| NOCREATEROLE|새로운 ROLE 생성 및 관리 가능 여부|
|INHERIT \| NOINHERIT|다른 유저에게 자신의 ROLE을 상속 가능한지의 여부|
|LOGIN \| NOLOGIN|유저의 로그인 가능 여부|
|REPLICATION \| NOREPLICATION|데이터베이스 복제 가능 여부|
|BYPASSRLS \| NOBYPASSRLS|행 수준 보안(Row Level Security)을 무시 가능 여부|
|CONNECTION LIMIT|해당 ROLE로 접속할 수 있는 최대 동시 접속 수 <br> 기본값은 -1 (제한 없음)|
|PASSWORD \| PASSWORD NULL|해당 ROLE의 비밀번호 지정 <br> 명시적으로 비밀번호를 null로 지정할 경우 항상 인증에 실패한다|
|VALID UNTIL|암호의 유효 기간 설정 <br> VALID UNTIL 구문 뒤에 timestamp를 입력하여 사용 <br> 지정한 시간이 지나면 해당 비밀번호로 로그인 불가|

## 3. 유저 생성
새로운 유저는 아래 커맨드를 사용하면 손쉽게 생성하실 수 있습니다.  
```sql
CREATE USER name [ [ WITH ] option [ ... ] ]
```

예시로, DB 생성 권한과 ROLE 생성 권한을 가진 SUPERUSER를 만들고자 한다면, 아래와 같이 사용할 수 있습니다.  

![create-user](https://github.com/user-attachments/assets/79dc3e81-4cdd-4f32-af95-5711e04dbc99)  

## 4. 권한 부여
유저 생성 이후에도, 아래 커맨드를 통해 손쉽게 ROLE에 권한을 부여하거나 제거할 수 있습니다.  
```sql
ALTER ROLE role_specification [ WITH ] option [ ... ]
```

예시로, SUPERUSER 권한을 제거하고, PASSWORD를 1234로 설정하고자 한다면, 아래와 같이 사용할 수 있습니다.  

![alter-role](https://github.com/user-attachments/assets/60c98d17-c032-40f6-8eeb-1ff0c1d0c91c)  

## 마무리
---
이번 포스팅에서는 기초적인 ROLE 생성, 권한 부여 및 제거 방법에 대해 살펴보았습니다.  
PostgreSQL의 ROLE 기능은 다양한 데이터베이스 환경에서 유연하게 사용될 수 있어 활용 범위가 매우 넓습니다.  
ROLE과 관련된 심화 주제는 공식 문서나 추가 학습 자료를 통해 깊이 있게 탐구해 보시기를 추천드립니다.  

감사합니다.  
