---
title: "전위(Prefix), 후위(Postfix) 연산자의 차이"
slug: prefix-vs-postfix-operator
date: 2026-03-18 17:31:00 +09:00
last_modified_at: 2026-03-18 17:31:00 +09:00
categories: [Programming, Basics]
tags: [basics, syntax]
image: "/assets/img/title/programming/basics/prefix_postfix_operator.png"
---

> [전위(Prefix), 중위(Infix), 후위(Postfix) 표기법](/posts/prefix-infix-postfix/) 포스팅을 함께 참고하시면 좋습니다.  
{: .prompt-info }

증감 연산자 **`++i`** 와 **`i++`**는 비슷해 보이지만, 연산자의 위치에 따라 값이 반환되는 시점이 달라집니다.  
이번 포스팅에서는 이와 같은 **전위(Prefix)**, **후위(Postfix)** 연산자의 개념과 차이를 정리해보겠습니다.  

## 1. 전위 연산자 (Prefix Operator)
---
**Prefix**는 연산자를 변수 **앞에** 붙이는 방식입니다.  
`++i`, `--i`처럼 증감 연산자가 변수 앞에 위치할 때를 **전위(Prefix)** 방식이라고 합니다.  

전위 방식의 핵심은 **"먼저 증감하고, 이후 값을 사용한다"** 는 점입니다.  

```c
int i = 5;
int result = ++i;
printf("i=%d, result=%d", i, result);  // i=6, result=6
```

위 코드에서는 변수 `i`의 값이 먼저 증가되고, 그 결과값인 `6`이 `result`에 대입됩니다.  

## 2. 후위 연산자 (Postfix Operator)
---
**Postfix**는 연산자를 변수 **뒤에** 붙이는 방식입니다.  
`i++`, `i--`처럼 증감 연산자가 변수 뒤에 위치할 때를 **후위(Postfix)** 방식이라고 합니다.  

후위 방식의 핵심은 **"현재 값을 먼저 사용하고, 이후 증감한다"** 는 점입니다.  

```c
int i = 5;
int result = i++;
printf("i=%d, result=%d", i, result);  // i=6, result=5
```

위 코드에서는 변수 `i`의 현재 값인 `5`가 먼저 `result`에 대입되고, 그 이후에 `i`가 `6`으로 증가합니다.  

## 3. Prefix vs Postfix 연산자 비교
---
두 연산자의 차이를 한 눈에 비교하면 아래와 같습니다.  

| | Prefix (`++i`) | Postfix (`i++`) |
|---|---|---|
| **연산 순서** | 증감 먼저 → 값 사용 | 값 사용 먼저 → 증감 |
| **반환값** | 증감된 값 | 증감 이전의 값 |
| **최종 변수값** | 동일하게 증감됨 | 동일하게 증감됨 |

아래 예시에서 두 방식의 차이를 명확하게 확인할 수 있습니다.  

```c
int a = 5;
int b = 5;

int x = ++a;  // a=6, x=6 (전위: 먼저 증가 후 대입)
int y = b++;  // b=6, y=5 (후위: 먼저 대입 후 증가)

printf("a=%d, x=%d", a, x);  // a=6, x=6
printf("b=%d, y=%d", b, y);  // b=6, y=5
```

단순히 반복문(`for`, `while`)의 증감식으로 사용할 때는 반환값을 사용하지 않으므로 두 방식의 결과가 동일합니다.  
하지만 위 예시처럼 **값을 대입하거나 표현식 내에서 사용할 때는 결과가 달라지므로 주의가 필요**합니다.
