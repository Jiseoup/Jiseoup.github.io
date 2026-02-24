---
title: "[Django ORM] QuerySet 메서드 완전 정복"
# slug: django-orm-queryset-methods
date: 2025-04-16 20:16:00 +09:00
last_modified_at: 2025-04-16 20:16:00 +09:00
categories: [Framework, Django]
# tags: [django, orm, queryset, python]
image: "/assets/img/title/framework/django/orm_queryset_method.png"
---

Django 프로젝트를 진행하다 보면, 대부분 ORM을 통해 데이터베이스와 상호작용하게 됩니다.  
이때 ORM 쿼리를 얼마나 잘 활용하느냐에 따라 개발의 생산성과 효율성이 크게 달라지기 마련입니다.  

이번 포스팅에서는 **자주 사용하는 Django ORM QuerySet 메서드를 정리해보았습니다.**  
Django ORM의 다양한 QuerySet 메서드를 한눈에 살펴보며, 프로젝트 개발에 실질적인 도움이 되기를 바랍니다.  

### **1. 데이터 생성 (Create)**
---
먼저 데이터 생성 메서드부터 살펴보겠습니다.  
이는 SQL의 **INSERT 쿼리**에 해당하는 기능입니다.  

#### 1-1. Model.objects.**create()**
가장 간단하게 객체를 생성하는 방법입니다.  
**하나의 객체를 생성**하여 반환하고 곧바로 데이터베이스에 저장합니다.  
```python
Student.objects.create(name='John Doe', gender='M', age=16)
```

#### 1-2. Model.objects.**bulk_create()**
**여러 객체를 한번에 생성**하는 방법입니다.  
이는 **INSERT 쿼리를 최소화해 성능을 향상**시킬 수 있습니다.  
```python
students = [
    Student(name='John Doe', gender='M', age=16),
    Student(name='Tony Stark', gender='M', age=18),
    Student(name='Emma Watson', gender='F', age=15),
]
Student.objects.bulk_create(students)
```

#### 1-3. **save()** 메서드 활용
단일 객체를 먼저 생성하고, **`save()` 메서드를 호출하여 저장하는 방법**입니다.  
**동적으로 값을 처리하거나 중간 로직이 필요한 경우 유용하게 사용**됩니다.  
```python
student = Student()
student.name = 'John Doe'
student.gender = 'M'
student.age = 16
student.save()
```

#### 1-4. Model.objects.**get_or_create()**
조건에 맞는 **객체가 이미 존재하면 가져오고, 없다면 새로 생성**하는 메서드입니다.  
조회와 생성을 동시에 처리할 수 있어 중복 방지에 유용합니다.  
```python
student, created = Student.objects.get_or_create(
    name='John Doe',
    defaults={'gender': 'M', 'age': 16}
)
```
이미 `name='John Doe'`인 객체가 있다면, 가져와 `student` 변수에 할당합니다. (`created`=False)  
만약 해당하는 객체가 없다면, 새로운 객체를 `defaults`에 입력된 정보를 포함하여 생성합니다. (`created`=True)  

#### 1-5. Model.objects.**update_or_create()**
조건에 맞는 **객체가 이미 존재하면 업데이트, 없다면 새로 생성**하는 메서드입니다.  
```python
student, created = Student.objects.update_or_create(
    name='Emma Watson',
    defaults={'gender': 'F', 'age': 17}
)
```
이미 `name='Emma Watson'`인 객체가 있다면, `defaults`에 입력된 정보에 알맞게 업데이트 합니다. (`created`=False)  
만약 해당하는 객체가 없다면, 새로운 객체를 `defaults`에 입력된 정보를 포함하여 생성합니다. (`created`=True)  


### **2. 데이터 조회 (Read)**
---
다음은 데이터 조회 메서드입니다.  
이는 SQL에서 가장 활용도가 높은 **SELECT 쿼리**에 해당하는 기능입니다.  
조회 쿼리는 활용 범위가 넓은 만큼, 다양한 메서드와 세부 옵션을 제공하며 상황에 따라 유연하게 사용할 수 있습니다.  

