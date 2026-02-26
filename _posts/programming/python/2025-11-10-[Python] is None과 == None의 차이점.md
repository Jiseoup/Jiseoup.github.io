---
title: "[Python] is None과 == None의 차이점"
slug: python-is-none
date: 2025-11-10 22:49:00 +09:00
last_modified_at: 2025-11-10 22:49:00 +09:00
categories: [Programming, Python]
tags: [python, syntax]
image: "/assets/img/title/programming/python/logo_designed_3.png"
---

Python에서 **`None`**을 체크할 때, **`== None`** 보다 **`is None`**이 권장되는 이유가 무엇일까요?  
두 표현 모두 동일하게 작동하는 것처럼 보이지만, 실제로는 **중요한 차이**가 있습니다.  
이번 포스팅에서는 두 방법을 자세히 비교해보는 시간을 가져보도록 하겠습니다.  

## 1. is 와 == 연산자의 차이
---
Python에서 `is` 와 `==` 연산자는 **근본적으로 완전히 다른 비교를 수행**합니다.  

### 1-1. is 연산자
`is` 연산자는 **식별 연산자(Identity Operator)**로, 두 객체가 **메모리상 같은 객체인지 확인**합니다.  

```python
a = [1, 2, 3]
b = [1, 2, 3]
c = a

# 객체 비교
print(a is b) # False 반환
print(a is c) # True 반환

# 메모리 주소 비교
print(id(a) == id(b)) # False 반환
print(id(a) == id(c)) # True 반환
```

위 예시에서 리스트 `a`와 `c`는 같은 객체로, `is` 연산 시 `True`을 반환합니다.  
하지만, 리스트 `b`는 값이 같더라도 서로 다른 메모리 공간에 저장된 객체이므로 `is` 연산 시 `False`를 반환합니다.  

### 1-2. == 연산자
`==` 연산자는 **비교 연산자(Comparison Operator)**로, 두 객체의 **값이 동일한지 비교**합니다.  

```python
a = [1, 2, 3]
b = [1, 2, 3]

# 값 비교
print(a == b) # True 반환

# 객체 비교
print(a is b) # False 반환
```

위 예시에서 리스트 `a`와 `b`는 같은 값을 가지고 있으므로, `==` 연산 시 `True`을 반환합니다.  
하지만, 두 리스트는 서로 다른 객체이므로 `is` 연산 시 `False`를 반환합니다.  

## 2. is None과 == None의 차이
---
앞서 살펴본 것처럼 `is`는 객체 동일성을, `==`는 값의 동등성을 비교합니다.  
그렇다면 `is None`은 어떻게 동작하며, 왜 `== None`보다 권장되는 걸까요?  

### 2-1. None 객체
Python에서 `None`은 **싱글톤(Singleton) 객체**입니다.  
즉, 프로그램 전체에서 **단 하나만의 `None` 객체가 존재**합니다.  

```python
def return_none():
    return None

a = None
b = None
c = return_none()

# 객체 비교
print(a is b) # True 반환
print(a is c) # True 반환
print(b is c) # True 반환

# 메모리 주소 비교
print(id(a) == id(b) == id(c)) # True 반환
```

위 예시에서 볼 수 있듯이, 어떤 방식으로 `None`을 할당하더라도 **모두 같은 객체를 참조**합니다.  
이러한 싱글톤 특성 덕분에 **`None` 체크 시 `is` 연산자를 사용**하는 것이 **성능상 효율적이고 의미상으로도 명확**합니다.  

### 2-2. 성능 차이
`is None`과 `== None`은 성능 면에서도 차이가 있습니다.  
`is`는 단순히 메모리 주소를 비교하지만, **`==`은 내부적으로 `__eq__` 메서드를 호출**하므로 상대적으로 느립니다.  

```python
from timeit import timeit

# is None 함수
def test_is_none():
    a = None
    if a is None:
        return

# == None 함수
def test_eq_none():
    a = None
    if a == None:
        return

# 성능 측정
result_is_none = timeit(test_is_none, number=10000000)
result_eq_none = timeit(test_eq_none, number=10000000)

print(f'is None: {result_is_none:.4f} 초') # 예시: 0.1895 초
print(f'== None: {result_eq_none:.4f} 초') # 예시: 0.2125 초
```

### 2-3. \__eq__ 메서드 오버라이딩 문제
위에서 살펴본 바와 같이, `==` 연산자는 내부적으로 `__eq__` 메서드를 호출합니다.  
따라서 클래스에서 `__eq__` 메서드를 오버라이딩하면 **예상치 못한 동작**이 발생할 수 있습니다.  

```python
class TestClass:
    # __eq__ 메서드가 항상 True를 반환하도록 오버라이딩
    def __eq__(self, other):
        return True

obj = TestClass()

# __eq__ 메서드가 호출되어 True 반환
if obj == None:
    print('예상치 못한 동작 발생')  # 실행 됨
```

## 3. 결론
---
* **`is` 연산자**는 **객체의 동일성(identity)**을 확인합니다.
* **`==` 연산자**는 **값의 동등성(equality)**을 확인합니다.
* 일반적으로 **`is` 연산자**는 `None`, `True`, `False` 체크에 주로 사용합니다.
* 일반적으로 **`==` 연산자**는 값 비교에 주로 사용합니다.
