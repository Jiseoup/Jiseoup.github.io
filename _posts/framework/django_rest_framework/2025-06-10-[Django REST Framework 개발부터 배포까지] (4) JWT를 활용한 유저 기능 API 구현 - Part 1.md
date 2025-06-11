---
title: "[Django REST Framework 개발부터 배포까지] (4) JWT를 활용한 유저 기능 API 구현 - Part 1"
date: 2025-06-10 17:00:00 +09:00
last_modified_at: 2025-06-10 17:00:00 +09:00
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
    jwt,
    json web token,
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
image: "/assets/img/title/drf_project/drf_project_4.png"
---

이번 포스팅에서는 **회원 가입 및 탈퇴, 로그인, 로그아웃**과 같은 유저 관련 기능을 구현하기 위한 준비 단계로,
이를 **JWT(JSON Web Token)** 기반 인증 방식으로 구현하기 위한 **개발 환경 구성**부터 다뤄보도록 하겠습니다.  

{% include drf-project.html %}

## 1. DRF 환경 구성
---
먼저 필수 패키지를 설치하고 프로젝트에 등록한 후, 등록한 패키지에 대해 설정하는 방법부터 살펴보겠습니다.  

### 1-1. 패키지 설치 및 앱 등록
아래 명령어를 통해 `django-rest-framework`와 `djangorestframework-simplejwt` 패키지를 설치합니다.  
이 중 `djangorestframework-simplejwt`는 **JWT 인증을 간편하게 구현**할 수 있도록 도와주는 강력한 라이브러리입니다.
```bash
pip install django-rest-framework
pip install djangorestframework-simplejwt
```

다음으로 설치한 패키지를 프로젝트에 적용하기 위해 `settings.py` 파일을 수정합니다.  
아래와 같이 `INSTALLED_APPS` 항목에 `rest_framework`와 `rest_framework_simplejwt.token_blacklist`를 등록합니다.  
```python
INSTALLED_APPS = [
    # Django Basic Apps
    'django.contrib.admin',
    ...
    # Third-Party Apps
    'rest_framework',
    'rest_framework_simplejwt.token_blacklist',
]
```

위와 같이 모든 앱의 등록을 마쳤다면, `token_blacklist` 관련 테이블이 프로젝트에 자동으로 생성됩니다.  
생성된 `token_blacklist` 테이블을 데이터베이스에 적용하기 위해 마이그레이션을 진행합니다.  
```bash
python manage.py migrate
```

### 1-2. JWT 인증 설정
이제 DRF의 기본 인증 방식을 **세션(Session) 기반**에서 **JWT 기반 인증**으로 전환합니다.  
`settings.py` 파일에 아래와 같이 `REST_FRAMEWORK` 설정을 추가하여 인증 방식을 변경합니다.  

> Django는 기본적으로 세션 기반 인증을 사용하지만, REST API에서는 토큰 기반인 JWT가 더 널리 사용됩니다.  
{: .prompt-info }

```python
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.AllowAny', # 누구나 접근 가능
        # 'rest_framework.permissions.IsAdminUser', # 관리자만 접근 가능
        # 'rest_framework.permissions.IsAuthenticated', # 인증된 사용자만 접근 가능
    ],
}
```
위와 같이 `DEFAULT_AUTHENTICATION_CLASSES` 설정을 통해, 프로젝트 전반에 JWT 인증 방식을 적용할 수 있습니다.  
또한, `DEFAULT_PERMISSION_CLASSES`는 API의 접근 권한을 설정하는 옵션으로, 프로젝트 성격에 따라 적절한 옵션으로 구성하면 됩니다.  

### 1-3. JWT 토큰 설정
이제 마지막으로 `settings.py` 파일에 `SIMPLE_JWT` 옵션을 추가하여 JWT 토큰 관련 설정을 추가합니다.  
```python
from datetime import timedelta

SIMPLE_JWT = {
    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'ACCESS_TOKEN_LIFETIME': timedelta(hours=1),
    'REFRESH_TOKEN_LIFETIME': timedelta(hours=24),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
}
```
각 항목의 의미는 다음과 같습니다.  

