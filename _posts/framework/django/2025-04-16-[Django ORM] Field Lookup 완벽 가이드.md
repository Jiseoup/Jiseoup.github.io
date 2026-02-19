---
title: "[Django ORM] Field Lookup 완벽 가이드"
date: 2025-04-16 02:12:00 +09:00
last_modified_at: 2025-04-16 02:12:00 +09:00
categories: [Framework, Django]
tags:
  [
    django,
    python,
    파이썬,
    orm,
    queryset,
    쿼리셋,
    lookup,
    룩업,
    field lookup,
    필드 룩업,
  ]
image: "/assets/img/title/framework/django/orm_field_lookup.png"
---

Django ORM은 등호 기호(=)를 이용한 기본적인 비교 외에도, 다양한 **Field Lookup**을 제공합니다.  

여기서 **Field Lookup**이란, Django ORM의 `get()`, `filter()` 등의 메서드에서 사용하는 **조건 지정 문법**입니다.  
이를 통해 필드 데이터에 대해 더 세밀한 조건을 지정할 수 있습니다.  

### **1. 문자열 관련 Lookup**
---
`CharField`, `TextField` 등에서 문자열 일치, 포함 여부 등을 필터링할 수 있습니다.  

#### **1-1. exact / iexact**
지정한 값과 **정확히 일치하는지** 확인합니다.  
* `exact` : 대소문자 구분
* `iexact` : 대소문자 구분 없이 비교

```python
# name이 정확히 'John'인 경우만 조회
Student.objects.filter(name__exact='John')

# name이 'john', 'JOHN', 'John' 등인 데이터 조회
Student.objects.filter(name__iexact='john')
```

#### **1-2. contains / icontains**
지정한 값이 해당 필드에 **포함되어 있는지** 확인합니다.  
* `contains` : 대소문자 구분
* `icontains` : 대소문자 구분 없이 포함 여부 확인

```python
# name에 정확히 'ohn'이 포함된 경우만 조회
Student.objects.filter(name__contains='ohn')

# name에 'ohn', 'OHN', Ohn' 등이 포함된 데이터 조회
Student.objects.filter(name__icontains='OHN')
```

#### **1-3. startswith / istartswith**
필드 값이 지정한 문자열로 **시작하는지** 확인합니다.  
* `startswith` : 대소문자 구분
* `istartswith` : 대소문자 구분 없이 문자열 시작 여부 확인

```python
# name이 'John', 'Joy', 'Jonathan' 등인 데이터 조회
Student.objects.filter(name__startswith='Jo')

# name이 'john', 'JOHN', 'jOy' 등인 데이터 조회
Student.objects.filter(name__istartswith='jo')
```

#### **1-4. endswith / iendswith**
필드 값이 지정한 문자열로 **끝나는지** 확인합니다.  
* `endswith` : 대소문자 구분
* `iendswith` : 대소문자 구분 없이 문자열 끝남 여부 확인

```python
# job이 'Engineer', 'plumber', 'EMPLOYer' 등인 데이터 조회
Job.objects.filter(name__endswith='er')

# job이 'Engineer', 'PLUMBeR', 'employER' 등인 데이터 조회
Job.objects.filter(name__iendswith='ER')
```

### **2. 숫자/비교 관련 Lookup**
---
`IntField`, `FloatField`, `AutoField` 등에서 숫자 대소 비교나 범위 조건 등을 기준으로 필터링할 수 있습니다.  

#### **2-1. gt / gte**
필드 값이 지정한 숫자보다 **큰지** 확인합니다.  
* `gt` : Greater Than (초과)
* `gte` : Greater Than or Equal (이상)

```python
# age가 19 초과인 데이터 조회 (age = 20, 21, ...)
Student.objects.filter(age__gt=19)

# age가 19 이상인 데이터 조회 (age = 19, 20, ...)
Student.objects.filter(age__gte=19)
```

#### **2-2. lt / lte**
필드 값이 지정한 숫자보다 **작은지** 확인합니다.  
* `lt` : Less Than (미만)
* `lte` : Less Than or Equal (이하)

```python
# age가 15 미만인 데이터 조회 (age = 14, 13, ...)
Student.objects.filter(age__lt=15)

# age가 15 이하인 데이터 조회 (age = 15, 14, ...)
Student.objects.filter(age__lte=15)
```

#### **2-3. in / range**
필드 값이 지정한 **범위나 집합에 포함되는지** 확인합니다.  
* `in` : 	특정 리스트, 튜플, 쿼리셋 등에 포함되는지 확인
* `range` : 두 숫자 범위안에 포함되는지 확인

```python
# age가 13, 16, 19 중 하나인 데이터 조회
Student.objects.filter(age__in=[13, 16, 19])

# name이 'John' 또는 'Amy'인 데이터 조회 (문자열 비교 등에도 활용 가능)
Student.objects.filter(name__in=['John', 'Amy'])

# age가 13 이상 16 이하인 데이터 조회 (13 ≤ age ≤ 16)
Student.objects.filter(age__range=(13, 16))
```

### **3. 날짜/시간 관련 Lookup**
---
`DateField`, `DateTimeField` 등에서 날짜의 일부 속성(연도, 월, 일, 요일 등)을 기준으로 필터링할 수 있습니다.  

#### **3-1. date / year / month / day**
**특정 날짜 또는 연, 월, 일**과 필드 값을 비교합니다.  
* `date` : 	날짜 전체(YYYY-MM-DD)와 비교
* `year`, `month`, `day` : 각각 연, 월, 일 단위로 비교

```python
# birthday가 2025년 1월 1일인 데이터 조회
Student.objects.filter(birthday__date='2025-01-01')

# birthday가 2025년 4월 16일에 해당하는 데이터 조회
Student.objects.filter(birthday__year=2025, birthday__month=4, birthday__day=16)
```

#### **3-2. week_day**
**특정 요일**과 필드 값을 비교합니다. (1=일요일, 7=토요일)  
```python
# birthday가 월요일(2)인 데이터 조회
Student.objects.filter(birthday__week_day=2)
```

### **4. 기타 유용한 Lookup**
---
위에서 소개하지 못한 기타 유용한 Field Lookup에 대해 소개합니다.  

#### **4-1. isnull**
필드 값의 **NULL 여부**를 확인합니다.  

```python
# email이 NULL인 데이터 조회
Student.objects.filter(email__isnull=True)

# email이 NOT NULL인 데이터 조회
Student.objects.filter(email__isnull=False)
```

#### **4-2. regex / iregex**
**정규표현식**을 활용해 문자열 조건을 필터링합니다.  
* `regex` : 대소문자 구분
* `iregex` : 대소문자 구분 없이 정규식 적용

```python
# 이메일이 '@gmail.com'으로 끝나는 데이터 조회
Student.objects.filter(email__regex=r'^[a-zA-Z0-9._%+-]+@gmail\.com$')

# 이메일 형식이 올바른 데이터 조회 (대소문자 무시)
Student.objects.filter(email__iregex=r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$')
```

### **마무리**
---
Django ORM의 Field Lookup은 단순한 값 비교를 넘어, 보다 유연하고 세밀한 조건 필터링을 가능하게 해줍니다.  
다양한 QuerySet 메서드와 함께 Lookup을 적절히 조합하면, 복잡한 SQL 없이도 대부분의 쿼리를 직관적으로 표현할 수 있습니다.  

감사합니다.  
