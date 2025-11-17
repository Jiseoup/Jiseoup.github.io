---
title: "[Database] 인덱스(Index) 동작 원리와 장단점"
date: 2025-11-17 16:51:00 +09:00
last_modified_at: 2025-11-17 16:51:00 +09:00
categories: [Computer Science, DB]
tags:
  [
    컴퓨터공학,
    컴퓨터과학,
    데이터베이스,
    데이터베이스 튜닝,
    데이터베이스 최적화,
    데이터베이스 성능 최적화,
    쿼리 튜닝,
    쿼리 최적화,
    디비,
    인덱스,
    인덱스 동작,
    인덱스 동작 원리,
    인덱스 사용법,
    인덱스 장점,
    인덱스 단점,
    인덱스 장단점,
    비트리,
    Computer Engineering,
    Computer Science,
    Database,
    DB,
    Index,
    B-Tree,
    B+Tree,
    B*Tree,
  ]
image: "/assets/img/title/computer_science/db/index.png"
---

## 1. 인덱스(Index)란?
---
인덱스는 데이터베이스 테이블의 **조회 속도를 향상시키기 위한 자료구조**입니다.  

예를 들어, 백과사전의 목차나 색인을 떠올리면 이해하기 쉽습니다.  
백과사전에서 특정 내용을 찾을 때, 모든 페이지를 처음부터 읽는 것보다 목차나 색인을 통해 해당 페이지로 바로 
이동하는 것이 훨씬 빠릅니다.  

데이터베이스 인덱스도 이와 같은 원리로 동작합니다.  
인덱스 없이 특정 데이터를 찾으려면 테이블의 모든 Row를 하나하나 확인해야 하지만(Full Table Scan), **인덱스가 있으면 원하는 데이터의 위치를 빠르게 찾을 수 있습니다.**  

## 2. 인덱스의 동작 원리
---
대부분의 RDBMS에서 인덱스는 **`B+Tree` 자료구조**를 사용합니다.  

**`B+Tree`는 균형 잡힌 트리 구조**로, 크게 세 가지 노드로 구성됩니다.  
* **Root Node**: 트리의 최상단 노드로, 검색의 시작점 역할을 합니다.  
* **Branch Node**: 중간 계층 노드로, 자식 노드로 가는 경로를 안내합니다.  
* **Leaf Node**: 실제 데이터가 저장된 위치(포인터)를 담고 있습니다.  

특히, **Leaf Node**들은 **연결 리스트(Linked List)**로 연결되어 있어 **범위 검색**에 매우 유리합니다.  

![btree_index](/assets/img/posts/computer_science/db/btree_index.png)  

예를 들어, `users` 테이블에 `user_id`라는 필드가 있고, 위 구조와 같은 인덱스가 설정되어 있다고 가정해봅시다.  

### 예시 1. 단일 값 검색

아래와 같은 쿼리를 실행하면 인덱스는 다음과 같이 동작합니다.  
```sql
SELECT * FROM users WHERE user_id = 7;
```
1. **Root Node[5, 15]에서 시작**: 7은 5 이상 15 미만이므로 중간 Branch Node[9, 12]로 이동  
2. **Branch Node[9, 12]에서 탐색**: 7은 9 미만이므로 왼쪽 Leaf Node[6, 7]로 이동  
3. **Leaf Node[6, 7]에 도달**: `user_id = 7`에 해당하는 실제 데이터의 위치(포인터)를 찾음  

만약 인덱스가 없었다면 테이블의 모든 Row를 순차적으로 확인해야 하지만, B+Tree 인덱스를 사용하면 단 3번의 비교만으로 원하는 값을 찾을 수 있습니다.  

### 예시 2. 범위 검색

범위 검색에서는 Leaf Node의 **연결 리스트 구조**가 빛을 발합니다.  
```sql
SELECT * FROM users WHERE user_id BETWEEN 6 AND 14;
```
1. **Root Node[5, 15]에서 시작**: 6은 5 이상 15 미만이므로 중간 Branch Node[9, 12]로 이동  
2. **시작 지점 탐색**: Branch Node[9, 12]에서 Leaf Node[6, 7]로 이동하여 시작점인 6을 찾음  
3. **연결 리스트 순회**: Leaf Node들을 따라 순차적으로 이동하며 [6, 7] → [10] → [14]를 효율적으로 수집  

이처럼 범위의 시작점만 찾으면, 이후에는 Leaf Node의 연결 리스트를 따라가며 빠르게 결과를 얻을 수 있습니다.  

## 3. 인덱스를 사용하면 좋은 경우
---
인덱스는 모든 컬럼에 무조건 설정하는 것이 아니라, **특정 조건에 부합할 때 효과적**입니다.  
다음은 인덱스를 설정하면 성능 향상을 기대할 수 있는 대표적인 경우들입니다.  

### 3-1. WHERE 절에 자주 사용되는 컬럼

