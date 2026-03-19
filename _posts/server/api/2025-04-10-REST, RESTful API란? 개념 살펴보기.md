---
title: "REST, RESTful API란? 개념 살펴보기"
slug: rest-restful-api
date: 2025-04-10 01:59:00 +09:00
last_modified_at: 2025-04-10 01:59:00 +09:00
categories: [Server, API]
tags: [rest-api, design]
image: "/assets/img/title/server/api/rest_api.png"
redirect_from:
    - /posts/REST,-RESTful-API란-개념-살펴보기/
    - /posts/REST,-RESTful-API%EB%9E%80-%EA%B0%9C%EB%85%90-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0/
---

웹 개발을 하다 보면 **REST API, RESTful API**라는 용어를 자주 접하게 됩니다.  
비슷해 보이지만, 정확히 어떤 개념이고 서로 어떤 차이가 있을까요?  
이번 포스팅에서는 REST와 RESTful API의 개념을 예시와 함께 정리하고 설명해보도록 하겠습니다.  

## 1. REST 란?
---
REST(REpresentational State Transfer)는 웹 아키텍처 스타일 중 하나로, **웹의 자원을 URI(Uniform Resource Identifier)로 표현하고, HTTP 메서드를 통해 자원을 처리하는 방식**을 말합니다.  

> 대표적인 HTTP 메서드 : GET, POST, PUT, PATCH, DELETE  
{: .prompt-info }

REST 아키텍처는 아래 6가지 원칙을 따릅니다.  

|REST 원칙|설명|
|------|-----|
|인터페이스 일관성|URI, HTTP 등의 표준화된 방법을 사용한다.|
|클라이언트-서버 구조|클라이언트와 서버는 명확히 구분되어야한다.|
|무상태성|각 요청은 독립적으로 처리되고, 서버는 요청 상태를 저장하지 않는다.|
|캐시 처리 가능|응답은 캐싱이 가능해야한다.|
|계층화된 시스템|클라이언트는 서버와 직접 통신하지 않고, 중간 계층을 거쳐 요청을 전달한다.|
|코드 온 디맨드 (Optional)|서버는 클라이언트로 실행 가능한 코드를 전송할 수 있다.|

