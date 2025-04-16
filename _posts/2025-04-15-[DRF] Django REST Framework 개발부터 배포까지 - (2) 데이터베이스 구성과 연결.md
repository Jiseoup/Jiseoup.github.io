---
title: "[DRF] Django REST Framework 개발부터 배포까지 - (2) 데이터베이스 구성과 연결"
date: 2025-04-15 19:14:00 +09:00
last_modified_at: 2025-04-15 19:14:00 +09:00
categories: [Framework, Django REST Framework]
tags:
  [
    django,
    DRF,
    Django REST Framework,
    ORM,
    Backend,
    API,
    REST API,
    RESTful API,
    python,
    postgres,
    postgresql,
    swagger,
    swagger ui,
    server,
    ubuntu,
    nginx,
    gunicorn,
    deploy,
    CI/CD,
    github actions,
    장고,
    장고 레스트 프레임워크,
    백엔드,
    백엔드 개발,
    파이썬,
    포스트그레스,
    포스트그레에스큐엘,
    포스트그레스큐엘,
    포스그레,
    스웨거,
    서버,
    우분투,
    엔진엑스,
    구니콘,
    배포,
    깃허브 액션,
  ]
image: "/assets/img/title/drf_project/drf_project_2.png"
---

이전 포스팅에서는 Django 프로젝트를 위한 개발 환경 구성을 살펴보았습니다.  
이번 포스팅에서는 **데이터베이스(PostgreSQL) 설치부터 구성, Django 프로젝트와의 연동**까지 단계별로 알아보도록 하겠습니다.  

{% include drf-project.html %}

## 1. PostgreSQL 설치 및 접속
---
이번 프로젝트에서는 데이터베이스로 PostgreSQL을 사용할 예정입니다.  
먼저 PostgreSQL 관련 패키지를 설치해줍니다.  
```bash
sudo apt-get update
sudo apt-get install postgresql
sudo apt-get install postgresql-contrib
```

설치가 완료되면 PostgreSQL 서비스가 자동으로 시작됩니다.  
정상적으로 서비스가 실행중인지 아래 명령어로 확인해보세요.  
```bash
sudo service postgresql status
```

또한, PostgreSQL를 설치하면 기본적으로 `postgres`라는 슈퍼유저 계정이 함께 생성됩니다.  
다음 명령어로 시스템에 해당 유저가 존재하는지 확인할 수 있습니다.  
```bash
grep /bin/bash /etc/passwd
```

이제 `postgres` 유저를 통해 데이터베이스에 접속해보겠습니다.  
아래 명령어로 PostgreSQL 쉘(PSQL)에 접근할 수 있습니다.  
```bash
sudo -i -u postgres psql
```

