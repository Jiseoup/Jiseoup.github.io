---
title: "[Python] 파이썬 switch-case문 사용법"
slug: python-switch-case
date: 2025-07-21 15:50:00 +09:00
last_modified_at: 2025-07-21 15:50:00 +09:00
categories: [Programming, Python]
tags: [python, syntax]
image: "/assets/img/title/programming/python/logo_designed_1.png"
---

C/C++, Java 등 많은 언어에서는 조건 분기 처리를 위한 제어문으로 `switch-case` 문이 사용됩니다.  
하지만, **파이썬에는 전통적인 `switch-case` 문이 존재하지 않기 때문에,** 처음 접하는 분들은 당황하실 수 있습니다.  

이번 포스팅에서는 **파이썬에서 `switch-case` 문을 대체할 수 있는 다양한 방법들을 정리**해보고, Python 3.10부터 새로 도입된 `match-case` 문법까지 함께 살펴보도록 하겠습니다.  

## 1. 왜 파이썬엔 switch-case 문이 없을까?
---
파이썬의 창시자인 [귀도 반 로섬(Guido van Rossum)](https://namu.wiki/w/%EA%B7%80%EB%8F%84%20%EB%B0%98%20%EB%A1%9C%EC%84%AC)은 `switch-case` 문이 필수적이지 않다고 판단했습니다.  
파이썬의 `if-elif-else` 문, 딕셔너리(Dictionary) 기반 분기 등으로도 충분히 같은 기능을 구현할 수 있기 때문입니다.  

## 2. if-elif-else 문 사용
---
가장 직관적인 방법으로는 **`if-elif-else` 문을 사용하여 구현하는 방법**이 있습니다.  
다만, 조건이 많아질수록 코드가 길어지고 가독성이 떨어질 수 있다는 단점이 있습니다.  

```python
def get_grade(score):
    if score >= 90:
        return 'A'
    elif score >= 80:
        return 'B'
    elif score >= 70:
        return 'C'
    elif score >= 60:
        return 'D'
    else:
        return 'F'
```

## 3. 딕셔너리(Dictionary) 활용
---
다음으로는 **딕셔너리를 활용하여 구현하는 방법**입니다.  
이는 `if-elif-else` 문에 비해 코드가 간결하고, 유지보수나 확장 측면에서도 유리합니다.  

```python
def get_grade(score):
    grades = {
        10: 'A',
        9: 'A',
        8: 'B',
        7: 'C',
        6: 'D'
    }
    return grades.get(score // 10, 'F')
```

단, 함수 실행이 필요한 경우 **`lambda` 또는 함수 객체**를 딕셔너리의 `value`로 넣어야 합니다.  

```python
def login():
    print('Logged in successfully.')

def logout():
    print('Logged out successfully.')

def action_message(action):
    # 함수 객체를 딕셔너리의 value로 지정
    actions = {
        'login': login,
        'logout': logout,
    }
    # 람다(lambda)를 활용하여 default value 설정
    return actions.get(action, lambda: print('Invalid action.'))()

action = 'login'
action_message(action)  # 'Logged in successfully.' 출력
```

## 4. match-case 문 사용
---
**Python 3.10**부터는 **패턴 매칭(Pattern Matching)을 활용한 `match-case` 문법**이 도입되었습니다.  
이를 통해, 다른 언어의 `switch-case` 문법과 매우 유사한 코드 구현이 가능해졌습니다.  

```python
def get_grade(score):
    match score // 10:
        case 10 | 9:
            return 'A'
        case 8:
            return 'B'
        case 7:
            return 'C'
        case 6:
            return 'D'
        case _:
            return 'F'
```

또한, 이는 패턴 매칭을 활용하기 때문에, 단순한 숫자와 문자 비교 외에도 **복잡한 구조 매칭이 가능**합니다.  

```python
def move(point):
    match point:
        case (x, 0) if x > 0:
            return 'Right'
        case (x, 0) if x < 0:
            return 'Left'
        case (0, y) if y > 0:
            return 'Up'
        case (0, y) if y < 0:
            return 'Down'
        case (0, 0):
            return 'Origin'
        case _:
            return 'Diagonal'

direction = move((0, 5))
print(direction)  # 'Up' 출력
```

## 마무리
---
지금까지 파이썬에서 전통적인 `switch-case` 문을 대체할 수 있는 다양한 방법에 대해 살펴보았습니다.  
상황에 맞는 적절한 방식으로 구현하면, 파이썬에서도 충분히 유연하고 가독성 높은 조건 분기 처리가 가능합니다.  

감사합니다.  
