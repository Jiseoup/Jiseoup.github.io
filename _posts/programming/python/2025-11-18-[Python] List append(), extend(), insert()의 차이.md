---
title: "[Python] List append(), extend(), insert()의 차이"
date: 2025-11-18 17:34:00 +09:00
last_modified_at: 2025-11-18 17:34:00 +09:00
categories: [Programming, Python]
tags:
  [
    python,
    파이썬,
    list,
    리스트,
    append,
    extend,
    insert,
    문법,
    추가,
  ]
image: "/assets/img/title/programming/python/logo_designed_1.png"
---

Python에서 List에 요소를 추가하는 메서드로는 `append()`, `extend()`, `insert()` 3가지가 있습니다.  
이번 포스팅에서는 리스트에 요소를 추가하는 3가지 메서드의 차이점과 각각의 사용법을 알아보겠습니다.  

### 1. append() 메서드
---
`append()` 메서드는 어떤 객체든 **단일 요소로 리스트의 끝**에 추가합니다.  

```python
# 1. 숫자를 요소로 추가
numbers = [1, 2, 3]
numbers.append(4)
print(numbers)  # [1, 2, 3, 4]

# 2. 리스트를 요소로 추가
numbers = [1, 2, 3]
numbers.append([4, 5])
print(numbers)  # [1, 2, 3, [4, 5]]  <- 리스트가 중첩됨
```

위 예시와 같이 리스트를 `append()`하면 중첩 리스트가 생성됩니다.  
이는 의도한 동작일 수도 있지만, 단순히 여러 요소를 추가하려는 경우라면 원하는 결과가 아닐 수 있습니다.  

### 2. extend() 메서드
---
`extend()` 메서드는 반복 가능한 객체(iterable)의 **각 요소를 개별적으로 리스트의 끝**에 추가합니다.  

```python
# 1. 리스트 확장
numbers = [1, 2, 3]
numbers.extend([4, 5])
print(numbers)  # [1, 2, 3, 4, 5]

# 2. 문자열로 확장
letters = ['a', 'b']
letters.extend('cd')
print(letters)  # ['a', 'b', 'c', 'd']

# 3. 튜플로 확장
numbers = [1, 2]
numbers.extend((3, 4))
print(numbers)  # [1, 2, 3, 4]
```

위 예시와 같이 `extend()` 메서드는 리스트뿐만 아니라 모든 iterable 객체(리스트, 튜플, 문자열 등)를 받을 수 있습니다.  

### 3. insert() 메서드
---
`insert()` 메서드는 **특정 인덱스 위치**에 단일 요소를 추가합니다.  

```python
# 1. 특정 위치에 요소 추가
numbers = [1, 2, 3]
numbers.insert(1, 9)  # 인덱스 1 위치에 9 추가
print(numbers)  # [1, 9, 2, 3]

# 2. 맨 앞에 요소 추가
numbers = [1, 2, 3]
numbers.insert(0, 0)
print(numbers)  # [0, 1, 2, 3]

# 3. 인덱스가 리스트 길이보다 큰 경우
numbers = [1, 2, 3]
numbers.insert(100, 4)  # 끝에 추가됨
print(numbers)  # [1, 2, 3, 4]
```

`insert()`는 `append()`처럼 객체를 단일 요소로 추가하지만, 리스트의 끝이 아닌 원하는 위치에 추가할 수 있습니다.  
또한, 인덱스가 리스트 길이를 초과하면 자동으로 맨 끝에 요소가 추가된다는 특징이 있습니다.  

### 4. 정리
---

| 특징 | append() | extend() | insert() |
|----------|----------|----------|----------|
| _추가 방식_ | 객체를 단일 요소로 추가 | iterable의 각 요소를 개별 추가 | 객체를 단일 요소로 추가 |
| _추가 위치_ | 리스트의 끝 | 리스트의 끝 | 지정한 인덱스 위치 |
| _인자 타입_ | 모든 객체 | iterable 객체 | 인덱스, 모든 객체 |
| _리스트 길이 증가_ | 항상 1 증가 | iterable 요소 개수만큼 증가 | 항상 1 증가 |
| _사용 예시_ | 단일 요소 추가, 중첩 리스트 | 여러 요소 추가, 리스트 병합 | 특정 위치에 요소 삽입 |
