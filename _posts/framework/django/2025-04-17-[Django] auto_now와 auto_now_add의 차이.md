---
title: "[Django] auto_now와 auto_now_add의 차이"
# slug: django-auto-now-vs-auto-now-add
date: 2025-04-17 20:33:00 +09:00
last_modified_at: 2025-04-17 20:33:00 +09:00
categories: [Framework, Django]
# tags: [django, orm, model-field]
image: "/assets/img/title/framework/django/logo_designed_1.png"
---

## 1. auto_now와 auto_now_add란?
---
Django에서 모델 클래스를 정의할 때, 생성일자나 수정일자를 필드로써 자주 구성하게 됩니다.  
이때, 유용하게 사용할 수 있는 옵션이 바로 **`auto_now`**와 **`auto_now_add`** 입니다.  

이 두 옵션은 `DateField`, `TimeField`, `DateTimeField`에서만 제공되며, 각각 다음과 같은 역할을 합니다.  

|_Option_|_Description_|_Example_|
|------|------|------|
|`auto_now`|객체가 **수정될 때마다** 자동으로 현재 날짜 및 시간으로 갱신됩니다.|수정일자(updated_at) 필드|
|`auto_now_add`|객체가 **최초 생성될 때** 자동으로 현재 날짜 및 시간을 저장합니다.|생성일자(created_at) 필드|

## 2. 예제 코드
---
아래는 `auto_now`와 `auto_now_add` 옵션의 사용 예시입니다.  
```python
from django.db import models

class Employee(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50)
    ...
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
```
위 예시는 `Employee` 객체를 처음 생성할 때, `created_at`, `updated_at` 필드에 현재 날짜 및 시간을 저장합니다.  
다음으로 생성된 `Employee` 객체에서 수정이 일어나면, `updated_at` 필드만 현재 날짜 및 시간으로 갱신합니다.  

## 3. 주의 사항
---
필드에 `auto_now=True` 또는 `auto_now_add=True` 옵션이 사용되었다면, 해당 값을 **수동으로 변경할 수 없습니다.**  
```python
from datetime import datetime
from models import Employee

employee = Employee.objects.get(id=1)

employee.created_at = datetime.now()  # ❌ 수동 변경 불가능
employee.updated_at = datetime.now()  # ❌ 수동 변경 불가능

employee.save()
```
위 예시에서 `save()`를 호출해도 수동으로 지정한 값은 무시되고, `created_at`은 최초 생성 시점, `updated_at`은 저장 시점의 현재 날짜 및 시간으로 자동 설정됩니다.  

특히 데이터 마이그레이션이나 데이터를 수동으로 삽입해야 하는 경우에는, `auto_now`와 `auto_now_add`를 비활성화하거나, 직접 값을 설정할 수 있도록 커스텀 구조를 구성하는 것이 요구됩니다.  
