---
title: 포스트맨(Postman) 사용 방법과 API 요청 테스트
date: 2025-06-10 14:37:00 +09:00
last_modified_at: 2025-06-10 14:37:00 +09:00
categories: [Tools, Postman]
tags:
  [
    postman,
    포스트맨,
    api,
    rest api,
    api test,
    api 테스트,
    http,
    http method,
    http 메서드,
    request,
    response,
  ]
image: "/assets/img/title/tools/postman/logo.png"
---

**Postman**은 API 테스트를 위한 도구로, 웹 개발에서 매우 자주 사용되는 강력한 도구 중 하나입니다.  
프론트엔드와 백엔드의 협업, 외부 API 연동 테스트, 인증 토큰 확인 등 다양한 상황에서 유용하게 활용할 수 있습니다.  

이번 포스팅에서는 **Postman 설치부터 기본적인 사용법, 그리고 API 요청 테스트까지 정리**해보도록 하겠습니다.  
본 포스팅의 [4장](https://devpro.kr/posts/%ED%8F%AC%EC%8A%A4%ED%8A%B8%EB%A7%A8(Postman)-%EC%82%AC%EC%9A%A9-%EB%B0%A9%EB%B2%95%EA%B3%BC-API-%EC%9A%94%EC%B2%AD-%ED%85%8C%EC%8A%A4%ED%8A%B8/#4-%EC%9A%94%EC%B2%ADrequests)부터 API 요청 기능 사용 방법과 테스트가 본격적으로 시작되니, 급하신 분들은 4장부터 바로 읽어보셔도 좋습니다.  

## 1. Postman 다운로드 및 설치
---
먼저 [Postman 공식 다운로드 링크](https://www.postman.com/downloads/)에 접속하여 운영체제에 맞는 파일을 다운로드하고 설치합니다.  
설치 과정은 직관적이며, 별도의 설정 없이도 빠르게 완료할 수 있어 생략합니다.  

![postman_download_web](/assets/img/posts/tools/postman/postman_download_web.png)  

설치가 완료된 후 Postman 앱을 실행하면 아래와 같은 초기 화면이 나타납니다.  

![postman_app_main](/assets/img/posts/tools/postman/postman_app_main.png)  

> Postman 사용에 로그인이 필수는 아니지만, 로그인 시 각종 동기화, 백업, 협업 등의 기능을 활용할 수 있기에 더욱 편리합니다.  
{: .prompt-info }

## 2. 워크스페이스(Workspaces)
---
Postman에서는 **워크스페이스**를 통해 프로젝트 단위로 API 요청들을 체계적으로 분리하고 관리할 수 있습니다.  
개발 중인 서비스가 여러 개이거나, 팀 협업 중이라면 워크스페이스 기능을 활용하는 것이 매우 유용합니다.  

워크스페이스는 좌측 상단의 `Workspaces` 드롭다운에서 `Create Workspace` 버튼을 클릭하여 생성 가능합니다.  

![postman_workspace_1](/assets/img/posts/tools/postman/postman_workspace_1.png)  

Postman은 워크스페이스를 생성할 때 유용한 템플릿도 함께 제공합니다.  
예를 들어 API 설계, 테스트, 문서화 목적에 맞춘 템플릿을 선택하여 보다 빠르게 시작할 수 있습니다.  

![postman_workspace_2](/assets/img/posts/tools/postman/postman_workspace_2.png)  

마지막으로 워크스페이스 이름, 접근 범위 등을 설정한 후 `Create` 버튼을 누르면 생성이 완료됩니다.  

![postman_workspace_3](/assets/img/posts/tools/postman/postman_workspace_3.png)  

워크스페이스는 Postman 사용 시 필수는 아니지만, 프로젝트를 보다 체계적이고 효율적으로 관리할 수 있는 유용한 기능입니다. 특히 서비스가 여러 개이거나 팀 단위 협업이 필요한 경우라면 꼭 활용해보시길 추천드립니다.  

## 3. 컬렉션(Collections)
---
**컬렉션**은 여러 개의 API 요청을 하나의 그룹으로 묶어 관리할 수 있는 기능입니다.  
프로젝트 내에서 API를 기능별 또는 모듈별로 정리할 때 매우 유용하며, 테스트 효율성과 가독성을 높일 수 있습니다.  

Postman 좌측의 `Collections` 탭에서 `+` 버튼을 클릭하여 새로운 컬렉션을 생성할 수 있습니다.  

![postman_collection_1](/assets/img/posts/tools/postman/postman_collection_1.png)  

컬렉션 생성 시, 원하는 이름과 설명을 입력할 수 있으며, 필요하다면 `기본 인증 방식(Authorization)`이나 `변수(Variables)` 등을 함께 탭에서 설정할 수도 있습니다.  

![postman_collection_2](/assets/img/posts/tools/postman/postman_collection_2.png)  

이러한 컬렉션은 단순한 API 요청 묶음 이상의 역할을 합니다.  
테스트 자동화, Mock 서버 구성, 팀 공유 등 다양한 기능과 연동되어 실무에서 매우 강력한 도구가 됩니다.  

다음에 기회가 된다면, 컬렉션 내 변수 활용, 테스트 스크립트 작성 등 심화된 내용을 다루는 포스팅도 준비해보겠습니다.  

## 4. 요청(Requests)
---
이제 본격적으로 API 요청 방법에 대해 알아보겠습니다.  
Postman에서는 다양한 HTTP 메서드(GET, POST, PUT, DELETE 등)를 사용하여 API를 손쉽게 호출할 수 있습니다.  

새로운 요청은 좌측 상단의 `New` 버튼을 클릭하거나, 컬렉션에 마우스 오른쪽 클릭 후 `Add request`를 선택해 생성할 수 있습니다.  

![postman_add_request](/assets/img/posts/tools/postman/postman_add_request.png)  

다음으로 Postman 요청 UI의 주요 기능들에 대해 알아보도록 하겠습니다.  

![postman_request_1](/assets/img/posts/tools/postman/postman_request_1.png)  

**① Request URL :** 요청할 HTTP 메서드(GET, POST 등)를 선택하고, 요청을 보낼 URL을 설정할 수 있습니다.  
**② Params :** 요청에 포함할 쿼리 파라미터(Query Parameters)를 `Key-Value` 형태로 간편하게 지정할 수 있습니다.  

![postman_request_2](/assets/img/posts/tools/postman/postman_request_2.png)  

**③ Authorization :** API 호출 시 필요한 인증 정보를 선택할 수 있습니다. 일반적으로 `Basic Auth`, `Bearer Token`, `API Key`를 사용합니다.  

![postman_request_3](/assets/img/posts/tools/postman/postman_request_3.png)  

**④ Headers :** API 요청에 포함할 HTTP 헤더를 `Key-Value` 형태로 설정할 수 있습니다.  

![postman_request_4](/assets/img/posts/tools/postman/postman_request_4.png)  

**⑤ Body :** 서버에 전송할 `Request Body`의 포맷과 데이터를 설정할 수 있습니다. 일반적으로 `form-data` 또는 `raw` 포맷을 사용합니다.    

위에서 설명한 내용들을 참고하여, HTTP 메서드, URL 등을 적절히 설정한 후, `Send` 버튼을 클릭하면 API 요청과 함께 응답을 확인할 수 있습니다.  

## 5. API 요청 테스트
---
이제 Postman을 활용한 API 요청 테스트를 진행해보겠습니다.  
본 포스팅에서는 테스트용 API를 무료로 제공하는 [JSON Placeholder](https://jsonplaceholder.typicode.com/) 사이트를 실습에 이용해보겠습니다.  

![json_placeholder_web_routes](/assets/img/posts/tools/postman/json_placeholder_web_routes.png)  

JSON Placeholder 사이트 하단에는 위와 같이 API 엔드포인트가 정의되어 있습니다.  
별도의 인증 정보는 필요하지 않으므로, HTTP 메서드, URL, Request Body 등만 적절히 조정하며 간단히 테스트를 진행해보겠습니다.  

### 5-1. GET Method
먼저 가장 간단한 GET Method 부터 테스트 해보도록 하겠습니다.  
GET Method는 Request Body를 지원하지 않기 때문에, URL과 쿼리 파라미터만 적절히 조정해주시면 됩니다.  

#### 5-1-1. 모든 데이터 GET (List)
`GET https://jsonplaceholder.typicode.com/posts`의 요청 예시입니다.  

아래와 같이 모든 포스트 목록을 응답으로 얻을 수 있습니다.  

![postman_get_1](/assets/img/posts/tools/postman/postman_get_1.png)  

#### 5-1-2. 특정 데이터 GET (Retrieve)
`GET https://jsonplaceholder.typicode.com/posts/1`의 요청 예시입니다.  
패스 파라미터(Path Parameter)로 포스트 번호(1)를 URL에 지정하여, 원하는 특정 데이터를 가져올 수 있습니다.  

아래와 같이 `id=1`인 포스트 정보를 응답으로 얻을 수 있습니다.  

![postman_get_2](/assets/img/posts/tools/postman/postman_get_2.png)  

#### 5-1-3. 쿼리 파라미터 활용
`GET https://jsonplaceholder.typicode.com/comments?postId=1`의 요청 예시입니다.  
쿼리 파라미터는 `Params` 탭에서 `Key-Value` 형태로 지정가능하며, URL에 직접 작성하는 것도 가능합니다.  

아래와 같이 `postId=1`인 포스트의 코멘트 정보를 응답으로 얻을 수 있습니다.  

![postman_get_3](/assets/img/posts/tools/postman/postman_get_3.png)  

### 5-2. POST Method
다음은 POST Method 입니다.  
POST Method는 주로 Request Body에 데이터를 담아 서버에 전송하기 때문에, 적절한 수정이 필요합니다.   

다음은 `POST https://jsonplaceholder.typicode.com/posts`의 요청 예시입니다.  
Request Body로 아래와 같은 데이터를 담아 요청을 전송합니다.  
```json
{
    "title": "Test Title",
    "body": "This is test posting.",
    "userId": 1
}
```

아래와 같이 Request Body에 입력한 데이터가 반영된 새로운 포스트가 생성된 결과를 응답으로 얻을 수 있습니다.  

![postman_post](/assets/img/posts/tools/postman/postman_post.png)  

### 5-3. PUT/PATCH Method
다음은 서버에 이미 존재하는 리소스를 수정할 때 사용하는 PUT Method와 PATCH Method 입니다.  
* **PUT Method :** 전체 리소스를 덮어쓰는 방식(Overwrite)으로 수정합니다.  
* **PATCH Method :** 리소스의 일부 필드만 선택적으로 수정합니다.  

#### 5-3-1. PUT Method
`PUT https://jsonplaceholder.typicode.com/posts/1`의 요청 예시입니다.  
Request Body에 기본키(PK)를 제외한 모든 필드를 포함하여 요청을 전송합니다.  
```json
{
    "title": "Updated Title. (PUT Method)",
    "body": "Updated body. (PUT Method)",
    "userId": 2
}
```

아래와 같이 업데이트된 1번 포스트의 데이터를 응답으로 얻을 수 있습니다.  

![postman_put](/assets/img/posts/tools/postman/postman_put.png)  

#### 5-3-2. PATCH Method
`PATCH https://jsonplaceholder.typicode.com/posts/1`의 요청 예시입니다.  
Request Body에 수정을 원하는 필드만 포함하여 요청을 전송합니다.  
```json
{
    "title": "Updated Title. (PATCH Method)"
}
```

아래와 같이 1번 포스트의 `title`만 업데이트된 결과를 응답으로 얻을 수 있습니다.  

![postman_patch](/assets/img/posts/tools/postman/postman_patch.png)  

### 5-4. DELETE Method
마지막으로 서버 리소스를 삭제하는 DELETE Method 입니다.  

다음은 `DELETE https://jsonplaceholder.typicode.com/posts/1`의 요청 예시입니다.  
패스 파라미터(Path Parameter)로 포스트 번호(1)를 URL에 지정하여, 원하는 특정 데이터를 삭제할 수 있습니다.  

현재 테스트중인 API는 실제로 데이터의 변경을 서버에 반영하고 있지는 않기 때문에, 응답으로 `200 OK`가 넘어오는 모습만 확인 가능합니다.  

![postman_delete](/assets/img/posts/tools/postman/postman_delete.png)  

## 마무리
---
이번 포스팅에서는 Postman의 기본 사용법부터 다양한 HTTP 메서드를 활용한 API 요청 테스트까지 단계별로 정리해보았습니다.  
처음 사용하는 분들도 부담 없이 따라올 수 있도록 예제 중심으로 구성했으니, 실제 개발 현장에서 API를 테스트하거나 협업 도구로 Postman을 사용할 때 많은 도움이 되기를 바랍니다.  

감사합니다.  
