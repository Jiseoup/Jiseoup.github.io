---
title: "HTTP 401(Unauthorized) vs 403(Forbidden) 차이점 제대로 이해하기"
slug: http-401-vs-403
date: 2026-03-19 10:32:00 +09:00
last_modified_at: 2026-03-19 10:32:00 +09:00
categories: [Server, API]
tags: [http, security]
image: "/assets/img/title/server/api/http_401_403.png"
---

HTTP 상태 코드 중 **401 Unauthorized**와 **403 Forbidden**은 흔히 혼동하기 쉬운 코드입니다.  
이번 포스팅에서는 두 코드의 의미, 차이점, 그리고 어떤 상황에 어떤 코드를 사용해야 하는지 정리해보겠습니다.  

## 1. 인증(Authentication)과 인가(Authorization)
---
401과 403의 차이를 이해하려면, 먼저 **인증(Authentication)**과 **인가(Authorization)**의 개념을 구분해야 합니다.  
이 두 개념은 영어로도, 한국어로도 비슷하게 들리지만, 의미는 전혀 다릅니다.  

**인증(Authentication)**은 **"당신이 누구인가?"** 를 확인하는 과정입니다.  
즉, 사용자가 주장하는 신원이 실제로 맞는지 검증하는 단계입니다.  
* 로그인 시 아이디와 비밀번호를 입력하는 행위  
* JWT, Session, OAuth 토큰을 서버에 전달하는 행위  

**인가(Authorization)**는 **"당신이 이 작업을 할 수 있는가?"** 를 확인하는 과정입니다.  
인증이 완료된 사용자에 한해, 특정 리소스나 기능에 접근할 권한이 있는지를 결정합니다.  
* 일반 사용자가 관리자 전용 페이지에 접근 가능한지 확인  
* 특정 데이터에 대한 읽기/쓰기/삭제 권한 검사  

> 인증(Authentication)은 인가(Authorization)보다 **항상 먼저** 수행됩니다.  
> 신원 확인이 되지 않은 사용자에게는 권한 검사 자체가 의미 없기 때문입니다.  
{: .prompt-info }

## 2. HTTP 401 Unauthorized
---
**401 Unauthorized**는 요청이 **인증되지 않았음**을 의미합니다.  
이름이 "Unauthorized" 이지만, 실질적인 의미는 **인증 실패(Unauthenticated)**에 가깝습니다.  

서버는 아래와 같은 상황에서 401을 반환합니다.  
* 요청에 인증 정보(토큰, 세션 등)가 포함되어 있지 않은 경우  
* 전달된 토큰이 만료되었거나 유효하지 않은 경우  
* 아이디 또는 비밀번호가 일치하지 않는 경우  

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer realm="example"
Content-Type: application/json

{
  "error": "Unauthorized",
  "message": "유효한 인증 정보가 없습니다."
}
```

> 401 응답 시에는 클라이언트가 어떤 인증 방식을 사용해야 하는지 안내할 수 있도록 **`WWW-Authenticate`** 헤더를 함께 포함하는 것이 HTTP 표준 권고사항입니다.  
{: .prompt-tip }

## 3. HTTP 403 Forbidden
---
**403 Forbidden**은 요청이 **인가되지 않았음**을 의미합니다.  
즉, 서버가 요청자의 신원은 알고 있지만, **해당 리소스에 접근할 권한이 없다**고 판단한 상태입니다.  

서버는 아래와 같은 상황에서 403을 반환합니다.  
* 인증된 사용자가 자신에게 허용되지 않은 리소스에 접근하려는 경우  
* 일반 사용자가 관리자 전용 API를 호출하는 경우  
* IP 차단, 지역 제한, 특정 역할 미보유 등의 이유로 접근이 거부된 경우  

```http
HTTP/1.1 403 Forbidden
Content-Type: application/json

{
  "error": "Forbidden",
  "message": "해당 리소스에 접근할 권한이 없습니다."
}
```

> 403은 **"리소스가 존재하지만, 당신은 볼 수 없다."** 는 의미를 내포합니다.  
> 리소스의 존재 자체를 숨기고 싶다면, `404 Not Found`를 반환하는 것이 보안적으로 더 적절한 경우도 있습니다.  
{: .prompt-warning }

## 4. 401 Unauthorized vs 403 Forbidden 비교
---
두 코드의 핵심 차이를 간단히 정리하면 아래와 같습니다.  

|구분|401 Unauthorized|403 Forbidden|
|------|-----|-----|
|관련 개념|인증(Authentication)|인가(Authorization)|
|신원 확인 여부|신원 미확인 (누구인지 모름)|신원 확인됨 (누구인지 앎)|
|원인|인증 정보 없음 또는 유효하지 않음|권한 부족|
|재시도 가능 여부|인증 정보를 추가하면 재시도 가능|권한이 부여되기 전까지 재시도 불가|
|WWW-Authenticate 헤더|포함 권장|포함하지 않음|

## 5. 사용 예시
---
아래는 두 상태 코드가 실제 서비스에서 어떻게 구분되어 사용되는지에 대한 예시입니다.  

**👉 예시 1: 로그인이 필요한 페이지에 비로그인 상태로 접근** → **`401 Unauthorized`**
> 인증 토큰 없이 `/api/mypage`를 요청한 경우, 서버는 누가 요청했는지 알 수 없습니다.  

**👉 예시 2: 만료된 토큰으로 API 요청** → **`401 Unauthorized`**
> 유효 기간이 지난 JWT를 Authorization 헤더에 담아 요청한 경우, 인증이 실패합니다.  

**👉 예시 3: 일반 사용자가 관리자 전용 API에 접근** → **`403 Forbidden`**
> 정상적으로 로그인한 일반 사용자가 `/api/admin`을 요청한 경우, 서버는 신원은 알지만 권한이 없음을 확인합니다.  

**👉 예시 4: 다른 사용자의 데이터에 접근** → **`403 Forbidden`**
> 로그인된 사용자 A가 사용자 B의 개인 데이터(`/api/users/B/profile`)를 요청한 경우, 해당 데이터에 대한 접근 권한이 없습니다.  
