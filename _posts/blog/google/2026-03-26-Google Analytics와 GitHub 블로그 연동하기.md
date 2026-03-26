---
title: "Google Analytics와 GitHub 블로그 연동하기"
slug: google-analytics
date: 2026-03-26 17:12:00 +09:00
last_modified_at: 2026-03-26 17:12:00 +09:00
categories: [Blog, Google]
tags: [github-blog, analytics, google]
image: "/assets/img/title/blog/google/google_analytics.png"
---

블로그를 운영하다 보면, 자연스럽게 **내 블로그를 얼마나 많은 사람들이 방문하는지** 궁금해지기 마련입니다.  
오늘은 GitHub 블로그에 **Google Analytics**를 연동하여 방문자 통계를 확인하는 방법을 정리해보았습니다.  

## 1. Google Analytics 란?
---
**Google Analytics는 내 웹사이트의 방문자 수, 유입 경로, 페이지별 조회 수 등을 실시간으로 추적하고 분석할 수 있는 Google의 무료 웹 분석 도구**입니다. 단순히 방문자 수를 확인하는 것을 넘어, **어느 나라에서 접속했는지, 어떤 경로로 유입되었는지, 어떤 글이 가장 많이 읽혔는지** 등 다양한 인사이트를 제공합니다.  

블로그를 더 많은 사람들에게 노출시키고 싶다면, Google Analytics는 **내 콘텐츠가 실제로 어떻게 소비되고 있는지 파악하는 데 없어서는 안 될 도구**라고 할 수 있습니다.  

## 2. Google Analytics 시작하기
---
먼저 [Google Analytics](https://analytics.google.com/) 사이트에 접속하여 **`측정 시작`** 버튼을 클릭합니다.  

![main](/assets/img/posts/blog/google/google_analytics/main.png)  

계정 이름을 입력하고 **`다음`** 버튼을 클릭합니다.  
계정 이름은 실제 서비스에 노출되지 않으므로, 본인이 식별하기 쉬운 이름으로 설정하시면 됩니다.  
저는 블로그 도메인명인 `devpro.kr`로 설정해주었습니다.  

![account](/assets/img/posts/blog/google/google_analytics/account.png)  

다음으로 속성 이름, 보고 시간대, 통화를 설정합니다.  
속성 이름은 분석할 사이트를 구분하기 쉬운 이름으로 입력하고, 시간대와 통화는 본인 국가에 알맞게 설정해줍니다.  

![property](/assets/img/posts/blog/google/google_analytics/property.png)  

다음은 비즈니스 세부정보를 선택할 차례입니다.  
저는 블로그 운영이 목적이기 때문에, 업종은 **`기타 비즈니스 활동`**, 규모는 **`작음`**으로 선택하였습니다.  

![business_details](/assets/img/posts/blog/google/google_analytics/business_details.png)  

비즈니스 목표는 아래와 같이 **`웹 또는 앱 트래픽 파악`**, **`사용자 참여 발생 시간 및 유지율 보기`**로 설정해주었습니다.  

![business_goals](/assets/img/posts/blog/google/google_analytics/business_goals.png)  

다음으로 Google 약관에 동의하면, 아래와 같이 데이터를 수집할 플랫폼을 선택하는 페이지가 나타납니다.  
GitHub 블로그는 웹 기반이므로 **`웹`**을 선택합니다.  

![platform](/assets/img/posts/blog/google/google_analytics/platform.png)  

이후 데이터 스트림 설정 페이지에서 본인의 웹사이트 URL과 스트림 이름을 입력한 뒤 **`만들고 계속하기`** 버튼을 클릭합니다.  

![data_stream](/assets/img/posts/blog/google/google_analytics/data_stream.png)  

데이터 스트림이 생성되면 아래와 같이 **측정 ID(G-XXXXXXXXXX)** 를 확인할 수 있습니다.  
이 ID는 이후 블로그 연동에 사용되므로 따로 복사해 두시기 바랍니다.  

![web_stream_details](/assets/img/posts/blog/google/google_analytics/web_stream_details.png)  

## 3. GitHub 블로그에 연동하기
---
측정 ID를 발급받았다면, 이제 GitHub 블로그에 연동할 차례입니다.  
저는 Chirpy 테마를 사용하고 있으므로, 이를 기준으로 설명하겠습니다.  

Chirpy 테마에서는 별도의 코드 수정 없이, `_config.yml` 파일만 수정하면 간단하게 연동할 수 있습니다.  
`_config.yml` 파일을 열고, 아래와 같이 `analytics` 항목에 발급받은 측정 ID를 입력합니다.  

```yml
# Web Analytics Settings
analytics:
  google:
    id: G-XXXXXXXXXX # 본인의 측정 ID 입력
```

수정이 완료되었다면 변경 내역을 커밋하고 배포합니다.  
배포가 완료되면 Google Analytics가 블로그에 자동으로 적용됩니다.  

## 4. 데이터 확인하기
---
연동이 정상적으로 완료되었다면, Google Analytics에서 실시간으로 데이터가 수집되는 것을 확인할 수 있습니다.  
본인의 블로그에 직접 접속해본 이후에, Google Analytics 대시보드 홈에서 활성 사용자가 나타나는지 확인해봅니다.  

![dashboard](/assets/img/posts/blog/google/google_analytics/dashboard.png)  

위와 같이 분당 활성 사용자에 방문자가 집계되고 있다면, Google Analytics 연동이 성공적으로 완료된 것입니다.  
전체 통계 데이터는 대략 최대 48시간 내에 반영되기 시작하니, 하루 정도 여유를 두고 확인해보시면 됩니다.  

## 마무리
---
이번 포스팅에서는 Google Analytics 시작부터, GitHub 블로그 연동, 실시간 데이터 확인까지 전 과정을 정리해보았습니다.  

내 블로그가 실제로 어떻게 운영되고 있는지 파악하고 싶다면, Google Analytics 연동은 선택이 아닌 필수라고 생각합니다.  
특히 어떤 글이 인기가 많은지, 어디서 방문자가 유입되는지를 파악하면 앞으로의 포스팅 방향을 잡는 데도 큰 도움이 됩니다.  

이 글이 처음 설정하시는 분들께 조금이나마 도움이 되었으면 좋겠습니다.  

감사합니다.  
