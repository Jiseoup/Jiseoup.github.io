---
published: false  # NOTE: 퍼블리싱 임시 중지
title: "[Django REST Framework 개발부터 배포까지] (3) Django ORM 파헤치기"
slug: drf-project-part3
date: 2025-04-16 23:22:00 +09:00
last_modified_at: 2025-04-16 23:22:00 +09:00
categories: [Framework, Django REST Framework]
tags: [django, drf, orm]
image: "/assets/img/title/framework/django_rest_framework/drf_project/lesson_3.png"
redirect_from:
    - /posts/Django-REST-Framework-개발부터-배포까지-(3)-Django-ORM-파헤치기/
    - /posts/Django-REST-Framework-%EA%B0%9C%EB%B0%9C%EB%B6%80%ED%84%B0-%EB%B0%B0%ED%8F%AC%EA%B9%8C%EC%A7%80-(3)-Django-ORM-%ED%8C%8C%ED%97%A4%EC%B9%98%EA%B8%B0/
    - /posts/DRF-Django-REST-Framework-개발부터-배포까지-(3)-Django-ORM-파헤치기/
    - /posts/DRF-Django-REST-Framework-%EA%B0%9C%EB%B0%9C%EB%B6%80%ED%84%B0-%EB%B0%B0%ED%8F%AC%EA%B9%8C%EC%A7%80-(3)-Django-ORM-%ED%8C%8C%ED%97%A4%EC%B9%98%EA%B8%B0/
---

이번 포스팅에서는 본격적인 API 개발에 앞서, **Django ORM**의 기본 사용법을 간단히 살펴보겠습니다.  
Django REST Framework에서는 ORM 기반의 데이터 처리 방식을 기본으로 권장하기 때문에, 이를 잘 이해하고 있어야 효율적이고 안정적인 API 구현이 가능합니다.  

{% include series/drf-project.html %}

## 1. ORM이란?
---
ORM(Object-Relational Mapping)은 **객체 지향 언어에서 사용하는 객체와, 관계형 데이터베이스의 테이블을 매핑해주는 기술**입니다. Django에서는 모델(Model) 클래스를 통해 ORM 기능을 제공하며, 복잡한 SQL을 직접 작성하지 않아도 손쉽게 데이터베이스를 다룰 수 있도록 도와줍니다.  

덕분에 코드의 가독성이 좋아지고, 개발 속도 역시 눈에 띄게 향상됩니다.  

## 2. 실습 환경 구성
---
먼저 ORM 실습을 위한 환경부터 간단히 구성해보도록 하겠습니다.  