**특정 조건으로 데이터를 자주 검색**하는 컬럼에는 인덱스를 설정하는 것이 효과적입니다.  
```sql
-- user_id로 특정 사용자의 주문 내역(orders)을 자주 조회하는 경우
SELECT * FROM orders WHERE user_id = 7;
```

### 3-2. JOIN 조건으로 사용되는 컬럼

테이블 간 조인 시 사용되는 컬럼, 특히 **Foreign Key**에 인덱스를 설정하면 **JOIN 성능이 크게 향상**됩니다.  
```sql
-- orders 테이블의 user_id 컬럼에 인덱스가 있으면 JOIN 속도 향상
SELECT o.*
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'Pending';
```

### 3-3 ORDER BY, GROUP BY에 사용되는 컬럼

**정렬**이나 **그룹화** 작업이 자주 발생하는 컬럼에 인덱스를 설정하면, 데이터베이스가 이미 **정렬된 인덱스를 활용**할 수 있어 성능이 개선됩니다.  
```sql
-- 최근 주문 내역(orders)을 자주 조회하는 경우
SELECT * FROM orders
ORDER BY created_at DESC
LIMIT 10;
```

### 3-4 카디널리티(Cardinality)가 높은 컬럼

**카디널리티**는 컬럼 내 **고유한 값의 개수**를 의미합니다. 카디널리티가 **높을수록** 인덱스의 효과가 큽니다.  
```sql
-- orders 테이블의 카디널리티가 높은 order_id 컬럼에 인덱스가 있으면 효과적
SELECT * FROM orders WHERE order_id = '20251114-ABCDEF;
```

* **카디널리티가 높은 컬럼 예시**
  * 주민등록번호: 모든 값이 고유함
  * 이메일: 대부분의 값이 고유함
  * 주문번호: 각 주문마다 고유한 값

* **카디널리티가 낮은 컬럼 예시**
  * 성별: 일반적으로 남/여 2가지 값만 존재
  * 상태(status): Active/Inactive/Pending 등의 제한된 값만 존재
  * 등급: 신규/일반/VIP 등의 몇 가지 값만 존재

## 4. 인덱스의 단점과 주의사항
---
인덱스는 조회 성능을 향상시키지만, **무분별하게 사용하면 오히려 성능 저하를 초래**할 수 있습니다.  
다음은 인덱스 사용 시 반드시 고려해야 할 단점과 주의사항입니다.  

### 4-1. 쓰기 성능 저하

인덱스가 설정된 컬럼에 데이터를 INSERT, UPDATE, DELETE 할 때마다 **인덱스도 함께 갱신**해야 하므로 **쓰기 작업의 성능이 저하**됩니다.  
```sql
-- 인덱스가 많을수록 성능 저하 (orders 테이블에 설정된 모든 인덱스가 함께 업데이트됨)
INSERT INTO orders (user_id, product_id, amount) VALUES (7, 12, 30000);
```
특히 인덱스가 많은 테이블일수록 쓰기 작업의 오버헤드가 커지므로, **꼭 필요한 컬럼에만 인덱스를 설정**해야 합니다.  

### 4-2. 추가 저장 공간 필요

인덱스는 `B+Tree`와 같은 별도의 자료구조로 저장되므로 **추가 디스크 공간을 차지**합니다.  
따라서, 인덱스가 많아질수록 저장 공간 부담도 증가합니다.  

### 4-3. 잘못된 인덱스 사용은 성능 저하의 원인

인덱스가 설정되어 있어도 **쿼리 작성 방식**에 따라 인덱스를 사용하지 못할 수 있습니다.  

**1. 인덱스 컬럼에 함수를 적용하는 경우**
```sql
-- 인덱스 사용 불가 ❌: UPPER() 함수가 적용됨
SELECT * FROM users WHERE UPPER(email) = 'USER@EXAMPLE.COM';

-- 인덱스 사용 가능 ✅: 원본 컬럼에 대한 비교를 수행함
SELECT * FROM users WHERE email = 'user@example.com';
```

**2. 인덱스 컬럼을 가공하는 경우**
```sql
-- 인덱스 사용 불가 ❌: 원본 컬럼을 가공하여 사용
SELECT * FROM orders WHERE created_at + INTERVAL '7 days' > NOW();

-- 인덱스 사용 가능 ✅: 원본 컬럼을 유지하며 사용
SELECT * FROM orders WHERE created_at > NOW() - INTERVAL '7 days';
```

**3. 와일드카드를 앞에 사용하는 LIKE 검색**
```sql
-- 인덱스 사용 불가 ❌: 앞에 와일드카드(%) 사용
SELECT * FROM products WHERE name LIKE '%keyboard%';

-- 인덱스 사용 가능 ✅: 뒤에만 와일드카드(%) 사용
SELECT * FROM products WHERE name LIKE 'keyboard%';
```

이처럼 인덱스를 효과적으로 활용하려면 **쿼리 실행 계획을 분석**하여 인덱스가 제대로 활용되고 있는지 확인하고, **쿼리 패턴에 맞춰 인덱스를 적절히 구성**해야 합니다.  