## 2. 데이터베이스 구성
---
데이터베이스 설치 완료 후 PSQL 접속까지 성공했다면, 이제 본격적으로 프로젝트용 데이터베이스와 사용자 계정을 구성할 차례입니다. 만약 PSQL 사용이 처음이거나 아직 익숙하지 않으시다면, [PSQL 사용법 정리](https://devpro.kr/posts/PSQL-%EC%82%AC%EC%9A%A9%EB%B2%95-%EC%A0%95%EB%A6%AC/) 포스팅을 참고하여 기초적인 명령어 사용법을 빠르게 익히실 수 있습니다.  

### 2-1. 유저 생성
먼저 프로젝트를 위한 데이터베이스 유저를 생성합니다.  
유저명은 자유롭게 설정하셔도 좋습니다. (예시에서는 `admin` 사용)  
```sql
CREATE USER admin;
```

이제 생성한 유저에게 적절한 권한을 부여해줍니다.  
여기서는 연습 프로젝트라는 점을 고려하여 넉넉하게 권한을 부여합니다.  
```sql
ALTER ROLE admin SUPERUSER CREATEDB CREATEROLE REPLICATION BYPASSRLS;
```

다음으로 유저 비밀번호를 설정하고, 계정 만료일을 무기한으로 설정합니다.  
유저 비밀번호 또한 자유롭게 설정하셔도 좋습니다. (예시에서는 `1234` 사용)  
```sql
ALTER ROLE admin WITH PASSWORD '1234';
ALTER ROLE admin WITH VALID UNTIL 'infinity';
```

> 실제 운영 환경에서는 SUPERUSER 권한을 지양하고, 최소 권한 원칙을 지키는 것이 중요합니다.  
{: .prompt-warning }

### 2-2. 데이터베이스 생성
이제 프로젝트에서 사용할 데이터베이스를 생성해보도록 하겠습니다.  
아래 명령어를 통해 원하는 이름의 데이터베이스를 생성합니다. (예시에서는 `mydb` 사용)  
```sql
CREATE DATABASE mydb;
```

현재 `postgres` 계정으로 접속 중이므로, 생성된 `mydb`의 소유자는 기본적으로 `postgres`입니다.  
이를 앞서 만든 `admin` 유저에게 소유권을 이전해줍니다.  
```sql
ALTER DATABASE mydb OWNER TO admin;
```

이후 `\l` 명령어를 통해 데이터베이스 생성과 소유권 이전이 성공적으로 완료되었는지 확인합니다.  
```bash
postgres=# \l
                                                   List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate |  Ctype  | ICU Locale | ICU Rules |   Access privileges   
-----------+----------+----------+-----------------+---------+---------+------------+-----------+-----------------------
 mydb      | admin    | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | 
 postgres  | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | 
 template0 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
(4 rows)
```
데이터베이스 목록에 `mydb`가 존재하며, 그 Owner가 `admin`으로 설정되어있다면 성공입니다.  

### 2-3. DB 접속 인증 방식 변경
데이터베이스와 사용자 생성이 끝났다면, `\q` 명령어로 PSQL을 종료합니다.  
이제 우리가 만든 `admin` 유저로 직접 `mydb`에 접속하는 방법에 대해 알아보겠습니다.  

PostgreSQL의 기본 설정은 **`peer 인증 방식`**으로, **리눅스 사용자명과 PostgreSQL 유저명이 같아야만 접속할 수 있는 구조**입니다. 즉, `admin`이라는 PostgreSQL 유저로 접속하려면, 리눅스 시스템에도 `admin` 계정을 별도로 만들어 로그인해야 합니다.  

위 방식이 보안성은 높지만, 이번 프로젝트에서는 편의성을 위해 **아이디/패스워드 기반 인증 방식**인 **`md5 인증 방식`**을 사용해보도록 하겠습니다.  

먼저 PostgreSQL 인증 설정 파일을 엽니다.  
```bash
sudo vim /etc/postgresql/16/main/pg_hba.conf
```

> PostgreSQL 버전에 따라 경로의 `16` 부분은 `15`, `14` 등으로 다를 수 있습니다.  
{: .prompt-info }

다음으로, 파일 내 항목을 아래와 같이 수정합니다. (`peer` → `md5`)  
```conf
# 기존
local   all             all                                     peer

# 수정 후
local   all             all                                     md5
```

이후 변경 사항 반영을 위해 서비스를 재시작합니다.  
```bash
sudo service postgresql restart
```

이제 `admin` 유저로 비밀번호를 입력하여 PSQL 접속이 가능합니다.  
아래 명령어를 사용하여 `mydb` 데이터베이스 접속을 시도해봅니다.  
```bash
psql -U admin -d mydb
```

> **인증 방식 선택은 자유롭게**  
> PostgreSQL은 peer, md5, scram-sha-256 등 다양한 인증 방식을 지원합니다.  
> 개발 편의성과 보안 수준에 따라 원하는 방식으로 선택하여 사용하시면 됩니다.  
{: .prompt-tip }

## 3. Django 프로젝트 연동
---
이제 앞서 구성한 PostgreSQL 데이터베이스를 Django 프로젝트와 연결해보겠습니다.  
이번 프로젝트에서는 데이터베이스 관련 기능을 하나의 앱에서 통합 관리할 예정이므로, 먼저 전용 앱을 하나 생성합니다.  

### 3-1. 앱 생성 및 등록
먼저 Django 프로젝트의 루트 디렉토리에서 원하는 이름의 앱을 생성합니다. (예시에서는 `core` 사용)  
```bash
django-admin startapp core
```

앱을 생성했다면, `settings.py` 파일의 `INSTALLED_APPS` 항목 하단에 `core`를 추가해야 Django가 이 앱을 인식합니다. 이전 포스팅부터 그대로 따라오셨다면, `settings.py`는 `conf` 디렉토리 안에 위치해 있을 겁니다.  
```python
INSTALLED_APPS = [
    ...
    'core',
]
```

참고로 저는 직접 생성한 앱들만 따로 보기 좋게 분리해서 등록하는 방식을 선호합니다.  
꼭 이렇게 하실 필요는 없지만, 참고용으로 공유드립니다.  
```python
INSTALLED_APPS = [
    # Django Basic Apps
    'django.contrib.admin',
    ...

    # Third-Party Apps
    ...
]

# My Apps
INSTALLED_APPS += [
    'core',
    ...
]
```

### 3-2. PostgreSQL 드라이버 설치
Django가 PostgreSQL과 통신하기 위해서는 드라이버가 필요합니다.  
아래 명령어로 `psycopg2-binary` 패키지를 설치합니다.  
```bash
pip install psycopg2-binary
```

### 3-3. 데이터베이스 연결
이제 `settings.py`에서 `DATABASES` 항목을 위에서 구성한 PostgreSQL 데이터베이스로 수정하여 연결합니다.  
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'mydb',
        'USER': 'admin',
        'PASSWORD': '1234',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
```

여기서, 위와 같이 **민감 정보를 하드코딩하는 방식은 보안상 위험**합니다.  
따라서 **환경변수를 설정하여 관리하는 것이 중요**합니다.  
실제 개발 환경에서는 `.env` 파일을 통해 환경변수를 관리하는 방법이 보편적이며, [[Python] .env 파일로 환경변수 관리하기](https://devpro.kr/posts/Python-.env-%ED%8C%8C%EC%9D%BC%EB%A1%9C-%ED%99%98%EA%B2%BD%EB%B3%80%EC%88%98-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0/) 포스팅을 참고하여 아래와 같이 구성하시는 것을 권장합니다.  
```python
from decouple import config  # settings.py 파일 상단에 추가

DATABASES = {
    'default': {
        'ENGINE': config('DB_ENGINE'),
        'NAME': config('DB_NAME'),
        'USER': config('DB_USER'),
        'PASSWORD': config('DB_PASSWORD'),
        'HOST': config('DB_HOST'),
        'PORT': config('DB_PORT'),
    }
}
```

아래는 위에 대한 `.env` 파일 설정 예시입니다.  
```conf
# .env
DB_ENGINE='django.db.backends.postgresql'
DB_NAME='mydb'
DB_USER='admin'
DB_PASSWORD='1234'
DB_HOST='localhost'
DB_PORT='5432'
```

### 3-4. 데이터베이스 모델 정의
이제 Django 모델(Model)을 통해 데이터베이스 스키마를 정의하고, 이를 실제 DB에 반영할 차례입니다.  
이번 시리즈의 목표는 단순한 게시판 API 구현이기 때문에, 테이블 구조도 간단하게 구성해보겠습니다.  

<p align="center" style="color:gray">
  <img
    src="/assets/img/posts/framework/django_rest_framework/drf_practice_erd.png"
    alt="drf_practice_erd"
  />
  프로젝트의 ERD (Entity Relationship Diagram)
</p>

> `auth_user` 테이블은 Django가 기본으로 제공하는 사용자 테이블입니다.  
{: .prompt-info }

위 ERD를 기반으로, `core/models.py`에 아래와 같이 모델 클래스를 정의합니다.  
```python
from django.db import models
from django.contrib.auth.models import User

class Post(models.Model):
    post_no = models.AutoField(primary_key=True)
    author = models.ForeignKey(User, models.PROTECT, db_column='author')
    title = models.CharField(max_length=100)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = True
        db_table = 'post'

class Comment(models.Model):
    comment_no = models.BigAutoField(primary_key=True)
    post = models.ForeignKey(Post, models.PROTECT, db_column='post')
    author = models.ForeignKey(User, models.PROTECT, db_column='author')
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = True
        db_table = 'comment'
```

Django에서는 위와 같이 **Python 클래스 형태로 데이터베이스 테이블을 정의**합니다.  
이렇게 정의된 모델은 ORM(Object-Relational Mapping)을 통해 자동으로 SQL 테이블로 변환되며, Python 코드만으로 손쉽게 데이터 CRUD 작업을 수행할 수 있습니다.  

기본적으로 Django는 자체 ORM 사용을 권장하지만, 필요에 따라 SQLAlchemy와 같은 다른 ORM 도구를 함께 사용할 수도 있습니다. 또한 Raw Query 방식도 지원하므로, 프로젝트의 성격이나 개발자의 선호에 따라 유연하게 선택할 수 있습니다.  

단, **위에서 정의한 모델은 아직 실제 데이터베이스에 반영된 상태는 아닙니다.**  
이를 반영하기 위해서, **Django 마이그레이션 과정을 통해 모델 정의를 테이블 구조로 변환하는 작업이 필요합니다.**  

### 3-5. 마이그레이션 수행
앞서 정의한 모델을 데이터베이스에 반영하려면 아래의 명령어를 순서대로 실행합니다.  
```bash
# 마이그레이션 파일 생성
python manage.py makemigrations

# 데이터베이스에 반영
python manage.py migrate
```

`makemigrations` 명령은 모델의 변경 사항을 감지해 마이그레이션 파일을 생성합니다.  
이 파일은 어떤 테이블이 생성되며, 어떤 필드가 포함되는지 등의 정보를 담은 일종의 데이터베이스 설계도입니다.  
예를 들어, 지금처럼 마이그레이션을 처음 수행한 경우에는 `migrations/0001_initial.py` 파일이 생성되었을 것입니다.  

다음으로 `migrate` 명령은 생성된 마이그레이션 파일을 바탕으로 실제 데이터베이스에 테이블을 생성하거나 변경 사항을 반영합니다.  

## 4. 결과 확인 및 테스트
---
이제 마지막으로, 지금까지 정의한 모델과 마이그레이션 작업이 정상적으로 데이터베이스에 반영되었는지 확인해보겠습니다.  

### 4-1. 마이그레이션 결과 확인
먼저, 앞서 설정한 `md5 인증 방식`을 통해 데이터베이스에 접속합니다.  
```bash
psql -U admin -d mydb
```

다음으로 `\dt` 명령어를 사용해 `mydb` 데이터베이스 테이블 목록을 확인합니다.  
```bash
mydb=# \dt
                  List of relations
 Schema |            Name            | Type  | Owner 
--------+----------------------------+-------+-------
 public | auth_group                 | table | admin
 public | auth_group_permissions     | table | admin
 public | auth_permission            | table | admin
 public | auth_user                  | table | admin
 public | auth_user_groups           | table | admin
 public | auth_user_user_permissions | table | admin
 public | comment                    | table | admin
 public | django_admin_log           | table | admin
 public | django_content_type        | table | admin
 public | django_migrations          | table | admin
 public | django_session             | table | admin
 public | post                       | table | admin
(12 rows)
```
위와 같이 직접 모델로 정의한 `post`, `comment` 테이블과 함께, Django가 기본으로 제공하는 `auth_user`, `auth_group` 등의 테이블이 생성되어있다면 마이그레이션이 성공적으로 완료된 것입니다.  

### 4-2. 관리자 페이지 접속
이제 기본 테이블이 모두 생성되었으니, 실제 데이터를 삽입하여 Django 관리자 페이지에 접속해보겠습니다.  
먼저, 관리자 페이지에 로그인할 수 있는 슈퍼유저 계정을 생성합니다.  
```bash
python manage.py createsuperuser
```
생성한 슈퍼유저 정보는 `auth_user` 테이블에 저장되며, 이를 통해 관리자 페이지 로그인이 가능합니다.  

이제 서버를 실행하고, 관리자 페이지([http://localhost:8000/admin](http://localhost:8000/admin))에 접속합니다.  
```bash
python manage.py runserver
```
![django_admin_login](/assets/img/posts/framework/django_rest_framework/django_admin_login.png)  

관리자 페이지에 접속하면 위와 같은 로그인 화면이 나타나며, 앞서 생성한 슈퍼유저 계정으로 접속이 가능합니다.  

![django_admin_main](/assets/img/posts/framework/django_rest_framework/django_admin_main.png)  

로그인 후, 위와 같은 관리자 페이지 메인 화면이 나타나면 성공입니다.  

## 마무리
---
이번 포스팅에서는 Django 모델을 정의하고, 이를 데이터베이스에 반영하는 과정을 통해 DB 구성부터 프로젝트 연동까지의 흐름을 살펴보았습니다.  

이제 프로젝트의 기본 뼈대가 완성되었으니, 다음 포스팅부터는 본격적으로 ORM 활용법 및 DRF를 활용한 API 구현을 시작할 예정입니다. CRUD 기능을 하나씩 직접 만들어보며, 백엔드 개발의 핵심 흐름을 함께 익혀보겠습니다.  

긴 글 읽어주셔서 감사합니다.  
