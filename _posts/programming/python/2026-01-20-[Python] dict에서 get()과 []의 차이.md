---
title: "[Python] dict에서 get()과 []의 차이"
date: 2026-01-20 10:53:00 +09:00
last_modified_at: 2026-01-20 10:53:00 +09:00
categories: [Programming, Python]
tags:
  [
    python,
    파이썬,
    dict,
    딕셔너리,
    get,
    keyerror,
    키 에러,
    조회,
  ]
image: "/assets/img/title/programming/python/python_logo_designed_2.png"
---

Python 딕셔너리(dict)에서 값을 가져올 때는 보통 `dict.get('key')`와 `dict['key']` 두 가지를 사용합니다.  
둘 다 **"key에 해당하는 값을 조회한다"**는 점은 같지만, 동작 방식과 쓰임새가 다릅니다.  

### 1. 기본 동작 차이
---
key가 없을 때 `dict['key']`는 **예외(KeyError)**를 발생시키고, `dict.get('key')`는 **기본값(None)**을 반환합니다.  

```python
data = {'name': 'Jayden'}

print(data['name'])      # 'Jayden'
print(data.get('name'))  # 'Jayden'

print(data['age'])       # KeyError 발생
print(data.get('age'))   # None 반환
```

즉, **key가 반드시 있어야 하는 상황이라면 `dict['key']`**을 사용한 직접 접근 방식이 더 명확하고, **key가 없어도 정상 흐름을 유지해야 한다면 `dict.get('key')`** 방식이 안전합니다.  

### 2. 기본값 지정
---
`get()` 메서드는 키가 없을 때 반환할 **기본값(default)** 을 지정할 수 있습니다.  

```python
data = {'name': 'Jayden'}

print(data.get('name'))            # 'Jayden'
print(data.get('age', 30))         # 30
print(data.get('lang', 'ko-KR'))   # 'ko-KR'
```

반면 `dict['key']`에는 기본값 기능이 없으므로, 예외 처리를 하거나 `in`으로 존재 여부를 검사해야 합니다.  

### 3. 상황별 선택 기준
---
아래와 같은 상황에서는 **`dict['key']`**를 사용하는 것이 더 적합합니다.  
- 키가 반드시 존재해야 하는 데이터일 때 (데이터 누락이 버그일 가능성이 큰 경우)
- 키가 반드시 존재함을 보장할 수 있을 때 (KeyError 발생 가능성이 없을 때)

```python
# timeout 설정값이 필수라면, 없을 경우 바로 실패시키는 편이 디버깅에 유리
timeout = config['timeout']
```

반대로 아래와 같은 상황에서는 **`dict.get('key')`**를 사용하는 것이 더 적합합니다.  
- 키가 없을 수도 있는 경우 (KeyError를 방지해야 할 때)
- 기본값을 설정해서 안전한 처리가 필요한 경우

```python
# nickname이 없을 수도 있는 경우
nickname = user.get('nickname')

# amount가 없을때 기본값을 0으로 설정해야하는 경우
amount = cash.get('amount', 0)
```

### 4. 성능 차이
---
두 방식은 내부적으로 비슷하게 동작해 성능 차이는 크지 않으며 상황에 따라 결과가 달라질 수 있습니다.  
따라서 선택 기준은 **의도 표현**과 **오류 처리 방식**이 더 중요합니다.  

```python
import timeit

data = {'key': 'value'}

# []를 사용한 직접 접근 방식이 대체로 빠르나, 환경에 따라 수치는 다를 수 있음
print(timeit.timeit("data['key']", globals=globals(), number=10000000))      # 약 0.2초
print(timeit.timeit("data.get('key')", globals=globals(), number=10000000))  # 약 0.5초
```

### 5. 정리
---
- 키가 **반드시 있어야** 하면: `dict['key']`
- 키가 **없어도 괜찮으면**: `dict.get('key')`
- **기본값**이 필요하면: `dict.get('key', default)`

실무에서는 **"데이터가 반드시 있어야 하는지"**를 기준으로 선택하면 됩니다.  
의도를 코드로 드러내는 것이 곧 유지보수성입니다.  

감사합니다.
