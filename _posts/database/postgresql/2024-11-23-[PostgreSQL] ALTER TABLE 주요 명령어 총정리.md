---
title: "[PostgreSQL] ALTER TABLE 주요 명령어 총정리"
date: 2024-11-23 01:31:00 +09:00
last_modified_at: 2024-11-23 01:31:00 +09:00
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
    alter table,
    alter column,
    포스트그레스,
    포스트그레에스큐엘,
    포스트그레스큐엘,
    포스그레,
    데이터베이스,
    디비,
    관계형데이터베이스,
    관계형디비,
  ]
image: "/assets/img/title/postgresql_alter_table.png"
---

### **1. 테이블 수정**
---
#### 1-1. 테이블명 변경
```sql
ALTER TABLE {table name} RENAME TO {new table name};
```

#### 1-2. 테이블 소유자 변경
```sql
ALTER TABLE {table name} OWNER TO {user name};
```

#### 1-3. 테이블 스키마 변경
```sql
ALTER TABLE {table name} SET SCHEMA {schema name};
```

### **2. 컬럼 수정**
---
#### 2-1. 컬럼명 변경
```sql
ALTER TABLE {table name} RENAME COLUMN {column name} TO {new column name};
```

#### 2-2. 컬럼 타입 변경
`TEXT → VARCHAR(50)`와 같이 타입의 사이즈가 달라지는 등의 변환은 PostgreSQL에서 자동으로 변환하기 때문에, `USING` 절을 생략할 수 있습니다. 
하지만, `TEXT → INTEGER`와 같은 변환은 `USING` 절을 사용하여 타입을 명시적으로 변환해야 합니다.  
* 자동 변환
```sql
ALTER TABLE {table name} ALTER COLUMN {column name} TYPE {column type};
```
* 수동 변환 (예시: `TEXT → INTEGER`)
```sql
ALTER TABLE {table name} ALTER COLUMN {column name}
TYPE INTEGER USING {column name}::INTEGER;
```

#### 2-3. 컬럼 추가
컬럼을 추가할 때는, `NOT NULL` 또는 `DEFAULT`와 같은 제약조건을 함께 지정할 수 있습니다.  
* 컬럼 추가 (NULLABLE)
```sql
ALTER TABLE {table name} ADD COLUMN {column name} {column type};
```
* NOT NULL 컬럼 추가
```sql
ALTER TABLE {table name} ADD COLUMN {column name} {column type} NOT NULL;
```

#### 2-4. 컬럼 삭제
컬럼을 삭제할 때는, `CASCADE`를 사용하여 컬럼과 관련된 제약조건이나 참조 관계도 함께 삭제할 수 있습니다.  
이 옵션은 **컬럼의 의존성을 모두 제거하기 때문에 굉장히 신중히 사용**하셔야 합니다.  
* 컬럼 삭제
```sql
ALTER TABLE {table name} DROP COLUMN {column name};
```
* 의존성 있는 컬럼 삭제
```sql
ALTER TABLE {table name} DROP COLUMN {column name} CASCADE;
```

#### 2-5. 컬럼 DEFAULT 설정 및 제거
* DEFAULT 설정
```sql
ALTER TABLE {table name} ALTER COLUMN {column name} SET DEFAULT {DEFAULT value};
```
* DEFAULT 제거
```sql
ALTER TABLE {table name} ALTER COLUMN {column name} DROP DEFAULT;
```

#### 2-6. 컬럼 NOT NULL 설정 및 제거
* NOT NULL 설정
```sql
ALTER TABLE {table name} ALTER COLUMN {column name} SET NOT NULL;
```
* NOT NULL 제거
```sql
ALTER TABLE {table name} ALTER COLUMN {column name} DROP NOT NULL;
```

### **3. 제약조건(Constraint) 설정**
---
#### 3-1. 기본 키(Primary Key) 추가
```sql
ALTER TABLE {table name} ADD CONSTRAINT {constraint name} PRIMARY KEY {column name};
```

#### 3-2. 외래 키(Foreign Key) 추가
```sql
ALTER TABLE {table name} ADD CONSTRAINT {constraint name}
FOREIGN KEY {column name} REFERENCES {ref table name}({ref column name});
```

#### 3-3. Unique 제약조건 추가
* 단일 컬럼
```sql
ALTER TABLE {table name} ADD CONSTRAINT {constraint name} UNIQUE {column name};
```
* 복합 컬럼
```sql
ALTER TABLE {table name} ADD CONSTRAINT {constraint name}
UNIQUE ({column name 1}, {column name 2}, ...);
```

#### 3-4. Check 제약조건 추가
* 기본 명령어
```sql
ALTER TABLE {table name} ADD CONSTRAINT {constraint name} CHECK ({constraint});
```
* 예시 1: `gender` 필드에 `male`, `female` 값만 허용
```sql
ALTER TABLE {table name} ADD CONSTRAINT {constraint name}
CHECK (gender in ('male', 'female'));
```
* 예시 2: `email` 필드에 정규식으로 유효한 값만 허용
```sql
ALTER TABLE {table name} ADD CONSTRAINT {constraint name}
CHECK (email ~ '^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
```

#### 3-5. 제약조건 제거
```sql
ALTER TABLE {table name} DROP CONSTRAINT {constraint name};
```

## 마무리
---
이로써 PostgreSQL에서 테이블을 수정할 때 사용하는 `ALTER TABLE`의 주요 명령어에 대해 알아보았습니다.  
더욱 자세한 내용을 알고싶으신 분들 께서는 아래 링크를 참고해주시길 바랍니다.  
* [PostgreSQL ALTER TABLE (국문)](https://postgresql.kr/docs/12/sql-altertable.html)  
* [PostgreSQL ALTER TABLE (영문)](https://www.postgresql.org/docs/current/sql-altertable.html)  

감사합니다.  