#### 2-1. Model.objects.**all()**
해당하는 모델의 **모든 객체를 조회**합니다.  
```python
Student.objects.all()
```

#### 2-2. Model.objects.**get()**
조건에 알맞는 **단일 객체를 조회**합니다.  
**조건에 맞는 객체가 하나만 존재해야 하며,** 없거나 둘 이상이면 `DoesNotExist` 또는 `MultipleObjectsReturned` 예외가 발생합니다.  
```python
Student.objects.get(name='Tony Stark')
```

#### 2-3. Model.objects.**filter()**
**조건에 알맞는 모든 객체를 조회**합니다.  
조건과 일치하는 결과가 없을 경우, 빈 QuerySet을 반환합니다.  
```python
Student.objects.filter(age=16)
```

#### 2-4. Model.objects.**exclude()**
지정한 **조건을 제외한 객체들을 조회**합니다.  
```python
Student.objects.exclude(gender='F')
```

#### 2-5. Model.objects.**order_by()**
**정렬 기준을 지정해 데이터를 조회**합니다.  
기본적으로 오름차순 정렬을 제공하며, `'-필드명'` 형태로 작성하여 내림차순 정렬도 가능합니다.  
```python
Student.objects.order_by('age')    # 오름차순
Student.objects.order_by('-age')   # 내림차순
```

#### 2-6. Model.objects.**values() / values_list()**
**원하는 필드만 딕셔너리 또는 튜플 형태로 조회**합니다.  
```python
Student.objects.values('name', 'age')
# → <QuerySet [{'name': 'John Doe', 'age': 16}, {'name': 'Tony Stark', 'age': 18}, ...]>

Student.objects.values_list('name', flat=True)
# → <QuerySet ['John Doe', 'Tony Stark', ...]>
```

#### 2-7. Model.objects.**first() / last()**
QuerySet의 **첫 번째 또는 마지막 객체를 조회**합니다.  
```python
Student.objects.filter(age=16).first()      # 첫 번째 객체 조회
Student.objects.filter(gender='M').last()   # 마지막 객체 조회
```

#### 2-8. Model.objects.**count()**
조건에 맞는 **객체의 개수를 반환**합니다.  
```python
Student.objects.filter(age=18).count()
```

#### 2-9. Model.objects.**exists()**
조건에 맞는 **객체가 존재하는지 확인**합니다.  
```python
Student.objects.filter(gender='M', age=16).exists()
```

#### 2-10. Model.objects.**distinct()**
**중복된 값을 제거**하고 고유한 값만 반환합니다.  
```python
Student.objects.values('age').distinct()
# → <QuerySet [{'age': 15}, {'age': 16}, {'age': 18}, ...]>
```

#### 2-11. Model.objects.**aggregate()**
전체 QuerySet에 대한 **집계 함수(합계, 평균, 최대값 등)를 계산**하여 반환합니다.  
Django에서 제공하는 집계 함수(Sum, Avg, Max 등)와 함께 사용합니다.  
```python
from django.db.models import Sum, Max, Min

Student.objects.aggregate(Sum('age'))
# → {'age__sum': 49}

Student.objects.aggregate(Max('age'), Min('age'))
# → {'age__max': 18, 'age__min': 15}
```

#### 2-12. Model.objects.**annotate()**
각 객체별로 **집계 값을 계산하여 필드처럼 추가**합니다.  
주로 집계 함수(Sum, Avg, Count 등) 및 `values()` 메서드와 함께 사용됩니다.  
```python
from django.db.models import Count

Student.objects.values('gender').annotate(student_count=Count('id'))
# → <QuerySet [{'gender': 'M', 'student_count': 2}, {'gender': 'F', 'student_count': 1}]>
```

#### 2-13. Model.objects.**only() / defer()**
특정 필드에 대해 **즉시 로딩 또는 지연 로딩**을 설정합니다.  
특히 대규모 테이블에서 **불필요한 필드의 초기 로딩을 줄이고자 할 때 유용하게 사용**됩니다.  
참고로 **지연 로딩된 필드에 접근하기 위해서는 추가 쿼리가 발생**합니다.  
```python
# name, age 필드만 즉시 로딩, 나머지 필드는 지연 로딩
Student.objects.only('name', 'age')

# gender 필드만 지연 로딩, 나머지 필드는 즉시 로딩
Student.objects.defer('gender')
```