참고 문서 : [What is REST?](https://restfulapi.net)  

## 2. REST API 란?
---
REST API는 위 **REST 원칙을 기반으로 한 API 설계 방식**입니다.  
즉, **웹 자원을 URI로 정의하고, HTTP 메서드를 이용해 해당 자원에 대한 CRUD 작업을 수행**합니다.  

아래는 USER 라는 자원을 활용해 REST API로 설계한 예시입니다.  

|HTTP 메서드|URI|설명|
|------|-----|-----|
|GET|/users|모든 유저 정보를 불러옵니다.|
|GET|/users/1|특정 유저(pk=1) 정보를 불러옵니다.|
|POST|/users|새로운 유저를 생성합니다.|
|PUT|/users/1|특정 유저(pk=1) 정보를 전체 수정합니다.|
|PATCH|/users/1|특정 유저(pk=1) 정보를 부분 수정합니다.|
|DELETE|/users/1|특정 유저(pk=1) 정보를 삭제합니다.|

## 3. REST API의 URI 네이밍 규칙
---
REST API 설계에 있어, URI 네이밍 규칙은 가장 기본이면서서도 매우 중요합니다.  
URI를 명확하고 일관성 있게 네이밍하여, API의 의미를 직관적으로 전달할 수 있어야 합니다.  

아래는 REST API의 URI 네이밍 규칙에 대한 설명입니다.  

**1. 명사를 사용하여 리소스를 표현한다.**  
* 리소스는 동사가 아닌 명사로 표현한다.  
* 단일 리소스(객체 인스턴스 등)에 대해서는 단수 명사를 사용한다.  
* 클라이언트 및 서버 리소스에 대해서는 복수 명사를 사용한다.  

```text
✅ 올바른 예시
GET /users
GET /users/admin
GET /users/{id}/playlists

❌ 잘못된 예시
GET /getUsers
GET /users/admins
GET /user/{id}/playlist
```

**2. 일관성이 핵심이다.**  
* 계층적 관계를 나타내기 위해서는 `슬래시(/)`를 사용한다.  
* URI 마지막에 `슬래시(/)`를 사용하지 않는다.  
* URI 가독성을 위해 `하이픈(-)`을 사용한다.  
* `언더라인(_)`을 사용하지 않는다.  
* URI에 소문자를 사용한다.  

```text
✅ 올바른 예시
GET /order-management/customer-orders
GET /order-management/customer-orders/{order-id}
GET /order-management/customer-orders/{order-id}/order-items

❌ 잘못된 예시
GET /order-management/customer-orders/
GET /ordeManagement/customerOrders
GET /order_management/customer_orders
```

**3. 파일 확장자를 사용하지 않는다.**  
* URI에 파일 확장자를 사용하지 않는다.  

```text
✅ 올바른 예시
GET /content-management/authors

❌ 잘못된 예시
GET /content-management/authors.xml
```

**4. CRUD 함수 이름을 사용하지 않는다.**  
* URI에 CRUD 기능을 나타내는 단어를 사용하지 않는다.  

```text
✅ 올바른 예시
GET /user-accounts

❌ 잘못된 예시
GET /get-all-users
```

**5. 쿼리 파라미터를 사용해 리소스를 필터링한다.**  
* 새로운 API 생성을 지양하고, 쿼리 파라미터를 사용해 리소스를 필터링한다.  

```text
✅ 올바른 예시
GET /drivers?status=active
GET /drivers?region=KR&age=30
GET /drivers?page=2&limit=100
```

참고 문서 : [REST API URI Naming Conventions and Best Practices](https://restfulapi.net/resource-naming)  

## 4. RESTful API 란?
---
RESTful API란, 앞서 살펴본 **REST 아키텍처 스타일을 충실히 따르는 API를 의미합니다.**  
즉, REST 원칙을 지키는 정도가 높을수록 RESTful하다고 평가됩니다.  

📌 지금까지의 내용을 간단히 정리하자면 아래와 같습니다.  
* REST는 웹 아키텍처 스타일, 즉 설계 원칙입니다.  
* REST API는 REST 스타일을 적용하여 설계한 API를 의미합니다.  
* RESTful API는 REST 원칙을 더 충실하게 따르는 API를 의미합니다.  

따라서 모든 REST API가 반드시 RESTful한 것은 아닙니다.  
예를 들어, URI에 동사를 넣거나 HTTP 메서드를 잘못 사용하는 경우 REST의 원칙을 어긴 것으로 볼 수 있습니다.  

## 마무리
---
지금까지 REST의 기본 원칙부터, RESTful API의 개념까지 알아보았습니다.  
RESTful API는 단순한 형식 맞추기를 넘어, 시스템을 더 직관적이고 일관성 있게 설계할 수 있도록 도와줍니다.  

RESTful하게 설계된 API는 URI만 봐도 어떤 동작을 하는지 쉽게 파악할 수 있어, 개발자 간 커뮤니케이션이 원활해지고 팀 간 협업 효율도 크게 향상됩니다. 또한 구조가 명확하기 때문에 유지보수가 쉬우며, 서비스가 확장되거나 복잡해지더라도 안정적으로 관리할 수 있습니다.  

요즘은 대부분의 웹 서비스가 REST 원칙을 기반으로 설계되기 때문에, REST는 이제 선택이 아닌 사실상 필수에 가까운 설계 기준이 되었습니다.  

이번 포스팅이 REST에 대한 이해를 더욱 깊게 만드는 데 도움이 되었기를 바랍니다.  
긴 글 읽어주셔서 감사합니다.  
