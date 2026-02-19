---
title: "JWT(JSON Web Token)란 무엇인가?"
date: 2025-06-11 23:27:00 +09:00
last_modified_at: 2025-06-11 23:27:00 +09:00
categories: [Security, JWT]
tags:
  [
    jwt,
    access token,
    액세스 토큰,
    refresh token,
    리프레시 토큰,
    token,
    토큰,
    인증,
    인가,
    보안,
  ]
image: "/assets/img/title/security/jwt_logo_black.png"
---

## 1. JWT 란?
---
**JWT(JSON Web Token)란, JSON 포맷을 이용하여 인증 정보를 안전하게 주고받기 위한 토큰**입니다.  

**일반적으로 사용자 인증에 사용**되며, 사용자가 로그인하면 서버는 인증 정보를 담은 JWT를 생성하여 클라이언트에게 전달합니다. 이후 클라이언트는 이 토큰을 저장해두고, **API 요청 시마다 토큰을 함께 전송함으로써 인증을 처리**합니다.  

이러한 JWT는 인증 과정에서 보안성과 확장성이 모두 뛰어나, 다양한 환경(웹, 앱, IoT 등)에서 널리 활용되고 있습니다.  

## 2. JWT의 구조
---
JWT는 **Header, Payload, Signature** 총 3가지 요소로 구성된 문자열입니다.  
각 요소는 **Base64URL 방식으로 인코딩**되어 있으며, `.`으로 구분됩니다.  
```
Header.Payload.Signature
```

![jwt_sample](/assets/img/posts/security/jwt/jwt_sample.png)  

> 위 사진은 [Logto - JWT decoder](https://logto.io/ko/jwt-decoder) 사이트의 JWT 예제 입니다.  

### 2-1. 헤더(Header)
JWT의 Header는 **토큰의 타입(`typ`)**과, **해싱 알고리즘 정보(`alg`)**를 담고 있습니다.  
일반적으로 아래와 같이 구성됩니다.  
```json
{
  "typ": "JWT",
  "alg": "HS256"
}
```

### 2-2. 페이로드(Payload)
JWT의 Payload는 **실제 데이터를 담고 있는 부분**이며, 이 안의 항목을 **클레임(Claim)**이라고 부릅니다.  
클레임은 총 세 가지 유형으로 구분됩니다.  

#### 2-2-1. 등록된 클레임(Registered Claim)
JWT 명세에서 **사전 정의되어 있는 표준 클레임**들입니다.  
사용은 선택이지만, 의미와 용도가 명확히 정해져 있어 호환성과 표준성을 높일 수 있습니다.  

|Claim|Description|
|-------|-------|
|`iss`|토큰 발급자 (Issuer)|
|`sub`|토큰 제목 (Subject)|
|`aud`|토큰 대상자 (Audience)|
|`exp`|토큰 만료 시간 (Expiration Time)|
|`nbf`|토큰 활성 날짜 (Not Before)|
|`iat`|토큰 발급 시간 (Issued At)|
|`jti`|	JWT 식별자 (JWT ID)|

> 등록된 클레임에서 `exp`, `nbf`, `iat` 등의 시간 정보는 *Unix Timestamp* 로 표기됩니다.  
{: .prompt-tip }

#### 2-2-2. 공개 클레임(Public Claim)
JWT 발급자가 **자유롭게 정의할 수 있는 클레임**입니다.  
단, 이름 충돌을 방지하기 위해 URI 형식의 네임스페이스를 사용하는 것이 권장됩니다.  
```json
{
  "https://devpro.kr/superuser": true
}
```

#### 2-2-3. 비공개 클레임(Private Claim)
JWT의 발급자와 수신자 간에 **내부적으로 약속된 사용자 정의 클레임**입니다.  
주로 서비스 특화 정보나 내부 식별자를 담는 용도로 사용됩니다.  
```json
{
  "emp_id": "E202506110001",
  "dept_code": "DEV",
  "access_level": "admin"
}
```

> **주의사항**  
> Payload는 암호화되지 않기 때문에 누구던지 디코딩이 가능합니다.  
> 민감한 정보(ID/Password, 카드번호 등)는 절대 포함해서는 안 됩니다.  
{: .prompt-warning }

### 2-3. 서명(Signature)
JWT의 Signature는 **토큰의 무결성을 보장하고, 위·변조 여부를 확인하는 데 사용되는 고유한 암호화 코드**입니다.  
즉, 클라이언트가 전달한 JWT가 **신뢰할 수 있는 서버에서 발급되었는지 검증**하는 데 핵심적인 역할을 합니다.  
```
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret
)
```

Signature는 위와 같이 **Header와 Payload를 결합한 문자열에 서버의 Secret Key를 이용해 해시 함수를 적용하여 생성**됩니다. 따라서 누군가 Payload의 내용을 변조하더라도, 서명을 재생성할 수 없기 때문에 서버는 해당 토큰을 신뢰하지 않고 거부하게 됩니다.  

## 3. JWT의 장단점
---
**👍 장점**
* 서버가 세션을 관리하지 않아도 되므로, **무상태(Stateless) 구조**를 구현할 수 있음
* 하나의 토큰으로 **다양한 클라이언트(웹, 앱 등)에서 일관된 방식**으로 사용 가능
* 토큰 자체에 필요한 모든 인증 정보가 포함되어 있어, **별도 DB 조회 없이 인증** 가능
* 서버간의 세션 공유가 필요하지 않기 때문에, **확장성이 뛰어남**
* Signature로 토큰의 위·변조 여부를 검증할 수 있어, **무결성이 보장**됨

**👎 단점**
* 클라이언트가 토큰을 보유하므로, **탈취 시 보안에 취약**함
* 발급된 토큰은 클라이언트에 저장되므로, 만료 시간 전에는 **서버에서 강제 폐기하기 어려움**
* JWT에 포함되는 데이터가 많아질수록 토큰 크기가 증가해, **네트워크 트래픽에 부담**을 줄 수 있음