> **실습 환경과 소스 코드는 [ORM 실습 소스 코드](https://github.com/Jiseoup/DRF-Practice/tree/main/project/orm_practice)를 참고해주세요.**  
{: .prompt-tip }

Django 프로젝트 루트 경로에 실습용 디렉토리와 소스 코드 파일을 생성합니다.  
```bash
# 실습용 디렉토리 생성 (/project/orm_practice)
mkdir orm_practice

# 실습용 소스 코드 파일 생성
touch orm_practice/create.py
touch orm_practice/read.py
touch orm_practice/update.py
touch orm_practice/delete.py
```

이제 다음 챕터부터 본격적으로 Django ORM을 활용한 CRUD 기능 구현을 실습해보겠습니다.  

모든 실습 예제는 **이전 포스팅에서 생성한 `Post` 모델과 `슈퍼유저 계정`이 존재한다는 전제 하에 작성**되었습니다.  
실습에 앞서 관련 데이터가 준비되어 있지 않다면, [이전 포스팅](https://devpro.kr/posts/drf-project-part2/)을 참고하여 환경을 먼저 구성하시는 것을 추천드립니다.  

> **아래 포스팅을 함께 참고하시면 Django ORM의 구조와 기능에 대해 더욱 깊이 이해하실 수 있습니다.**  
> 👉 [[Django ORM] QuerySet 메서드 완전 정복](https://devpro.kr/posts/django-orm-queryset/)  
> 👉 [[Django ORM] Field Lookup 완벽 가이드](https://devpro.kr/posts/django-field-lookup/)  
{: .prompt-tip }

## 3. 데이터 생성 (CREATE)
---
먼저, **데이터 생성(CREATE)** 작업을 실습해보겠습니다.  
실습 코드 작성은 `orm_practice/create.py` 파일에서 수행합니다.  

실습 코드 실행을 위해서는 아래의 명령을 사용합니다.  
```bash
python manage.py shell < orm_practice/create.py
```

### 3-1. create() 메서드로 생성
가장 간단한 방식으로, 필드 값을 직접 인자로 넘겨주고 객체를 생성과 동시에 저장합니다.  
```python
from core.models import User, Post

# 필드 값을 지정하여 Post 객체를 생성하고 저장
Post.objects.create(
    title='First post title.',
    content='First post content.',
    author=User.objects.get(username='admin'),  # ⚠️ `admin`을 생성한 슈퍼유저 계정 이름으로 대체
)

print('First post created successfully.')

# OutPut:
#   First post created successfully.
```

### 3-2. 딕셔너리 언패킹을 활용한 생성
필드 값을 딕셔너리로 정의한 뒤, `**` 연산자를 사용해 `create()` 메서드에 전달할 수 있습니다.  
이 방식은 코드가 더 유연하며, 필드 구성이 동적으로 변경될 수 있는 경우에도 유용합니다.  
```python
from core.models import User, Post

# Post 객체의 필드 값을 딕셔너리로 정의
dict_post = {
    'title': 'Second post title.',
    'content': 'Second post content.',
    'author': User.objects.get(username='admin'),  # ⚠️ `admin`을 생성한 슈퍼유저 계정 이름으로 대체
}

# 딕셔너리 언패킹을 통해 Post 객체를 생성하고 저장
Post.objects.create(**dict_post)

print('Second post created successfully.')

# OutPut:
#   Second post created successfully.
```

### 3-3. 객체 생성 후 save() 메서드로 저장
객체를 먼저 메모리에 생성하고, 필요한 값을 조작하거나 추가 로직을 처리한 후 저장할 수 있는 방법입니다.  
이 방식은 커스텀 메서드나 저장 전 데이터 가공이 필요한 경우 자주 사용됩니다.  
```python
from core.models import User, Post

# 필드 값 정의와 함께 Post 객체 생성
my_post = Post(
    title='My favorite foods.',
    content='I love pizza and pasta.',
    author=User.objects.get(username='admin'),  # ⚠️ `admin`을 생성한 슈퍼유저 계정 이름으로 대체
)

# Post 객체 저장
my_post.save()

print('Third post created successfully.')

# OutPut:
#   Third post created successfully.
```

## 4. 데이터 조회 (READ)
---
이번에는 **데이터 조회(SELECT)** 실습을 진행해보겠습니다.  
**데이터 조회는 CRUD 중 가장 자주 사용되는 기능**으로, 단일 객체 조회부터 조건 검색까지 다양한 형태로 사용됩니다.  
실습 코드 작성은 `orm_practice/read.py` 파일에서 수행합니다.  

실습 코드 실행을 위해서는 아래의 명령을 사용합니다.  
```bash
python manage.py shell < orm_practice/read.py
```

### 4-1. 전체 데이터 조회
모든 객체를 조회하는 가장 기본적인 방법입니다.  
`all()` 메서드는 해당 모델의 전체 데이터를 가져오며, 반환값은 QuerySet입니다.  
조회된 객체는 반복문을 통해 각 필드에 `객체.필드명` 형식으로 접근할 수 있습니다.  
```python
from core.models import Post

# 모든 Post 객체 조회
all_posts = Post.objects.all()
print(f'All Post Objects: {all_posts}')

# 모든 Post 객체의 필드 데이터 출력
print('All Posts:')
for post in all_posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content} / Author: {post.author.username}')
print('\n')

# OutPut:
#   All Post Objects: <QuerySet [<Post: Post object (1)>, <Post: Post object (2)>, <Post: Post object (3)>]>
#   All Posts:
#   (1) Title: First post title. / Content: First post content. / Author: admin
#   (2) Title: Second post title. / Content: Second post content. / Author: admin
#   (3) Title: My favorite foods. / Content: I love pizza and pasta. / Author: admin
```

### 4-2. 단일 객체 조회
단 하나의 객체를 조회하는 방법입니다.  
**`get()` 메서드는 조건에 맞는 객체가 없거나, 2개 이상일 경우 예외가 발생**하므로 사용에 주의가 필요합니다.  
```python
from django.core.exceptions import MultipleObjectsReturned

from core.models import Post

# `post_no` 필드 값이 3인 단일 Post 객체 조회 후 출력
post_no = 3
try:
    post = Post.objects.get(post_no=post_no)
    print(f'Single Post Object: {post}')
    print('Single Post:')
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content} / Author: {post.author.username}')

# 조건에 맞는 Post 객체가 없을 경우에 대한 예외 처리
except Post.DoesNotExist:
    print(f'Post number {post_no} does not exist.')

# 2개 이상의 Post 객체가 존재할 경우에 대한 예외 처리
except MultipleObjectsReturned:
    print(f'Multiple posts returned for post number {post_no}.')

# 그 외 에러 케이스에 대한 예외 처리
except Exception as e:
    print(f'Unknown error occurred: {e}')
print('\n')

# OutPut:
#   Single Post Object: Post object (3)
#   Single Post:
#   (3) Title: My favorite foods. / Content: I love pizza and pasta. / Author: admin
```

### 4-3. 조건 필터링 조회
특정 조건에 맞는 여러 객체를 조회할 때 사용하는 방법입니다.  
`filter()` 메서드는 조건에 맞는 객체들을 QuerySet 형태로 반환합니다.  
조건에 부합하는 결과가 없더라도 예외가 발생하지 않고, 빈 QuerySet을 반환합니다.  
```python
from core.models import Post

# `title` 필드에 'post' 문자열이 포함된 Post 객체 조회
filtered_posts = Post.objects.filter(title__icontains='post')
print(f'Filtered Post Objects: {filtered_posts}')

# 조회된 Post 객체의 필드 데이터 출력
print('Filtered Posts:')
for post in filtered_posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content} / Author: {post.author.username}')
print('\n')

# OutPut:
#   Filtered Post Objects: <QuerySet [<Post: Post object (1)>, <Post: Post object (2)>]>
#   Filtered Posts:
#   (1) Title: First post title. / Content: First post content. / Author: admin
#   (2) Title: Second post title. / Content: Second post content. / Author: admin
```

## 5. 데이터 수정 (UPDATE)
---
다음으로 **데이터 수정(UPDATE)** 방법을 실습해보겠습니다.  
실습 코드 작성은 `orm_practice/update.py` 파일에서 수행합니다.  

실습 코드 실행을 위해서는 아래의 명령을 사용합니다.  
```bash
python manage.py shell < orm_practice/update.py
```

### 5-1. update() 메서드로 일괄 수정
조회한 QuerySet 객체의 지정한 필드를 한 번에 수정하는 방법입니다.  
```python
from core.models import Post

# `title` 필드에 'post' 문자열이 포함된 Post 객체 조회
posts = Post.objects.filter(title__icontains='post')

# 수정 이전의 Post 객체 필드 데이터 출력
print('Before Update:')
for post in posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content}')

# 조회한 Post 객체들의 `content` 필드 값을 'Updated content.'로 수정
posts.update(content='Updated content.')

# 수정 이후의 Post 객체 필드 데이터 출력
print('After Update:')
for post in posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content}')

print('\n')

# OutPut:
#   Before Update:
#   (1) Title: First post title. / Content: First post content.
#   (2) Title: Second post title. / Content: Second post content.
#   After Update:
#   (1) Title: First post title. / Content: Updated content.
#   (2) Title: Second post title. / Content: Updated content.
```

### 5-2. 객체 수정 후 save() 메서드로 저장
객체를 하나씩 반복하며 값을 수정하고, `save()` 메서드를 호출하여 반영하는 방식입니다.  
이 방식은 객체별로 다른 값을 적용하거나, 로직 처리와 함께 수정할 때 적합합니다.  
```python
from core.models import Post

# `title` 필드에 'post' 문자열이 포함된 Post 객체 조회
posts = Post.objects.filter(title__icontains='post')

# 수정 이전의 Post 객체 필드 데이터 출력
print('Before Update:')
for post in posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content}')

# Post 객체를 하나씩 반복하며 `content` 필드 값을 알맞게 수정
for post in posts:
    post.content = f'The post number is {post.post_no}.'
    post.save()

# 수정 이후의 Post 객체 필드 데이터 출력
print('After Update:')
for post in posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content}')

print('\n')

# OutPut:
#   Before Update:
#   (1) Title: First post title. / Content: Updated content.
#   (2) Title: Second post title. / Content: Updated content.
#   After Update:
#   (1) Title: First post title. / Content: The post number is 1.
#   (2) Title: Second post title. / Content: The post number is 2.
```

## 6. 데이터 삭제 (DELETE)
---
마지막으로, **데이터 삭제(DELETE)** 작업을 실습해보겠습니다.  
실습 코드 작성은 `orm_practice/delete.py` 파일에서 수행합니다.  

실습 코드 실행을 위해서는 아래의 명령을 사용합니다.  
```bash
python manage.py shell < orm_practice/delete.py
```

### 6-1. delete() 메서드로 일괄 삭제
조회한 QuerySet 객체를 한 번에 삭제하는 방법입니다.  
```python
from core.models import Post

# 모든 Post 객체 조회
all_posts = Post.objects.all()

# `title` 필드에 'post' 문자열이 포함된 Post 객체 조회
posts = all_posts.filter(title__icontains='post')

# 삭제 이전의 모든 Post 객체 필드 데이터 출력
print('Before Delete:')
for post in all_posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content}')

# 조회한 Post 객체들을 삭제
posts.delete()

# 객체 삭제 확인을 위해, 모든 Post 객체를 다시 조회
all_posts = Post.objects.all()

# 삭제 이후의 모든 Post 객체 필드 데이터 출력
print('After Delete:')
for post in all_posts:
    print(f'({post.post_no}) Title: {post.title} / Content: {post.content}')

# OutPut:
#   Before Delete:
#   (1) Title: First post title. / Content: The post number is 1.
#   (2) Title: Second post title. / Content: The post number is 2.
#   (3) Title: My favorite foods. / Content: I love pizza and pasta.
#   After Delete:
#   (3) Title: My favorite foods. / Content: I love pizza and pasta.
```

## 마무리
---
이번 포스팅에서는 Django ORM을 활용한 CRUD 작업을 실습 예제와 함께 간단히 정리해보았습니다.  

ORM을 얼마나 효율적으로 잘 활용하느냐에 따라 코드의 생산성, 가독성, 유지보수성이 크게 달라집니다.  
본격적인 API 개발에 들어가기 앞서, Django ORM에 대한 기본 개념과 사용법을 충분히 익혀두는 것을 추천드립니다.  

이제 다음 포스팅부터는 DRF 환경 구성과 함께, 실제 API를 구현하는 단계로 넘어가보도록 하겠습니다.  

감사합니다.  
