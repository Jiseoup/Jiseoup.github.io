---
title: "매개변수(Parameter)와 인자(Argument)의 차이"
date: 2025-11-19 00:44:00 +09:00
last_modified_at: 2025-11-19 00:44:00 +09:00
categories: [Programming, Basics]
tags:
  [
    function,
    함수,
    parameter,
    파라미터,
    매개변수,
    argument,
    아규먼트,
    인자,
  ]
image: "/assets/img/title/programming/basics/params_args.png"
---

흔히 프로그래밍을 할 때, **매개변수(Parameter)**와 **인자(Argument)**라는 용어를 자주 접하게 됩니다.  
두 용어 모두 함수와 관련된 개념이지만, 많은 개발자들이 혼용해서 사용하거나 정확한 차이를 모르는 경우가 많습니다.  
따라서 두 용어의 차이를 간략하게 정리해보고자 이번 포스팅을 작성합니다.  

### 1. 매개변수(Parameter)
---
매개변수는 **함수를 정의할 때 선언하는 변수**입니다.  
간단히 함수가 어떤 입력을 받을지 명세하는 틀이라고 생각하면 됩니다.  

```python
def add(num1, num2):
    return num1 + num2
```

위 예시에서 괄호안에 작성된 `num1`, `num2` 변수가 모두 매개변수입니다.  

### 2. 인자(Argument)
---
인자는 **함수를 호출할 때 전달하는 실제 값**입니다.  
매개변수라는 틀에 들어가는 실제 데이터라고 생각하면 이해하기 쉽습니다.  

```python
result = add(3, 5)
print(result)  # 8 출력
```

위 예시에서 함수에 전달한 값 3과 5는 모두 인자입니다.  

### 3. 한 눈에 비교하기
---
<div style="text-align: left;">
  <img
      src="/assets/img/posts/programming/basics/parameter_and_argument.png"
      alt="parameter_and_argument"
      width=500
  />
</div>
