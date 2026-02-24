---
title: "[Database] DDL, DML, DCL 이란?"
# slug: database-ddl-dml-dcl
date: 2026-01-31 01:17:00 +09:00
last_modified_at: 2026-01-31 01:17:00 +09:00
categories: [Computer Science, DB]
# tags: [database, sql, ddl, dml] # [database, sql, sql-commands]
image: "/assets/img/title/computer_science/db/ddl_dml_dcl.png"
---

### 1. 데이터 정의어 (DDL, Data Definition Language)
---
**데이터 구조를 정의하거나 변경하는 명령어**입니다.  
테이블, 인덱스, 스키마 같은 구조 자체를 다룹니다.  

대표적인 DDL 명령어는 아래와 같습니다.
- `CREATE`: 생성 (테이블, 인덱스, 뷰 등)
- `ALTER`: 변경 (컬럼 추가/수정/삭제 등)
- `DROP`: 삭제 (테이블, 인덱스, 뷰 등)
- `TRUNCATE`: 테이블 데이터 초기화

```sql
-- users 테이블 생성
CREATE TABLE users (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(255)
);

-- users 테이블에 age 컬럼 추가
ALTER TABLE users ADD COLUMN age INT;

-- users 테이블 데이터 초기화
TRUNCATE TABLE users;

-- users 테이블 삭제
DROP TABLE users;
```

DDL은 대부분 **자동 커밋(Auto Commit)**으로 동작합니다.  
실행 즉시 데이터베이스 구조가 변경되므로, 운영 환경에서는 신중하게 다뤄야합니다.  

### 2. 데이터 조작어 (DML, Data Manipulation Language)
---
**데이터를 조회하거나 변경하는 명령어**입니다.  
행(Row) 단위로 데이터를 다룰 때 사용합니다.  

대표적인 DML 명령어는 아래와 같습니다.
- `SELECT`: 데이터 조회
- `INSERT`: 데이터 삽입
- `UPDATE`: 데이터 수정
- `DELETE`: 데이터 삭제

```sql
-- users 테이블의 모든 데이터 조회
SELECT * FROM users;

-- users 테이블 데이터 삽입
INSERT INTO users (id, name, email) VALUES (1, 'Jayden', 'jayden@example.com');

-- users 테이블의 id가 1인 데이터의 name을 'PRO'로 수정
UPDATE users SET name = 'PRO' WHERE id = 1;

-- users 테이블에서 id가 1인 데이터를 삭제
DELETE FROM users WHERE id = 1;
```

> `SELECT` 명령은 엄격히 분류하면 **데이터 질의어(DQL, Data Query Language)**에 해당합니다.  
> 하지만, 일반적으로 DML의 일부로 함께 묶어 설명하는 경우가 많습니다.  
{: .prompt-info }

DML은 **트랜잭션의 대상**이 되는 명령어입니다.  
따라서 `COMMIT` 또는 `ROLLBACK`을 통해 변경사항을 확정하거나 되돌릴 수 있습니다.  

### 3. 데이터 제어어 (DCL, Data Control Language)
---
**권한과 접근 제어를 관리하는 명령어**입니다.  
누가 어떤 작업을 할 수 있는지 설정할 때 사용합니다.  

대표적인 DCL 명령어는 아래와 같습니다.
- `GRANT`: 권한 부여
- `REVOKE`: 권한 회수

```sql
-- jayden 유저에게 users 테이블에 대한 조회, 삽입 권한 부여
GRANT SELECT, INSERT ON users TO jayden;

-- jayden 유저의 users 테이블에 대한 삽입 권한 회수
REVOKE INSERT ON users FROM jayden;
```

DCL은 운영 환경의 보안과 직결되므로, 원칙적으로 **최소 권한 원칙**을 적용하는 것이 바람직합니다.  

### 4. 한 줄 정리
---
- `DDL`: 데이터베이스 구조를 **정의 또는 변경**한다.
- `DML`: 데이터를 **조회 및 조작**한다.
- `DCL`: 데이터베이스 **권한을 제어**한다.
