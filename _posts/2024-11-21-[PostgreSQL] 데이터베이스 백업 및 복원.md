---
title: "[PostgreSQL] 데이터베이스 백업 및 복원"
date: 2024-11-21 22:23:00 +09:00
last_modified_at: 2024-11-21 22:23:00 +09:00
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
    backup,
    database backup,
    rollback,
    database rollback,
    dump,
    restore,
    pg_dump,
    pg_restore,
    포스트그레스,
    포스트그레에스큐엘,
    포스트그레스큐엘,
    포스그레,
    데이터베이스,
    디비,
    관계형데이터베이스,
    관계형디비,
    데이터베이스 백업,
    데이터베이스 덤프,
    데이터베이스 롤백,
    데이터베이스 복원,
  ]
image: "/assets/img/title/postgresql_logo_white.png"
---

이번 포스팅에서는 PostgreSQL에서 데이터베이스 백업 및 복원하는 방법에 대해 알아보겠습니다.  

## 1. pg_dump 명령어
PostgreSQL에서는 간편하고 좋은 데이터베이스 백업 방법으로 `pg_dump` 명령어를 제공합니다.  
`pg_dump` 명령어의 주요 옵션은 아래와 같습니다.  

|Option|Description|
|------|------|
|-d|백업할 데이터베이스 명|
|-h|백업할 데이터베이스 호스트|
|-p|백업할 데이터베이스 포트|
|-U|백업을 수행할 데이터베이스 유저|
|-n|선택한 스키마를 백업|
|-N|선택한 스키마를 제외하고 백업|
|-t|선택한 테이블 또는 뷰를 백업|
|-T|선택한 테이블 또는 뷰를 제외하고 백업|
|-F|백업 포맷을 지정하는 옵션|

위 옵션 중, `-F` 옵션의 포맷 종류는 아래와 같습니다.  

|Format|Description|
|------|------|
|p|평문(Plain) SQL format으로 백업 \| 기본 옵션 \| `pg_restore` 불가능|
|c|Custom format으로 백업 \| 압축 지원 \| `pg_restore` 가능|
|d|Directory format으로 백업 \| 압축 지원 \| `pg_restore` 가능|
|t|Tar format으로 백업 \| `pg_restore` 가능|

이 중 가장 널리 사용되는 포맷은 `Plain format`과 `Custom format` 입니다.  
`Plain format`은 평문 SQL로 백업을 하기 때문에 속도가 빠른대신 파일 크기가 크다는 특징이 있고, 반대로 `Custom format`은 압축을 진행하기 때문에 파일 크기가 작아지는 대신 속도가 느려질 수 있다는 특징이 있습니다.  

## 2. 데이터베이스 백업
`pg_dump` 명령어를 이용한 데이터베이스 백업 방법은 매우 간단합니다.  
앞서 설명드린 명령어를 잘 조합하여 사용하면 원하시는 백업 파일을 만드는데 도움이 될 것 입니다.  

아래는 예시입니다.  

1. 데이터베이스 전체 백업
```shell
pg_dump -d {$ database} -h {$ host} -U {$ username} -p {$ port} \
    -F c -f {$ backup file name}.dump
```

2. 데이터베이스 특정 테이블 백업
```shell
pg_dump -d {$ database} -h {$ host} -U {$ username} -p {$ port} \
    -t {$ schema}.{$ table} \
    -t {$ schema}.{$ table} \
    -F c -f {$ backup file name}.dump
```

## 3. 데이터베이스 복원
데이터베이스 복원을 위해서는 `pg_restore` 명령어를 사용합니다.  
백업할 때 사용한 포맷에 따라 `-F` 옵션 뒤의 포맷을 변경해서 사용하시면 됩니다.  
만약 `Plain format`으로 백업을 진행했다면, `psql`을 사용하여 복원을 진행해야 합니다.  

아래는 예시입니다.  

1. Custom format 파일로 복원
```shell
pg_restore -d {$ database} -h {$ host} -U {$ username} -p {$ port} \
    -F c {$ backup file name}.dump
```

2. Plain format 파일로 복원
```shell
psql -d {$ database} -h {$ host} -U {$ username} -p {$ port} \
    -f {$ backup file name}.dump
```

## 마무리
---
이번 포스팅에서는 PostgreSQL에서 데이터베이스를 백업하고 복원하는 방법에 대해 알아보았습니다.  
`pg_dump`와 `pg_restore` 명령어는 데이터베이스 유지보수 작업에서 가장 기본적이면서도 중요한 도구입니다.  
이 명령어들을 적절히 활용하면, 데이터베이스 복제, 마이그레이션 등에도 정말 유용하게 사용할 수 있습니다.  

감사합니다.  