#### 2-14. Q 객체를 이용한 **복합 조건 조회**
Django에서 제공하는 **Q 객체**를 활용하면 AND, OR, NOT 등의 복합 조건을 보다 유연하게 구성할 수 있습니다.  
주로 `filter()` 또는 `exclude()` 메서드와 함께 사용됩니다.  
```python
from django.db.models import Q

# age가 15이거나, name이 'Emma Watson'인 객체 조회 (OR)
Student.objects.filter(Q(age=15) | Q(name='Emma Watson'))

# name이 'John Doe'이면서, gender가 'M'인 객체 조회 (AND)
Student.objects.filter(Q(name='John Doe') & Q(gender='M'))

# gender가 'F'가 아닌 객체 조회 (NOT)
Student.objects.filter(~Q(gender='F'))
```

> 더 다양한 조건 조회와 필드별 비교 방법이 궁금하다면, [[Django ORM] Field Lookup 완벽 가이드](https://devpro.kr/posts/Django-ORM-Field-Lookup-%EC%99%84%EB%B2%BD-%EA%B0%80%EC%9D%B4%EB%93%9C/) 포스팅을  
> 함께 참고해보세요.  
{: .prompt-tip }

### **3. 데이터 수정 (Update)**
---
다음은 데이터 수정 메서드입니다.  
이는 SQL의 **UPDATE 쿼리**에 해당하는 기능입니다.  

#### 3-1. Model.objects.**update()**
특정 조건에 해당하는 **여러 객체의 필드를 동일한 값으로 일괄 수정**합니다.  
**QuerySet 단위**로 업데이트 작업을 수행합니다.  
```python
# gender가 'M'인 객체의 age 값을 모두 20으로 업데이트
Student.objects.filter(gender='M').update(age=20)
```

#### 3-2. Model.objects.**bulk_update()**
여러 객체를 미리 수정한 뒤, **지정한 필드를 한 번의 쿼리로 일괄 반영**합니다.  
**객체 리스트 단위**로 업데이트 작업을 수행합니다.  
```python
# gender가 'M'인 객체의 age 값을 모두 +1 씩 하여 업데이트
students = Student.objects.filter(gender='M')

for student in students:
    student.age += 1

Student.objects.bulk_update(students, ['age'])
```

#### 3-3. **save()** 메서드 활용
단일 객체의 필드를 먼저 수정하고, **`save()` 메서드를 호출하여 저장하는 방법**입니다.  
**동적으로 값을 처리하거나 중간 로직이 필요한 경우 유용하게 사용**됩니다.  
```python
student = Student.objects.get(name='John Doe')
student.age = 22
student.save()
```

### **4. 데이터 삭제 (Delete)**
---
마지막으로 데이터 삭제 메서드입니다.  
이는 SQL의 **DELETE 쿼리**에 해당하는 기능입니다.  

#### 4-1. Model.objects.**delete()**
특정 조건에 해당하는 **여러 객체를 삭제**합니다.  
```python
# name이 'John Doe'인 단일 객체 삭제
Student.objects.get(name='John Doe').delete()

# gender가 'M'인 모든 객체 삭제
Student.objects.filter(gender='M').delete()

# 모든 Student 객체 삭제
Student.objects.all().delete()
```

### **마무리**
---
이번 포스팅에서는 Django ORM의 다양한 QuerySet CRUD 메서드에 대해 알아보았습니다.  
QuerySet 메서드를 적절히 조합하면, 보다 간결하고 효율적인 코드 작성은 물론, 안정적인 데이터 처리까지 가능합니다.  

이번 포스팅이 Django 실무 프로젝트에 적용 가능한 더 좋은 개발을 이어나갈 수 있는 계기가 되었기를 바랍니다.  

감사합니다.  