|항목|설명|
|------|------|
|*ACCESS_TOKEN_LIFETIME*|액세스 토큰 유효 시간 (예제에서는 1시간으로 설정)|
|*REFRESH_TOKEN_LIFETIME*|리프레시 토큰 유효 시간 (예제에서는 24시간으로 설정)|
|*ROTATE_REFRESH_TOKENS*|리프레시 토큰 사용 시, 새로운 토큰으로 자동 교체할지의 여부|
|*BLACKLIST_AFTER_ROTATION*|리프레시 토큰 교체 후, 이전 토큰을 블랙리스트에 등록해 재사용을 차단할지의 여부|

이러한 설정을 통해 보안성과 편의성을 모두 고려한 토큰 인증 환경을 구축할 수 있습니다.  

## 2. DRF 앱 구성
---
DRF 프로젝트를 위한 기본적인 환경 구성을 마쳤으니, 이제 본격적으로 유저 기능 API를 개발할 준비를 해보겠습니다.  

### 2-1. 앱 생성
먼저, 프로젝트 루트 디렉토리에 각종 애플리케이션 코드를 모아둘 `apps` 디렉토리를 생성합니다.  
```bash
mkdir apps
```

그다음 `apps` 디렉토리로 이동하여, 유저 기능을 담당할 `account` 앱을 생성합니다.  
```bash
cd apps
django-admin startapp account
```

이제 `account` 앱 내부에 `serializers.py` 와 `urls.py` 파일을 생성합니다.  
```bash
cd account
touch serializers.py
touch urls.py
```
여기서 `serializers.py`는 **Django 모델 인스턴스를 JSON 형태로 변환**하거나, **사용자로부터 전달받은 데이터를 검증**하는 역할을 하며, `urls.py`는 `account` 앱에서 제공하는 **API 엔드포인트를 정의**합니다.  

### 2-2. 서비스 레이어 구성
본 프로젝트에서는 뷰(View)와 로직을 분리하여 **서비스 레이어 구조를 도입**하고자 합니다.  
이를 통해 핵심 로직을 보다 명확하고 독립적으로 관리할 수 있습니다.  

이를 위해 `account` 앱 내부에 서비스 레이어를 담당할 `application` 디렉토리를 생성하고, 유저 기능 관련 로직을 담을 `sign.py` 파일도 함께 생성합니다.  
```bash
mkdir application
touch application/sign.py
```
> `sign.py`에는 회원 가입, 회원 탈퇴, 로그인, 로그아웃 등 유저 인증 관련 핵심 로직을 구현하게 됩니다.  
{: .prompt-info }

### 2-3. 앱 설정 변경
추가로 앞서 생성한 `account` 앱을 `apps` 디렉토리 내부에 위치하도록 구성하였기 때문에, 앱 설정 파일의 경로도 변경해야 합니다. `account` 앱 내부의 `apps.py`를 열고, `name` 속성을 아래와 같이 `apps.account`로 변경합니다.  
```python
from django.apps import AppConfig

class AccountConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.account'
```

### 2-4. 앱 등록 및 URL 연결
마지막으로 `account` 앱이 Django 프로젝트에서 제대로 인식되고 동작할 수 있도록 설정을 해야합니다.  
먼저, `settings.py` 파일의 `INSTALLED_APPS` 항목에 `account` 앱을 추가로 등록합니다.  
```python
INSTALLED_APPS += [
    'core',
    'apps.account',
]
```

다음으로, 프로젝트의 메인 URL 설정 파일인 `conf/urls.py`에 `account` 앱의 URL 라우트를 연결합니다.  
```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('account/', include('apps.account.urls'), name='account'),
]
```
이 설정은 `/account/` 경로로 들어오는 요청을 앞서 생성한 `apps/account/urls.py`로 전달합니다.  

## 마무리
---
이제 유저 기능 API 구현을 위한 모든 준비가 끝났습니다.  
다음 포스팅에서는 본격적으로 회원 가입과 탈퇴, 로그인, 로그아웃에 대한 API를 하나씩 구현해보며, API의 실제 동작 확인까지 함께 살펴보도록 하겠습니다.  

감사합니다.  
