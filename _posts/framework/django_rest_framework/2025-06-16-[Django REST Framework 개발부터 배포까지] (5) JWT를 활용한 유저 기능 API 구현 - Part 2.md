---
published: false  # NOTE: 퍼블리싱 임시 중지
title: "[Django REST Framework 개발부터 배포까지] (5) JWT를 활용한 유저 기능 API 구현 - Part 2"
slug: drf-project-part5
date: 2025-06-16 18:40:00 +09:00
last_modified_at: 2025-06-16 18:40:00 +09:00
categories: [Framework, Django REST Framework]
tags: [django, drf, jwt, rest-api]
image: "/assets/img/title/framework/django_rest_framework/drf_project/lesson_5.png"
---

이전 포스팅의 DRF 개발 환경 구성에 이어, 이번에는 본격적으로 유저 기능 API를 구현해보도록 하겠습니다.  
유저 기능 API는 크게 **회원 가입과 탈퇴, 로그인, 로그아웃으로 구성**됩니다.  
추가로, 로그인과 로그아웃 기능은 [**JWT(JSON Web Token)**](https://devpro.kr/posts/JWT(JSON-Web-Token)%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80/) 기반 인증 방식으로 구현할 것이기 때문에, **Access Token을 재발급하는 API도 함께 구현**할 예정입니다.  

{% include drf-project.html %}

## 1. 회원 가입/탈퇴 API 구현
---
먼저, 유저 기능 중 회원 가입과 탈퇴 API를 먼저 구현해보겠습니다.  
Django의 기본 `User` 모델을 기반으로 하여, DRF의 `ModelSerializer`, `ViewSet`, 그리고 서비스 레이어 구조를 활용한 방식으로 개발합니다.  

### 1-1. 시리얼라이저(Serializer) 정의
> /apps/account/serializers.py  

회원 가입 및 탈퇴 기능에 사용할 `User` 모델 기반 시리얼라이저 클래스(`AccountSerializer`)를 정의합니다.  

`Meta` 클래스의 `model` 항목에는 **사용할 모델을 지정**하고, `fields` 항목에는 **활용하고자 하는 필드를 명시**합니다.  
추가로 `password` 필드는 민감 정보이므로, 응답에 포함되지 않도록 `write_only=True` 옵션을 설정합니다.  

```python
from rest_framework import serializers
from django.contrib.auth.models import User

class AccountSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'password', 'email', 'first_name', 'last_name']

    def create(self, validated_data: dict):
        user = User.objects.create_user(
            username=validated_data.get('username'),
            password=validated_data.get('password'),
            email=validated_data.get('email'),
            first_name=validated_data.get('first_name'),
            last_name=validated_data.get('last_name')
        )
        return user
```

클래스 메서드 **`create()`**는 시리얼라이저에서 `.save()` 메서드가 호출될 때, **새로운 인스턴스를 생성하는 경우 자동으로 실행**되는 메서드 입니다.  
즉, 시리얼라이저가 유효성 검사를 통과한 `validated_data`를 바탕으로, Django의 내장 메서드인 `create_user()`를 호출하여 **새로운 `User` 인스턴스를 생성**하도록 합니다.  

> `create_user()` 메서드는 비밀번호를 자동으로 해싱 처리해 저장하므로, `User` 인스턴스를 생성할 때 반드시 사용하는 것이 보안상 안전합니다.  
{: .prompt-tip }

### 1-2. 서비스 레이어 구현
> /apps/account/application/sign.py  

다음으로 회원 가입 및 탈퇴에 대한 핵심 로직을 처리할 서비스 레이어 코드를 작성합니다.  
DRF의 `GenericViewSet`과 함께 `mixins`를 적절히 조합하여, 유저 생성 및 삭제 기능을 구현합니다.  

> **mixins 란?**  
> 사전적 의미로는 특정 클래스에 상속을 통해 **새로운 속성이나 기능을 추가하는 보조 클래스**를 의미합니다.  
> DRF에서는 **CRUD 기능을 각각의 mixin으로 나누어 제공**하며, **필요한 기능만 골라 사용**할 수 있도록 합니다.  
> 이는 불필요한 코드를 줄이고, **필요한 기능만 유연하게 조합할 수 있게 해주는 강력한 도구**입니다.  
{: .prompt-info }

이번 구현에서는 유저의 생성과 삭제를 위해 DRF에서 제공하는 두 가지 `mixins`를 사용합니다.  
* `CreateModelMixin` : POST 요청을 처리하여 새로운 유저 인스턴스를 생성  
* `DestroyModelMixin` : DELETE 요청을 처리하여 기존 유저 인스턴스를 삭제  

`GenericViewSet`과 함께, 위에서 설명한 두 가지 `mixins`를 클래스에 상속하여 아래와 같이 코드를 구성합니다.  

```python
from rest_framework import mixins, viewsets
from rest_framework.request import Request
from rest_framework.response import Response

from apps.account import serializers

class Account(
    mixins.CreateModelMixin,
    mixins.DestroyModelMixin,
    viewsets.GenericViewSet
):
    serializer_class = serializers.AccountSerializer
    queryset = serializer_class.Meta.model.objects.all()

    def create_account(self, request: Request, *args, **kwargs) -> Response:
        return super().create(request, *args, **kwargs)

    def delete_account(self, request: Request, *args, **kwargs) -> Response:
        return super().destroy(request, *args, **kwargs)
```

여기서 `serializer_class` 속성은 해당 **ViewSet에서 사용할 시리얼라이저를 지정**합니다.  
위 코드에서는 `AccountSerializer`를 사용하여 유저 생성 시 전달된 데이터를 검증하고, 실제 **`User` 인스턴스를 생성하는 작업에 사용**됩니다.  

다음으로 `queryset`은 **ViewSet이 조회하거나 삭제할 수 있는 데이터의 기본 범위를 지정**합니다.  
위 코드에서는 `serializer_class.Meta.model.objects.all()`을 통해, `AccountSerializer`에 지정된 `User` 모델 전체를 대상으로 합니다.  

마지막으로 `create_account()`와 `delete_account()` 메서드는, 각각 **유저 생성과 삭제 요청을 처리**하는 역할을 합니다.  
이 두 메서드는 DRF의 `CreateModelMixin`과 `DestroyModelMixin`이 제공하는 **기본 동작(`create()`, `destroy()`)을 그대로 호출하는 방식으로 구현**되어, 불필요한 로직 없이 간결하고도 명확하게 구성했습니다.  

### 1-3. 뷰(View) 정의
> /apps/account/views.py  

이제 앞서 정의한 서비스 레이어를 실제 뷰로 연결해주는 `AccountView` 클래스를 작성합니다.  
이 뷰 클래스는 `sign.py`에 정의된 `Account` 클래스(ViewSet)를 상속받아, 내부적으로 **`create_account()`와 `delete_account()` 메서드를 호출함으로써 각각 회원 가입과 탈퇴 요청을 처리**합니다.  

```python
from apps.account.application import sign

class AccountView(sign.Account):
    def create(self, request, *args, **kwargs):
        return self.create_account(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        return self.delete_account(request, *args, **kwargs)
```

이처럼 서비스 레이어와 분리된 뷰 로직을 구성하면, 코드의 재사용성과 유지보수성을 높일 수 있습니다.  

### 1-4. URL 설정
> /apps/account/urls.py  

마지막으로, 앞서 정의한 **뷰를 URL과 매핑하여 외부에서 접근 가능한 API 엔드포인트로 노출**합니다.  

```python
from django.urls import path

from apps.account.views import AccountView

app_name = 'account'

urlpatterns = [
    # Create/Delete user account.
    path('create-account', AccountView.as_view({'post': 'create'}), name='create-account'),
    path('delete-account/<int:pk>', AccountView.as_view({'delete': 'destroy'}), name='delete-account'),
]
```

위 설정에서는 Django의 `path()` 함수와 DRF의 `as_view()` 메서드를 함께 사용하여, **HTTP 요청 방식(POST, DELETE)에 따라 ViewSet의 특정 메서드를 호출하도록 명시**합니다.  

* `create-account` : POST 요청 시, `AccountView`의 `create()` 메서드를 호출하여 회원 가입 처리
* `delete-account/<int:pk>` : DELETE 요청 시, `AccountView`의 `destroy()` 메서드를 호출하여 회원 탈퇴 처리

> `delete-account`에서 `<int:pk>`는 **삭제 대상 유저의 기본 키(Primary Key)를 의미**합니다.  
{: .prompt-tip }

이제 회원 가입과 탈퇴를 위한 API 구성은 완료되었습니다.  
다음 단계에서 로그인과 로그아웃 기능을 구현하고, 이후에 API 테스트를 한번에 진행하도록 하겠습니다.  

## 2. 로그인/로그아웃 API 구현
---
이제 JWT 기반의 로그인, 로그아웃, 그리고 Access Token 재발급 기능을 구현해보도록 하겠습니다.  

위 기능들은 이전 포스팅에서 설치한 `djangorestframework-simplejwt` 패키지를 기반으로, 별도의 시리얼라이저 없이 패키지에서 제공하는 View 클래스를 상속하여 간단하게 커스터마이징하는 방식으로 구현합니다.  

### 2-1. 서비스 레이어 구현
> /apps/account/application/sign.py  

로그인, 로그아웃, Access Token 재발급 기능은 앞서 작성한 회원 가입 및 탈퇴 코드에 이어서 작성합니다.  
먼저, `simplejwt` 패키지의 `TokenObtainPairView`, `TokenBlacklistView`, `TokenRefreshView` 클래스를 임포트합니다.  
```python
from rest_framework_simplejwt.views import TokenObtainPairView, TokenBlacklistView, TokenRefreshView
```
각 기능은 해당 클래스의 `post()` 메서드를 오버라이딩하여 응답 메시지를 커스터마이징하는 방식으로 구현합니다.  

#### 2-1-1. 로그인
`TokenObtainPairView` 클래스는 클라이언트로부터 `username`과 `password`를 받아 인증하고, 성공 시 **`Access Token + Refresh Token 쌍(pair)`을 발급**합니다.  
```python
class Login(TokenObtainPairView):
    def post(self, request: Request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)

        if response.status_code == 200:
            return Response({'message': 'Login successful', **response.data}, status=200)

        return response
```

#### 2-1-2. 로그아웃
`TokenBlacklistView` 클래스는 클라이언트가 보유한 **Refresh Token을 블랙리스트에 등록하여, 더 이상 해당 토큰을 재사용할 수 없도록 합니다.**  
```python
class Logout(TokenBlacklistView):
    def post(self, request: Request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)

        if response.status_code == 200:
            return Response({'message': 'Logout successful'}, status=200)

        return response
```

#### 2-1-3. Access Token 재발급
`TokenRefreshView` 클래스는 만료된 Access Token을 갱신하기 위해, **유효한 Refresh Token을 활용하여 새로운 Access Token을 발급**하도록 합니다.  
```python
class Refresh(TokenRefreshView):
    def post(self, request: Request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)

        if response.status_code == 200:
            return Response({**response.data}, status=200)

        return response
```

> 설정 파일(`settings.py`)의 `SIMPLE_JWT` 항목에서 **`ROTATE_REFRESH_TOKENS = True`** 옵션을 설정한 경우, **Access Token과 Refresh Token이 함께 재발급**됩니다.  
{: .prompt-tip }

### 2-2. 뷰(View) 정의
> /apps/account/views.py  

다음으로, 서비스 레이어를 실제 뷰로 연결하기 위해 `LoginView`, `LogoutView`, `RefreshView` 클래스를 작성합니다.  
```python
class LoginView(sign.Login):
    def post(self, request, *args, **kwargs):
        return super().post(request, *args, **kwargs)

class LogoutView(sign.Logout):
    def post(self, request, *args, **kwargs):
        return super().post(request, *args, **kwargs)

class RefreshView(sign.Refresh):
    def post(self, request, *args, **kwargs):
        return super().post(request, *args, **kwargs)
```
각 뷰 클래스는 `sign.py`에 정의한 각 클래스를 상속하고, **`post()` 메서드를 호출하여 기능을 수행**합니다.  

### 2-3. URL 설정
> /apps/account/urls.py  

마지막으로, `LoginView`, `LogoutView`, `RefreshView`를 **URL과 매핑하여 API 엔드포인트로 노출**합니다.  
```python
from apps.account.views import LoginView, LogoutView, RefreshView

app_name = 'account'

urlpatterns = [
    ...
    # User Login/Logout using JWT.
    path('login', LoginView.as_view(), name='login'),
    path('logout', LogoutView.as_view(), name='logout'),

    # Refresh JWT.
    path('refresh', RefreshView.as_view(), name='refresh'),
]
```
이제 로그인, 로그아웃, Access Token 재발급을 위한 API 구성도 모두 완료되었습니다.  
다음 단계에서는 **포스트맨(Postman)**을 활용하여 실제 API 요청 테스트를 진행해보도록 하겠습니다.  

## 3. API 테스트
---
앞서 구현한 유저 기능 API를 테스트하기 위해, 먼저 로컬 서버를 실행합니다.  
```bash
python manage.py runserver
```
이제 브라우저 또는 API 테스트 도구를 사용하여, 각 엔드포인트에 요청을 보내 결과를 확인할 수 있습니다.  
브라우저에서 [http://localhost:8000](http://localhost:8000) 주소 뒤에 구현한 API 엔드포인트를 입력하면, DRF에서 기본 제공하는 웹 브라우저용 API 인터페이스를 통해 바로 테스트가 가능합니다.  

예를 들어, 아래는 `/account/create-account` 엔드포인트에 접속한 화면입니다.  

![drf_web_api_test](/assets/img/posts/framework/django_rest_framework/drf_web_api_test.png)  

하지만, 이러한 방법보다는 **포스트맨(Postman)과 같은 전문 API 테스트 도구를 사용하는 것을 추천**합니다.  
Postman을 사용하면 Request Body, Header, Token 등을 보다 세밀하게 설정하고, Response 또한 더 직관적으로 확인할 수 있어 실제 API 개발 및 디버깅에 매우 유용합니다.  

**Postman 설치 및 사용 방법은 아래 포스팅을 참고**해주세요.  

> [포스트맨(Postman) 사용 방법과 API 요청 테스트](https://devpro.kr/posts/%ED%8F%AC%EC%8A%A4%ED%8A%B8%EB%A7%A8(Postman)-%EC%82%AC%EC%9A%A9-%EB%B0%A9%EB%B2%95%EA%B3%BC-API-%EC%9A%94%EC%B2%AD-%ED%85%8C%EC%8A%A4%ED%8A%B8/)  
{: .prompt-info }

### 3-1. 회원 가입 API
먼저 회원 가입 API 요청 테스트를 진행해보도록 하겠습니다.  
![api_create_account](/assets/img/posts/framework/django_rest_framework/api_create_account.png)  

Postman에서 다음과 같이 설정합니다.  
* HTTP 메서드 : `POST`
* 요청 URL : `http://localhost:8000/account/create-account`
* Body 탭 : `raw` + `JSON` 형식 선택

아래는 실제로 요청에 사용된 Request Body 예시입니다.  
```json
{
    "username": "myuser",
    "password": "1234",
    "email": "myuser@test.com",
    "first_name": "Doe",
    "last_name": "John"
}
```

정상적으로 요청이 처리되면, `201 Created` 상태 코드와 함께 **생성된 유저 정보가 응답으로 반환**됩니다.  
참고로 **`password` 필드는 코드 구현에서 `write_only=True` 옵션으로 설정**하였기에, **응답에 포함되지 않습니다.**  

![query_create_account](/assets/img/posts/framework/django_rest_framework/query_create_account.png)  
회원 가입 API를 성공적으로 호출한 후 `User` 모델 테이블을 직접 쿼리해보면, 위와 같이 **새로운 유저(myuser)가 생성된 모습을 확인**할 수 있습니다.  
또한, 내부적으로 Django의 `create_user()` 메서드를 호출하여 `User` 인스턴스를 생성하는 방식으로 구현하였기 때문에, **`password` 필드가 자동으로 해싱 처리되어 저장**된 모습도 함께 확인할 수 있습니다.  

### 3-2. 로그인 API
다음으로 로그인 API가 **`Access Token + Refresh Token 쌍`**을 잘 반환하는지 확인해봅시다.  
![api_login](/assets/img/posts/framework/django_rest_framework/api_login.png)  

Postman에서 다음과 같이 설정합니다.  
* HTTP 메서드 : `POST`
* 요청 URL : `http://localhost:8000/account/login`
* Body 탭 : `raw` + `JSON` 형식 선택

이번에는 회원 가입 API를 통해 생성한 유저의 `username`과 `password`를 Request Body에 넣어 요청을 전달합니다.  
```json
{
    "username": "myuser",
    "password": "1234"
}
```

정상적으로 요청이 처리되면, `200 OK` 상태 코드와 함께 **`Access Token + Refresh Token 쌍`이 응답으로 반환**됩니다.  
추가로, **`Login successful`이라는 커스텀 메시지 또한 함께 응답에 포함**된 모습을 확인할 수 있습니다.  

### 3-3. Access Token 재발급 API
이제 로그인 API를 통해 발급받은 Refresh Token을 활용하여 Access Token을 재발급해보도록 하겠습니다.  
![api_refresh](/assets/img/posts/framework/django_rest_framework/api_refresh.png)  

Postman에서 다음과 같이 설정합니다.  
* HTTP 메서드 : `POST`
* 요청 URL : `http://localhost:8000/account/refresh`
* Body 탭 : `raw` + `JSON` 형식 선택

아래와 같이, 로그인 API를 호출하여 발급받은 Refresh Token을 `refresh` 키의 값으로 설정하여 요청합니다.  
```json
{
    "refresh": "<Refresh Token>"
}
```

일반적으로 Access Token만 재발급되어 응답으로 반환되지만, `SIMPLE_JWT` 설정의 `ROTATE_REFRESH_TOKENS` 옵션을 `True`로 설정한 경우, 위 Postman 요청 예시 사진과 같이 **Access Token과 Refresh Token이 모두 재발급되어 응답으로 반환**됩니다.  

### 3-4. 로그아웃 API
다음으로 재발급받은 Access Token과 Refresh Token을 사용하여 로그아웃을 진행합니다.  

Postman에서 다음과 같이 설정합니다.  
* HTTP 메서드 : `POST`
* 요청 URL : `http://localhost:8000/account/logout`
* Authorization 탭 : `Bearer Token` 선택
* Body 탭 : `raw` + `JSON` 형식 선택

먼저, 로그아웃은 로그인된 사용자만 수행할 수 있는 기능이므로, **요청 시 반드시 Access Token을 포함해 인증을 수행**해야 합니다.  
![api_logout_1](/assets/img/posts/framework/django_rest_framework/api_logout_1.png)  
위 사진과 같이 Authorization 탭으로 이동하여 **Auth Type을 `Bearer Token`으로 설정**하고, **재발급받은 Access Token 값을 입력**합니다.  

인증 정보 설정이 끝났다면, Body 탭으로 이동하여 (재발급받은) Refresh Token을 `refresh` 키의 값으로 설정하여 요청합니다.  
```json
{
    "refresh": "<Refresh Token>"
}
```
![api_logout_2](/assets/img/posts/framework/django_rest_framework/api_logout_2.png)  

정상적으로 요청이 처리되면, `200 OK` 상태 코드와 함께 위와 같은 **커스텀 메시지가 응답으로 반환**됩니다.  
이때, **요청에 포함된 Refresh Token은 서버의 블랙리스트에 등록**되며, 이후에는 **해당 토큰을 이용한 Access Token 재발급이 차단**됩니다.  

### 3-5. 회원 탈퇴 API
마지막으로 회원 탈퇴 API를 사용하여, 앞서 생성한 유저를 삭제해보도록 하겠습니다.  
![api_delete_account](/assets/img/posts/framework/django_rest_framework/api_delete_account.png)  

Postman에서 다음과 같이 설정합니다.  
* HTTP 메서드 : `DELETE`
* 요청 URL : `http://localhost:8000/account/delete-account/<int:pk>`

요청 URL의 **`<int:pk>` 부분에는 회원 탈퇴하고자 하는 유저의 기본 키(PK)를 입력**합니다.  
예를 들어, 저는 앞서 생성한 유저의 PK가 `2`였기 때문에, 값을 다음과 같이 요청을 보냈습니다.  
```
DELETE http://localhost:8000/account/delete-account/2
```
요청이 성공하면 `204 No Content` 상태 코드가 반환되며, 해당 유저가 정상적으로 삭제됩니다.  

![query_delete_account](/assets/img/posts/framework/django_rest_framework/query_delete_account.png)  
회원 가입 API를 성공적으로 호출한 후 `User` 모델 테이블을 직접 쿼리해보면, 위와 같이 **앞서 생성한 유저가 삭제된 모습을 확인**할 수 있습니다.  

## 마무리
---
이번 포스팅에서는 DRF와 JWT 인증 방식을 활용하여 유저 기능 API 전반을 직접 구현하고, Postman을 통해 실제 요청을 테스트하는 과정까지 모두 다뤄보았습니다.  

Django의 기본 `User` 모델과 DRF의 Serializer, ViewSet 구조를 바탕으로, 서비스 레이어 아키텍처를 적용하여 유저 기능 API를 설계해보았고, 이를 통해 DRF 기반 API 구현 방법을 어느 정도 익힐 수 있었을 것이라고 생각합니다.  

다음 포스팅부터는 **JWT 인증을 바탕으로 권한이 필요한 게시글 CRUD 기능을 구현**해보며, 실질적인 유저 인증 흐름이 어떻게 다른 기능과 연결되는지를 함께 살펴보겠습니다.  

긴 글 읽어주셔서 감사합니다.  
질문이 있으시다면 댓글로 남겨주세요!  
